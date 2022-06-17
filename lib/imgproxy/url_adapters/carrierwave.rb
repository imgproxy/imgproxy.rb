module Imgproxy
  class UrlAdapters
    # Adapter for Carrierwave
    #
    #   Imgproxy.configure do |config|
    #     config.url_adapters.add Imgproxy::UrlAdapters::Carrierwave.new
    #   end
    #
    #   Imgproxy.url_for(user.avatar)
    class Carrierwave
      def applicable?(image)
        image.is_a?(::CarrierWave::Uploader::Base)
      end

      def url(image)
        image.url
      end
    end
  end
end
