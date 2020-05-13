module Imgproxy
  module OptionsExtractors
    # Extracts float option
    class Float
      def initialize(key)
        @key = key
      end

      def extract(raw)
        raw[@key]&.to_f
      end
    end
  end
end
