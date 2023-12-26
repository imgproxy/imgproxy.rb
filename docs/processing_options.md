# Supported processing options

### [resize](https://docs.imgproxy.net/usage/processing#resize)

```ruby
{
  resize: {
    resizing_type: String || Symbol,
    width: Integer,
    height: Integer,
    enlarge: true || false,
    extend: extend, # See the 'extend' option
  }
}
```

### [size](https://docs.imgproxy.net/usage/processing#size)

```ruby
{
  size: {
    width: Integer,
    height: Integer,
    enlarge: true || false,
    extend: extend, # See the 'extend' option
  }
}
```

### [resizing_type](https://docs.imgproxy.net/usage/processing#resizing-type)

```ruby
{
  resizing_type: String || Symbol,
}
```

### [resizing_algorithm (pro)](https://docs.imgproxy.net/usage/processing#resizing-algorithm)

```ruby
{
  resizing_algorithm: String || Symbol,
}
```

### [width](https://docs.imgproxy.net/usage/processing#width)

```ruby
{
  width: Integer,
}
```

### [height](https://docs.imgproxy.net/usage/processing#height)

```ruby
{
  height: Integer,
}
```

### [min-width](https://docs.imgproxy.net/usage/processing#min-width)

```ruby
{
  "min-width": Integer,
}
```

### [min-height](https://docs.imgproxy.net/usage/processing#min-height)

```ruby
{
  "min-height": Integer,
}
```

### [zoom](https://docs.imgproxy.net/usage/processing#zoom)

```ruby
{
  zoom: {
    zoom_x_y: Float
  }
}
```

```ruby
{
  zoom: {
    zoom_x: Float
    zoom_y: Float
  }
}
```

### [dpr](https://docs.imgproxy.net/usage/processing#dpr)

```ruby
{
  dpr: Float,
}
```

### [enlarge](https://docs.imgproxy.net/usage/processing#enlarge)

```ruby
{
  enlarge: true || false,
}
```

### [extend](https://docs.imgproxy.net/usage/processing#extend)

```ruby
{
  extend: {
    extend: true || false,
    gravity: gravity, # See the 'gravity' option
  }
}
```

### [extend_aspect_ratio](https://docs.imgproxy.net/usage/processing#extend_aspect_ratio)

```ruby
{
  extend_aspect_ratio: {
    extend: true || false,
    gravity: gravity, # See the 'gravity' option
  }
}
```

### [gravity](https://docs.imgproxy.net/usage/processing#gravity)

```ruby
{
  gravity: {
    type: String || Symbol,
    x_offset: Float,
    y_offset: Float,
  }
}
```

#### Special gravities

```ruby
{
  gravity: {
    type: :fp,
    x_offset: Float,
    y_offset: Float,
  }
}
```

```ruby
{
  gravity: {
    type: :sm,
  }
}
```

```ruby
{
  gravity: {
    type: :obj,
    class_names: Array[String || Symbol],
  }
}
```

### [crop](https://docs.imgproxy.net/usage/processing#crop)

```ruby
{
  crop: {
    width: Float,
    height: Float,
    gravity: gravity, # See the 'gravity' option
  }
}
```

### [trim](https://docs.imgproxy.net/usage/processing#trim)

```ruby
{
  trim: {
    threshold: Float,
    color: String,
    equal_hor: true || false,
    equal_ver: true || false,
  }
}
```

### [padding](https://docs.imgproxy.net/usage/processing#padding)

```ruby
{
  padding: {
    top: Integer,
    right: Integer,
    bottom: Integer,
    left: Integer,
  }
}
```

### [auto_rotate](https://docs.imgproxy.net/usage/processing#auto-rotate)

```ruby
{
  auto_rotate: true || false
}
```

### [rotate](https://docs.imgproxy.net/usage/processing#rotate)

```ruby
{
  rotate: 90 || 180 || 270
}
```

### [background](https://docs.imgproxy.net/usage/processing#background)

```ruby
{
  background: {
    r: Integer,
    g: Integer,
    b: Integer,
  }
}
```

```ruby
{
  background: {
    hex_color: String,
  }
}
```

### [background_alpha (pro)](https://docs.imgproxy.net/usage/processing#background-alpha)

```ruby
{
  background_alpha: Float
}
```

### [adjust (pro)](https://docs.imgproxy.net/usage/processing#adjust)

