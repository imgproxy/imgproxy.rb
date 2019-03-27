require "spec_helper"

RSpec.describe Imgproxy do
  let(:options) do
    {
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
      preset: %i[preset1 preset2],
      cachebuster: "qwerty",
      format: :webp,
    }
  end

  let(:src_url) { "https://images.test/image.jpg" }

  subject(:url) { described_class.url_for(src_url, options) }

  it "builds URL" do
    expect(url).to eq(
      "http://imgproxy.test/unsafe/"\
      "rs:fill:200:300:1:1/dpr:2.0/g:fp:0.25:0.75/q:80/bg:abcdfe/bl:0.5/"\
      "sh:0.7/wm:0.5:noea:10:5:0.1/pr:preset1:preset2/cb:qwerty/"\
      "plain/https://images.test/image.jpg@webp",
    )
  end

  it "builds URL with full processing options names" do
    described_class.config.use_short_options = false

    expect(url).to eq(
      "http://imgproxy.test/unsafe/"\
      "resize:fill:200:300:1:1/dpr:2.0/gravity:fp:0.25:0.75/quality:80/background:abcdfe/blur:0.5/"\
      "sharpen:0.7/watermark:0.5:noea:10:5:0.1/preset:preset1:preset2/cachebuster:qwerty/"\
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
end
