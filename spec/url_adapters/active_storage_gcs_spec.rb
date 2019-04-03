require "rails_helper"

RSpec.describe Imgproxy::UrlAdapters::ActiveStorageGCS do
  let(:gcs_service) do
    ActiveStorage::Service.configure(
      :gcs,
      gcs: {
        service: :GCS,
        project: "test",
        credentials: {},
        bucket: "uploads",
      },
    )
  end

  let!(:user) do
    User.create!.tap do |user|
      user.avatar.attach(
        io: StringIO.new("AVATAR"), filename: "avatar.jpg", content_type: "image/jpg",
      )
    end
  end

  before do
    ActiveStorage::Blob.service = gcs_service
    Imgproxy.config.url_adapters.add described_class.new("uploads")
  end

  it "fethces url for ActiveStorage::Attached::One" do
    expect(Imgproxy.url_for(user.avatar)).to end_with \
      "/plain/gs://uploads/#{user.avatar.key}"
  end

  it "fethces url for ActiveStorage::Attachment" do
    expect(Imgproxy.url_for(user.avatar.attachment)).to end_with \
      "/plain/gs://uploads/#{user.avatar.key}"
  end

  it "fethces url for ActiveStorage::Blob" do
    expect(Imgproxy.url_for(user.avatar.attachment.blob)).to end_with \
      "/plain/gs://uploads/#{user.avatar.key}"
  end

  describe "extension" do
    before do
      Imgproxy.config.url_adapters.clear!
      Imgproxy.extend_active_storage!(use_gcs: true, gcs_bucket: "uploads")
    end

    it "build URL with ActiveStorage extension" do
      expect(user.avatar.imgproxy_url(width: 200)).to eq(
        "http://imgproxy.test/unsafe/w:200/plain/gs://uploads/#{user.avatar.key}",
      )
    end
  end
end
