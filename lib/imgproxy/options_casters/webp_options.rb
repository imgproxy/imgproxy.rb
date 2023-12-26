require "imgproxy/options_casters/group"
require "imgproxy/options_casters/string"

module Imgproxy
  module OptionsCasters
    # Casts `webp_options` processing option
    module WebpOptions
      CASTER = Imgproxy::OptionsCasters::Group.new(
        compression: Imgproxy::OptionsCasters::String,
      ).freeze

      def self.cast(raw)
        return raw unless raw.is_a?(Hash)

        values = CASTER.cast(raw)
        values.empty? ? nil : values
      end
    end
  end
end
