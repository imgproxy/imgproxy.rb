module Imgproxy
  module OptionsExtractors
    # Extracts array option
    class Array
      def initialize(key)
        @key = key
      end

      def extract(raw)
        value = raw[@key]

        return if value.nil?

        value.is_a?(Array) ? value : [value]
      end
    end
  end
end
