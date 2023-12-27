# frozen_string_literal: true

require "openssl"
require "base64"
require "erb"

require "imgproxy/options_builders/base"

module Imgproxy
  module UrlBuilders
    class UnknownServiceError < StandardError; end

    class InvalidEncryptionKeyError < StandardError; end

    # Builds imgproxy URL
    #
    #   builder = Imgproxy::UrlBuilders::Base.new(
    #     width: 500,
    #     height: 400,
    #     resizing_type: :fill,
    #     sharpen: 0.5
    #   )
    #
    #   builder.url_for("http://images.example.com/images/image1.jpg")
    #   builder.url_for("http://images.example.com/images/image2.jpg")
    class Base
      OPTIONS_BUILDER = OptionsBuilders::Base
      OPTION_ALIASES = {}.freeze

      # @param [Hash] options imgproxy URL options
      # @see Imgproxy.url_for
      # @see Imgproxy.info_url_for
      def initialize(options = {})
        options = options.dup

        extract_builder_options(options)

        @options = self.class::OPTIONS_BUILDER.new(options)
      end

      # Genrates imgproxy URL
      #
      # @return [String] imgproxy URL
      # @param [String,URI, Object] _image Source image URL or object applicable for
      #   the configured URL adapters
      # @see Imgproxy.url_for
      # @see Imgproxy.info_url_for
      def url_for(_image)
        raise NotImplementedError
      end

      private

      attr_reader :service

      NEED_ESCAPE_RE = /[@?% ]|[^\p{Ascii}]/.freeze
      AES_SIZES = {32 => 256, 24 => 196, 16 => 128}.freeze

      def extract_builder_options(options)
        @service = options.delete(:service)&.to_sym || :default

        @use_short_options =
          not_nil_or(options.delete(:use_short_options), config.use_short_options)
        @base64_encode_url =
          not_nil_or(options.delete(:base64_encode_url), config.base64_encode_urls)
        @escape_plain_url =
          not_nil_or(options.delete(:escape_plain_url), config.always_escape_plain_urls)
        @encrypt_source_url =
          not_nil_or(options.delete(:encrypt_source_url), service_config.always_encrypt_source_urls)
        @source_url_encryption_iv = options.delete(:source_url_encryption_iv)
      end

      def option_strings
        @option_strings ||= @options.map do |key, value|
          [option_alias(key), value].join(":")
        end
      end

      def sourcce_url(image, ext: nil)
        url = config.url_adapters.url_of(image)

        return encrypted_sourcce_url_for(url, ext: ext) if @encrypt_source_url
        return base64_sourcce_url_for(url, ext: ext) if @base64_encode_url
        plain_url_for(url, ext: ext)
      end

      def plain_url_for(url, ext: nil)
        escaped_url = need_escape_url?(url) ? ERB::Util.url_encode(url) : url

        ext ? "plain/#{escaped_url}@#{ext}" : "plain/#{escaped_url}"
      end

      def base64_sourcce_url_for(url, ext: nil)
        encoded_url = Base64.urlsafe_encode64(url).tr("=", "").scan(/.{1,16}/).join("/")

        ext ? "#{encoded_url}.#{ext}" : encoded_url
      end

      def encrypted_sourcce_url_for(url, ext: nil)
        cipher = build_cipher

        iv = @source_url_encryption_iv || cipher.random_iv
        cipher.iv = iv

        "enc/#{base64_sourcce_url_for(iv + cipher.update(url) + cipher.final, ext: ext)}"
      end

      def need_escape_url?(url)
        @escape_plain_url || url.match?(NEED_ESCAPE_RE)
      end

      def build_cipher
        key = encryption_key.to_s

        aes_size = AES_SIZES.fetch(key.length) do
          raise Imgproxy::UrlBuilders::InvalidEncryptionKeyError,
            "Encryption key should be 16/24/32 bytes long, now - #{key.length}"
        end

        OpenSSL::Cipher::AES.new(aes_size, :CBC).tap do |cipher|
          cipher.encrypt
          cipher.key = key
        end
      end

      def option_alias(name)
        return name unless @use_short_options

        self.class::OPTION_ALIASES.fetch(name, name)
      end

      def sign_path(path)
        return "unsafe" unless ready_to_sign?

        digest = OpenSSL::HMAC.digest(
          OpenSSL::Digest.new("sha256"),
          signature_key,
          "#{signature_salt}/#{path}",
        )[0, signature_size]

        Base64.urlsafe_encode64(digest).tr("=", "")
      end

      def ready_to_sign?
        !(signature_key.nil? || signature_salt.nil? ||
          signature_key.empty? || signature_salt.empty?)
      end

      def signature_key
        service_config.raw_key
      end

      def signature_salt
        service_config.raw_salt
      end

      def signature_size
        service_config.signature_size
      end

      def encryption_key
        service_config.raw_source_url_encryption_key
      end

      def not_nil_or(value, fallback)
        value.nil? ? fallback : value
      end

      def endpoint
        service_config.endpoint
      end

      def service_config
        @service_config ||= config.services[service].tap do |c|
          raise Imgproxy::UrlBuilders::UnknownServiceError, service unless c
        end
      end

      def config
        Imgproxy.config
      end
    end
  end
end
