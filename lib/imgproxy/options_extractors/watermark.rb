require "imgproxy/options_extractors/string"
require "imgproxy/options_extractors/integer"
require "imgproxy/options_extractors/float"
require "imgproxy/options_extractors/group"

module Imgproxy
  module OptionsExtractors
    # Extracts string option
    module Watermark
      EXTRACTOR = Imgproxy::OptionsExtractors::Group.new(
        Imgproxy::OptionsExtractors::Float.new(:watermark_opacity),
        Imgproxy::OptionsExtractors::String.new(:watermark_position),
        Imgproxy::OptionsExtractors::Integer.new(:watermark_x_offset),
        Imgproxy::OptionsExtractors::Integer.new(:watermark_y_offset),
        Imgproxy::OptionsExtractors::Float.new(:watermark_scale),
      )

      def self.extract(raw)
        values = EXTRACTOR.extract(raw)
        values unless values[0].nil?
      end
    end
  end
end
