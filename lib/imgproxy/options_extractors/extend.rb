require "imgproxy/options_extractors/string"
require "imgproxy/options_extractors/float"
require "imgproxy/options_extractors/bool"
require "imgproxy/options_extractors/group"

module Imgproxy
  module OptionsExtractors
    # Extracts extend option
    module Extend
      EXTRACTOR = Imgproxy::OptionsExtractors::Group.new(
        Imgproxy::OptionsExtractors::Bool.new(:extend),
        Imgproxy::OptionsExtractors::String.new(:extend_gravity),
        Imgproxy::OptionsExtractors::Float.new(:extend_gravity_x),
        Imgproxy::OptionsExtractors::Float.new(:extend_gravity_y),
      )

      def self.extract(raw)
        values = EXTRACTOR.extract(raw)

        return if values[0].nil?
        return 0 if values[0].zero?

        values
      end
    end
  end
end
