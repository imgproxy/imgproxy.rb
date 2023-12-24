require "imgproxy/trim_array"
require "imgproxy/options_casters/bool"

module Imgproxy
  module OptionsCasters
    # Casts `average` info option
    module Average
      using TrimArray

      def self.cast(raw)
        # Allow average to be just a boolean
        return Imgproxy::OptionsCasters::Bool.cast(raw) if [true, false].include?(raw)

        return raw unless raw.is_a?(Hash)
        return if raw[:average].nil?

        values = [
          Imgproxy::OptionsCasters::Bool.cast(raw[:average]),
          Imgproxy::OptionsCasters::Bool.cast(raw[:ignore_transparent]),
        ].trim!
        values[0].zero? ? 0 : values
      end
    end
  end
end
