require "imgproxy/options_casters/group"
require "imgproxy/options_casters/string"
require "imgproxy/options_casters/bool"
require "imgproxy/options_casters/base64"

module Imgproxy
  module OptionsCasters
    # Casts `filename` processing option
    module Filename
      CASTER = Imgproxy::OptionsCasters::Group.new(
        filename: Imgproxy::OptionsCasters::String,
        encoded: Imgproxy::OptionsCasters::Bool,
      ).freeze

      def self.cast(raw)
        return raw unless raw.is_a?(Hash)
        return if raw[:filename].nil?

        encoded = Imgproxy::OptionsCasters::Bool.cast(raw[:encoded])

        if encoded.nil? || encoded.zero?
          return Imgproxy::OptionsCasters::String.cast(raw[:filename])
        end

        [Imgproxy::OptionsCasters::Base64.cast(raw[:filename]), 1]
      end
    end
  end
end
