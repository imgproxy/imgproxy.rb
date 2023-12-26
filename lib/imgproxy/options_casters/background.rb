require "imgproxy/options_casters/group"
require "imgproxy/options_casters/integer"
require "imgproxy/options_casters/string"

module Imgproxy
  module OptionsCasters
    # Casts `background` info option
    module Background
      CASTER = Imgproxy::OptionsCasters::Group.new(
        r: Imgproxy::OptionsCasters::Integer,
        g: Imgproxy::OptionsCasters::Integer,
        b: Imgproxy::OptionsCasters::Integer,
      ).freeze

      def self.cast(raw)
        return raw.map { |v| Imgproxy::OptionsCasters::Integer.cast(v) } if raw.is_a?(::Array)

        return raw unless raw.is_a?(Hash)
        return Imgproxy::OptionsCasters::String.cast(raw[:hex_color]) if raw.key?(:hex_color)

        CASTER.cast(raw)
      end
    end
  end
end
