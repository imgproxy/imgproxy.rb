require "imgproxy/config"
require "imgproxy/builder"

module Imgproxy
  # Imgproxy service
  #
  class Service
    # @param name [Symbol]
    def initialize(name)
      @name = name
    end

    # Imgproxy config
    #
    # @return [Config]
    def config
      @config ||= Imgproxy::Config.new
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
    # @option options [String] :resizing_algorithm supported only by imgproxy pro
    # @option options [Integer] :width
    # @option options [Integer] :height
    # @option options [Float] :dpr
    # @option options [Boolean] :enlarge
    # @option options [Hash|Array|Boolean|String] :extend
    # @option options [Hash|Array|String] :gravity
    # @option options [Hash|Array|String] :crop
    # @option options [Array] :padding
    # @option options [Hash|Array|String] :trim
    # @option options [Integer] :rotate
    # @option options [Integer] :quality
    # @option options [Integer] :max_bytes
    # @option options [Array|String] :background
    # @option options [Float] :background_alpha supported only by imgproxy pro
    # @option options [Hash|Array|String] :adjust
    # @option options [Integer] :brightness supported only by imgproxy pro
    # @option options [Float] :contrast supported only by imgproxy pro
    # @option options [Float] :saturation supported only by imgproxy pro
    # @option options [Float] :blur
    # @option options [Float] :sharpen
    # @option options [Integer] :pixelate supported only by imgproxy pro
    # @option options [String] :unsharpening supported only by imgproxy pro
    # @option options [Hash|Array|Float|String] :watermark
    # @option options [String] :watermark_url supported only by imgproxy pro
    # @option options [String] :style supported only by imgproxy pro
    # @option options [Hash|Array|String] :jpeg_options supported only by imgproxy pro
    # @option options [Hash|Array|String] :png_options supported only by imgproxy pro
    # @option options [Hash|Array|String] :gif_options supported only by imgproxy pro
    # @option options [Integer] :page supported only by imgproxy pro
    # @option options [Integer] :video_thumbnail_second supported only by imgproxy pro
    # @option options [Array] :preset
    # @option options [String] :cachebuster
    # @option options [Boolean] :strip_metadata
    # @option options [Boolean] :strip_color_profile
    # @option options [Boolean] :auto_rotate
    # @option options [String] :filename
    # @option options [String] :format
    # @option options [Boolean] :return_attachment
    # @option options [Integer] :expires
    # @option options [Boolean] :use_short_options
    # @option options [Boolean] :base64_encode_urls
    # @option options [Boolean] :escape_plain_url
    # @see https://docs.imgproxy.net/#/generating_the_url_advanced?id=processing-options
    #   Available imgproxy URL processing options and their arguments
    def url_for(image, options = {})
      Imgproxy::Builder.new(**options, config: config).url_for(image)
    end

    # Genrates imgproxy info URL. Supported only by imgproxy pro
    #
    #   Imgproxy.info_url_for("http://images.example.com/images/image.jpg")
    #
    # @return [String] imgproxy info URL
    # @param [String,URI, Object] image Source image URL or object applicable for
    #   the configured URL adapters
    # @param [Hash] options Processing options
    # @option options [Boolean] :base64_encode_urls
    # @option options [Boolean] :escape_plain_url
    def info_url_for(image, options = {})
      Imgproxy::Builder.new(**options, config: config).info_url_for(image)
    end
  end
end
