# frozen_string_literal: true

require "imgproxy/options_casters/integer"

module Imgproxy
  module OptionsCasters
    # Casts `format_quality` info option
    module FormatQuality
      def self.cast(raw)
        return raw unless raw.is_a?(Hash)

        raw.flat_map do |format, quality|
          next if quality.nil?
          [format.to_s, Imgproxy::OptionsCasters::Integer.cast(quality)]
        end.compact
      end
    end
  end
end
