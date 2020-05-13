module Imgproxy
  module OptionsExtractors
    # Extracts group of options and trim nils from the end
    class Group
      def initialize(*extractors)
        @extractors = extractors
      end

      def extract(raw)
        values = @extractors.map { |extractor| extractor.extract(raw) }
        values.delete_at(-1) while !values.empty? && values.last.nil?
        values
      end
    end
  end
end
