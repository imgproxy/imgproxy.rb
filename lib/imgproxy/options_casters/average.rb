# frozen_string_literal: true

require "imgproxy/options_casters/group"
require "imgproxy/options_casters/bool"

module Imgproxy
  module OptionsCasters
    # Casts `average` info option
    module Average
      CASTER = Imgproxy::OptionsCasters::Group.new(
        average: Imgproxy::OptionsCasters::Bool,
        ignore_transparent: Imgproxy::OptionsCasters::Bool,
      ).freeze

      def self.cast(raw)
        # Allow average to be just a boolean
        return Imgproxy::OptionsCasters::Bool.cast(raw) if [true, false].include?(raw)

        return raw unless raw.is_a?(Hash)
        return if raw[:average].nil?

        values = CASTER.cast(raw)
        values[0].zero? ? 0 : values
      end
    end
  end
end
