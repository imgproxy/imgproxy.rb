# frozen_string_literal: true

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
  # @!attribute source_url_encryption_key
  #   imgproxy hex-encoded source URL encryption key
  #   @return [String]
  # @!attribute raw_source_url_encryption_key
  #   Decoded source URL encryption key
  #   @return [String]
  # @!attribute always_encrypt_source_urls
  #   Always encrypt source URLs. Defaults to false
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
      :source_url_encryption_key,
      :raw_source_url_encryption_key,
      signature_size: 32,
      always_encrypt_source_urls: false,
    )

    coerce_types(
      endpoint: :string,
      key: :string,
      salt: :string,
      raw_key: :string,
      raw_salt: :string,
      signature_size: :integer,
      source_url_encryption_key: :string,
      raw_source_url_encryption_key: :string,
      always_encrypt_source_urls: :boolean,
    )

    alias_method :set_key, :key=
    alias_method :set_raw_key, :raw_key=
    alias_method :set_salt, :salt=
    alias_method :set_raw_salt, :raw_salt=
    alias_method :set_source_url_encryption_key, :source_url_encryption_key=
    alias_method :set_raw_source_url_encryption_key, :raw_source_url_encryption_key=

    private :set_key, :set_raw_key, :set_salt, :set_raw_salt,
      :set_source_url_encryption_key, :set_raw_source_url_encryption_key

    def key=(value)
      str_value = value&.to_s
      super(str_value)
      set_raw_key(str_value && [str_value].pack("H*"))
    end

    def raw_key=(value)
      str_value = value&.to_s
      super(str_value)
      set_key(str_value&.unpack!("H*"))
    end

    def salt=(value)
      str_value = value&.to_s
      super(str_value)
      set_raw_salt(str_value && [str_value].pack("H*"))
    end

    def raw_salt=(value)
      str_value = value&.to_s
      super(str_value)
      set_salt(str_value&.unpack1("H*"))
    end

    def source_url_encryption_key=(value)
      str_value = value&.to_s
      super(str_value)
      set_raw_source_url_encryption_key(str_value && [str_value].pack("H*"))
    end

    def raw_source_url_encryption_key=(value)
      str_value = value&.to_s
      super(str_value)
      set_source_url_encryption_key(str_value&.unpack1("H*"))
    end
  end
end
