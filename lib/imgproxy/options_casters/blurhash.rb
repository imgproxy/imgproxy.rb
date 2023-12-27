# frozen_string_literal: true

require "imgproxy/options_casters/group"
require "imgproxy/options_casters/integer"

module Imgproxy
  module OptionsCasters
    # Casts `blurhash` info option
    module Blurhash
      CASTER = Imgproxy::OptionsCasters::Group.new(
        x_components: Imgproxy::OptionsCasters::Integer,
        y_components: Imgproxy::OptionsCasters::Integer,
      ).freeze

      def self.cast(raw)
        return raw unless raw.is_a?(Hash)
        CASTER.cast(raw)
      end
    end
  end
end
