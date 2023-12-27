require "spec_helper"

require "carrierwave"

RSpec.describe Imgproxy::UrlAdapters::Carrierwave do
  let(:uploader_class) { Class.new(CarrierWave::Uploader::Base) }
  let(:uploader) { uploader_class.new }
  let(:file) { File.open(__FILE__) }
  let(:upload_path) { "./uploads" }

  after { FileUtils.rm_rf(upload_path) }

  before do
    CarrierWave.configure do |config|
      config.root = upload_path
      config.asset_host = "http://localhost:3000"
    end    
    Imgproxy.extend_carrierwave! 
    uploader.store!(file)
  end

  it "builds URL for CarrierWave::Uploader::Base" do
    expect(Imgproxy.url_for(uploader)).to end_with \
      "/plain/#{uploader.url}"
    expect(Imgproxy.url_for(uploader)).to end_with \
      "http://localhost:3000/uploads/carrierwave_spec.rb"
  end

  describe "extension" do
    it "builds URL with Carrierwave extension" do
      expect(uploader.imgproxy_url(width: 200)).to eq(
        "http://imgproxy.test/unsafe/w:200" \
        "/plain/#{uploader.url}",
      )
    end

    it "builds info URL with Carrierwave extension" do
      expect(uploader.imgproxy_info_url).to eq(
        "http://imgproxy.test/info/unsafe" \
        "/plain/#{uploader.url}",
      )
    end
  end
end
