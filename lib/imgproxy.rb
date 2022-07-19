require "imgproxy/version"
require "imgproxy/service"

require "imgproxy/extensions/active_storage"
require "imgproxy/extensions/shrine"

# @see Imgproxy::ClassMethods
module Imgproxy
  class << self
    # Get required service for Imgproxy
    #
    # @param name [Symbol]
    # @return [Service]
    def service(name)
      @services ||= {}
      @services[name] ||= Imgproxy::Service.new(name)
    end

    # @see Imgproxy::Service#config
    def config
      service(:default).config
    end

    # Yields Imgproxy config
    #
    #   Imgproxy.configure do |config|
    #     config.endpoint = "http://imgproxy.example.com"
    #     config.key = "your_key"
    #     config.salt = "your_salt"
    #     config.use_short_options = true
    #   end
    #
    # @yieldparam config [Config]
    # @return [Config]
    def configure(service_name = :default)
      config = service(service_name).config
      yield config

      if service_name != :default
        extend_active_storage!(service_name)
        extend_shrine!(service_name)
      end

      config
    end

    # @see Imgproxy::Service#url_for
    def url_for(*args, **kwargs)
      service(:default).url_for(*args, **kwargs)
    end

    # @see Imgproxy::Service#info_url_for
    def info_url_for(*args, **kwargs)
      service(:default).info_url_for(*args, **kwargs)
    end

    # Extends +ActiveStorage::Blob+ with {Imgproxy::Extensions::ActiveStorage.imgproxy_url} method
    # and adds URL adapters for ActiveStorage
    def extend_active_storage!(service_name = nil)
      return unless defined?(ActiveSupport) && ActiveSupport.respond_to?(:on_load)

      config = service_name ? Imgproxy.service(service_name).config : Imgproxy.config
      ActiveSupport.on_load(:active_storage_blob) do
        ::ActiveStorage::Blob.include Imgproxy::Extensions::ActiveStorage
        config.url_adapters.add(Imgproxy::UrlAdapters::ActiveStorage.new(service_name))
      end
    end

    # Extends +Shrine::UploadedFile+ with {Imgproxy::Extensions::Shrine.imgproxy_url} method
    # and adds URL adapters for Shrine
    def extend_shrine!(service_name = nil)
      return unless defined?(::Shrine::UploadedFile)

      config = service_name ? Imgproxy.service(service_name).config : Imgproxy.config
      ::Shrine::UploadedFile.include Imgproxy::Extensions::Shrine
      config.url_adapters.add(Imgproxy::UrlAdapters::Shrine.new(service_name))
    end
  end
end

Imgproxy.extend_active_storage!
Imgproxy.extend_shrine!
