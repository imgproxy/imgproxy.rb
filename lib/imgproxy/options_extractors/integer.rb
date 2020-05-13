module Imgproxy
  module OptionsExtractors
    # Extracts integer option
    class Integer
      def initialize(key)
        @key = key
      end

      def extract(raw)
        raw[@key]&.to_i
      end
    end
  end
end
