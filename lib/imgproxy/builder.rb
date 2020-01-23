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
    OMITTED_OPTIONS = %i[format base64_encode_url].freeze
    # @param [Hash] options Processing options
    # @see Imgproxy.url_for
    def initialize(options = {})
      options = options.dup

      @use_short_options = options.delete(:use_short_options)
      @use_short_options = config.use_short_options if @use_short_options.nil?

      @options = Imgproxy::Options.new(options)
    end

    # Genrates imgproxy URL
    #
    # @return [String] imgproxy URL
    # @param [String,URI, Object] image Source image URL or object applicable for
    #   the configured URL adapters
    # @see Imgproxy.url_for
    def url_for(image)
      path = base64_encode_url? ? base64_url_for(image) : plain_url_for(image)
      signature = sign_path(path)

      File.join(Imgproxy.config.endpoint.to_s, signature, path)
    end

    private

    OPTIONS_ALIASES = {
      crop: :c,
      resize: :rs,
      size: :s,
      resizing_type: :rt,
      width: :w,
      height: :h,
      enlarge: :en,
      extend: :ex,
      gravity: :g,
      quality: :q,
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

    def plain_url_for(image)
      path = [*processing_options, "plain", url(image)].join("/")
      path = "#{path}@#{@options[:format]}" if @options[:format]

      path
    end

    def base64_url_for(image)
      url = config.url_adapters.url_of(image)
      encoded_url = Base64.urlsafe_encode64(url).tr("=", "").scan(/.{1,16}/).join("/")

      path = [*processing_options, encoded_url].join("/")
      path = "#{path}.#{@options[:format]}" if @options[:format]

      path
    end

    def base64_encode_url?
      config.base64_encode_urls || @options[:base64_encode_url] == "true"
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
      url.match?(NEED_ESCAPE_RE) ? ERB::Util.url_encode(url) : url
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
