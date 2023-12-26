require "imgproxy/trim_array"
require "imgproxy/options_casters/float"
require "imgproxy/options_casters/array"

module Imgproxy
  module OptionsCasters
    # Casts `blur_detections` processing option
    module BlurDetections
      using TrimArray

      def self.cast(raw)
        # Allow blur_detections to be just a numeric
        return Imgproxy::OptionsCasters::Float.cast(raw) if raw.is_a?(Numeric)

        return raw unless raw.is_a?(Hash)
        return unless raw[:sigma]

        values = [
          Imgproxy::OptionsCasters::Float.cast(raw[:sigma]),
          *Imgproxy::OptionsCasters::Array.cast(raw[:class_names]),
        ].trim!
        values[0].zero? ? 0 : values
      end
    end
  end
end
