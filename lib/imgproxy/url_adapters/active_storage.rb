module Imgproxy
  class UrlAdapters
    # Adapter for ActiveStorage
    #
    #   Imgproxy.configure do |config|
    #     config.url_adapters.add Imgproxy::UrlAdapters::ActiveStorage.new
    #   end
    #
    #   Imgproxy.url_for(user.avatar)
    class ActiveStorage
      def applicable?(image)
        image.is_a?(::ActiveStorage::Attached::One) ||
          image.is_a?(::ActiveStorage::Attachment) ||
          image.is_a?(::ActiveStorage::Blob)
      end

      def url(image)
        Rails.application.routes.url_helpers.url_for(image)
      end
    end
  end
end