```ruby
{
  adjust: {
    brightness: Integer,
    contrast: Float,
    saturation: Float,
  }
}
```

### [brightness (pro)](https://docs.imgproxy.net/usage/processing#brightness)

```ruby
{
  brightness: Integer,
}
```

### [contrast (pro)](https://docs.imgproxy.net/usage/processing#contrast)

```ruby
{
  contrast: Float,
}
```

### [saturation (pro)](https://docs.imgproxy.net/usage/processing#saturation)

```ruby
{
  saturation: Float,
}
```

### [blur](https://docs.imgproxy.net/usage/processing#blur)

```ruby
{
  blur: Float,
}
```

### [sharpen](https://docs.imgproxy.net/usage/processing#sharpen)

```ruby
{
  sharpen: Float,
}
```

### [pixelate (pro)](https://docs.imgproxy.net/usage/processing#pixelate)

```ruby
{
  pixelate: Integer,
}
```

### [unsharp_masking (pro)](https://docs.imgproxy.net/usage/processing#unsharp_masking)

```ruby
{
  unsharp_masking: {
    mode: String || Symbol,
    weight: Float,
    divider: Float,
  }
}
```

### [blur_detections (pro)](https://docs.imgproxy.net/usage/processing#blur-detections)

```ruby
{
  blur_detections: {
    sigma: Float,
    class_names: Array[String || Symbol],
  }
}
```

### [draw_detections (pro)](https://docs.imgproxy.net/usage/processing#draw-detections)

```ruby
{
  draw_detections: {
    draw: true || false,
    class_names: Array[String || Symbol],
  }
}
```

### [gradient (pro)](https://docs.imgproxy.net/usage/processing#gradient)

```ruby
{
  gradient: {
    opacity: Float,
    color: String,
    direction: String || Symbol,
    start: Float,
    stop: Float,
  }
}
```

### [watermark](https://docs.imgproxy.net/usage/processing#watermark)

```ruby
{
  watermark: {
    opacity: Float,
    position: String || Symbol,
    x_offset: Float,
    y_offset: Float,
    scale: Float,
  }
}
```

### [watermark_url (pro)](https://docs.imgproxy.net/usage/processing#watermark-url)

```ruby
{
  watermark_url: String # Encoded to Base64 automatically
}
```

### [watermark_text (pro)](https://docs.imgproxy.net/usage/processing#watermark-text)

```ruby
{
  watermark_text: String # Encoded to Base64 automatically
}
```

### [watermark_size (pro)](https://docs.imgproxy.net/usage/processing#watermark-size)

```ruby
{
  watermark_size: {
    width: Integer,
    height: Integer,
  }
}
```

### [watermark_shadow (pro)](https://docs.imgproxy.net/usage/processing#watermark-shadow)

```ruby
{
  watermark_shadow: Float
}
```

### [style (pro)](https://docs.imgproxy.net/usage/processing#style)

```ruby
{
  style: String # Encoded to Base64 automatically
}
```

### [strip_metadata](https://docs.imgproxy.net/usage/processing#strip-metadata)

```ruby
{
  strip_metadata: true || false,
}
```

### [keep_copyright](https://docs.imgproxy.net/usage/processing#keep-copyright)

```ruby
{
  keep_copyright: true || false,
}
```

### [dpi](https://docs.imgproxy.net/usage/processing#dpi)

```ruby
{
  dpi: Float,
}
```

### [strip_color_profile](https://docs.imgproxy.net/usage/processing#strip-color-profile)

```ruby
{
  strip_color_profile: true || false,
}
```

### [enforce_thumbnail](https://docs.imgproxy.net/usage/processing#enforce-thumbnail)

```ruby
{
  enforce_thumbnail: true || false,
}
```

### [quality](https://docs.imgproxy.net/usage/processing#quality)

```ruby
{
  quality: Integer,
}
```

### [format_quality](https://docs.imgproxy.net/usage/processing#format-quality)

```ruby
{
  format_quality: {
    jpeg: Integer,
    webp: Integer,
    avif: Integer,
    # etc...
  }
}
```

### [autoquality](https://docs.imgproxy.net/usage/processing#autoquality)

```ruby
{
  autoquality: {
    method: String || Symbol,
    target: Float,
    min_quality: Integer,
    max_quality: Integer,
    allowed_error: Float,
  }
}
```

