require "anyway_config"

require "imgproxy/service_config"
require "imgproxy/url_adapters"

module Imgproxy
  # Imgproxy config
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
  # @!attribute use_short_options
  #   Use short processing option names (+rs+ for +resize+, +g+ for +gravity+, etc).
  #   Defaults to true
  #   @return [String]
  # @!attribute base64_encode_urls
  #   Base64 encode the URL. Defaults to false
  #   @return [String]
  # @!attribute always_escape_plain_urls
  #   Always escape plain URLs. Defaults to false
  #   @return [String]
  # @!attribute use_s3_urls
  #   Use short S3 urls (s3://...) when possible. Defaults to false
  #   @return [String]
  # @!attribute use_gcs_urls
  #   Use short Google Cloud Storage urls (gs://...) when possible. Defaults to false
  #   @return [String]
  # @!attribute gcs_bucket
  #   Google Cloud Storage bucket name
  #   @return [String]
  # @!attribute shrine_host
  #   Shrine host
  #   @return [String]
  #
  # @see Imgproxy.configure
  # @see https://github.com/palkan/anyway_config anyway_config
  class Config < Anyway::Config
    attr_config(
      use_short_options: true,
      base64_encode_urls: false,
      always_escape_plain_urls: false,
      use_s3_urls: false,
      use_gcs_urls: false,
      gcs_bucket: nil,
      shrine_host: nil,
      services: {},
    )

    def endpoint=(value)
      service(:default).endpoint = value
    end

    def key=(value)
      service(:default).key = value
    end

    def raw_key=(value)
      service(:default).raw_key = value
    end

    def salt=(value)
      service(:default).salt = value
    end

    def raw_salt=(value)
      service(:default).raw_salt = value
    end

    def signature_size=(value)
      service(:default).signature_size = value
    end

    def service(name)
      services[name.to_sym] ||= ServiceConfig.new(services[:default].to_h)
      yield services[name.to_sym] if block_given?

      services[name.to_sym]
    end

    def services
      @services ||= {}.tap do |s|
        s[:default] = ServiceConfig.new

        super.each do |name, data|
          s[name.to_sym] = ServiceConfig.new(
            s[:default].to_h.merge(data.symbolize_keys),
          )
        end
      end
    end

    # @deprecated Please use {#key} instead
    def hex_key=(value)
      warn "[DEPRECATION] #hex_key is deprecated. Please use #key instead."
      self.key = value
    end

    # @deprecated Please use {#salt} instead
    def hex_salt=(value)
      warn "[DEPRECATION] #hex_salt is deprecated. Please use #salt instead."
      self.salt = value
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
