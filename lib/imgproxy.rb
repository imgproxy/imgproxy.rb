require "imgproxy/version"
require "imgproxy/config"
require "imgproxy/builder"

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
    #     sharpen: 0.5
    #   )
    #
    # @return [String] imgproxy URL
    # @param [String] image Source image URL
    # @param [Hash] options Processing options
    # @option options [String] :resizing_type
    # @option options [Integer] :width
    # @option options [Integer] :height
    # @option options [Float] :dpr
    # @option options [Boolean] :enlarge
    # @option options [Boolean] :extend
    # @option options [String] :gravity
    # @option options [Float] :gravity_x
    # @option options [Float] :gravity_y
    # @option options [Integer] :quality
    # @option options [Array] :background
    # @option options [Float] :blur
    # @option options [Float] :sharpen
    # @option options [Float] :watermark_opacity
    # @option options [String] :watermark_position
    # @option options [Integer] :watermark_x_offset
    # @option options [Integer] :watermark_y_offset
    # @option options [Float] :watermark_scale
    # @option options [Array] :preset
    # @option options [String] :cachebuster
    # @option options [String] :format
    # @option options [Boolean] :use_short_options
    # @see https://github.com/DarthSim/imgproxy/blob/master/docs/generating_the_url_advanced.md
    #   imgproxy URL format documentation
    def url_for(image, options = {})
      Imgproxy::Builder.new(options).url_for(image)
    end
  end
end
