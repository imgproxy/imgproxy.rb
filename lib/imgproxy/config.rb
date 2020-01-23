require "imgproxy/url_adapters"

module Imgproxy
  # Imgproxy config
  # @see Imgproxy.configure
  class Config
    # @return [String] imgproxy endpoint
    attr_accessor :endpoint
    # @return [String] imgproxy signature key
    attr_accessor :key
    # @return [String] imgproxy signature salt
    attr_accessor :salt
    # @return [Integer] imgproxy signature size. Defaults to 32
    attr_accessor :signature_size
    # @return [Boolean] use short processing option names
    #   (`rs` for `resize`, `g` for `gravity`, etc).
    #   Defaults to true
    attr_accessor :use_short_options

    # @return [Boolean] base64 encode the URL
    #   Defaults to false
    attr_accessor :base64_encode_urls

    def initialize
      self.signature_size = 32
      self.use_short_options = true
      self.base64_encode_urls = false
    end

    # Decodes hex-encoded key and sets it to {#key}
    #
    # @param value [String] hex-encoded signature key
    def hex_key=(value)
      self.key = value.nil? ? nil : [value].pack("H*")
    end

    # Decodes hex-encoded salt and sets it to {#salt}
    #
    # @param value [String] hex-encoded signature salt
    def hex_salt=(value)
      self.salt = value.nil? ? nil : [value].pack("H*")
    end

    # URL adapters config. Allows to use this gem with ActiveStorage, Shrine, etc.
    #
    #   Imgproxy.configure do |config|
    #     config.url_adapters.add Imgproxy::UrlAdapters::ActiveStorage.new
    #   end
    #
    #   Imgproxy.url_for(user.avatar)
    #
    # @return [Imgproxy::UrlAdapters]
    # @see Imgproxy::UrlAdapters
    def url_adapters
      @url_adapters ||= Imgproxy::UrlAdapters.new
    end
  end
end
