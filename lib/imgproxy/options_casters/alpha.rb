require "imgproxy/trim_array"
require "imgproxy/options_casters/bool"

module Imgproxy
  module OptionsCasters
    # Casts `alpha` info option
    module Alpha
      using TrimArray

      def self.cast(raw)
        # Allow alpha to be just a boolean
        return Imgproxy::OptionsCasters::Bool.cast(raw) if [true, false].include?(raw)

        return raw unless raw.is_a?(Hash)
        return if raw[:alpha].nil?

        values = [
          Imgproxy::OptionsCasters::Bool.cast(raw[:alpha]),
          Imgproxy::OptionsCasters::Bool.cast(raw[:check_transparency]),
        ].trim!
        values[0].zero? ? 0 : values
      end
    end
  end
end
