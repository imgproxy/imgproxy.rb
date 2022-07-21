require "anyway_config"

require "imgproxy/service_config"
require "imgproxy/url_adapters"

module Imgproxy
  # Imgproxy config
  #
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

    coerce_types use_short_options: :boolean,
                 base64_encode_urls: :boolean,
                 always_escape_plain_urls: :boolean,
                 use_s3_urls: :boolean,
                 use_gcs_urls: :boolean,
                 gcs_bucket: :string,
                 shrine_host: :string

    def endpoint
      service(:default).endpoint
    end

    def endpoint=(value)
      service(:default).endpoint = value
    end

    def key
      service(:default).key
    end

    def key=(value)
      service(:default).key = value
    end

    def raw_key
      service(:default).raw_key
    end

    def raw_key=(value)
      service(:default).raw_key = value
    end

    def salt
      service(:default).salt
    end

    def salt=(value)
      service(:default).salt = value
    end

    def raw_salt
      service(:default).raw_salt
    end

    def raw_salt=(value)
      service(:default).raw_salt = value
    end

    def signature_size
      service(:default).signature_size
    end

    def signature_size=(value)
      service(:default).signature_size = value
    end

    def service(name)
      services[name.to_sym] ||= services[:default].dup

      yield services[name.to_sym] if block_given?

      services[name.to_sym]
    end

    # rubocop: disable Metrics/AbcSize
    def services
      @services ||= {}.tap do |s|
        s[:default] = ServiceConfig.new

        super.each do |name, data|
          config = s[name.to_sym] = s[:default].dup

          data.symbolize_keys.slice(*config.class.config_attributes).each do |key, value|
            value = config.class.type_caster.coerce(key, value)
            config.public_send("#{key}=", value)
          end
        end
      end
    end
    # rubocop: enable Metrics/AbcSize

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
