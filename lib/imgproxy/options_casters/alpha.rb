require "imgproxy/options_casters/group"
require "imgproxy/options_casters/bool"

module Imgproxy
  module OptionsCasters
    # Casts `alpha` info option
    module Alpha
      CASTER = Imgproxy::OptionsCasters::Group.new(
        alpha: Imgproxy::OptionsCasters::Bool,
        check_transparency: Imgproxy::OptionsCasters::Bool,
      ).freeze

      def self.cast(raw)
        # Allow alpha to be just a boolean
        return Imgproxy::OptionsCasters::Bool.cast(raw) if [true, false].include?(raw)

        return raw unless raw.is_a?(Hash)
        return if raw[:alpha].nil?

        values = CASTER.cast(raw)
        values[0].zero? ? 0 : values
      end
    end
  end
end
