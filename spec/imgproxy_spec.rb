require "spec_helper"

RSpec.describe Imgproxy do
  let(:options) do
    {
      crop_width: "500",
      crop_height: 100,
      crop_gravity: "ce",
      crop_gravity_x: 0.35,
      crop_gravity_y: 0.65,
      resizing_type: :fill,
      width: "200",
      height: 300,
      dpr: 2,
      enlarge: true,
      extend: true,
      gravity: :fp,
      gravity_x: 0.25,
      gravity_y: 0.75,
      quality: 80,
      background: "abcdfe",
      blur: 0.5,
      sharpen: 0.7,
      watermark_opacity: 0.5,
      watermark_position: :noea,
      watermark_x_offset: 10,
      watermark_y_offset: 5,
      watermark_scale: 0.1,
      watermark_url: "https://images.test/wm.svg",
      preset: %i[preset1 preset2],
      cachebuster: "qwerty",
      format: :webp,
    }
  end

  let(:src_url) { "https://images.test/image.jpg" }

  subject(:url) { described_class.url_for(src_url, options) }

  describe "builds URL" do
    context "when plain" do
      it do
        expect(url).to eq(
          "http://imgproxy.test/unsafe/"\
          "c:500:100:ce:0.35:0.65/"\
          "rs:fill:200:300:1:1/dpr:2.0/g:fp:0.25:0.75/q:80/bg:abcdfe/bl:0.5/"\
          "sh:0.7/wm:0.5:noea:10:5:0.1/wmu:aHR0cHM6Ly9pbWFnZXMudGVzdC93bS5zdmc/"\
          "pr:preset1:preset2/cb:qwerty/"\
          "plain/https://images.test/image.jpg@webp",
        )
      end
    end

    context "when base64" do
      around do |ex|
        described_class.config.base64_encode_urls = true

        ex.run

        described_class.config.base64_encode_urls = false
      end

      it do
        expect(url).to eq(
          "http://imgproxy.test/unsafe/"\
          "c:500:100:ce:0.35:0.65/"\
          "rs:fill:200:300:1:1/dpr:2.0/g:fp:0.25:0.75/q:80/bg:abcdfe/bl:0.5/"\
          "sh:0.7/wm:0.5:noea:10:5:0.1/wmu:aHR0cHM6Ly9pbWFnZXMudGVzdC93bS5zdmc/"\
          "pr:preset1:preset2/cb:qwerty/"\
          "#{Base64.urlsafe_encode64(src_url).tr('=', '').scan(/.{1,16}/).join('/')}.webp",
        )
      end
    end
  end

  it "builds URL with full processing options names" do
    described_class.config.use_short_options = false

    expect(url).to eq(
      "http://imgproxy.test/unsafe/"\
      "crop:500:100:ce:0.35:0.65/"\
      "resize:fill:200:300:1:1/dpr:2.0/gravity:fp:0.25:0.75/quality:80/background:abcdfe/blur:0.5/"\
      "sharpen:0.7/watermark:0.5:noea:10:5:0.1/watermark_url:aHR0cHM6Ly9pbWFnZXMudGVzdC93bS5zdmc/"\
      "preset:preset1:preset2/cachebuster:qwerty/"\
      "plain/https://images.test/image.jpg@webp",
    )
  end

  context "when source image is an URI" do
    let(:src_url) { URI.parse("https://images.test/image.jpg") }

    it "builds URL" do
      expect(url).to end_with "/plain/https://images.test/image.jpg@webp"
    end
  end

  describe "resize/size grouping" do
    context "when only width/height is set" do
      let(:options) { { width: 200, enlarge: true } }

      it "doesn't group" do
        expect(url).to eq(
          "http://imgproxy.test/unsafe/w:200/en:1/plain/https://images.test/image.jpg",
        )
      end
    end

    context "when both width and height are set" do
      let(:options) { { width: 200, height: 300, enlarge: true } }

      it "groups size" do
        expect(url).to eq(
          "http://imgproxy.test/unsafe/s:200:300:1/plain/https://images.test/image.jpg",
        )
      end
    end

    context "when width, height and resizing_type are set" do
      let(:options) { { resizing_type: :fill, width: 200, height: 300, enlarge: true } }

      it "groups resize" do
        expect(url).to eq(
          "http://imgproxy.test/unsafe/rs:fill:200:300:1/plain/https://images.test/image.jpg",
        )
      end
    end
  end

  describe "crop grouping" do
    context "when crop width and height are set" do
      let(:options) { { crop_width: 200, crop_height: 300 } }

      it "groups crop" do
        expect(url).to eq(
          "http://imgproxy.test/unsafe/c:200:300/plain/https://images.test/image.jpg",
        )
      end
    end

    context "when crop width, height and gravity are set" do
      let(:options) { { crop_width: 200, crop_height: 300, crop_gravity: "ce" } }

      it "groups crop" do
        expect(url).to eq(
          "http://imgproxy.test/unsafe/c:200:300:ce/plain/https://images.test/image.jpg",
        )
      end
    end

    context "when crop width, height, gravity and gravity x and y are set" do
      let(:options) do
        {
          crop_width: 200, crop_height: 300,
          crop_gravity: "ce", crop_gravity_x: 0.2, crop_gravity_y: 0.4
        }
      end

      it "groups crop" do
        expect(url).to eq(
          "http://imgproxy.test/unsafe/c:200:300:ce:0.2:0.4/plain/https://images.test/image.jpg",
        )
      end
    end

    context "when crop width and height aren't set" do
      let(:options) { { crop_gravity: "ce" } }

      it "omits crop" do
        expect(url).to eq(
          "http://imgproxy.test/unsafe/plain/https://images.test/image.jpg",
        )
      end
    end

    context "when crop width or height aren't set" do
      let(:options) { { crop_width: 300 } }

      it "replaces missed side with zero" do
        expect(url).to eq(
          "http://imgproxy.test/unsafe/c:300:0/plain/https://images.test/image.jpg",
        )
      end
    end

    context "when crop gravity type aren't set but crop gravity x and y are" do
      let(:options) { { crop_width: 300, crop_gravity_x: 0.2, crop_gravity_y: 0.4 } }

      it "ignores crop gravity" do
        expect(url).to eq(
          "http://imgproxy.test/unsafe/c:300:0/plain/https://images.test/image.jpg",
        )
      end
    end

    context "when crop gravity y aren't set" do
      let(:options) { { crop_width: 300, crop_gravity: "fp", crop_gravity_x: 0.2 } }

      it "ignores crop gravity y" do
        expect(url).to eq(
          "http://imgproxy.test/unsafe/c:300:0:fp:0.2/plain/https://images.test/image.jpg",
        )
      end
    end

    context "when crop gravity x aren't set" do
      let(:options) { { crop_width: 300, crop_gravity: "fp", crop_gravity_y: 0.2 } }

      it "ignores crop gravity y" do
        expect(url).to eq(
          "http://imgproxy.test/unsafe/c:300:0:fp::0.2/plain/https://images.test/image.jpg",
        )
      end
    end
  end

  describe "extend grouping" do
    context "when extend is true" do
      let(:options) { { extend: true } }

      it "groups extend" do
        expect(url).to eq(
          "http://imgproxy.test/unsafe/ex:1/plain/https://images.test/image.jpg",
        )
      end
    end

    context "when extend is true and its gravity is set" do
      let(:options) { { extend: true, extend_gravity: "no" } }

      it "groups extend" do
        expect(url).to eq(
          "http://imgproxy.test/unsafe/ex:1:no/plain/https://images.test/image.jpg",
        )
      end
    end

    context "when extend is true, and its gravity and gravity x and y are set" do
      let(:options) do
        {
          extend: true,
          extend_gravity: "ce", extend_gravity_x: 0.2, extend_gravity_y: 0.4
        }
      end

      it "groups extend" do
        expect(url).to eq(
          "http://imgproxy.test/unsafe/ex:1:ce:0.2:0.4/plain/https://images.test/image.jpg",
        )
      end
    end

    context "when extend is false, and its gravity is set" do
      let(:options) { { extend: false, extend_gravity: "no" } }

      it "omits extend gravity" do
        expect(url).to eq(
          "http://imgproxy.test/unsafe/ex:0/plain/https://images.test/image.jpg",
        )
      end
    end

    context "when extend is not set" do
      let(:options) { { extend_gravity: "ce" } }

      it "omits extend" do
        expect(url).to eq(
          "http://imgproxy.test/unsafe/plain/https://images.test/image.jpg",
        )
      end
    end

    context "when extend gravity y aren't set" do
      let(:options) { { extend: true, extend_gravity: "fp", extend_gravity_x: 0.2 } }

      it "ignores extend gravity y" do
        expect(url).to eq(
          "http://imgproxy.test/unsafe/ex:1:fp:0.2/plain/https://images.test/image.jpg",
        )
      end
    end

    context "when extend gravity x aren't set" do
      let(:options) { { extend: true, extend_gravity: "fp", extend_gravity_y: 0.2 } }

      it "ignores extend gravity x" do
        expect(url).to eq(
          "http://imgproxy.test/unsafe/ex:1:fp::0.2/plain/https://images.test/image.jpg",
        )
      end
    end
  end

  describe "adjust grouping" do
    context "when only one adjust option is set" do
      let(:options) { { brightness: 10 } }

      it "doesn't group adjust options" do
        expect(url).to eq(
          "http://imgproxy.test/unsafe/br:10/plain/https://images.test/image.jpg",
        )
      end
    end

    context "when more than one adjust option is set" do
      let(:options) { { brightness: 10, saturation: 1.5 } }

      it "groups adjust options" do
        expect(url).to eq(
          "http://imgproxy.test/unsafe/a:10::1.5/plain/https://images.test/image.jpg",
        )
      end
    end
  end

  describe "base64_encode_url" do
    let(:options) do
      {
        base64_encode_url: true, watermark_opacity: 0.5,
        watermark_x_offset: 10, watermark_y_offset: 5
      }
    end

    it "base64 encodes the URL" do
      expect(url).to eq(
        "http://imgproxy.test/unsafe/wm:0.5::10:5/"\
        "#{Base64.urlsafe_encode64(src_url).tr('=', '').scan(/.{1,16}/).join('/')}",
      )
    end
  end

  describe "ommiting processing options arguments" do
    let(:options) { { watermark_opacity: 0.5, watermark_x_offset: 10, watermark_y_offset: 5 } }

    it "ommits unset arguments" do
      expect(url).to eq(
        "http://imgproxy.test/unsafe/wm:0.5::10:5/plain/https://images.test/image.jpg",
      )
    end
  end

  context "when source URL needs escaping" do
    let(:src_url) { "https://images.test/image.jpg?version=123" }

    it "escapes source URL" do
      expect(url).to end_with "/plain/https%3A%2F%2Fimages.test%2Fimage.jpg%3Fversion%3D123@webp"
    end
  end

  context "when source URL contains non-ascii chars" do
    let(:src_url) { "https://images.test/и.jpg" }

    it "escapes source URL" do
      expect(url).to end_with "/plain/https%3A%2F%2Fimages.test%2F%D0%B8.jpg@webp"
    end
  end

  context "when source URL contains spaces" do
    let(:src_url) { "https://images.test/lorem ipsum.jpg" }

    it "escapes source URL" do
      expect(url).to end_with "/plain/https%3A%2F%2Fimages.test%2Florem%20ipsum.jpg@webp"
    end
  end

  context "when key and salt are provided" do
    before do
      described_class.configure do |config|
        config.hex_key = "Hello".unpack1("H*")
        config.hex_salt = "World".unpack1("H*")
      end
    end

    it "signs the URL" do
      expect(url).to start_with "http://imgproxy.test/C6NPpeJ8AGTjz3mC0otakIa-urucnuVok55J4o2xQD4/"
    end

    context "when signature is truncated" do
      before { described_class.config.signature_size = 5 }

      it "signs the URL with truncated signature" do
        expect(url).to start_with "http://imgproxy.test/C6NPpeI/"
      end
    end
  end
end
