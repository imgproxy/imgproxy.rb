require "imgproxy/url_adapters/active_storage"

module Imgproxy
  class UrlAdapters
    # Adapter for ActiveStorage with S3 service
    #
    #   Imgproxy.configure do |config|
    #     config.url_adapters.add Imgproxy::UrlAdapters::ActiveStorageGCS.new("bucket_name")
    #   end
    #
    #   Imgproxy.url_for(user.avatar)
    class ActiveStorageGCS < Imgproxy::UrlAdapters::ActiveStorage
      # @param [String] bucket_name Google Cloud Storage bucket name
      def initialize(bucket_name)
        @bucket_name = bucket_name
      end

      # @return [String] Google Cloud Storage bucket name
      attr_reader :bucket_name

      def applicable?(image)
        super &&
          image.service.is_a?(::ActiveStorage::Service::GCSService)
      end

      def url(image)
        "gs://#{bucket_name}/#{image.key}"
      end
    end
  end
end
