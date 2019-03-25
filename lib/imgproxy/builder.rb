require 'openssl'
require 'base64'

require 'imgproxy/options'

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
    # @param [Hash] options Processing options
    # @see Imgproxy.url_for
    def initialize(options = {})
      @use_short_options = options.delete(:use_short_options)
      @use_short_options = config.use_short_options if @use_short_options.nil?

      @options = Imgproxy::Options.new(options)
    end

    # Genrates imgproxy URL
    #
    # @return [String] imgproxy URL
    # @param [String] image Source image URL
    # @see Imgproxy.url_for
    def url_for(image)
      path = [*processing_options, 'plain', escape_url(image)].join('/')
      path = "#{path}@#{options[:format]}" if @options[:format]

      signature = sign_path(path)

      "#{Imgproxy.config.endpoint}/#{signature}/#{path}"
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
      quality: :q,
      background: :bg,
      blur: :bl,
      sharpen: :sh,
      watermark: :wm,
      preset: :pr,
      cachebuster: :cb
    }.freeze

    NEED_ESCAPE_RE = /@\?%/.freeze

    def processing_options
      @processing_options ||=
        @options.build.map do |key, value|
          "#{option_alias(key)}:#{wrap_array(value).join(':')}"
        end
    end

    def option_alias(name)
      return name unless config.use_short_options

      OPTIONS_ALIASES.fetch(name, name)
    end

    def wrap_array(value)
      value.is_a?(Array) ? value : [value]
    end

    def escape_url(url)
      url =~ NEED_ESCAPE_RE ? CGI.escape(url) : url
    end

    def sign_path(path)
      return 'unsafe' if signature_key.nil? || signature_salt.nil?

      digest = OpenSSL::HMAC.digest(
        OpenSSL::Digest.new('sha256'),
        signature_key,
        "#{signature_salt}/#{path}"
      )[0, signature_size]

      Base64.urlsafe_encode64(digest).tr('=', '')
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
