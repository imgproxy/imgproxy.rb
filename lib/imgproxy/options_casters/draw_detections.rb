require "imgproxy/trim_array"
require "imgproxy/options_casters/bool"
require "imgproxy/options_casters/array"

module Imgproxy
  module OptionsCasters
    # Casts `draw_detections` processing option
    module DrawDetections
      using TrimArray

      def self.cast(raw)
        # Allow draw_detections to be just a boolean
        return Imgproxy::OptionsCasters::Bool.cast(raw) if [true, false].include?(raw)

        return raw unless raw.is_a?(Hash)
        return unless raw[:draw]

        values = [
          Imgproxy::OptionsCasters::Bool.cast(raw[:draw]),
          *Imgproxy::OptionsCasters::Array.cast(raw[:class_names]),
        ].trim!
        values[0].zero? ? 0 : values
      end
    end
  end
end
