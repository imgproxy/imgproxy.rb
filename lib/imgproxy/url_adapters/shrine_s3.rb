module Imgproxy
  class UrlAdapters
    # Adapter for Shrinew ith S3 storage
    #
    #   Imgproxy.configure do |config|
    #     config.url_adapters.add Imgproxy::UrlAdapters::ShrineS3.new
    #   end
    #
    #   Imgproxy.url_for(user.avatar)
    class ShrineS3 < Imgproxy::UrlAdapters::Shrine
      def applicable?(image)
        super && image.storage.is_a?(::Shrine::Storage::S3)
      end

      def url(image)
        "s3://#{image.storage.bucket.name}/#{image.id}"
      end
    end
  end
end
