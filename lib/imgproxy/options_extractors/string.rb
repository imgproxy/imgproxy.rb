module Imgproxy
  module OptionsExtractors
    # Extracts string option
    class String
      def initialize(key)
        @key = key
      end

      def extract(raw)
        raw[@key]&.to_s
      end
    end
  end
end
