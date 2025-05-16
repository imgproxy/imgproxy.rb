<p align="center">
  <a href="https://imgproxy.net">
    <picture>
      <source media="(prefers-color-scheme: dark)" srcset="assets/logo-dark.svg?sanitize=true">
      <source media="(prefers-color-scheme: light)" srcset="assets/logo-light.svg?sanitize=true">
      <img alt="imgproxy logo" src="assets/logo-light.svg?sanitize=true">
    </picture>
  </a>
</p>

<p align="center"><strong>
  <a href="https://imgproxy.net">Website</a> |
  <a href="https://imgproxy.net/blog/">Blog</a> |
  <a href="https://docs.imgproxy.net">Documentation</a> |
  <a href="https://imgproxy.net/#pro">imgproxy Pro</a>
</strong></p>

<p align="center">
  <a href="https://github.com/imgproxy/imgproxy/pkgs/container/imgproxy"><img alt="Docker" src="https://img.shields.io/badge/Docker-0068F1?style=for-the-badge&logo=docker&logoColor=fff" /></a>
  <a href="https://bsky.app/profile/imgproxy.net"><img alt="Bluesky" src="https://img.shields.io/badge/Bluesky-0068F1?style=for-the-badge&logo=bluesky&logoColor=fff" /></a>
  <a href="https://x.com/imgproxy_net"><img alt="X" src="https://img.shields.io/badge/X.com-0068F1?style=for-the-badge&logo=x&logoColor=fff" /></a>
  <a href="https://mastodon.social/@imgproxy"><img alt="X" src="https://img.shields.io/badge/Mastodon-0068F1?style=for-the-badge&logo=mastodon&logoColor=fff" /></a>
  <a href="https://discord.gg/5GgpXgtC9u"><img alt="Discord" src="https://img.shields.io/badge/Discord-0068F1?style=for-the-badge&logo=discord&logoColor=fff" /></a>
</p>

<p align="center">
<a href="https://github.com/imgproxy/imgproxy.rb/actions"><img alt="GH Test" src="https://img.shields.io/github/actions/workflow/status/imgproxy/imgproxy.rb/test.yml?branch=master&label=Test&style=for-the-badge"/></a>
<a href="https://github.com/imgproxy/imgproxy.rb/actions"><img alt="GH Lint" src="https://img.shields.io/github/actions/workflow/status/imgproxy/imgproxy.rb/lint.yml?branch=master&label=Lint&style=for-the-badge"/></a>
<a href="https://rubygems.org/gems/imgproxy"><img alt="Gem" src="https://img.shields.io/gem/v/imgproxy.svg?style=for-the-badge"/></a>
<a href="https://www.rubydoc.info/gems/imgproxy"><img alt="rubydoc.org" src="https://img.shields.io/badge/rubydoc-reference-blue.svg?style=for-the-badge"/></a>
</p>

---