### [max_bytes](https://docs.imgproxy.net/usage/processing#max-bytes)

```ruby
{
  max_bytes: Integer,
}
```

### [jpeg_options (pro)](https://docs.imgproxy.net/usage/processing#jpeg-options)

```ruby
{
  jpeg_options: {
    progressive: true || false,
    no_subsample: true || false,
    trellis_quant: true || false,
    overshoot_deringing: true || false,
    optimize_scans: true || false,
    quant_table: Integer,
  }
}
```

### [png_options (pro)](https://docs.imgproxy.net/usage/processing#png-options)

```ruby
{
  png_options: {
    interlaced: true || false,
    quantize: true || false,
    quantization_colors: Integer,
  }
}
```

### [webp_options (pro)](https://docs.imgproxy.net/usage/processing#webp-options)

```ruby
{
  webp_options: {
    compression: String || Symbol,
  }
}
```

### [format](https://docs.imgproxy.net/usage/processing#format)

```ruby
{
  format: String || Symbol
}
```

### [page (pro)](https://docs.imgproxy.net/usage/processing#page)

```ruby
{
  page: Integer
}
```

### [pages (pro)](https://docs.imgproxy.net/usage/processing#pages)

```ruby
{
  pages: Integer
}
```

### [disable_animation (pro)](https://docs.imgproxy.net/usage/processing#disable-animation)

```ruby
{
  disable_animation: true || false
}
```

### [video_thumbnail_second (pro)](https://docs.imgproxy.net/usage/processing#video-thumbnail-second)

```ruby
{
  video_thumbnail_second: Float
}
```

### [video_thumbnail_keyframes (pro)](https://docs.imgproxy.net/usage/processing#video-thumbnail-keyframes)

```ruby
{
  video_thumbnail_keyframes: true || false
}
```

### [video_thumbnail_tile (pro)](https://docs.imgproxy.net/usage/processing#video-thumbnail-tile)

```ruby
{
  video_thumbnail_tile: {
    step: Float,
    columns: Integer,
    rows: Integer,
    tile_width: Integer,
    tile_height: Integer,
    extend_tile: true || false,
    trim: true || false,
  }
}
```

### [fallback_image_url (pro)](https://docs.imgproxy.net/usage/processing#fallback-image-url)

```ruby
{
  fallback_image_url: String # Encoded to Base64 automatically
}
```

### [skip_processing](https://docs.imgproxy.net/usage/processing#skip-processing)

```ruby
{
  skip_processing: Array[String || Symbol]
}
```

### [raw](https://docs.imgproxy.net/usage/processing#raw)

```ruby
{
  raw: true || false
}
```

### [cachebuster](https://docs.imgproxy.net/usage/processing#cachebuster)

```ruby
{
  cachebuster: String || Symbol
}
```

### [expires](https://docs.imgproxy.net/usage/processing#expires)

```ruby
{
  expires: Integer || Time,
}
```

### [filename](https://docs.imgproxy.net/usage/processing#filename)

```ruby
{
  filename: String,
}
```

```ruby
{
  filename: {
    filename: String, # Encoded to Base64 automatically if :encoded is true
    encoded: true || false,
  }
}
```

### [return_attachment](https://docs.imgproxy.net/usage/processing#return-attachment)

```ruby
{
  return_attachment: true || false
}
```

### [preset](https://docs.imgproxy.net/usage/processing#preset)

```ruby
{
  preset: Array[String || Symbol]
}
```

### [hashsum](https://docs.imgproxy.net/usage/processing#hashsum)

```ruby
{
  hashsum: {
    hashsum_type: Array[String || Symbol]
    hashsum: String,
  }
}
```

### [max_src_resolution](https://docs.imgproxy.net/usage/processing#max-src-resolution)

```ruby
{
  max_src_resolution: Float
}
```

### [max_src_file_size](https://docs.imgproxy.net/usage/processing#max-src-file-size)

```ruby
{
  max_src_file_size: Integer
}
```

### [max_animation_frames](https://docs.imgproxy.net/usage/processing#max-animation-frames)

```ruby
{
  max_animation_frames: Integer
}
```

### [max_animation_frame_resolution](https://docs.imgproxy.net/usage/processing#max-animation-frame-resolution)

```ruby
{
  max_animation_frame_resolution: Float
}
```
