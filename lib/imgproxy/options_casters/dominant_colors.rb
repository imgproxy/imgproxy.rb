require "imgproxy/options_casters/group"
require "imgproxy/options_casters/bool"

module Imgproxy
  module OptionsCasters
    # Casts `dominant_colors` info option
    module DominantColors
      CASTER = Imgproxy::OptionsCasters::Group.new(
        dominant_colors: Imgproxy::OptionsCasters::Bool,
        build_missed: Imgproxy::OptionsCasters::Bool,
      ).freeze

      def self.cast(raw)
        # Allow dominant_colors to be just a boolean
        return Imgproxy::OptionsCasters::Bool.cast(raw) if [true, false].include?(raw)

        return raw unless raw.is_a?(Hash)
        return if raw[:dominant_colors].nil?

        values = CASTER.cast(raw)
        values[0].zero? ? 0 : values
      end
    end
  end
end
