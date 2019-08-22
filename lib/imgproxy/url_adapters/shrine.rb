module Imgproxy
  class UrlAdapters
    # Adapter for Shrine
    #
    #   Imgproxy.configure do |config|
    #     config.url_adapters.add Imgproxy::UrlAdapters::Shrine.new
    #   end
    #
    #   Imgproxy.url_for(user.avatar)
    class Shrine
      def initialize(host: nil)
        @host = host
      end

      def applicable?(image)
        image.is_a?(::Shrine::UploadedFile)
      end

      def url(image)
        opts = {}
        opts[:host] = @host if @host
        image.url(opts)
      end
    end
  end
end
