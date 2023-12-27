# frozen_string_literal: true

require "imgproxy/options_casters/group"
require "imgproxy/options_casters/float"
require "imgproxy/options_casters/string"

module Imgproxy
  module OptionsCasters
    # Casts `watermark` processing option
    module Watermark
      CASTER = Imgproxy::OptionsCasters::Group.new(
        opacity: Imgproxy::OptionsCasters::Float,
        position: Imgproxy::OptionsCasters::String,
        x_offset: Imgproxy::OptionsCasters::Float,
        y_offset: Imgproxy::OptionsCasters::Float,
        scale: Imgproxy::OptionsCasters::Float,
      ).freeze

      def self.cast(raw)
        # Allow watermark to be just a numeric
        return Imgproxy::OptionsCasters::Float.cast(raw) if raw.is_a?(Numeric)

        return raw unless raw.is_a?(Hash)
        return unless raw[:opacity]

        values = CASTER.cast(raw)
        values[0].zero? ? 0 : values
      end
    end
  end
end
