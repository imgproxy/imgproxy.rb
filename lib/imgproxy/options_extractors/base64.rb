require "base64"

module Imgproxy
  module OptionsExtractors
    # Extracts string option and encodes it to base64
    class Base64
      def initialize(key)
        @key = key
      end

      def extract(raw)
        value = raw[@key]
        ::Base64.urlsafe_encode64(value.to_s).tr("=", "") unless value.nil?
      end
    end
  end
end
