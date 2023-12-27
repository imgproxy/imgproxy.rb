<!--
# @title Upgrading imgproxy.rb
-->

# Upgrading imgproxy.rb

## Upgrading 2.x to 3.x

Version 3.0 brings a single breaking change and a single deprecation:

* `Imgproxy::Builder` class was replaced with `Imgproxy::UrlBuilders::Processing`. If you don't use URL builders directly, you are not affected by this change. Otherwise, just replace the old class with the new one:

**Was:**

```ruby
builder = Imgproxy::Builder.new(
  width: 500,
  height: 400,
  resizing_type: :fill,
  sharpen: 0.5
)
```

**Becomes:**

```ruby
builder = Imgproxy::UrlBuilders::Processing.new(
  width: 500,
  height: 400,
  resizing_type: :fill,
  sharpen: 0.5
)
```

* The `unsharpening` processing option was deprecated, use the `unsharp_masking` option.

## Upgrading 1.x to 2.x

Version 2.0 brings several breaking changes. Here are some things you need to know to safely upgrade from version 1.x to 2.0.

* If you use `key` and `salt` config options to provide raw (not hex-encoded) key/salt pair, use `raw_key` and `raw_salt` instead.

**Was:**

```ruby
Imgproxy.configure do |config|
  config.key = "your_raw_key"
  config.salt = "your_raw_salt"
end
```

**Becomes:**

```ruby
Imgproxy.configure do |config|
  config.raw_key = "your_raw_key"
  config.raw_salt = "your_raw_salt"
end
```

* If you use `hex_key` and `hex_salt` config options to provide hex-encoded key/salt pair, use `key` and `salt` instead.

**Was:**

```ruby
Imgproxy.configure do |config|
  config.hex_key = "your_key"
  config.hex_salt = "your_salt"
end
```

**Becomes:**

```ruby
Imgproxy.configure do |config|
  config.key = "your_key"
  config.salt = "your_salt"
end
```

* If you use complex processing options with multiple arguments like `crop`, `gravity`, `watermark`, etc, rewrite their usage according to the [Complex processing options](README.md#complex-processing-options) chapter in the gem's documentation.

**Was:**

```ruby
Imgproxy.url_for(
  image_url,
  crop_width: 500,
  crop_height: 600,
  crop_gravity: :nowe,
  watermark_opacity: 0.5,
  watermark_scale: 0.3
)
```

**Becomes:**

```ruby
Imgproxy.url_for(
  image_url,
  crop: { width: 500, height: 600, gravity: { type: :nowe } },
  watermark: { opacity: 0.5, scale: 0.3 }
)
```

* If you use integration with Active Storage, put `gem "imgproxy"` after `gem "rails"` in your `Gemfile` and remove `Imgproxy.extend_active_storage!` from your initializer. Active Storage support is enabled automatically since the version 2.0.

* If you use integration with Shrine, put `gem "imgproxy"` after `gem "shrine"` in your `Gemfile` and remove `Imgproxy.extend_shrine!` from your initializer. Shrine support is enabled automatically since the version 2.0.

* If you use additional options for the Active Storage or Shrine integrations, move them to centralized config under `Imgproxy.configure`.

**Was:**

```ruby
Imgproxy.extend_active_storage!(
  use_s3: true,
  use_gcs: true,
  gcs_bucket: "my_bucket"
)

Imgproxy.extend_shrine!(
  host: "http://your-host.test",
  use_s3: true
)
```

**Becomes:**

```ruby
Imgproxy.configure do |config|
  config.use_s3_urls = true
  config.use_gcs_urls = true
  config.gcs_bucket = "my_bucket"
  config.shrine_host = "http://your-host.test"
end
```
