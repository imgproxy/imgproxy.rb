# frozen_string_literal: true

require "imgproxy/trim_array"
require "imgproxy/options_casters/string"
require "imgproxy/options_casters/group"
require "imgproxy/options_casters/array"
require "imgproxy/options_casters/float"

module Imgproxy
  module OptionsCasters
    # Casts `gravity` processing option
    module Gravity
      using TrimArray

      CLASS_NAMES_CASTER = Imgproxy::OptionsCasters::Group.new(
        class_names: Imgproxy::OptionsCasters::Array,
      )
      OFFSETS_CASTER = Imgproxy::OptionsCasters::Group.new(
        x_offset: Imgproxy::OptionsCasters::Float,
        y_offset: Imgproxy::OptionsCasters::Float,
      )

      def self.cast(raw)
        return raw unless raw.is_a?(Hash)
        return unless raw[:type]

        type = Imgproxy::OptionsCasters::String.cast(raw[:type])

        case type
        when "sm" then type
        when "obj" then [type, *CLASS_NAMES_CASTER.cast(raw)].trim!
        else [type, *OFFSETS_CASTER.cast(raw)].trim!
        end
      end
    end
  end
end
