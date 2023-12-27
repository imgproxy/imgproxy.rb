<!--
# @title Supported info options
-->
# Supported info options

### [size](https://docs.imgproxy.net/usage/getting_info#size)

```ruby
{
  size: true || false
}
```

### [format](https://docs.imgproxy.net/usage/getting_info#format)

```ruby
{
  format: true || false
}
```

### [dimensions](https://docs.imgproxy.net/usage/getting_info#dimensions)

```ruby
{
  dimensions: true || false
}
```

### [video_meta](https://docs.imgproxy.net/usage/getting_info#video-meta)

```ruby
{
  video_meta: true || false
}
```

### [detect_objects](https://docs.imgproxy.net/usage/getting_info#detect-objects)

```ruby
{
  detect_objects: true || false
}
```

### [colorspace](https://docs.imgproxy.net/usage/getting_info#colorspace)

```ruby
{
  colorspace: true || false
}
```

### [bands](https://docs.imgproxy.net/usage/getting_info#bands)

```ruby
{
  bands: true || false
}
```

### [sample_format](https://docs.imgproxy.net/usage/getting_info#sample-format)

```ruby
{
  sample_format: true || false
}
```

### [pages_number](https://docs.imgproxy.net/usage/getting_info#pages-number)

```ruby
{
  pages_number: true || false
}
```

### [alpha](https://docs.imgproxy.net/usage/getting_info#alpha)

```ruby
{
  alpha: {
    alpha: true || false,
    check_transparency: true || false,
  }
}
```

### [crop](https://docs.imgproxy.net/usage/getting_info#crop)

```ruby
{
  crop: {
    width: Float,
    height: Float,
    gravity: gravity, # See the 'gravity' processing option
  }
}
```

### [palette](https://docs.imgproxy.net/usage/getting_info#palette)

```ruby
{
  palette: Integer
}
```

### [average](https://docs.imgproxy.net/usage/getting_info#average)

```ruby
{
  average: {
    average: true || false,
    ignore_transparent: true || false,
  }
}
```

### [dominant_colors](https://docs.imgproxy.net/usage/getting_info#dominant_colors)

```ruby
{
  dominant_colors: {
    dominant_colors: true || false,
    build_missed: true || false,
  }
}
```

### [blurhash](https://docs.imgproxy.net/usage/getting_info#blurhash)

```ruby
{
  blurhash: {
    x_components: Integer,
    y_components: Integer,
  }
}
```

### [calc_hashsum](https://docs.imgproxy.net/usage/getting_info#calc_hashsum)

```ruby
{
  calc_hashsum: Array[String || Symbol]
}
```

### [page](https://docs.imgproxy.net/usage/getting_info#page)

```ruby
{
  page: Integer
}
```

### [video_thumbnail_second](https://docs.imgproxy.net/usage/getting_info#video_thumbnail_second)

```ruby
{
  video_thumbnail_second: Float
}
```

### [video_thumbnail_keyframes](https://docs.imgproxy.net/usage/getting_info#video_thumbnail_keyframes)

```ruby
{
  video_thumbnail_keyframes: true || false
}
```

### [cachebuster](https://docs.imgproxy.net/usage/getting_info#cachebuster)

```ruby
{
  cachebuster: String || Symbol
}
```

### [expires](https://docs.imgproxy.net/usage/getting_info#expires)

```ruby
{
  expires: Integer || Time,
}
```

### [preset](https://docs.imgproxy.net/usage/getting_info#preset)

```ruby
{
  preset: Array[String || Symbol]
}
```

### [hashsum](https://docs.imgproxy.net/usage/getting_info#hashsum)

```ruby
{
  hashsum: {
    hashsum_type: Array[String || Symbol]
    hashsum: String,
  }
}
```

### [max_src_resolution](https://docs.imgproxy.net/usage/getting_info#max_src_resolution)

```ruby
{
  max_src_resolution: Float
}
```

### [max_src_file_size](https://docs.imgproxy.net/usage/getting_info#max_src_file_size)

```ruby
{
  max_src_file_size: Integer
}
```
