require "rails_helper"

RSpec.describe Imgproxy::UrlAdapters::ActiveStorageS3 do
  let(:s3_service) do
    ActiveStorage::Service.configure(
      :s3,
      s3: {
        service: :S3,
        access_key_id: "access",
        secret_access_key: "secret",
        region: "us-east-1",
        bucket: "uploads",
        stub_responses: true,
      },
    )
  end

  let(:user) do
    User.create!.tap do |user|
      user.avatar.attach(
        io: StringIO.new("AVATAR"), filename: "avatar.jpg", content_type: "image/jpg",
      )
    end
  end

  before do
    ActiveStorage::Blob.service = s3_service
    Imgproxy.config.url_adapters.add described_class.new
  end

  it "fethces url for ActiveStorage::Attached::One" do
    expect(Imgproxy.url_for(user.avatar)).to end_with \
      "/plain/s3://uploads/#{user.avatar.key}"
  end

  it "fethces url for ActiveStorage::Attachment" do
    expect(Imgproxy.url_for(user.avatar.attachment)).to end_with \
      "/plain/s3://uploads/#{user.avatar.key}"
  end

  it "fethces url for ActiveStorage::Blob" do
    expect(Imgproxy.url_for(user.avatar.attachment.blob)).to end_with \
      "/plain/s3://uploads/#{user.avatar.key}"
  end

  describe "extension" do
    before do
      Imgproxy.config.url_adapters.clear!
      Imgproxy.extend_active_storage!(use_s3: true)
    end

    it "build URL with ActiveStorage extension" do
      expect(user.avatar.imgproxy_url(width: 200)).to eq(
        "http://imgproxy.test/unsafe/w:200/plain/s3://uploads/#{user.avatar.key}",
      )
    end
  end
end
