# frozen_string_literal: true

require "imgproxy/options_casters/group"
require "imgproxy/options_casters/float"
require "imgproxy/options_casters/string"

module Imgproxy
  module OptionsCasters
    # Casts `gradient` processing option
    module Gradient
      CASTER = Imgproxy::OptionsCasters::Group.new(
        opacity: Imgproxy::OptionsCasters::Float,
        color: Imgproxy::OptionsCasters::String,
        direction: Imgproxy::OptionsCasters::String,
        start: Imgproxy::OptionsCasters::Float,
        stop: Imgproxy::OptionsCasters::Float,
      ).freeze

      def self.cast(raw)
        # Allow gradient to be just a numeric
        return Imgproxy::OptionsCasters::Float.cast(raw) if raw.is_a?(Numeric)

        return raw unless raw.is_a?(Hash)
        return if raw[:opacity].nil?

        values = CASTER.cast(raw)
        values[0].zero? ? 0 : values
      end
    end
  end
end
