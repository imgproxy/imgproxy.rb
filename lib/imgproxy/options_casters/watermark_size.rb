require "imgproxy/options_casters/integer"
require "imgproxy/options_casters/bool"
require "imgproxy/options_casters/extend"

module Imgproxy
  module OptionsCasters
    # Casts `watermark_size` processing option
    module WatermarkSize
      def self.cast(raw)
        return raw unless raw.is_a?(Hash)

        [
          Imgproxy::OptionsCasters::Integer.cast(raw[:width]) || 0,
          Imgproxy::OptionsCasters::Integer.cast(raw[:height]) || 0,
        ]
      end
    end
  end
end
