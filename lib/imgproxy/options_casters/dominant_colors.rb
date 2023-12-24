require "imgproxy/trim_array"
require "imgproxy/options_casters/bool"

module Imgproxy
  module OptionsCasters
    # Casts `dominant_colors` info option
    module DominantColors
      using TrimArray

      def self.cast(raw)
        # Allow dominant_colors to be just a boolean
        return Imgproxy::OptionsCasters::Bool.cast(raw) if [true, false].include?(raw)

        return raw unless raw.is_a?(Hash)
        return if raw[:dominant_colors].nil?

        values = [
          Imgproxy::OptionsCasters::Bool.cast(raw[:dominant_colors]),
          Imgproxy::OptionsCasters::Bool.cast(raw[:build_missed]),
        ].trim!
        values[0].zero? ? 0 : values
      end
    end
  end
end
