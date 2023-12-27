# frozen_string_literal: true

module Imgproxy
  module OptionAliases
    INFO = {
      size: :s,
      format: :f,
      dimensions: :d,
      video_meta: :vm,
      detect_objects: :do,
      colorspace: :cs,
      bands: :b,
      sample_format: :sf,
      pages_number: :pn,
      alpha: :a,
      crop: :c,
      palette: :p,
      average: :avg,
      dominant_colors: :dc,
      blurhash: :bh,
      calc_hashsum: :chs,
      page: :pg,
      video_thumbnail_second: :vts,
      video_thumbnail_keyframes: :vtk,
      cachebuster: :cb,
      expires: :exp,
      preset: :pr,
      hashsum: :hs,
      max_src_resolution: :msr,
      max_src_file_size: :msfs,
    }.freeze
  end
end
