require "anyway_config"

module Imgproxy
  # Imgproxy custom config for services
  #
  # @!attribute endpoint
  #   imgproxy endpoint
  #   @return [String]
  # @!attribute key
  #   imgproxy hex-encoded signature key
  #   @return [String]
  # @!attribute salt
  #   imgproxy hex-encoded signature salt
  #   @return [String]
  # @!attribute raw_key
  #   Decoded signature key
  #   @return [String]
  # @!attribute raw_salt
  #   Decoded signature salt
  #   @return [String]
  # @!attribute signature_size
  #   imgproxy signature size. Defaults to 32
  #   @return [String]
  #
  # @see Imgproxy::Config
  class ServiceConfig < Anyway::Config
    # Inherit global config values
    config_name :imgproxy

    attr_config(
      :endpoint,
      :key,
      :salt,
      :raw_key,
      :raw_salt,
      signature_size: 32,
    )

    alias_method :set_key, :key=
    alias_method :set_raw_key, :raw_key=
    alias_method :set_salt, :salt=
    alias_method :set_raw_salt, :raw_salt=
    private :set_key, :set_raw_key, :set_salt, :set_raw_salt

    def key=(value)
      value = value&.to_s
      super(value)
      set_raw_key(value && [value].pack("H*"))
    end

    def raw_key=(value)
      value = value&.to_s
      super(value)
      set_key(value&.unpack("H*")&.first)
    end

    def salt=(value)
      value = value&.to_s
      super(value)
      set_raw_salt(value && [value].pack("H*"))
    end

    def raw_salt=(value)
      value = value&.to_s
      super(value)
      set_salt(value&.unpack("H*")&.first)
    end
  end
end
