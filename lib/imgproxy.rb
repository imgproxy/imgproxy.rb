require "imgproxy/version"
require "imgproxy/config"
require "imgproxy/url_builders/processing"
require "imgproxy/url_builders/info"

require "imgproxy/extensions/active_storage"
require "imgproxy/extensions/shrine"

# @see Imgproxy::ClassMethods
module Imgproxy
  class << self
    # Imgproxy config
    #
    # @return [Config]
    def config
      @config ||= Imgproxy::Config.new
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
    def configure
      yield config
      config
    end

    # Genrates imgproxy URL
    #
    #   Imgproxy.url_for(
    #     "http://images.example.com/images/image.jpg",
    #     width: 500,
    #     height: 400,
    #     resizing_type: :fill,
    #     sharpen: 0.5,
    #     gravity: {
    #       type: :soea,
    #       x_offset: 10,
    #       y_offset: 5,
    #     },
    #     crop: {
    #       width: 2000,
    #       height: 1000,
    #       gravity: {
    #         type: :nowe,
    #         x_offset: 20,
    #         y_offset: 30,
    #       },
    #     },
    #   )
    #
    # @return [String] imgproxy URL
    # @param [String,URI, Object] image Source image URL or object applicable for
    #   the configured URL adapters
    # @param [Hash] options Processing options
    # @see https://github.com/imgproxy/imgproxy.rb#processing-options
    #   Supported processing options
    def url_for(image, options = {})
      Imgproxy::UrlBuilders::Processing.new(options).url_for(image)
    end

    # Genrates imgproxy info URL. Supported only by imgproxy Pro
    #
    #   Imgproxy.info_url_for(
    #     "http://images.example.com/images/image.jpg",
    #     alpha: {
    #       alpha: true,
    #       check_transparency: true
    #     },
    #     palette: 128,
    #   )
    #
    # @return [String] imgproxy info URL
    # @param [String,URI, Object] image Source image URL or object applicable for
    #   the configured URL adapters
    # @param [Hash] options Info options
    # @see https://github.com/imgproxy/imgproxy.rb#info-options
    #   Supported info options
    def info_url_for(image, options = {})
      Imgproxy::UrlBuilders::Info.new(options).url_for(image)
    end

    # Extends +ActiveStorage::Blob+ with {Imgproxy::Extensions::ActiveStorage.imgproxy_url} method
    # and adds URL adapters for ActiveStorage
    def extend_active_storage!
      return unless defined?(ActiveSupport) && ActiveSupport.respond_to?(:on_load)

      ActiveSupport.on_load(:active_storage_blob) do
        ::ActiveStorage::Blob.include Imgproxy::Extensions::ActiveStorage
        Imgproxy.config.url_adapters.add(Imgproxy::UrlAdapters::ActiveStorage.new)
      end
    end

    # Extends +Shrine::UploadedFile+ with {Imgproxy::Extensions::Shrine.imgproxy_url} method
    # and adds URL adapters for Shrine
    def extend_shrine!
      return unless defined?(::Shrine::UploadedFile)

      ::Shrine::UploadedFile.include Imgproxy::Extensions::Shrine
      Imgproxy.config.url_adapters.add(Imgproxy::UrlAdapters::Shrine.new)
    end
  end
end

Imgproxy.extend_active_storage!
Imgproxy.extend_shrine!
