module Imgproxy
  # Imgproxy config
  # @see Imgproxy.configure
  class Config
    # @return [String] imgproxy endpoint
    attr_reader :endpoint
    # @return [String] imgproxy signature key
    attr_accessor :key
    # @return [String] imgproxy signature salt
    attr_accessor :salt
    # @return [Boolean] use short processing option names
    #   (`rs` for `resize`, `g` for `gravity`, etc).
    #   Defaults to true
    attr_accessor :use_short_options

    def initialize
      self.use_short_options = true
    end

    # Decodes hex-encoded key and sets it to {#key}
    #
    # @param value [String] hex-encoded signature key
    def hex_key=(value)
      self.key = [value].pack('H*')
    end

    # Decodes hex-encoded salt and sets it to {#salt}
    #
    # @param value [String] hex-encoded signature salt
    def hex_salt=(value)
      self.salt = [value].pack('H*')
    end

    def endpoint=(value)
      @endpoint = value.end_with?('/') ? value[0..-2] : value
    end
  end
end
