require "imgproxy/options_casters/group"
require "imgproxy/options_casters/integer"

module Imgproxy
  module OptionsCasters
    # Casts `padding` info option
    module Padding
      CASTER = Imgproxy::OptionsCasters::Group.new(
        top: Imgproxy::OptionsCasters::Integer,
        right: Imgproxy::OptionsCasters::Integer,
        bottom: Imgproxy::OptionsCasters::Integer,
        left: Imgproxy::OptionsCasters::Integer,
      ).freeze

      def self.cast(raw)
        # Allow padding to be just a number
        return Imgproxy::OptionsCasters::Integer.cast(raw) if raw.is_a?(Numeric)

        return raw.map { |v| Imgproxy::OptionsCasters::Integer.cast(v) } if raw.is_a?(::Array)

        return raw unless raw.is_a?(Hash)

        compact CASTER.cast(raw)
      end

      # rubocop:disable Metrics/AbcSize
      def self.compact(values)
        if values[0] == values[1] && values[0] == values[2] && values[0] == values[3]
          return values[0]
        end

        return values[0, 2] if values[0] == values[2] && values[1] == values[3]

        return values[0, 3] if values[1] == values[3]

        values
      end
      # rubocop:enable Metrics/AbcSize
    end
  end
end
