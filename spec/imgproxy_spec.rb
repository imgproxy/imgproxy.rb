require "spec_helper"

RSpec.describe Imgproxy do
  let(:src_url) { "https://images.test/image.jpg" }

  describe ".url_for" do
    let(:options) do
      {
        resize: {
          resizing_type: :auto,
          width: 100,
          height: "200",
          enlarge: true,
          extend: {
            extend: true,
            gravity: {
              type: :noea,
              x_offset: 1,
              y_offset: 2,
            },
          },
        },
        size: {
          width: 150,
          height: "250",
          enlarge: false,
          extend: {
            extend: true,
            gravity: {
              type: :soea,
              x_offset: 2,
              y_offset: 3,
            },
          },
        },
        resizing_type: :fill,
        resizing_algorithm: :cubic,
        width: "200",
        height: 300,
        dpr: 2,
        enlarge: true,
        extend: {
          extend: true,
          gravity: {
            type: :nowe,
            x_offset: 5,
            y_offset: 6,
          },
        },
        gravity: {
          type: :fp,
          x_offset: 0.25,
          y_offset: 0.75,
        },
        crop: {
          width: "500",
          height: 100,
          gravity: {
            type: "ce",
            x_offset: 0.35,
            y_offset: 0.65,
          },
        },
        padding: [10, 20],
        trim: {
          threshold: 10,
          color: "ffffff",
          equal_hor: true,
          equal_ver: false,
        },
        rotate: 90,
        quality: 80,
        max_bytes: 1024,
        background: "abcdfe",
        background_alpha: 0.5,
        adjust: {
          brightness: -10,
          contrast: 0.5,
          saturation: 2,
        },
        brightness: 10,
        contrast: 2,
        saturation: 0.5,
        blur: 0.5,
        sharpen: 0.7,
        pixelate: 10,
        unsharpening: :always,
        watermark: {
          opacity: 0.5,
          position: :noea,
          x_offset: 10,
          y_offset: 5,
          scale: 0.1,
        },
        watermark_url: "https://images.test/wm.svg",
        style: "color: rgba(255, 255, 255, .5)",
        jpeg_options: {
          progressive: true,
          no_subsample: false,
          trellis_quant: true,
          overshoot_deringing: false,
          optimize_scans: true,
          quant_table: 5,
        },
        png_options: {
          interlaced: false,
          quantize: true,
          quantization_colors: 128,
        },
        gif_options: {
          optimize_frames: true,
          optimize_transparency: false,
        },
        page: 42,
        video_thumbnail_second: 15,
        preset: %i[preset1 preset2],
        cachebuster: "qwerty",
        strip_metadata: true,
        strip_color_profile: false,
        auto_rotate: true,
        filename: "the_image.jpg",
        format: :webp,
      }
    end

    let(:casted_options) do
      "rs:auto:100:200:1:1:noea:1:2/"\
      "s:150:250:0:1:soea:2:3/"\
      "rt:fill/"\
      "ra:cubic/"\
      "w:200/"\
      "h:300/"\
      "dpr:2/"\
      "en:1/"\
      "ex:1:nowe:5:6/"\
      "g:fp:0.25:0.75/"\
      "c:500:100:ce:0.35:0.65/"\
      "pd:10:20/"\
      "t:10:ffffff:1:0/"\
      "rot:90/"\
      "q:80/"\
      "mb:1024/"\
      "bg:abcdfe/"\
      "bga:0.5/"\
      "a:-10:0.5:2/"\
      "br:10/"\
      "co:2/"\
      "sa:0.5/"\
      "bl:0.5/"\
      "sh:0.7/"\
      "pix:10/"\
      "ush:always/"\
      "wm:0.5:noea:10:5:0.1/"\
      "wmu:aHR0cHM6Ly9pbWFnZXMudGVzdC93bS5zdmc/"\
      "st:Y29sb3I6IHJnYmEoMjU1LCAyNTUsIDI1NSwgLjUp/"\
      "jpego:1:0:1:0:1:5/"\
      "pngo:0:1:128/"\
      "gifo:1:0/"\
      "pg:42/"\
      "vts:15/"\
      "pr:preset1:preset2/"\
      "cb:qwerty/" \
      "sm:1/"\
      "scp:0/"\
      "ar:1/"\
      "fn:the_image.jpg"
    end

    let(:casted_options_full) do
      "resize:auto:100:200:1:1:noea:1:2/"\
      "size:150:250:0:1:soea:2:3/"\
      "resizing_type:fill/"\
      "resizing_algorithm:cubic/"\
      "width:200/"\
      "height:300/"\
      "dpr:2/"\
      "enlarge:1/"\
      "extend:1:nowe:5:6/"\
      "gravity:fp:0.25:0.75/"\
      "crop:500:100:ce:0.35:0.65/"\
      "padding:10:20/"\
      "trim:10:ffffff:1:0/"\
      "rotate:90/"\
      "quality:80/"\
      "max_bytes:1024/"\
      "background:abcdfe/"\
      "background_alpha:0.5/"\
      "adjust:-10:0.5:2/"\
      "brightness:10/"\
      "contrast:2/"\
      "saturation:0.5/"\
      "blur:0.5/"\
      "sharpen:0.7/"\
      "pixelate:10/"\
      "unsharpening:always/"\
      "watermark:0.5:noea:10:5:0.1/"\
      "watermark_url:aHR0cHM6Ly9pbWFnZXMudGVzdC93bS5zdmc/"\
      "style:Y29sb3I6IHJnYmEoMjU1LCAyNTUsIDI1NSwgLjUp/"\
      "jpeg_options:1:0:1:0:1:5/"\
      "png_options:0:1:128/"\
      "gif_options:1:0/"\
      "page:42/"\
      "video_thumbnail_second:15/"\
      "preset:preset1:preset2/"\
      "cachebuster:qwerty/" \
      "strip_metadata:1/"\
      "strip_color_profile:0/"\
      "auto_rotate:1/"\
      "filename:the_image.jpg"
    end

    subject(:url) { described_class.url_for(src_url, options) }

    it "builds URL" do
      expect(url).to eq(
        "http://imgproxy.test/unsafe/#{casted_options}/"\
        "plain/https://images.test/image.jpg@webp",
      )
    end

    context "when base64_encode_urls is true" do
      before { described_class.config.base64_encode_urls = true }

      it "builds URL with base64 URL" do
        expect(url).to eq(
          "http://imgproxy.test/unsafe/#{casted_options}/"\
          "#{Base64.urlsafe_encode64(src_url).tr('=', '').scan(/.{1,16}/).join('/')}.webp",
        )
      end
    end

    context "when base64_encode_url option true" do
      before { options[:base64_encode_url] = true }

      it "builds URL with base64 URL" do
        expect(url).to eq(
          "http://imgproxy.test/unsafe/#{casted_options}/"\
          "#{Base64.urlsafe_encode64(src_url).tr('=', '').scan(/.{1,16}/).join('/')}.webp",
        )
      end
    end

    context "when use_short_options config is false" do
      before { described_class.config.use_short_options = false }

      it "builds URL with full processing options names" do
        expect(url).to eq(
          "http://imgproxy.test/unsafe/#{casted_options_full}/"\
          "plain/https://images.test/image.jpg@webp",
        )
      end
    end

    context "when use_short_options option is false" do
      before { options[:use_short_options] = false }

      it "builds URL with full processing options names" do
        expect(url).to eq(
          "http://imgproxy.test/unsafe/#{casted_options_full}/"\
          "plain/https://images.test/image.jpg@webp",
        )
      end
    end

    context "when source image is an URI" do
      let(:src_url) { URI.parse("https://images.test/image.jpg") }

      it "builds URL" do
        expect(url).to end_with "/plain/https://images.test/image.jpg@webp"
      end
    end

    describe "resize/size grouping" do
      let(:options) do
        {
          width: "200",
          height: 300,
          enlarge: true,
          extend: {
            extend: true,
            gravity: {
              type: :nowe,
              x_offset: 5,
              y_offset: 6,
            },
          },
        }
      end

      it "groups size" do
        expect(url).to eq(
          "http://imgproxy.test/unsafe/s:200:300:1:1:nowe:5:6/"\
          "plain/https://images.test/image.jpg",
        )
      end

      context "when resizing_type is set too" do
        before { options[:resizing_type] = :fill }

        it "groups resize" do
          expect(url).to eq(
            "http://imgproxy.test/unsafe/rs:fill:200:300:1:1:nowe:5:6/"\
            "plain/https://images.test/image.jpg",
          )
        end
      end

      context "when size is already set" do
        before { options[:size] = [100, 200] }

        it "doesn't regroup" do
          expect(url).to eq(
            "http://imgproxy.test/unsafe/s:100:200/w:200/h:300/en:1/ex:1:nowe:5:6/"\
            "plain/https://images.test/image.jpg",
          )
        end
      end

      context "when resize is already set" do
        before { options[:resize] = [:fit, 100, 200] }

        it "doesn't regroup" do
          expect(url).to eq(
            "http://imgproxy.test/unsafe/rs:fit:100:200/w:200/h:300/en:1/ex:1:nowe:5:6/"\
            "plain/https://images.test/image.jpg",
          )
        end
      end

      context "when only width/height is set" do
        before { options.delete(:height) }

        it "doesn't group" do
          expect(url).to eq(
            "http://imgproxy.test/unsafe/w:200/en:1/ex:1:nowe:5:6/"\
            "plain/https://images.test/image.jpg",
          )
        end
      end
    end

    describe "adjust grouping" do
      let(:options) { { brightness: 10, contrast: 0.5, saturation: 1.5 } }

      it "groups adjust options" do
        expect(url).to eq(
          "http://imgproxy.test/unsafe/a:10:0.5:1.5/plain/https://images.test/image.jpg",
        )
      end

      context "when only one adjust argument is set" do
        let(:options) { { brightness: 10 } }

        it "doesn't group" do
          expect(url).to eq(
            "http://imgproxy.test/unsafe/br:10/plain/https://images.test/image.jpg",
          )
        end
      end

      context "when adjust option is set" do
        before { options[:adjust] = [1, 2, 3] }

        it "doesn't group" do
          expect(url).to eq(
            "http://imgproxy.test/unsafe/a:1:2:3/br:10/co:0.5/sa:1.5/"\
            "plain/https://images.test/image.jpg",
          )
        end
      end
    end

    describe "crop casting" do
      context "when both crop width and height aren't set" do
        let(:options) { { crop: { gravity: { type: "ce" } } } }

        it "omits crop" do
          expect(url).to eq(
            "http://imgproxy.test/unsafe/plain/https://images.test/image.jpg",
          )
        end
      end

      context "when crop width or height aren't set" do
        let(:options) { { crop: { width: 300 } } }

        it "replaces missed side with zero" do
          expect(url).to eq(
            "http://imgproxy.test/unsafe/c:300:0/plain/https://images.test/image.jpg",
          )
        end
      end
    end

    describe "extend casting" do
      context "when the 'extend' argument is not set" do
        let(:options) { { extend: { gravity: { type: "no" } } } }

        it "omits whole extend" do
          expect(url).to eq(
            "http://imgproxy.test/unsafe/plain/https://images.test/image.jpg",
          )
        end
      end

      context "when the 'extend' argument is false" do
        let(:options) { { extend: { extend: false, gravity: { type: "no" } } } }

        it "omits all other arguments" do
          expect(url).to eq(
            "http://imgproxy.test/unsafe/ex:0/plain/https://images.test/image.jpg",
          )
        end
      end

      context "when a boolean value is used" do
        let(:options) { { extend: true } }

        it "casts to boolean" do
          expect(url).to eq(
            "http://imgproxy.test/unsafe/ex:1/plain/https://images.test/image.jpg",
          )
        end
      end
    end

    describe "watermark casting" do
      context "when the 'opacity' argument is not set" do
        let(:options) { { watermark: { position: "no" } } }

        it "omits whole watermark" do
          expect(url).to eq(
            "http://imgproxy.test/unsafe/plain/https://images.test/image.jpg",
          )
        end
      end

      context "when the 'opacity' argument is zero" do
        let(:options) { { watermark: { opacity: 0, position: "no" } } }

        it "omits omits all other arguments" do
          expect(url).to eq(
            "http://imgproxy.test/unsafe/wm:0/plain/https://images.test/image.jpg",
          )
        end
      end

      context "when a numeric value is used" do
        let(:options) { { watermark: 0.5 } }

        it "casts number" do
          expect(url).to eq(
            "http://imgproxy.test/unsafe/wm:0.5/plain/https://images.test/image.jpg",
          )
        end
      end
    end

    describe "ommiting processing options arguments" do
      let(:options) do
        {
          extend: {
            extend: true,
          },
          gravity: {
            type: "nowe",
            y_offset: 10,
          },
          crop: {
            width: 100,
            height: 200,
          },
          trim: {
            threshold: 10,
            equal_hor: true,
          },
          adjust: {
            contrast: 0.5,
          },
          watermark: {
            opacity: 0.5,
            x_offset: 10,
            y_offset: 5,
          },
        }
      end

      it "ommits unset arguments and trims trailing ones" do
        expect(url).to eq(
          "http://imgproxy.test/unsafe/"\
          "ex:1/g:nowe::10/c:100:200/t:10::1/a::0.5/wm:0.5::10:5/"\
          "plain/https://images.test/image.jpg",
        )
      end
    end

    context "when using unsupported options" do
      let(:options) do
        {
          unsupported1: {
            arg1: 1,
            arg2: %w[val1 val2],
            arg3: {
              arg4: 2,
              arg5: {
                arg6: 3,
              },
            },
          },
          unsupported2: [1, nil, 2, 3],
          unsupported3: "4:5:6",
        }
      end

      it "unwraps unsupported options arguments" do
        expect(url).to eq(
          "http://imgproxy.test/unsafe/"\
          "unsupported1:1:val1:val2:2:3/"\
          "unsupported2:1::2:3/"\
          "unsupported3:4:5:6/"\
          "plain/https://images.test/image.jpg",
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

    context "when always_escape_plain_urls config is true" do
      before { described_class.config.always_escape_plain_urls = true }

      it "escapes source URL" do
        expect(url).to end_with "/plain/https%3A%2F%2Fimages.test%2Fimage.jpg@webp"
      end
    end

    context "when escape_plain_url option is true" do
      before { options[:escape_plain_url] = true }

      it "escapes source URL" do
        expect(url).to end_with "/plain/https%3A%2F%2Fimages.test%2Fimage.jpg@webp"
      end
    end

    context "when key and salt are provided" do
      let(:options) { { width: 100, height: 100 } }

      before do
        described_class.configure do |config|
          config.key = "Hello".unpack1("H*")
          config.salt = "World".unpack1("H*")
        end
      end

      it "signs the URL" do
        expect(url).to start_with "http://imgproxy.test/6PuaY-dst3YwA3CwS_QDSWk4yA3oSr3pEHxT9kiEbOE/"
      end

      context "when signature is truncated" do
        before { described_class.config.signature_size = 5 }

        it "signs the URL with truncated signature" do
          expect(url).to start_with "http://imgproxy.test/6PuaY-c/"
        end
      end
    end
  end

  describe ".info_url_for" do
    let(:options) { {} }

    subject(:url) { described_class.info_url_for(src_url, options) }

    it "builds info URL" do
      expect(described_class.info_url_for(src_url)).to eq(
        "http://imgproxy.test/info/unsafe/plain/https://images.test/image.jpg",
      )
    end

    context "when base64_encode_urls is true" do
      before { described_class.config.base64_encode_urls = true }

      it "builds info URL with base64 URL" do
        expect(url).to eq(
          "http://imgproxy.test/info/unsafe/"\
          "#{Base64.urlsafe_encode64(src_url).tr('=', '').scan(/.{1,16}/).join('/')}",
        )
      end
    end

    context "when base64_encode_url option true" do
      before { options[:base64_encode_url] = true }

      it "builds info URL with base64 URL" do
        expect(url).to eq(
          "http://imgproxy.test/info/unsafe/"\
          "#{Base64.urlsafe_encode64(src_url).tr('=', '').scan(/.{1,16}/).join('/')}",
        )
      end
    end

    context "when key and salt are provided" do
      let(:options) { { width: 100, height: 100 } }

      before do
        described_class.configure do |config|
          config.key = "Hello".unpack1("H*")
          config.salt = "World".unpack1("H*")
        end
      end

      it "signs the info URL" do
        expect(described_class.info_url_for(src_url)).to start_with(
          "http://imgproxy.test/info/1KMMwfiizRxXf-H63Dkb3FsQ46DKtL1S94ocezxg-8k/",
        )
      end

      context "when signature is truncated" do
        before { described_class.config.signature_size = 5 }

        it "signs the info URL with truncated signature" do
          expect(described_class.info_url_for(src_url)).to start_with(
            "http://imgproxy.test/info/1KMMwfg/",
          )
        end
      end
    end
  end
end
