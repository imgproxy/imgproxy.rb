require "imgproxy/option_aliases/info"
require "imgproxy/options_builders/info"
require "imgproxy/url_builders/base"

module Imgproxy
  module UrlBuilders
    # Builds imgproxy info URL
    #
    #   builder = Imgproxy::UrlBuilders::Info.new(
    #     width: 500,
    #     height: 400,
    #     resizing_type: :fill,
    #     sharpen: 0.5
    #   )
    #
    #   builder.url_for("http://images.example.com/images/image1.jpg")
    #   builder.url_for("http://images.example.com/images/image2.jpg")
    class Info < Base
      OPTIONS_BUILDER = OptionsBuilders::Info
      OPTION_ALIASES = Imgproxy::OptionAliases::INFO

      # @param [Hash] options Info options
      # @see Imgproxy.info_url_for
      def initialize(options = {})
        super
      end

      # Genrates imgproxy info URL
      #
      # @return [String] imgproxy info URL
      # @param [String,URI, Object] image Source image URL or object applicable for
      #   the configured URL adapters
      # @see Imgproxy.info_url_for
      def url_for(image)
        path = [*option_strings, sourcce_url(image)].join("/")
        signature = sign_path(path)

        File.join(endpoint.to_s, "info", signature, path)
      end
    end
  end
end
