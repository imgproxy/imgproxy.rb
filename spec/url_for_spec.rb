# frozen_string_literal: true

require "spec_helper"

RSpec.describe Imgproxy, ".url_for" do
  subject(:url) { described_class.url_for(src_url, options) }

  let(:src_url) { "https://images.test/image.jpg" }

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
      "min-width": 50,
      "min-height": 60,
      zoom: {
        zoom_x: 0.5,
        zoom_y: 0.75,
      },
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
      extend_aspect_ratio: {
        extend: true,
        gravity: {
          type: :soea,
          x_offset: 0.1,
          y_offset: 0.2,
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
      trim: {
        threshold: 10,
        color: "ffffff",
        equal_hor: true,
        equal_ver: false,
      },
      padding: {
        top: 10,
        right: 20,
        bottom: 30,
        left: 40,
      },
      auto_rotate: true,
      rotate: 90,
      background: {
        r: 10,
        g: 20,
        b: 30,
      },
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
      unsharp_masking: {
        mode: :always,
        weight: 10,
        divider: 20,
      },
      blur_detections: {
        sigma: 10,
        class_names: %w[class1 class2],
      },
      draw_detections: {
        draw: true,
        class_names: %w[class1 class2],
      },
      gradient: {
        opacity: 0.5,
        color: "ffffff",
        direction: "down",
        start: 0.25,
        stop: 0.75,
      },
      watermark: {
        opacity: 0.5,
        position: :noea,
        x_offset: 10,
        y_offset: 5,
        scale: 0.1,
      },
      watermark_url: "https://images.test/wm.svg",
      watermark_text: "the watermark",
      watermark_size: {
        width: 256,
        height: 1024,
      },
      watermark_shadow: 15,
      style: "color: rgba(255, 255, 255, .5)",
      strip_metadata: true,
      keep_copyright: true,
      dpi: 72,
      strip_color_profile: false,
      enforce_thumbnail: true,
      quality: 80,
      format_quality: {
        jpeg: 85,
        webp: 75,
        avif: 65,
      },
      autoquality: {
        method: "dssim",
        target: 0.01,
        min_quality: 50,
        max_quality: 90,
        allowed_error: 0.001,
      },
      max_bytes: 1024,
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
      webp_options: {
        compression: "lossless",
      },
      format: :webp,
      page: 42,
      pages: 2,
      disable_animation: true,
      video_thumbnail_second: 15,
      video_thumbnail_keyframes: true,
      video_thumbnail_tile: {
        step: 1.5,
        columns: 2,
        rows: 3,
        tile_width: 200,
        tile_height: 100,
        extend_tile: true,
        trim: true,
      },
      fallback_image_url: "https://images.test/fallback.jpg",
      skip_processing: %w[gif svg],
      raw: true,
      cachebuster: "qwerty",
      expires: Time.at(4810374983),
      filename: {
        filename: "the_image.jpg",
        encoded: true,
      },
      return_attachment: true,
      preset: %i[preset1 preset2],
      hashsum: {
        hashsum_type: "md5",
        hashsum: "4810374983",
      },
      max_src_resolution: 1.5,
      max_src_file_size: 1024,
      max_animation_frames: 10,
      max_animation_frame_resolution: 2.5,
      source_url_encryption_iv: "1234567890123456",
    }
  end

  let(:casted_options) do
    [
      "rs:auto:100:200:1:1:noea:1:2",
      "s:150:250:0:1:soea:2:3",
      "rt:fill",
      "ra:cubic",
      "w:200",
      "h:300",
      "mw:50",
      "mh:60",
      "z:0.5:0.75",
      "dpr:2",
      "el:1",
      "ex:1:nowe:5:6",
      "exar:1:soea:0.1:0.2",
      "g:fp:0.25:0.75",
      "c:500:100:ce:0.35:0.65",
      "t:10:ffffff:1:0",
      "pd:10:20:30:40",
      "ar:1",
      "rot:90",
      "bg:10:20:30",
      "bga:0.5",
      "a:-10:0.5:2",
      "br:10",
      "co:2",
      "sa:0.5",
      "bl:0.5",
      "sh:0.7",
      "pix:10",
      "ush:always:10:20",
      "bd:10:class1:class2",
      "dd:1:class1:class2",
      "gr:0.5:ffffff:down:0.25:0.75",
      "wm:0.5:noea:10:5:0.1",
      "wmu:aHR0cHM6Ly9pbWFnZXMudGVzdC93bS5zdmc",
      "wmt:dGhlIHdhdGVybWFyaw",
      "wms:256:1024",
      "wmsh:15",
      "st:Y29sb3I6IHJnYmEoMjU1LCAyNTUsIDI1NSwgLjUp",
      "sm:1",
      "kcr:1",
      "dpi:72",
      "scp:0",
      "eth:1",
      "q:80",
      "fq:jpeg:85:webp:75:avif:65",
      "aq:dssim:0.01:50:90:0.001",
      "mb:1024",
      "jpego:1:0:1:0:1:5",
      "pngo:0:1:128",
      "webpo:lossless",
      "pg:42",
      "pgs:2",
      "da:1",
      "vts:15",
      "vtk:1",
      "vtt:1.5:2:3:200:100:1:1",
      "fiu:aHR0cHM6Ly9pbWFnZXMudGVzdC9mYWxsYmFjay5qcGc",
      "skp:gif:svg",
      "raw:1",
      "cb:qwerty",
      "exp:4810374983",
      "fn:dGhlX2ltYWdlLmpwZw:1",
      "att:1",
      "pr:preset1:preset2",
      "hs:md5:4810374983",
      "msr:1.5",
      "msfs:1024",
      "maf:10",
      "mafr:2.5",
    ].join("/")
  end

  let(:casted_options_full) do
    [
      "resize:auto:100:200:1:1:noea:1:2",
      "size:150:250:0:1:soea:2:3",
      "resizing_type:fill",
      "resizing_algorithm:cubic",
      "width:200",
      "height:300",
      "min-width:50",
      "min-height:60",
      "zoom:0.5:0.75",
      "dpr:2",
      "enlarge:1",
      "extend:1:nowe:5:6",
      "extend_aspect_ratio:1:soea:0.1:0.2",
      "gravity:fp:0.25:0.75",
      "crop:500:100:ce:0.35:0.65",
      "trim:10:ffffff:1:0",
      "padding:10:20:30:40",
      "auto_rotate:1",
      "rotate:90",
      "background:10:20:30",
      "background_alpha:0.5",
      "adjust:-10:0.5:2",
      "brightness:10",
      "contrast:2",
      "saturation:0.5",
      "blur:0.5",
      "sharpen:0.7",
      "pixelate:10",
      "unsharp_masking:always:10:20",
      "blur_detections:10:class1:class2",
      "draw_detections:1:class1:class2",
      "gradient:0.5:ffffff:down:0.25:0.75",
      "watermark:0.5:noea:10:5:0.1",
      "watermark_url:aHR0cHM6Ly9pbWFnZXMudGVzdC93bS5zdmc",
      "watermark_text:dGhlIHdhdGVybWFyaw",
      "watermark_size:256:1024",
      "watermark_shadow:15",
      "style:Y29sb3I6IHJnYmEoMjU1LCAyNTUsIDI1NSwgLjUp",
      "strip_metadata:1",
      "keep_copyright:1",
      "dpi:72",
      "strip_color_profile:0",
      "enforce_thumbnail:1",
      "quality:80",
      "format_quality:jpeg:85:webp:75:avif:65",
      "autoquality:dssim:0.01:50:90:0.001",
      "max_bytes:1024",
      "jpeg_options:1:0:1:0:1:5",
      "png_options:0:1:128",
      "webp_options:lossless",
      "page:42",
      "pages:2",
      "disable_animation:1",
      "video_thumbnail_second:15",
      "video_thumbnail_keyframes:1",
      "video_thumbnail_tile:1.5:2:3:200:100:1:1",
      "fallback_image_url:aHR0cHM6Ly9pbWFnZXMudGVzdC9mYWxsYmFjay5qcGc",
      "skip_processing:gif:svg",
      "raw:1",
      "cachebuster:qwerty",
      "expires:4810374983",
      "filename:dGhlX2ltYWdlLmpwZw:1",
      "return_attachment:1",
      "preset:preset1:preset2",
      "hashsum:md5:4810374983",
      "max_src_resolution:1.5",
      "max_src_file_size:1024",
      "max_animation_frames:10",
      "max_animation_frame_resolution:2.5",
    ].join("/")
  end

  it "builds URL" do
    expect(url).to eq(
      "http://imgproxy.test/unsafe/#{casted_options}/" \
      "plain/https://images.test/image.jpg@webp",
    )
  end

  context "when base64_encode_urls is true" do
    before { described_class.config.base64_encode_urls = true }

    it "builds URL with base64 URL" do
      expect(url).to eq(
        "http://imgproxy.test/unsafe/#{casted_options}/" \
        "#{Base64.urlsafe_encode64(src_url).tr("=", "").scan(/.{1,16}/).join("/")}.webp",
      )
    end
  end

  context "when base64_encode_url option true" do
    before { options[:base64_encode_url] = true }

    it "builds URL with base64 URL" do
      expect(url).to eq(
        "http://imgproxy.test/unsafe/#{casted_options}/" \
        "#{Base64.urlsafe_encode64(src_url).tr("=", "").scan(/.{1,16}/).join("/")}.webp",
      )
    end
  end

  context "when use_short_options config is false" do
    before { described_class.config.use_short_options = false }

    it "builds URL with full processing options names" do
      expect(url).to eq(
        "http://imgproxy.test/unsafe/#{casted_options_full}/" \
        "plain/https://images.test/image.jpg@webp",
      )
    end
  end

  context "when use_short_options option is false" do
    before { options[:use_short_options] = false }

    it "builds URL with full processing options names" do
      expect(url).to eq(
        "http://imgproxy.test/unsafe/#{casted_options_full}/" \
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
        "http://imgproxy.test/unsafe/s:200:300:1:1:nowe:5:6/" \
        "plain/https://images.test/image.jpg",
      )
    end

    context "when resizing_type is set too" do
      before { options[:resizing_type] = :fill }

      it "groups resize" do
        expect(url).to eq(
          "http://imgproxy.test/unsafe/rs:fill:200:300:1:1:nowe:5:6/" \
          "plain/https://images.test/image.jpg",
        )
      end
    end

    context "when size is already set" do
      before { options[:size] = [100, 200] }

      it "doesn't regroup" do
        expect(url).to eq(
          "http://imgproxy.test/unsafe/s:100:200/w:200/h:300/el:1/ex:1:nowe:5:6/" \
          "plain/https://images.test/image.jpg",
        )
      end
    end

    context "when resize is already set" do
      before { options[:resize] = [:fit, 100, 200] }

      it "doesn't regroup" do
        expect(url).to eq(
          "http://imgproxy.test/unsafe/rs:fit:100:200/w:200/h:300/el:1/ex:1:nowe:5:6/" \
          "plain/https://images.test/image.jpg",
        )
      end
    end

    context "when only width/height is set" do
      before { options.delete(:height) }

      it "doesn't group" do
        expect(url).to eq(
          "http://imgproxy.test/unsafe/w:200/el:1/ex:1:nowe:5:6/" \
          "plain/https://images.test/image.jpg",
        )
      end
    end
  end

  describe "adjust grouping" do
    let(:options) { {brightness: 10, contrast: 0.5, saturation: 1.5} }

    it "groups adjust options" do
      expect(url).to eq(
        "http://imgproxy.test/unsafe/a:10:0.5:1.5/plain/https://images.test/image.jpg",
      )
    end

    context "when only one adjust argument is set" do
      let(:options) { {brightness: 10} }

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
          "http://imgproxy.test/unsafe/a:1:2:3/br:10/co:0.5/sa:1.5/" \
          "plain/https://images.test/image.jpg",
        )
      end
    end
  end

  describe "zoom casting" do
    context "when the 'zoom_x_y' argument is set" do
      let(:options) { {zoom: {zoom_x_y: 10, zoom_x: 20, zoom_y: 30}} }

      it "ignores 'zoom_x' and 'zoom_y'" do
        expect(url).to eq(
          "http://imgproxy.test/unsafe/z:10/plain/https://images.test/image.jpg",
        )
      end
    end
  end

  describe "extend casting" do
    context "when the 'extend' argument is not set" do
      let(:options) { {extend: {gravity: {type: "no"}}} }

      it "omits whole extend" do
        expect(url).to eq(
          "http://imgproxy.test/unsafe/plain/https://images.test/image.jpg",
        )
      end
    end

    context "when the 'extend' argument is false" do
      let(:options) { {extend: {extend: false, gravity: {type: "no"}}} }

      it "omits all other arguments" do
        expect(url).to eq(
          "http://imgproxy.test/unsafe/ex:0/plain/https://images.test/image.jpg",
        )
      end
    end

    context "when a boolean value is used" do
      let(:options) { {extend: true} }

      it "casts to boolean" do
        expect(url).to eq(
          "http://imgproxy.test/unsafe/ex:1/plain/https://images.test/image.jpg",
        )
      end
    end
  end

  describe "gravity casting" do
    context "when 'mode' argument is 'sm'" do
      let(:options) do
        {
          gravity: {
            type: :sm,
            x_offset: 10,
            y_offset: 5,
            class_names: %w[class1 class2],
          },
        }
      end

      it "ignores offsets and class names" do
        expect(url).to eq(
          "http://imgproxy.test/unsafe/g:sm/plain/https://images.test/image.jpg",
        )
      end
    end

    context "when 'mode' argument is 'obj'" do
      let(:options) do
        {
          gravity: {
            type: :obj,
            x_offset: 10,
            y_offset: 5,
            class_names: %w[class1 class2],
          },
        }
      end

      it "ignores offsets and uses class names" do
        expect(url).to eq(
          "http://imgproxy.test/unsafe/g:obj:class1:class2/plain/https://images.test/image.jpg",
        )
      end
    end

    context "when 'mode' argument is not 'sm' or 'obj'" do
      let(:options) do
        {
          gravity: {
            type: :nowe,
            x_offset: 10,
            y_offset: 5,
            class_names: %w[class1 class2],
          },
        }
      end

      it "ignores class names and uses offsets" do
        expect(url).to eq(
          "http://imgproxy.test/unsafe/g:nowe:10:5/plain/https://images.test/image.jpg",
        )
      end
    end
  end

  describe "crop casting" do
    context "when both crop width and height aren't set" do
      let(:options) { {crop: {gravity: {type: "ce"}}} }

      it "omits crop" do
        expect(url).to eq(
          "http://imgproxy.test/unsafe/plain/https://images.test/image.jpg",
        )
      end
    end

    context "when crop width or height aren't set" do
      let(:options) { {crop: {width: 300}} }

      it "replaces missed side with zero" do
        expect(url).to eq(
          "http://imgproxy.test/unsafe/c:300:0/plain/https://images.test/image.jpg",
        )
      end
    end
  end

  describe "padding casting" do
    context "when all arguments are equal" do
      let(:options) { {padding: {top: 10, right: 10, bottom: 10, left: 10}} }

      it "compacts arguments" do
        expect(url).to eq(
          "http://imgproxy.test/unsafe/pd:10/plain/https://images.test/image.jpg",
        )
      end
    end

    context "when right equals left" do
      let(:options) { {padding: {top: 10, right: 10, bottom: 20, left: 10}} }

      it "compacts arguments" do
        expect(url).to eq(
          "http://imgproxy.test/unsafe/pd:10:10:20/plain/https://images.test/image.jpg",
        )
      end
    end

    context "when top equals bottom and right equals left" do
      let(:options) { {padding: {top: 10, right: 20, bottom: 10, left: 20}} }

      it "compacts arguments" do
        expect(url).to eq(
          "http://imgproxy.test/unsafe/pd:10:20/plain/https://images.test/image.jpg",
        )
      end
    end
  end

  describe "background casting" do
    context "when 'hex_color' argument is defined" do
      let(:options) { {background: {hex_color: "123456", R: 10, G: 20, b: 30}} }

      it "ignores other arguments" do
        expect(url).to eq(
          "http://imgproxy.test/unsafe/bg:123456/plain/https://images.test/image.jpg",
        )
      end
    end

    context "when defined as an array" do
      let(:options) { {background: %w[10a 20b 30c]} }

      it "casts values to int" do
        expect(url).to eq(
          "http://imgproxy.test/unsafe/bg:10:20:30/plain/https://images.test/image.jpg",
        )
      end
    end
  end

  describe "blur_detections casting" do
    context "when 'class_names' argument is not defined" do
      let(:options) { {blur_detections: {sigma: 10}} }

      it "ignores 'class_names' argument" do
        expect(url).to eq(
          "http://imgproxy.test/unsafe/bd:10/plain/https://images.test/image.jpg",
        )
      end
    end

    context "when 'class_names' argument is empty" do
      let(:options) { {blur_detections: {sigma: 10, class_names: []}} }

      it "ignores 'class_names' argument" do
        expect(url).to eq(
          "http://imgproxy.test/unsafe/bd:10/plain/https://images.test/image.jpg",
        )
      end
    end
  end

  describe "draw_detections casting" do
    context "when 'class_names' argument is not defined" do
      let(:options) { {draw_detections: {draw: true}} }

      it "ignores 'class_names' argument" do
        expect(url).to eq(
          "http://imgproxy.test/unsafe/dd:1/plain/https://images.test/image.jpg",
        )
      end
    end

    context "when 'class_names' argument is empty" do
      let(:options) { {draw_detections: {draw: true, class_names: []}} }

      it "ignores 'class_names' argument" do
        expect(url).to eq(
          "http://imgproxy.test/unsafe/dd:1/plain/https://images.test/image.jpg",
        )
      end
    end
  end

  describe "watermark casting" do
    context "when the 'opacity' argument is not set" do
      let(:options) { {watermark: {position: "no"}} }

      it "omits whole watermark" do
        expect(url).to eq(
          "http://imgproxy.test/unsafe/plain/https://images.test/image.jpg",
        )
      end
    end

    context "when the 'opacity' argument is zero" do
      let(:options) { {watermark: {opacity: 0, position: "no"}} }

      it "omits omits all other arguments" do
        expect(url).to eq(
          "http://imgproxy.test/unsafe/wm:0/plain/https://images.test/image.jpg",
        )
      end
    end
  end

  describe "format_quality casting" do
    context "when some qualities are nil" do
      let(:options) { {format_quality: {jpeg: 80, webp: nil, avif: 70}} }

      it "ignores nil qualities" do
        expect(url).to eq(
          "http://imgproxy.test/unsafe/fq:jpeg:80:avif:70/plain/https://images.test/image.jpg",
        )
      end
    end
  end

  describe "video_thumbnail_tile casting" do
    context "when the 'step' argument is zero" do
      let(:options) do
        {
          video_thumbnail_tile: {
            step: 0,
            columns: 2,
            rows: 3,
            tile_width: 200,
            tile_height: 100,
          },
        }
      end

      it "ignores all other arguments" do
        expect(url).to eq(
          "http://imgproxy.test/unsafe/vtt:0/plain/https://images.test/image.jpg",
        )
      end
    end
  end

  describe "filename casting" do
    context "when the 'encoded' argument is false" do
      let(:options) { {filename: {filename: "the_image.jpg", encoded: false}} }

      it "doesn't encode 'filename' argument" do
        expect(url).to eq(
          "http://imgproxy.test/unsafe/fn:the_image.jpg/plain/https://images.test/image.jpg",
        )
      end
    end

    context "when the 'encoded' argument is omitted" do
      let(:options) { {filename: {filename: "the_image.jpg"}} }

      it "doesn't encode 'filename' argument" do
        expect(url).to eq(
          "http://imgproxy.test/unsafe/fn:the_image.jpg/plain/https://images.test/image.jpg",
        )
      end
    end

    context "when defined as a string" do
      let(:options) { {filename: "the_image.jpg"} }

      it "uses the value as is" do
        expect(url).to eq(
          "http://imgproxy.test/unsafe/fn:the_image.jpg/plain/https://images.test/image.jpg",
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
          gravity: :sm,
        },
        trim: {
          threshold: 10,
          equal_hor: true,
        },
        adjust: {
          contrast: 0.5,
        },
        unsharp_masking: {
          weight: 10,
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
        "http://imgproxy.test/unsafe/" \
        "ex:1/g:nowe::10/c:100:0:sm/t:10::1/a::0.5/ush::10/wm:0.5::10:5/" \
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
        "http://imgproxy.test/unsafe/" \
        "unsupported1:1:val1:val2:2:3/unsupported2:1::2:3/unsupported3:4:5:6/" \
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
    let(:options) { {width: 100, height: 100} }

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

      after { described_class.config.signature_size = 32 }

      it "signs the URL with truncated signature" do
        expect(url).to start_with "http://imgproxy.test/6PuaY-c/"
      end
    end
  end

  context "when always_encrypt_source_urls config is true" do
    before do
      described_class.config.source_url_encryption_key =
        "1eb5b0e971ad7f45324c1bb15c947cb207c43152fa5c6c7f35c4f36e0c18e0f1"
      described_class.config.always_encrypt_source_urls = true
    end

    it "encrypts source URL" do
      expect(url).to end_with(
        "/enc/MTIzNDU2Nzg5MDEy/MzQ1Np6L0YlR92XD/i3aaVA5KINDMHKXf/LUaQ1N0ae5N7JjBZ.webp",
      )
    end

    context "without encryption key specified" do
      before { described_class.config.source_url_encryption_key = nil }

      it "rises an error" do
        expect { url }.to raise_error(Imgproxy::UrlBuilders::InvalidEncryptionKeyError)
      end
    end

    context "with encryption key of invalid length" do
      before do
        described_class.config.source_url_encryption_key =
          "1eb5b0e971ad7f45324c1bb15c947cb207c43152fa5c6c7f35c4f36e0c18"
      end

      it "rises an error" do
        expect { url }.to raise_error(Imgproxy::UrlBuilders::InvalidEncryptionKeyError)
      end
    end
  end

  context "when encrypt_source_url option is true" do
    before do
      described_class.config.source_url_encryption_key =
        "1eb5b0e971ad7f45324c1bb15c947cb207c43152fa5c6c7f35c4f36e0c18e0f1"
      options[:encrypt_source_url] = true
    end

    it "encrypts source URL" do
      expect(url).to end_with(
        "/enc/MTIzNDU2Nzg5MDEy/MzQ1Np6L0YlR92XD/i3aaVA5KINDMHKXf/LUaQ1N0ae5N7JjBZ.webp",
      )
    end

    context "without encryption key specified" do
      before { described_class.config.source_url_encryption_key = nil }

      it "rises an error" do
        expect { url }.to raise_error(Imgproxy::UrlBuilders::InvalidEncryptionKeyError)
      end
    end

    context "with encryption key of invalid length" do
      before do
        described_class.config.source_url_encryption_key =
          "1eb5b0e971ad7f45324c1bb15c947cb207c43152fa5c6c7f35c4f36e0c18"
      end

      it "rises an error" do
        expect { url }.to raise_error(Imgproxy::UrlBuilders::InvalidEncryptionKeyError)
      end
    end
  end

  context "when custom service specified" do
    let(:options) { {width: 100, height: 100} }

    before do
      described_class.configure do |config|
        config.service(:custom) do |custom|
          custom.key = "Lorem".unpack1("H*")
          custom.salt = "Ipsum".unpack1("H*")
          custom.endpoint = "http://custom-imgproxy.test/"
        end
      end
    end

    it "signs the URL using custom service key/salt" do
      expect(described_class.url_for(src_url, service: :custom)).to start_with(
        "http://custom-imgproxy.test/Ce7iwcp9c0K7mvJD9pLbwXmQ-r-rkNJ1jLIPr2sCVv8/",
      )
    end

    context "when signature is truncated" do
      before { described_class.config.service(:custom).signature_size = 5 }

      after { described_class.config.service(:custom).signature_size = 32 }

      it "signs the URL with truncated signature using custom service key/salt" do
        expect(described_class.url_for(src_url, service: :custom)).to start_with(
          "http://custom-imgproxy.test/Ce7iwco/",
        )
      end
    end

    context "when service is unknown" do
      it "raises UnknownServiceError" do
        expect { described_class.url_for(src_url, service: :unknown) }
          .to raise_error(Imgproxy::UrlBuilders::UnknownServiceError)
      end
    end
  end
end
