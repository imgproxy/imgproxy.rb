require "imgproxy/version"
require "imgproxy/config"
require "imgproxy/builder"

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
    #     config.hex_key = "your_key"
    #     config.hex_salt = "your_salt"
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
    # @option options [Hash|Array|String] :resize
    # @option options [Hash|Array|String] :size
    # @option options [String] :resizing_type
    # @option options [Integer] :width
    # @option options [Integer] :height
    # @option options [Float] :dpr
    # @option options [Boolean] :enlarge
    # @option options [Hash|Array|Boolean|String] :extend
    # @option options [Hash|Array|String] :gravity
    # @option options [Hash|Array|String] :crop
    # @option options [Hash|Array|String] :trim
    # @option options [Array] :padding
    # @option options [Integer] :quality
    # @option options [Integer] :max_bytes
    # @option options [Array|String] :background
    # @option options [Hash|Array|String] :adjust
    # @option options [Integer] :brightness supported only by imgproxy pro
    # @option options [Float] :contrast supported only by imgproxy pro
    # @option options [Float] :saturation supported only by imgproxy pro
    # @option options [Float] :blur
    # @option options [Float] :sharpen
    # @option options [Integer] :pixelate supported only by imgproxy pro
    # @option options [Hash|Array|Float|String] :watermark
    # @option options [String] :watermark_url supported only by imgproxy pro
    # @option options [String] :style supported only by imgproxy pro
    # @option options [Integer] :video_thumbnail_second supported only by imgproxy pro
    # @option options [Array] :preset
    # @option options [String] :cachebuster
    # @option options [String] :filename
    # @option options [String] :format
    # @option options [Boolean] :use_short_options
    # @option options [Boolean] :base64_encode_urls
    # @option options [Boolean] :escape_plain_url
    # @see https://docs.imgproxy.net/#/generating_the_url_advanced?id=processing-options
    #   Available imgproxy URL processing options and their arguments
    def url_for(image, options = {})
      Imgproxy::Builder.new(options).url_for(image)
    end

    # Extends ActiveStorage::Blob with {Imgproxy::Extensions::ActiveStorage.imgproxy_url} method
    # and adds URL adapters for ActiveStorage
    #
    # @return [void]
    # @param use_s3 [Boolean] enable Amazon S3 source URLs
    # @param use_gcs [Boolean] enable Google Cloud Storage source URLs
    # @param gcs_bucket [String] Google Cloud Storage bucket name
    def extend_active_storage!(use_s3: false, use_gcs: false, gcs_bucket: nil)
      ActiveSupport.on_load(:active_storage_blob) do
        ::ActiveStorage::Blob.include Imgproxy::Extensions::ActiveStorage

        url_adapters = Imgproxy.config.url_adapters

        url_adapters.add(Imgproxy::UrlAdapters::ActiveStorageS3.new) if use_s3
        url_adapters.add(Imgproxy::UrlAdapters::ActiveStorageGCS.new(gcs_bucket)) if use_gcs
        url_adapters.add(Imgproxy::UrlAdapters::ActiveStorage.new)
      end
    end

    # Extends Shrine::UploadedFile with {Imgproxy::Extensions::Shrine.imgproxy_url} method
    # and adds URL adapters for Shrine
    #
    # @return [void]
    # @param use_s3 [Boolean] enable Amazon S3 source URLs
    def extend_shrine!(host: nil, use_s3: false)
      ::Shrine::UploadedFile.include Imgproxy::Extensions::Shrine

      url_adapters = Imgproxy.config.url_adapters

      url_adapters.add(Imgproxy::UrlAdapters::ShrineS3.new) if use_s3
      url_adapters.add(Imgproxy::UrlAdapters::Shrine.new(host: host))
    end
  end
end
