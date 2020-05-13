require "imgproxy/options_extractors/string"
require "imgproxy/options_extractors/float"
require "imgproxy/options_extractors/group"

module Imgproxy
  module OptionsExtractors
    # Extracts crop option
    module Crop
      WIDTH_EXTRACTOR = Imgproxy::OptionsExtractors::Integer.new(:crop_width)
      HEIGHT_EXTRACTOR = Imgproxy::OptionsExtractors::Integer.new(:crop_height)
      GRAVITY_EXTRACTOR = Imgproxy::OptionsExtractors::Group.new(
        Imgproxy::OptionsExtractors::String.new(:crop_gravity),
        Imgproxy::OptionsExtractors::Float.new(:crop_gravity_x),
        Imgproxy::OptionsExtractors::Float.new(:crop_gravity_y),
      )

      def self.extract(raw)
        width = WIDTH_EXTRACTOR.extract(raw)
        height = HEIGHT_EXTRACTOR.extract(raw)
        gravity = GRAVITY_EXTRACTOR.extract(raw)

        return unless width || height

        gravity = nil if gravity[0].nil?

        [width || 0, height || 0, *gravity]
      end
    end
  end
end
