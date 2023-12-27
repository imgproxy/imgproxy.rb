require "imgproxy/options_builders/base"

require "imgproxy/options_casters/string"
require "imgproxy/options_casters/integer"
require "imgproxy/options_casters/float"
require "imgproxy/options_casters/bool"
require "imgproxy/options_casters/array"
require "imgproxy/options_casters/base64"
require "imgproxy/options_casters/resize"
require "imgproxy/options_casters/size"
require "imgproxy/options_casters/zoom"
require "imgproxy/options_casters/extend"
require "imgproxy/options_casters/gravity"
require "imgproxy/options_casters/crop"
require "imgproxy/options_casters/trim"
require "imgproxy/options_casters/padding"
require "imgproxy/options_casters/background"
require "imgproxy/options_casters/adjust"
require "imgproxy/options_casters/unsharp_masking"
require "imgproxy/options_casters/blur_detections"
require "imgproxy/options_casters/draw_detections"
require "imgproxy/options_casters/gradient"
require "imgproxy/options_casters/watermark"
require "imgproxy/options_casters/watermark_size"
require "imgproxy/options_casters/format_quality"
require "imgproxy/options_casters/autoquality"
require "imgproxy/options_casters/jpeg_options"
require "imgproxy/options_casters/png_options"
require "imgproxy/options_casters/webp_options"
require "imgproxy/options_casters/video_thumbnail_tile"
require "imgproxy/options_casters/filename"
require "imgproxy/options_casters/hashsum"

module Imgproxy
  module OptionsBuilders
    # Formats and regroups processing options
    class Processing < Base
      CASTERS = {
        resize:                         Imgproxy::OptionsCasters::Resize,
        size:                           Imgproxy::OptionsCasters::Size,
        resizing_type:                  Imgproxy::OptionsCasters::String,
        resizing_algorithm:             Imgproxy::OptionsCasters::String,
        width:                          Imgproxy::OptionsCasters::Integer,
        height:                         Imgproxy::OptionsCasters::Integer,
        "min-width":                    Imgproxy::OptionsCasters::Integer,
        "min-height":                   Imgproxy::OptionsCasters::Integer,
        zoom:                           Imgproxy::OptionsCasters::Zoom,
        dpr:                            Imgproxy::OptionsCasters::Float,
        enlarge:                        Imgproxy::OptionsCasters::Bool,
        extend:                         Imgproxy::OptionsCasters::Extend,
        extend_aspect_ratio:            Imgproxy::OptionsCasters::Extend,
        gravity:                        Imgproxy::OptionsCasters::Gravity,
        crop:                           Imgproxy::OptionsCasters::Crop,
        trim:                           Imgproxy::OptionsCasters::Trim,
        padding:                        Imgproxy::OptionsCasters::Padding,
        auto_rotate:                    Imgproxy::OptionsCasters::Bool,
        rotate:                         Imgproxy::OptionsCasters::Integer,
        background:                     Imgproxy::OptionsCasters::Background,
        background_alpha:               Imgproxy::OptionsCasters::Float,
        adjust:                         Imgproxy::OptionsCasters::Adjust,
        brightness:                     Imgproxy::OptionsCasters::Integer,
        contrast:                       Imgproxy::OptionsCasters::Float,
        saturation:                     Imgproxy::OptionsCasters::Float,
        blur:                           Imgproxy::OptionsCasters::Float,
        sharpen:                        Imgproxy::OptionsCasters::Float,
        pixelate:                       Imgproxy::OptionsCasters::Integer,
        unsharp_masking:                Imgproxy::OptionsCasters::UnsharpMasking,
        blur_detections:                Imgproxy::OptionsCasters::BlurDetections,
        draw_detections:                Imgproxy::OptionsCasters::DrawDetections,
        gradient:                       Imgproxy::OptionsCasters::Gradient,
        watermark:                      Imgproxy::OptionsCasters::Watermark,
        watermark_url:                  Imgproxy::OptionsCasters::Base64,
        watermark_text:                 Imgproxy::OptionsCasters::Base64,
        watermark_size:                 Imgproxy::OptionsCasters::WatermarkSize,
        watermark_shadow:               Imgproxy::OptionsCasters::Float,
        style:                          Imgproxy::OptionsCasters::Base64,
        strip_metadata:                 Imgproxy::OptionsCasters::Bool,
        keep_copyright:                 Imgproxy::OptionsCasters::Bool,
        dpi:                            Imgproxy::OptionsCasters::Float,
        strip_color_profile:            Imgproxy::OptionsCasters::Bool,
        enforce_thumbnail:              Imgproxy::OptionsCasters::Bool,
        quality:                        Imgproxy::OptionsCasters::Integer,
        format_quality:                 Imgproxy::OptionsCasters::FormatQuality,
        autoquality:                    Imgproxy::OptionsCasters::Autoquality,
        max_bytes:                      Imgproxy::OptionsCasters::Integer,
        jpeg_options:                   Imgproxy::OptionsCasters::JpegOptions,
        png_options:                    Imgproxy::OptionsCasters::PngOptions,
        webp_options:                   Imgproxy::OptionsCasters::WebpOptions,
        format:                         Imgproxy::OptionsCasters::String,
        page:                           Imgproxy::OptionsCasters::Integer,
        pages:                          Imgproxy::OptionsCasters::Integer,
        disable_animation:              Imgproxy::OptionsCasters::Bool,
        video_thumbnail_second:         Imgproxy::OptionsCasters::Integer,
        video_thumbnail_keyframes:      Imgproxy::OptionsCasters::Bool,
        video_thumbnail_tile:           Imgproxy::OptionsCasters::VideoThumbnailTile,
        fallback_image_url:             Imgproxy::OptionsCasters::Base64,
        skip_processing:                Imgproxy::OptionsCasters::Array,
        raw:                            Imgproxy::OptionsCasters::Bool,
        cachebuster:                    Imgproxy::OptionsCasters::String,
        expires:                        Imgproxy::OptionsCasters::Integer,
        filename:                       Imgproxy::OptionsCasters::Filename,
        return_attachment:              Imgproxy::OptionsCasters::Bool,
        preset:                         Imgproxy::OptionsCasters::Array,
        hashsum:                        Imgproxy::OptionsCasters::Hashsum,
        max_src_resolution:             Imgproxy::OptionsCasters::Float,
        max_src_file_size:              Imgproxy::OptionsCasters::Integer,
        max_animation_frames:           Imgproxy::OptionsCasters::Integer,
        max_animation_frame_resolution: Imgproxy::OptionsCasters::Float,
      }.freeze

      META = %i[size resize adjust].freeze

      def initialize(options)
        super

        # Legacy name for unsharp_masking
        if options.key?(:unsharpening)
          warn "[DEPRECATION] `unsharpening` option is deprecated. Please use `unsharp_masking` instead."
          delete(:unsharpening)
          unless self.key?(:unsharp_masking)
            self[:unsharp_masking] = CASTERS[:unsharp_masking].cast(options[:unsharpening])
          end
        end
      end

      private

      def group_opts
        group_resizing_opts
        group_adjust_opts
      end

      def group_resizing_opts
        return unless self[:width] && self[:height] && !self[:size] && !self[:resize]

        self[:size] = extract_and_trim_nils(:width, :height, :enlarge, :extend)
        self[:resize] = [delete(:resizing_type), *delete(:size)] if self[:resizing_type]
      end

      def group_adjust_opts
        return if self[:adjust]
        return unless values_at(:brightness, :contrast, :saturation).count { |o| o } > 1

        self[:adjust] = extract_and_trim_nils(:brightness, :contrast, :saturation)
      end
    end
  end
end
