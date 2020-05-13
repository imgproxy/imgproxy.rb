require "imgproxy/options_extractors/string"
require "imgproxy/options_extractors/float"
require "imgproxy/options_extractors/group"

module Imgproxy
  module OptionsExtractors
    # Extracts gravity option
    module Gravity
      EXTRACTOR = Imgproxy::OptionsExtractors::Group.new(
        Imgproxy::OptionsExtractors::String.new(:gravity),
        Imgproxy::OptionsExtractors::Float.new(:gravity_x),
        Imgproxy::OptionsExtractors::Float.new(:gravity_y),
      )

      def self.extract(raw)
        values = EXTRACTOR.extract(raw)
        values unless values[0].nil?
      end
    end
  end
end
