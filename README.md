# imgproxy.rb

[![Gem](https://img.shields.io/gem/v/imgproxy.svg?style=for-the-badge)](https://rubygems.org/gems/imgproxy) [![rubydoc.org](https://img.shields.io/badge/rubydoc-reference-blue.svg?style=for-the-badge)](https://www.rubydoc.info/gems/imgproxy/)

Gem for [imgproxy](https://github.com/DarthSim/imgproxy) URLs generation.

[imgproxy](https://github.com/DarthSim/imgproxy) is a fast and secure standalone server for resizing and converting remote images. The main principles of imgproxy are simplicity, speed, and security.

## Installation

```
gem install imgproxy
```

or add it to your `Gemfile`:

```ruby
gem "imgproxy"
```

## Configuration

```ruby
# config/initializers/imgproxy.rb

Imgproxy.configure do |config|
  # imgproxy endpoint
  config.endpoint = "http://imgproxy.example.com"
  # hex-encoded signature key
  config.hex_key = "your_key"
  # hex-encoded signature salt
  config.hex_salt = "your_salt"
  # signature size. Defaults to 32
  config.signature_size = 5
  # use short processing option names (`rs` for `resize`, `g` for `gravity`, etc).
  # Defaults to true
  config.use_short_options = false
end
```

## Usage

```ruby
Imgproxy.url_for(
  "http://images.example.com/images/image.jpg",
  width: 500,
  height: 400,
  resizing_type: :fill,
  sharpen: 0.5
)
# => http://imgproxy.example.com/2tjGMpWqjO/rs:fill:500:400/sh:0.5/plain/http://images.example.com/images/image.jpg
```

You can reuse processing options by using `Imgproxy::Builder`:

```ruby
builder = Imgproxy::Builder.new(
  width: 500,
  height: 400,
  resizing_type: :fill,
  sharpen: 0.5
)

builder.url_for("http://images.example.com/images/image1.jpg")
builder.url_for("http://images.example.com/images/image2.jpg")
```

Available options are:

* `resizing_type`
* `width`
* `height`
* `dpr`
* `enlarge`
* `extend`
* `gravity`
* `gravity_x`
* `gravity_y`
* `quality`
* `background`
* `blur`
* `sharpen`
* `watermark_opacity`
* `watermark_position`
* `watermark_x_offset`
* `watermark_y_offset`
* `watermark_scale`
* `preset`
* `cachebuster`
* `format`
* `use_short_options`

_See [imgproxy URL format guide](https://github.com/DarthSim/imgproxy/blob/master/docs/generating_the_url_advanced.md) for more info_

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/imgproxy/imgproxy.rb.

## License
The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
