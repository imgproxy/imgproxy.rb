require "imgproxy/trim_array"
require "imgproxy/options_casters/float"

module Imgproxy
  module OptionsCasters
    # Casts `zoom` info option
    module Zoom
      using TrimArray

      def self.cast(raw)
        # Allow zoom to be just a float
        return Imgproxy::OptionsCasters::Float.cast(raw) if raw.is_a?(Numeric)

        return raw unless raw.is_a?(Hash)

        return Imgproxy::OptionsCasters::Float.cast(raw[:zoom_x_y]) if raw.key?(:zoom_x_y)

        [
          Imgproxy::OptionsCasters::Float.cast(raw[:zoom_x]) || 1,
          Imgproxy::OptionsCasters::Float.cast(raw[:zoom_y]) || 1,
        ].trim!
      end
    end
  end
end
