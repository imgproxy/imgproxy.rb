require "imgproxy/options_casters/group"
require "imgproxy/options_casters/string"

module Imgproxy
  module OptionsCasters
    # Casts `hashsum` info option
    module Hashsum
      CASTER = Imgproxy::OptionsCasters::Group.new(
        hashsum_type: Imgproxy::OptionsCasters::String,
        hashsum: Imgproxy::OptionsCasters::String,
      ).freeze

      def self.cast(raw)
        return raw unless raw.is_a?(Hash)
        return if raw[:hashsum_type].nil?

        values = CASTER.cast(raw)
        values[0] == "none" ? "none" : values
      end
    end
  end
end
