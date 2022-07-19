module Imgproxy
  module Extensions
    # Extension for Shrine::UploadedFile
    # @see Imgproxy.extend_shrine!
    module Shrine
      def self.with(service_name)
        Module.new.tap do |m|
          m.define_method(:__service_name) do
            service_name
          end

          m.prepend self
        end
      end

      # Returns imgproxy URL for a Shrine::UploadedFile instance
      #
      # @return [String]
      # @param options [Hash, Imgproxy::Builder]
      # @see Imgproxy.url_for
      def imgproxy_url(options = {})
        return options.url_for(self) if options.is_a?(Imgproxy::Builder)

        __imgproxy.url_for(self, options)
      end

      # Returns imgproxy info URL for a Shrine::UploadedFile instance
      #
      # @return [String]
      # @param options [Hash, Imgproxy::Builder]
      # @see Imgproxy.info_url_for
      def imgproxy_info_url(options = {})
        return options.info_url_for(self) if options.is_a?(Imgproxy::Builder)

        __imgproxy.info_url_for(self, options)
      end

      private

      def __imgproxy
        return Imgproxy unless respond_to?(:__service_name, true)
        return Imgproxy unless __service_name

        Imgproxy.service(__service_name)
      end
    end
  end
end
