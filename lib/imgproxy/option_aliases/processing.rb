# frozen_string_literal: true

module Imgproxy
  module OptionAliases
    PROCESSING = {
      resize: :rs,
      size: :s,
      resizing_type: :rt,
      resizing_algorithm: :ra,
      width: :w,
      height: :h,
      "min-width": :mw,
      "min-height": :mh,
      zoom: :z,
      enlarge: :el,
      extend: :ex,
      extend_aspect_ratio: :exar,
      gravity: :g,
      crop: :c,
      trim: :t,
      padding: :pd,
      auto_rotate: :ar,
      rotate: :rot,
      background: :bg,
      background_alpha: :bga,
      adjust: :a,
      brightness: :br,
      contrast: :co,
      saturation: :sa,
      blur: :bl,
      sharpen: :sh,
      pixelate: :pix,
      unsharp_masking: :ush,
      blur_detections: :bd,
      draw_detections: :dd,
      gradient: :gr,
      watermark: :wm,
      watermark_url: :wmu,
      watermark_text: :wmt,
      watermark_size: :wms,
      watermark_shadow: :wmsh,
      style: :st,
      strip_metadata: :sm,
      keep_copyright: :kcr,
      strip_color_profile: :scp,
      enforce_thumbnail: :eth,
      quality: :q,
      format_quality: :fq,
      autoquality: :aq,
      max_bytes: :mb,
      jpeg_options: :jpego,
      png_options: :pngo,
      webp_options: :webpo,
      page: :pg,
      pages: :pgs,
      disable_animation: :da,
      video_thumbnail_second: :vts,
      video_thumbnail_keyframes: :vtk,
      video_thumbnail_tile: :vtt,
      fallback_image_url: :fiu,
      skip_processing: :skp,
      cachebuster: :cb,
      expires: :exp,
      filename: :fn,
      return_attachment: :att,
      preset: :pr,
      hashsum: :hs,
      max_src_resolution: :msr,
      max_src_file_size: :msfs,
      max_animation_frames: :maf,
      max_animation_frame_resolution: :mafr,
    }.freeze
  end
end
