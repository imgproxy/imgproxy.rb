require "imgproxy/options_casters/group"
require "imgproxy/options_casters/string"
require "imgproxy/options_casters/float"

module Imgproxy
  module OptionsCasters
    # Casts `unsharp_masking` info option
    module UnsharpMasking
      CASTER = Imgproxy::OptionsCasters::Group.new(
        mode: Imgproxy::OptionsCasters::String,
        weight: Imgproxy::OptionsCasters::Float,
        divider: Imgproxy::OptionsCasters::Float,
      ).freeze

      def self.cast(raw)
        return raw unless raw.is_a?(Hash)

        values = CASTER.cast(raw)
        values[0] == "none" ? "none" : values
      end
    end
  end
end
