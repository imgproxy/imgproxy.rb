# frozen_string_literal: true

module Imgproxy
  module Extensions
    # Extension for Shrine::UploadedFile
    # @see Imgproxy.extend_shrine!
    module Shrine
      # Returns imgproxy URL for a Shrine::UploadedFile instance
      #
      # @return [String]
      # @param options [Hash, Imgproxy::UrlBuilders::Processing]
      # @see Imgproxy.url_for
      def imgproxy_url(options = {})
        return options.url_for(self) if options.is_a?(Imgproxy::UrlBuilders::Processing)
        Imgproxy.url_for(self, options)
      end

      # Returns imgproxy info URL for a Shrine::UploadedFile instance
      #
      # @return [String]
      # @param options [Hash, Imgproxy::UrlBuilders::Info]
      # @see Imgproxy.info_url_for
      def imgproxy_info_url(options = {})
        return options.info_url_for(self) if options.is_a?(Imgproxy::UrlBuilders::Info)
        Imgproxy.info_url_for(self, options)
      end
    end
  end
end
