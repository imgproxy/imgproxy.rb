# frozen_string_literal: true

require "imgproxy/options_builders/base"

require "imgproxy/options_casters/string"
require "imgproxy/options_casters/integer"
require "imgproxy/options_casters/float"
require "imgproxy/options_casters/bool"
require "imgproxy/options_casters/array"
require "imgproxy/options_casters/alpha"
require "imgproxy/options_casters/crop"
require "imgproxy/options_casters/average"
require "imgproxy/options_casters/dominant_colors"
require "imgproxy/options_casters/blurhash"
require "imgproxy/options_casters/hashsum"

module Imgproxy
  module OptionsBuilders
    # Formats and regroups info options
    class Info < Base
      CASTERS = {
        size: Imgproxy::OptionsCasters::Bool,
        format: Imgproxy::OptionsCasters::Bool,
        dimensions: Imgproxy::OptionsCasters::Bool,
        exif: Imgproxy::OptionsCasters::Bool,
        iptc: Imgproxy::OptionsCasters::Bool,
        video_meta: Imgproxy::OptionsCasters::Bool,
        detect_objects: Imgproxy::OptionsCasters::Bool,
        colorspace: Imgproxy::OptionsCasters::Bool,
        bands: Imgproxy::OptionsCasters::Bool,
        sample_format: Imgproxy::OptionsCasters::Bool,
        pages_number: Imgproxy::OptionsCasters::Bool,
        alpha: Imgproxy::OptionsCasters::Alpha,
        crop: Imgproxy::OptionsCasters::Crop,
        palette: Imgproxy::OptionsCasters::Integer,
        average: Imgproxy::OptionsCasters::Average,
        dominant_colors: Imgproxy::OptionsCasters::DominantColors,
        blurhash: Imgproxy::OptionsCasters::Blurhash,
        calc_hashsums: Imgproxy::OptionsCasters::Array,
        page: Imgproxy::OptionsCasters::Integer,
        video_thumbnail_second: Imgproxy::OptionsCasters::Integer,
        video_thumbnail_keyframes: Imgproxy::OptionsCasters::Bool,
        cachebuster: Imgproxy::OptionsCasters::String,
        expires: Imgproxy::OptionsCasters::Integer,
        preset: Imgproxy::OptionsCasters::Array,
        hashsum: Imgproxy::OptionsCasters::Hashsum,
        max_src_resolution: Imgproxy::OptionsCasters::Float,
        max_src_file_size: Imgproxy::OptionsCasters::Integer,
      }.freeze
    end
  end
end
