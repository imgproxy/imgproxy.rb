require "shrine_helper"

RSpec.describe Imgproxy::UrlAdapters::Shrine do
  let(:uploaded_file) do
    Shrine.new(:store).upload StringIO.new("AVATAR")
  end

  before do
    Imgproxy.config.url_adapters.add described_class.new
  end

  it "fethces url for Shrine::UploadedFile" do
    expect(Imgproxy.url_for(uploaded_file)).to end_with \
      "/plain/#{uploaded_file.url}"
  end

  describe "extension" do
    before do
      Imgproxy.config.url_adapters.clear!
      Imgproxy.extend_shrine!
    end

    it "build URL with Shrine extension" do
      expect(uploaded_file.imgproxy_url(width: 200)).to eq(
        "http://imgproxy.test/unsafe/w:200" \
        "/plain/#{uploaded_file.url}",
      )
    end
  end
end
