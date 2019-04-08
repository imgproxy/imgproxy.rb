require "imgproxy/url_adapters/active_storage"

module Imgproxy
  class UrlAdapters
    # Adapter for ActiveStorage with S3 service
    #
    #   Imgproxy.configure do |config|
    #     config.url_adapters.add Imgproxy::UrlAdapters::ActiveStorageS3.new
    #   end
    #
    #   Imgproxy.url_for(user.avatar)
    class ActiveStorageS3 < Imgproxy::UrlAdapters::ActiveStorage
      def applicable?(image)
        super &&
          image.service.is_a?(::ActiveStorage::Service::S3Service)
      end

      def url(image)
        "s3://#{image.service.bucket.name}/#{image.key}"
      end
    end
  end
end
