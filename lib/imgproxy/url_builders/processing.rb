# frozen_string_literal: true

require "imgproxy/option_aliases/processing"
require "imgproxy/options_builders/processing"
require "imgproxy/url_builders/base"

module Imgproxy
  module UrlBuilders
    # Builds imgproxy URL
    #
    #   builder = Imgproxy::UrlBuilders::Processing.new(
    #     width: 500,
    #     height: 400,
    #     resizing_type: :fill,
    #     sharpen: 0.5
    #   )
    #
    #   builder.url_for("http://images.example.com/images/image1.jpg")
    #   builder.url_for("http://images.example.com/images/image2.jpg")
    class Processing < Base
      OPTIONS_BUILDER = OptionsBuilders::Processing
      OPTION_ALIASES = Imgproxy::OptionAliases::PROCESSING

      # @param [Hash] options Processing options
      # @see Imgproxy.url_for
      def initialize(options = {})
        super(options)

        @format = @options.delete(:format)
      end

      # Genrates imgproxy URL
      #
      # @return [String] imgproxy URL
      # @param [String,URI, Object] image Source image URL or object applicable for
      #   the configured URL adapters
      # @see Imgproxy.url_for
      def url_for(image)
        path = [*option_strings, source_url(image, ext: @format)].join("/")
        signature = sign_path(path)

        File.join(endpoint.to_s, signature, path)
      end

      # # Genrates imgproxy info URL
      # #
      # # @return [String] imgproxy info URL
      # # @param [String,URI, Object] image Source image URL or object applicable for
      # #   the configured URL adapters
      # # @see Imgproxy.info_url_for
      # def info_url_for(image)
      #   path = url(image)
      #   signature = sign_path(path)

      #   File.join(endpoint.to_s, "info", signature, path)
      # end
    end
  end
end