[imgproxy](https://imgproxy.net) is a fast and secure standalone server for resizing and converting remote images. The main principles of imgproxy are simplicity, speed, and security. It is a Go application, ready to be installed and used in any Unix environment—also ready to be containerized using Docker.

imgproxy can be used to provide a fast and secure way to _get rid of all the image resizing code_ in your web application (like calling ImageMagick or GraphicsMagick, or using libraries), while also being able to resize everything on the fly on a separate server that only you control. imgproxy is fast, easy to use, and requires zero processing power or storage from the main application. imgproxy is indispensable when handling image resizing of epic proportions, especially when original images are coming from a remote source.

[imgproxy.rb](https://github.com/imgproxy/imgproxy.rb) is a framework-agnostic Ruby Gem for imgproxy that includes proper support for Ruby on Rails' most popular image attachment options: [Active Storage](https://edgeguides.rubyonrails.org/active_storage_overview.html) and [Shrine](https://github.com/shrinerb/shrine).

> [!IMPORTANT]
> This readme shows documentation for version 3.x.
>
> * For version 2.x see the [v2.1.0](https://github.com/imgproxy/imgproxy.rb/tree/v2.1.0) tag
> * For version 1.x see the [v1.2.0](https://github.com/imgproxy/imgproxy.rb/tree/v1.2.0) tag
>
> See [Upgrading imgproxy.rb](UPGRADE.md) for the upgrade guide.

## Installation

Add this to your `Gemfile`:

```ruby
gem "imgproxy"
```

or install system-wide:

```bash
gem install imgproxy
```

## Configuration

imgproxy.rb uses [anyway_config](https://github.com/palkan/anyway_config) to load configuration, so you can configure it in different ways.

With a separate config file:

```yaml
# <Rails root>/config/imgproxy.yml
development:
  # Full URL to where your imgproxy lives.
  endpoint: "http://imgproxy.example.com"
  # Hex-encoded signature key and salt
  key: "your_key"
  salt: "your_salt"
production: ...
test: ...
```

With a `secrets.yml` entry for imgproxy:

```yaml
# secrets.yml
production:
  ...
  imgproxy:
    # Full URL to where your imgproxy lives.
    endpoint: "http://imgproxy.example.com"
    # Hex-encoded signature key and salt
    key: "your_key"
    salt: "your_salt"
...
```

With environment variables:

```bash
IMGPROXY_ENDPOINT="http://imgproxy.example.com" \
IMGPROXY_KEY="your_key" \
IMGPROXY_SALT="your_salt" \
rails s
```

...or right in your application code:

```ruby
# config/initializers/imgproxy.rb

Imgproxy.configure do |config|
  # Full URL to where your imgproxy lives.
  config.endpoint = "http://imgproxy.example.com"
  # Hex-encoded signature key and salt
  config.key = "your_key"
  config.salt = "your_salt"
end
```

### Configuration options

* `endpoint` (`IMGPROXY_ENDPOINT`) - Full URL to your imgproxy instance. Default: `nil`.
* `key` (`IMGPROXY_KEY`) - Hex-encoded signature key. Default: `nil`.
* `salt` (`IMGPROXY_SALT`) - Hex-encoded signature salt. Default: `nil`.
* `raw_key` (`IMGPROXY_RAW_KEY`) - Raw (not hex-encoded) signature key. Default: `nil`.
* `raw_salt` (`IMGPROXY_RAW_SALT`) - Raw (not hex-encoded) signature salt. Default: `nil`.
* `signature_size` (`IMGPROXY_SIGNATURE_SIZE`) - Signature size. See [URL signature](https://docs.imgproxy.net/configuration/options#url-signature) section of imgproxy docs. Default: 32.
* `use_short_options` (`IMGPROXY_USE_SHORT_OPTIONS`) - Use short processing options names (`rs` for `resize`, `g` for `gravity`, etc). Default: true.
* `base64_encode_urls` (`IMGPROXY_BASE64_ENCODE_URLS`) - Encode source URLs to base64. Default: false.
* `always_escape_plain_urls` (`IMGPROXY_ALWAYS_ESCAPE_PLAIN_URLS`) - Always escape plain source URLs even when ones don't need to be escaped. Default: false.
* `source_url_encryption_key` (`IMGPROXY_SOURCE_URL_ENCRYPTION_KEY`) - Hex-encoded source URL encryption key. Default: `nil`.
* `raw_source_url_encryption_key` (`IMGPROXY_RAW_SOURCE_URL_ENCRYPTION_KEY`) - Raw (not hex-encoded) source URL encryption key. Default: `nil`.
* `always_encrypt_source_urls` (`IMGPROXY_ALWAYS_ENCRYPT_SOURCE_URLS`) - Always encrypt source URLs. Default: false.
* `use_s3_urls` (`IMGPROXY_USE_S3_URLS`) - Use `s3://...` source URLs for Active Storage and Shrine attachments stored in Amazon S3. Default: false.
* `use_gcs_urls` (`IMGPROXY_USE_GCS_URLS`) - Use `gs://...` source URLs for Active Storage and Shrine attachments stored in Google Cloud Storage. Default: false.
* `gcs_bucket` (`IMGPROXY_GCS_BUCKET`) - Google Cloud Storage bucket name. Default: `nil`.
* `shrine_host` (`IMGPROXY_SHRINE_HOST`) - Shrine host for locally stored files.

## Usage

### Using with Active Storage

imgproxy.rb comes with the Active Storage support built-in. It is enabled _automagically_ if you load `imgproxy` gem after `rails` (basically, just put `gem "imgproxy"` after `gem "rails"` in your `Gemfile`). Otherwise, modify your initializer at `config/initializers/imgproxy.rb`:

```ruby
# config/initializers/imgproxy.rb

Imgproxy.extend_active_storage!
```

Now, to add imgproxy processing to your image attachments, just use the `imgproxy_url` method:

```ruby
user.avatar.imgproxy_url(width: 500, height: 400, resizing_type: :fill)
```

This method will return a URL to your user's avatar, resized to fill 500x400px on the fly.

If you're a happy user of [imgproxy Pro](https://imgproxy.net#pro), you may find useful it's [Getting an image info](https://docs.imgproxy.net/usage/getting_info) feature. imgproxy.rb allows you to easily generate info URLs for your images:

```ruby
user.avatar.imgproxy_info_url(detect_objects: true, palette: 128)
```

This method will return a URL to the JSON with the requested info about your user's avatar.

#### Amazon S3

If you have configured both your imgproxy server and Active Storage to work with Amazon S3, you can use `use_s3_urls` config option (or `IMGPROXY_USE_S3_URLS` env variable) to make imgproxy.rb use short `s3://...` source URLs instead of long ones generated by Rails.

#### Google Cloud Storage

You can also enable `gs://...` URLs usage for the files stored in Google Cloud Storage with `use_gcs_urls` and `gcs_bucket` config options (or `IMGPROXY_USE_GCS_URLS` and `IMGPROXY_GCS_BUCKET` env variables).

> [!IMPORTANT]
> You need to explicitly provide GCS bucket name since Active Storage "hides" the GCS config.

### Using with Shrine

You can also use imgproxy.rb's built-in [Shrine](https://github.com/shrinerb/shrine) support. It is enabled automagically if you load `imgproxy` gem after `shrine` (basically, just put `gem "imgproxy"` after `gem "shrine"` in your `Gemfile`). Otherwise, modify your initializer at `config/initializers/imgproxy.rb`:

```ruby
# config/initializers/imgproxy.rb

Imgproxy.extend_shrine!
```

Now you can use `imgproxy_url` method of `Shrine::UploadedFile`:

```ruby
user.avatar.imgproxy_url(width: 500, height: 400, resizing_type: :fill)
```

This method will return a URL to your user's avatar, resized to fill 500x400px on the fly.

If you're a happy user of [imgproxy Pro](https://imgproxy.net#pro), you may find useful it's [Getting an image info](https://docs.imgproxy.net/usage/getting_info) feature. imgproxy.rb allows you to easily generate info URLs for your images:

```ruby
user.avatar.imgproxy_info_url(detect_objects: true, palette: 128)
```

This method will return a URL to the JSON with the requested info about your user's avatar.

> [!IMPORTANT]
> If you use `Shrine::Storage::FileSystem` as storage, uploaded file URLs won't include the hostname, so imgproxy server won't be able to access them. To fix this, use `shrine_host` config.
>
> Alternatively, you can launch your imgproxy server with the `IMGPROXY_BASE_URL` setting:
>
> ```
> IMGPROXY_BASE_URL="http://your-host.test" imgproxy
> ```

#### Amazon S3

If you have configured both your imgproxy server and Shrine to work with Amazon S3, you can use `use_s3_urls` config option (or `IMGPROXY_USE_S3_URLS` env variable) to make imgproxy.rb use short `s3://...` source URLs instead of long ones generated by Shrine.

### Usage imgproxy.rb in a framework-agnostic way

If you use another gem for your attachment operations, you like to keep things minimal or Rails-free, or if you want to generate imgproxy URLs for pictures that did not originate from your application, you can use the `Imgproxy.url_for` method:

```ruby
Imgproxy.url_for(
  "http://images.example.com/images/image.jpg",
  width: 500,
  height: 400,
  resizing_type: :fill
)
```

This method will return a URL to the image, resized to fill 500x400px on the fly.

If you're a happy user of [imgproxy Pro](https://imgproxy.net#pro), you may find useful it's [Getting an image info](https://docs.imgproxy.net/usage/getting_info) feature. imgproxy.rb allows you to easily generate info URLs for your images:

```ruby
Imgproxy.info_url_for(
  "http://images.example.com/images/image.jpg",
  detect_objects: true,
  palette: 128
)
```

This method will return a URL to the JSON with the requested info about the image.

You can reuse processing options by using `Imgproxy::Builder`:

```ruby
builder = Imgproxy::UrlBuilders::Processing.new(
  width: 500,
  height: 400,
  resizing_type: :fill,
  sharpen: 0.5
)

builder.url_for("http://images.example.com/images/image1.jpg")
builder.url_for("http://images.example.com/images/image2.jpg")

info_builder = Imgproxy::UrlBuilders::Info.new(
  detect_objects: true,
  palette: 128
)

info_builder.url_for("http://images.example.com/images/image1.jpg")
info_builder.url_for("http://images.example.com/images/image2.jpg")
```

## Supported imgproxy options

### Common options

* `base64_encode_url` — per-call redefinition of `base64_encode_urls` config.
* `escape_plain_url` — per-call redefinition of `always_escape_plain_urls` config.
* `use_short_options` — per-call redefinition of `use_short_options` config.
* `encrypt_source_url` - _(pro)_ per-call redefinition of `always_encrypt_source_urls` config.
* `source_url_encryption_iv` - _(pro)_ an initialization vector (IV) to be used for the source URL encryption if encryption is needed. If not specified, a random IV is used.

### Processing options

See [Supported processing options](docs/processing_options.md) for the supported processing options list and their arguments.

### Info options (pro)

See [Supported info options](docs/info_options.md) for the supported info options list and their arguments.

### Complex processing options

Some of the processing and info options like `crop` or `gravity` may have multiple arguments, and you can define these arguments multiple ways:

#### Named arguments

First and the most readable way is to use a `Hash` with named arguments:

```ruby
Imgproxy.url_for(
  "http://images.example.com/images/image.jpg",
  crop: {
    width: 500,
    height: 600,
    gravity: {
      type: :nowe,
      x_offset: 10,
      y_offset: 5
    }
  }
)
# => .../c:500:600:nowe:10:5/...
```

You can find argument names on the [Supported processing options](docs/processing_options.md) and [Supported info options](docs/info_options.md) pages.

##### Using named arguments with usupported options

You can use named arguments even if the option is not supported by the gem. In this case the arguments won't be reordered nor formatted, so you should provide them in the same order and right the same way they should appear in the URL:

```ruby
Imgproxy.url_for(
  "http://images.example.com/images/image.jpg",
  unsupported: {
    arg1: 1,
    nested1: {
      arg2: 2,
      nested2: {
        arg3: 3
      }
    }
  }
)
# => .../unsupported:1:2:3/...
```

#### Unnamed arguments

The arguments of the complex options can be provided as an array of formatted values:

```ruby
Imgproxy.url_for(
  "http://images.example.com/images/image.jpg",
  crop: [500, 600, :nowe, 10, 5],
  trim: [10, "aabbcc", 1. 1]
)
# => .../c:500:600:nowe:10:5/t:10:aabbcc:1:1/...
```

#### Single required argument

If a complex option has a single required argument, and you don't want to use the optional ones, you can just use the required argument value:

```ruby
Imgproxy.url_for(
  "http://images.example.com/images/image.jpg",
  gravity: :nowe,
  trim: 10
)
# => .../g:nowe/t:10/...
```

### Base64 processing options arguments

Some of the processing options like `watermark_url` or `style` require their arguments to be base64-encoded. Good news is that imgproxy.rb will encode them for you:

```ruby
Imgproxy.url_for(
  "http://images.example.com/images/image.jpg",
  watermark_url: "http://example.com/watermark.jpg",
  style: "color: rgba(255, 255, 255, .5)"
)
# => .../wmu:aHR0cDovL2V4YW1wbGUuY29tL3dhdGVybWFyay5qcGc/st:Y29sb3I6IHJnYmEoMjU1LCAyNTUsIDI1NSwgLjUp/...
```

## URL adapters

By default, `Imgproxy.url_for` accepts only `String` and `URI` as the source URL, but you can extend that behavior by using URL adapters.

> [!TIP]
> imgproxy.rb provides built-in adapters for Active Storage and Shrine that are automatically added when Active Storage or Shrine support is enabled.

URL adapter is a simple class that implements `applicable?` and `url` methods. See the example below:

```ruby
class MyItemAdapter
  # `applicable?` checks if the adapter can extract
  # source URL from the provided object
  def applicable?(item)
    item.is_a? MyItem
  end

  # `url` extracts source URL from the provided object
  def url(item)
    item.image_url
  end
end

# ...

Imgproxy.configure do |config|
  config.url_adapters.add MyItemAdapter.new
end
```

> [!NOTE]
> `Imgproxy` will use the first applicable URL adapter. If you need to add your adapter to the beginning of the list, use the `prepend` method instead of `add`.

## Extra services

If you use more than one instance of imgproxy and they have different endpoints and key/salt configurations you can specify them in `services` option.

```ruby
Imgproxy.configure do |config|
  config.endpoint = "https://main.imgproxy.com/"
  config.service(:pro) do |pro|
    pro.endpoint = "https://pro.imgproxy.com/"
    pro.key = ENV["IMGPROXY_PRO_KEY"]
    pro.salt = ENV["IMGPROXY_PRO_SALT"]
    pro.source_url_encryption_key = ENV["IMGPROXY_PRO_ENCRYPTION_KEY"]
    pro.always_encrypt_source_urls = true
  end
end
```

Or via YAML config:

```yaml
endpoint: "https://main.imgproxy.com/"
services:
  pro:
    endpoint: "https://pro.imgproxy.com/"
    key: <%= ENV["IMGPROXY_PRO_KEY"] %>
    salt: <%= ENV["IMGPROXY_PRO_SALT"] %>
    source_url_encryption_key: ENV["IMGPROXY_PRO_ENCRYPTION_KEY"]
    always_encrypt_source_urls: true
```

If you don't specify `key`, `salt`, `endpoint`, `signature_size`, `source_url_encryption_key`, or `always_encrypt_source_urls`, they are inherited from the global configuration.

Pass the `service` option to `url_for` and `info_url_for`:

```ruby
Imgproxy.url_for(image, service: :pro)
Imgproxy.info_url_for(image, service: :pro)
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/imgproxy/imgproxy.rb.

If you are having any problems with image processing of imgproxy itself, be sure to visit https://github.com/imgproxy/imgproxy first and check out the docs at https://docs.imgproxy.net/.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

## Security Contact

To report a security vulnerability, please contact us at security@imgproxy.net. We will coordinate the fix and disclosure.
