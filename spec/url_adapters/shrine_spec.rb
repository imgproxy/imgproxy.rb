require "spec_helper"

require "shrine"
require "shrine/storage/file_system"
require "shrine/storage/s3"

RSpec.describe Imgproxy::UrlAdapters::Shrine do
  let(:shrine_storages) do
    {
      cache: Shrine::Storage::FileSystem.new("."),
      store: Shrine::Storage::FileSystem.new("."),
    }
  end

  let(:uploaded_file) do
    Shrine.new(:store).upload StringIO.new("AVATAR")
  end

  before do
    Shrine.storages = shrine_storages

    shrine_storages.each_value { |s| allow(s).to receive(:upload).and_return(nil) }

    Imgproxy.config.shrine_host = "http://example.com"
    Imgproxy.extend_shrine!
  end

  it "builds URL for Shrine::UploadedFile" do
    expect(Imgproxy.url_for(uploaded_file)).to end_with \
      "/plain/#{uploaded_file.url(host: 'http://example.com')}"
  end

  describe "extension" do
    it "builds URL with Shrine extension" do
      expect(uploaded_file.imgproxy_url(width: 200)).to eq(
        "http://imgproxy.test/unsafe/w:200" \
        "/plain/#{uploaded_file.url(host: 'http://example.com')}",
      )
    end

    it "builds info URL with Shrine extension" do
      expect(uploaded_file.imgproxy_info_url).to eq(
        "http://imgproxy.test/info/unsafe" \
        "/plain/#{uploaded_file.url(host: 'http://example.com')}",
      )
    end
  end

  context "when using s3://... urls" do
    let(:s3_options) do
      {
        access_key_id: "access",
        secret_access_key: "secret",
        region: "us-east-1",
        bucket: "uploads",
        stub_responses: true,
      }
    end

    let(:shrine_storages) do
      {
        cache: ::Shrine::Storage::S3.new(**s3_options.merge(prefix: "cache")),
        store: ::Shrine::Storage::S3.new(**s3_options),
      }
    end

    let(:uploaded_file) do
      Shrine.new(:store).upload StringIO.new("AVATAR")
    end

    before { Imgproxy.config.use_s3_urls = true }

    it "builds URL for Shrine::UploadedFile" do
      expect(Imgproxy.url_for(uploaded_file)).to end_with \
        "/plain/s3://uploads/#{uploaded_file.id}"
    end

    context "when prefix is defined" do
      let(:s3_options) do
        {
          access_key_id: "access",
          secret_access_key: "secret",
          region: "us-east-1",
          bucket: "uploads",
          stub_responses: true,
          prefix: "prefix",
        }
      end

      it "builds URL for Shrine::UploadedFile with prefix" do
        expect(Imgproxy.url_for(uploaded_file)).to end_with \
          "/plain/s3://uploads/prefix/#{uploaded_file.id}"
      end
    end

    describe "extension" do
      it "builds URL with Shrine extension" do
        expect(uploaded_file.imgproxy_url(width: 200)).to eq(
          "http://imgproxy.test/unsafe/w:200/plain/s3://uploads/#{uploaded_file.id}",
        )
      end
    end
  end

  describe "for custom service" do
    before do
      Imgproxy.config(:custom).shrine_host = "http://custom.com"
      Imgproxy.extend_shrine!
    end

    it "builds URL for Shrine::UploadedFile" do
      expect(Imgproxy.url_for(uploaded_file, service: :custom)).to end_with \
        "/plain/#{uploaded_file.url(host: 'http://custom.com')}"
    end
  end
end
