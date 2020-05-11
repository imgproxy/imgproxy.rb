require "openssl"
require "base64"
require "erb"

require "imgproxy/options"

module Imgproxy
  # Builds imgproxy URL
  #
  #   builder = Imgproxy::Builder.new(
  #     width: 500,
  #     height: 400,
  #     resizing_type: :fill,
  #     sharpen: 0.5
  #   )
  #
  #   builder.url_for("http://images.example.com/images/image1.jpg")
  #   builder.url_for("http://images.example.com/images/image2.jpg")
  class Builder
    OMITTED_OPTIONS = %i[format].freeze
    # @param [Hash] options Processing options
    # @see Imgproxy.url_for
    def initialize(options = {})
      options = options.dup

      @base64_encode_url = options.delete(:base64_encode_url)
      @use_short_options = options.delete(:use_short_options)

      @use_short_options = config.use_short_options if @use_short_options.nil?
      @base64_encode_url = config.base64_encode_urls if @base64_encode_url.nil?

      @options = Imgproxy::Options.new(options)
    end

    # Genrates imgproxy URL
    #
    # @return [String] imgproxy URL
    # @param [String,URI, Object] image Source image URL or object applicable for
    #   the configured URL adapters
    # @see Imgproxy.url_for
    def url_for(image)
      path = [*processing_options, url(image)].join("/")
      signature = sign_path(path)

      File.join(Imgproxy.config.endpoint.to_s, signature, path)
    end

    private

    OPTIONS_ALIASES = {
      resize: :rs,
      size: :s,
      resizing_type: :rt,
      width: :w,
      height: :h,
      enlarge: :en,
      extend: :ex,
      gravity: :g,
      crop: :c,
      padding: :pd,
      trim: :t,
      quality: :q,
      max_bytes: :mb,
      background: :bg,
      adjust: :a,
      brightness: :br,
      contrast: :co,
      saturation: :sa,
      blur: :bl,
      sharpen: :sh,
      pixelate: :pix,
      watermark: :wm,
      watermark_url: :wmu,
      preset: :pr,
      cachebuster: :cb,
    }.freeze

    NEED_ESCAPE_RE = /[@?% ]|[^\p{Ascii}]/.freeze

    def processing_options
      @processing_options ||=
        @options.reject { |k, _| OMITTED_OPTIONS.include?(k) }.map do |key, value|
          "#{option_alias(key)}:#{wrap_array(value).join(':')}"
        end
    end

    def plain_url_for(url)
      escaped_url = url.match?(NEED_ESCAPE_RE) ? ERB::Util.url_encode(url) : url

      @options[:format] ? "plain/#{escaped_url}@#{@options[:format]}" : "plain/#{escaped_url}"
    end

    def base64_url_for(url)
      encoded_url = Base64.urlsafe_encode64(url).tr("=", "").scan(/.{1,16}/).join("/")

      @options[:format] ? "#{encoded_url}.#{@options[:format]}" : encoded_url
    end

    def option_alias(name)
      return name unless config.use_short_options

      OPTIONS_ALIASES.fetch(name, name)
    end

    def wrap_array(value)
      value.is_a?(Array) ? value : [value]
    end

    def url(image)
      url = config.url_adapters.url_of(image)

      @base64_encode_url ? base64_url_for(url) : plain_url_for(url)
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
      config.key
    end

    def signature_salt
      config.salt
    end

    def signature_size
      config.signature_size
    end

    def config
      Imgproxy.config
    end
  end
end
