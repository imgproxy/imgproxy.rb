# frozen_string_literal: true

require "imgproxy/options_casters/group"
require "imgproxy/options_casters/string"
require "imgproxy/options_casters/integer"
require "imgproxy/options_casters/float"

module Imgproxy
  module OptionsCasters
    # Casts `autoquality` processing option
    module Autoquality
      CASTER = Imgproxy::OptionsCasters::Group.new(
        method: Imgproxy::OptionsCasters::String,
        target: Imgproxy::OptionsCasters::Float,
        min_quality: Imgproxy::OptionsCasters::Integer,
        max_quality: Imgproxy::OptionsCasters::Integer,
        allowed_error: Imgproxy::OptionsCasters::Float,
      ).freeze

      def self.cast(raw)
        return raw unless raw.is_a?(Hash)

        values = CASTER.cast(raw)
        (values[0] == "none") ? "none" : values
      end
    end
  end
end
