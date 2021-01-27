require "imgproxy/options_extractors/string"
require "imgproxy/options_extractors/integer"
require "imgproxy/options_extractors/float"
require "imgproxy/options_extractors/bool"
require "imgproxy/options_extractors/array"
require "imgproxy/options_extractors/base64"
require "imgproxy/options_extractors/extend"
require "imgproxy/options_extractors/gravity"
require "imgproxy/options_extractors/crop"
require "imgproxy/options_extractors/trim"
require "imgproxy/options_extractors/watermark"

module Imgproxy
  # Formats and regroups processing options
  class Options < Hash
    OPTS = {
      resize:        nil,
      size:          nil,
      resizing_type: Imgproxy::OptionsExtractors::String.new(:resizing_type),
      width:         Imgproxy::OptionsExtractors::Integer.new(:width),
      height:        Imgproxy::OptionsExtractors::Integer.new(:height),
      dpr:           Imgproxy::OptionsExtractors::Float.new(:dpr),
      enlarge:       Imgproxy::OptionsExtractors::Bool.new(:enlarge),
      extend:        Imgproxy::OptionsExtractors::Extend,
      gravity:       Imgproxy::OptionsExtractors::Gravity,
      crop:          Imgproxy::OptionsExtractors::Crop,
      padding:       Imgproxy::OptionsExtractors::Array.new(:padding),
      trim:          Imgproxy::OptionsExtractors::Trim,
      quality:       Imgproxy::OptionsExtractors::Integer.new(:quality),
      max_bytes:     Imgproxy::OptionsExtractors::Integer.new(:max_bytes),
      background:    Imgproxy::OptionsExtractors::Array.new(:background),
      adjust:        nil,
      brightness:    Imgproxy::OptionsExtractors::Integer.new(:brightness),
      contrast:      Imgproxy::OptionsExtractors::Float.new(:contrast),
      saturation:    Imgproxy::OptionsExtractors::Float.new(:saturation),
      blur:          Imgproxy::OptionsExtractors::Float.new(:blur),
      sharpen:       Imgproxy::OptionsExtractors::Float.new(:sharpen),
      pixelate:      Imgproxy::OptionsExtractors::Integer.new(:pixelate),
      watermark:     Imgproxy::OptionsExtractors::Watermark,
      watermark_url: Imgproxy::OptionsExtractors::Base64.new(:watermark_url),
      style:         Imgproxy::OptionsExtractors::Base64.new(:style),
      preset:        Imgproxy::OptionsExtractors::Array.new(:preset),
      cachebuster:   Imgproxy::OptionsExtractors::String.new(:cachebuster),
      format:        Imgproxy::OptionsExtractors::String.new(:format),
      filename:      Imgproxy::OptionsExtractors::String.new(:filename),
      video_thumbnail_second: Imgproxy::OptionsExtractors::Integer.new(:video_thumbnail_second),
      strip_metadata:         Imgproxy::OptionsExtractors::Bool.new(:strip_metadata),
    }.freeze

    # @param options [Hash] raw processing options
    def initialize(options)
      OPTS.each do |name, extractor|
        # Options order hack, part 1:
        # We have some meta-options that we will deal with a bit later.
        # But we want them to be ordered properly in the hash.
        # So we just reserve a place for them for now.
        next self[name] = nil if extractor.nil?

        val = extractor.extract(options)
        self[name] = val unless val.nil?
      end

      group_resizing_opts
      group_adjust_opts

      # Options order hack, part 2:
      # Since some meta-options may be not set, we need to clean has from nils
      compact!
    end

    private

    def group_resizing_opts
      return unless self[:width] && self[:height]

      self[:size] = extract_and_trim_nils(:width, :height, :enlarge, :extend)

      self[:resize] = [delete(:resizing_type), *delete(:size)] if self[:resizing_type]
    end

    def group_adjust_opts
      return unless values_at(:brightness, :contrast, :saturation).count { |o| !o.nil? } > 1

      self[:adjust] = extract_and_trim_nils(:brightness, :contrast, :saturation)
    end

    def extract_and_trim_nils(*keys)
      values = keys.map { |k| delete(k) }
      values.delete_at(-1) while !values.empty? && values.last.nil?
      values
    end
  end
end
