require "spec_helper"

RSpec.describe Imgproxy do
  let(:src_url) { "https://images.test/image.jpg" }

  describe ".info_url_for" do
    let(:options) do
      {
        size: true,
        format: false,
        dimensions: true,
        exif: false,
        iptc: true,
        video_meta: false,
        detect_objects: true,
        colorspace: false,
        bands: true,
        sample_format: false,
        pages_number: true,
        alpha: {
          alpha: true,
          check_transparency: true,
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
        palette: "123",
        average: {
          average: true,
          ignore_transparent: true,
        },
        dominant_colors: {
          dominant_colors: true,
          build_missed: true,
        },
        blurhash: {
          x_components: 4,
          y_components: 3,
        },
        calc_hashsum: %w[md5 sha1],
        page: 42,
        video_thumbnail_second: 15,
        cachebuster: "qwerty",
        expires: Time.at(4810374983),
        preset: %i[preset1 preset2],
        source_url_encryption_iv: "1234567890123456",
      }
    end

    let(:casted_options) do
      [
        "s:1",
        "f:0",
        "d:1",
        "exif:0",
        "iptc:1",
        "vm:0",
        "do:1",
        "cs:0",
        "b:1",
        "sf:0",
        "pn:1",
        "a:1:1",
        "c:500:100:ce:0.35:0.65",
        "p:123",
        "avg:1:1",
        "dc:1:1",
        "bh:4:3",
        "chs:md5:sha1",
        "pg:42",
        "vts:15",
        "cb:qwerty",
        "exp:4810374983",
        "pr:preset1:preset2",
      ].join("/")
    end

    let(:casted_options_full) do
      [
        "size:1",
        "format:0",
        "dimensions:1",
        "exif:0",
        "iptc:1",
        "video_meta:0",
        "detect_objects:1",
        "colorspace:0",
        "bands:1",
        "sample_format:0",
        "pages_number:1",
        "alpha:1:1",
        "crop:500:100:ce:0.35:0.65",
        "palette:123",
        "average:1:1",
        "dominant_colors:1:1",
        "blurhash:4:3",
        "calc_hashsum:md5:sha1",
        "page:42",
        "video_thumbnail_second:15",
        "cachebuster:qwerty",
        "expires:4810374983",
        "preset:preset1:preset2",
      ].join("/")
    end

    subject(:url) { described_class.info_url_for(src_url, options) }

    it "builds URL" do
      expect(url).to eq(
        "http://imgproxy.test/info/unsafe/#{casted_options}/"\
        "plain/https://images.test/image.jpg",
      )
    end

    context "when base64_encode_urls is true" do
      before { described_class.config.base64_encode_urls = true }

      it "builds URL with base64 URL" do
        expect(url).to eq(
          "http://imgproxy.test/info/unsafe/#{casted_options}/"\
          "#{Base64.urlsafe_encode64(src_url).tr('=', '').scan(/.{1,16}/).join('/')}",
        )
      end
    end

    context "when base64_encode_url option true" do
      before { options[:base64_encode_url] = true }

      it "builds URL with base64 URL" do
        expect(url).to eq(
          "http://imgproxy.test/info/unsafe/#{casted_options}/"\
          "#{Base64.urlsafe_encode64(src_url).tr('=', '').scan(/.{1,16}/).join('/')}",
        )
      end
    end

    context "when use_short_options config is false" do
      before { described_class.config.use_short_options = false }

      it "builds URL with full processing options names" do
        expect(url).to eq(
          "http://imgproxy.test/info/unsafe/#{casted_options_full}/"\
          "plain/https://images.test/image.jpg",
        )
      end
    end

    context "when use_short_options option is false" do
      before { options[:use_short_options] = false }

      it "builds URL with full processing options names" do
        expect(url).to eq(
          "http://imgproxy.test/info/unsafe/#{casted_options_full}/"\
          "plain/https://images.test/image.jpg",
        )
      end
    end

    context "when source image is an URI" do
      let(:src_url) { URI.parse("https://images.test/image.jpg") }

      it "builds URL" do
        expect(url).to end_with "/plain/https://images.test/image.jpg"
      end
    end

    describe "crop casting" do
      context "when both crop width and height aren't set" do
        let(:options) { { crop: { gravity: { type: "ce" } } } }

        it "omits crop" do
          expect(url).to eq(
            "http://imgproxy.test/info/unsafe/plain/https://images.test/image.jpg",
          )
        end
      end

      context "when crop width or height aren't set" do
        let(:options) { { crop: { width: 300 } } }

        it "replaces missed side with zero" do
          expect(url).to eq(
            "http://imgproxy.test/info/unsafe/c:300:0/plain/https://images.test/image.jpg",
          )
        end
      end
    end

    describe "alpha casting" do
      context "when the 'alpha' argument is not set" do
        let(:options) { { alpha: { check_transparency: true } } }

        it "omits whole alpha" do
          expect(url).to eq(
            "http://imgproxy.test/info/unsafe/plain/https://images.test/image.jpg",
          )
        end
      end

      context "when the 'alpha' argument is false" do
        let(:options) { { alpha: { alpha: false, check_transparency: true } } }

        it "omits all other arguments" do
          expect(url).to eq(
            "http://imgproxy.test/info/unsafe/a:0/plain/https://images.test/image.jpg",
          )
        end
      end

      context "when a boolean value is used" do
        let(:options) { { alpha: true } }

        it "casts to boolean" do
          expect(url).to eq(
            "http://imgproxy.test/info/unsafe/a:1/plain/https://images.test/image.jpg",
          )
        end
      end
    end

    describe "average casting" do
      context "when the 'average' argument is not set" do
        let(:options) { { average: { ignore_transparent: true } } }

        it "omits whole average" do
          expect(url).to eq(
            "http://imgproxy.test/info/unsafe/plain/https://images.test/image.jpg",
          )
        end
      end

      context "when the 'average' argument is false" do
        let(:options) { { average: { average: false, ignore_transparent: true } } }

        it "omits all other arguments" do
          expect(url).to eq(
            "http://imgproxy.test/info/unsafe/avg:0/plain/https://images.test/image.jpg",
          )
        end
      end

      context "when a boolean value is used" do
        let(:options) { { average: true } }

        it "casts to boolean" do
          expect(url).to eq(
            "http://imgproxy.test/info/unsafe/avg:1/plain/https://images.test/image.jpg",
          )
        end
      end
    end

    describe "dominant_colors casting" do
      context "when the 'dominant_colors' argument is not set" do
        let(:options) { { dominant_colors: { build_missing: true } } }

        it "omits whole dominant_colors" do
          expect(url).to eq(
            "http://imgproxy.test/info/unsafe/plain/https://images.test/image.jpg",
          )
        end
      end

      context "when the 'dominant_colors' argument is false" do
        let(:options) { { dominant_colors: { dominant_colors: false, build_missing: true } } }

        it "omits all other arguments" do
          expect(url).to eq(
            "http://imgproxy.test/info/unsafe/dc:0/plain/https://images.test/image.jpg",
          )
        end
      end

      context "when a boolean value is used" do
        let(:options) { { dominant_colors: true } }

        it "casts to boolean" do
          expect(url).to eq(
            "http://imgproxy.test/info/unsafe/dc:1/plain/https://images.test/image.jpg",
          )
        end
      end
    end

    describe "ommiting processing options arguments" do
      let(:options) do
        {
          alpha: {
            alpha: true,
          },
          crop: {
            width: 100,
            gravity: :sm,
          },
          average: {
            average: false,
          },
          dominant_colors: {
            dominant_colors: true,
          },
        }
      end

      it "ommits unset arguments and trims trailing ones" do
        expect(url).to eq(
          "http://imgproxy.test/info/unsafe/"\
          "a:1/c:100:0:sm/avg:0/dc:1/"\
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
          "http://imgproxy.test/info/unsafe/"\
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
        expect(url).to end_with "/plain/https%3A%2F%2Fimages.test%2Fimage.jpg%3Fversion%3D123"
      end
    end

    context "when source URL contains non-ascii chars" do
      let(:src_url) { "https://images.test/и.jpg" }

      it "escapes source URL" do
        expect(url).to end_with "/plain/https%3A%2F%2Fimages.test%2F%D0%B8.jpg"
      end
    end

    context "when source URL contains spaces" do
      let(:src_url) { "https://images.test/lorem ipsum.jpg" }

      it "escapes source URL" do
        expect(url).to end_with "/plain/https%3A%2F%2Fimages.test%2Florem%20ipsum.jpg"
      end
    end

    context "when always_escape_plain_urls config is true" do
      before { described_class.config.always_escape_plain_urls = true }

      it "escapes source URL" do
        expect(url).to end_with "/plain/https%3A%2F%2Fimages.test%2Fimage.jpg"
      end
    end

    context "when escape_plain_url option is true" do
      before { options[:escape_plain_url] = true }

      it "escapes source URL" do
        expect(url).to end_with "/plain/https%3A%2F%2Fimages.test%2Fimage.jpg"
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
        expect(url).to start_with "http://imgproxy.test/info/T9ZBRjsTHNpKAO7nqBciDZbxbuWNlgQRlVCyQb1zE3Q/"
      end

      context "when signature is truncated" do
        before { described_class.config.signature_size = 5 }

        after { described_class.config.signature_size = 32 }

        it "signs the URL with truncated signature" do
          expect(url).to start_with "http://imgproxy.test/info/T9ZBRjs/"
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
          "/enc/MTIzNDU2Nzg5MDEy/MzQ1Np6L0YlR92XD/i3aaVA5KINDMHKXf/LUaQ1N0ae5N7JjBZ",
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
          "/enc/MTIzNDU2Nzg5MDEy/MzQ1Np6L0YlR92XD/i3aaVA5KINDMHKXf/LUaQ1N0ae5N7JjBZ",
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
      let(:options) { { width: 100, height: 100 } }

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
        expect(described_class.info_url_for(src_url, service: :custom)).to start_with(
          "http://custom-imgproxy.test/info/Ce7iwcp9c0K7mvJD9pLbwXmQ-r-rkNJ1jLIPr2sCVv8/",
        )
      end

      context "when signature is truncated" do
        before { described_class.config.service(:custom).signature_size = 5 }

        after { described_class.config.service(:custom).signature_size = 32 }

        it "signs the URL with truncated signature using custom service key/salt" do
          expect(described_class.info_url_for(src_url, service: :custom)).to start_with(
            "http://custom-imgproxy.test/info/Ce7iwco/",
          )
        end
      end

      context "when service is unknown" do
        it "raises UnknownServiceError" do
          expect { described_class.info_url_for(src_url, service: :unknown) }
            .to raise_error(Imgproxy::UrlBuilders::UnknownServiceError)
        end
      end
    end
  end
end
