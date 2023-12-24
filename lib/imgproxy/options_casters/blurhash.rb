require "imgproxy/trim_array"
require "imgproxy/options_casters/integer"

module Imgproxy
  module OptionsCasters
    # Casts `blurhash` info option
    module Blurhash
      using TrimArray

      def self.cast(raw)
        return raw unless raw.is_a?(Hash)

        [
          Imgproxy::OptionsCasters::Integer.cast(raw[:x_components]),
          Imgproxy::OptionsCasters::Integer.cast(raw[:y_components]),
        ].trim!
      end
    end
  end
end
