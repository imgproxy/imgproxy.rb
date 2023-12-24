module Imgproxy
  module OptionAliases
    PROCESSING = {
      resize: :rs,
      size: :s,
      resizing_type: :rt,
      resizing_algorithm: :ra,
      width: :w,
      height: :h,
      enlarge: :el,
      extend: :ex,
      gravity: :g,
      crop: :c,
      padding: :pd,
      trim: :t,
      rotate: :rot,
      quality: :q,
      max_bytes: :mb,
      background: :bg,
      background_alpha: :bga,
      adjust: :a,
      brightness: :br,
      contrast: :co,
      saturation: :sa,
      blur: :bl,
      sharpen: :sh,
      pixelate: :pix,
      unsharpening: :ush,
      watermark: :wm,
      watermark_url: :wmu,
      watermark_text: :wmt,
      style: :st,
      jpeg_options: :jpego,
      png_options: :pngo,
      gif_options: :gifo,
      page: :pg,
      video_thumbnail_second: :vts,
      preset: :pr,
      cachebuster: :cb,
      strip_metadata: :sm,
      strip_color_profile: :scp,
      auto_rotate: :ar,
      filename: :fn,
      return_attachment: :att,
      expires: :exp,
    }.freeze
  end
end
