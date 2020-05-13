require "imgproxy/options_extractors/string"
require "imgproxy/options_extractors/integer"
require "imgproxy/options_extractors/bool"
require "imgproxy/options_extractors/group"

module Imgproxy
  module OptionsExtractors
    # Extracts trim option
    module Trim
      EXTRACTOR = Imgproxy::OptionsExtractors::Group.new(
        Imgproxy::OptionsExtractors::Integer.new(:trim_threshold),
        Imgproxy::OptionsExtractors::String.new(:trim_color),
        Imgproxy::OptionsExtractors::Bool.new(:trim_equal_hor),
        Imgproxy::OptionsExtractors::Bool.new(:trim_equal_ver),
      )

      def self.extract(raw)
        values = EXTRACTOR.extract(raw)
        values unless values[0].nil?
      end
    end
  end
end
