require "shrine_helper"

RSpec.describe Imgproxy::UrlAdapters::ShrineS3 do
  let(:s3_options) do
    {
      access_key_id: "access",
      secret_access_key: "secret",
      region: "us-east-1",
      bucket: "uploads",
      stub_responses: true,
    }
  end

  let(:uploaded_file) do
    Shrine.new(:store).upload StringIO.new("AVATAR")
  end

  subject(:adapter) { described_class.new }

  before do
    Shrine.storages = {
      cache: ::Shrine::Storage::S3.new(**s3_options.merge(prefix: "cache")),
      store: ::Shrine::Storage::S3.new(**s3_options),
    }

    Imgproxy.config.url_adapters.add adapter
  end

  it "fethces url for Shrine::UploadedFile" do
    expect(Imgproxy.url_for(uploaded_file)).to end_with \
      "/plain/s3://uploads/#{uploaded_file.id}"
  end

  describe "extension" do
    before do
      Imgproxy.config.url_adapters.clear!
      Imgproxy.extend_shrine!(use_s3: true)
    end

    it "build URL with ActiveStorage extension" do
      expect(uploaded_file.imgproxy_url(width: 200)).to eq(
        "http://imgproxy.test/unsafe/w:200/plain/s3://uploads/#{uploaded_file.id}",
      )
    end
  end
end
