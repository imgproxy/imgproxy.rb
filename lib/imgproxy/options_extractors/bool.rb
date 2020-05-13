module Imgproxy
  module OptionsExtractors
    # Extracts boolean option
    class Bool
      def initialize(key)
        @key = key
      end

      def extract(raw)
        value = raw[@key]

        return if value.nil?
        return 1 if value && value != 0 && value != "0"

        0
      end
    end
  end
end
