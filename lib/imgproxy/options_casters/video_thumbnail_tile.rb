# frozen_string_literal: true

require "imgproxy/options_casters/group"
require "imgproxy/options_casters/float"
require "imgproxy/options_casters/integer"
require "imgproxy/options_casters/bool"

module Imgproxy
  module OptionsCasters
    # Casts `video_thumbnail_tile` processing option
    module VideoThumbnailTile
      CASTER = Imgproxy::OptionsCasters::Group.new(
        step: Imgproxy::OptionsCasters::Float,
        columns: Imgproxy::OptionsCasters::Integer,
        rows: Imgproxy::OptionsCasters::Integer,
        tile_width: Imgproxy::OptionsCasters::Integer,
        tile_height: Imgproxy::OptionsCasters::Integer,
        extend_tile: Imgproxy::OptionsCasters::Bool,
        trim: Imgproxy::OptionsCasters::Bool,
        fill: Imgproxy::OptionsCasters::Bool,
        focus_x: Imgproxy::OptionsCasters::Float,
        focus_y: Imgproxy::OptionsCasters::Float,
      ).freeze

      def self.cast(raw)
        # Allow video_thumbnail_tile to be just a zero
        return 0 if raw.is_a?(Numeric) && raw.zero?

        return raw unless raw.is_a?(Hash)
        return unless raw[:step]

        values = CASTER.cast(raw)
        values[0].zero? ? 0 : values
      end
    end
  end
end
