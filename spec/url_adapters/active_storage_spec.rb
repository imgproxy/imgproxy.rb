# frozen_string_literal: true

require "rails_helper"

RSpec.describe Imgproxy::UrlAdapters::ActiveStorage do
  let(:active_storage_service_name) { :local }

  let(:user) do
    User.create.tap do |user|
      user.avatar.attach(
        io: StringIO.new("AVATAR"),
        filename: "avatar.jpg",
        content_type: "image/jpeg",
      )
    end
  end

  before do
    ActiveStorage::Blob.service = active_storage_service_name

    active_storage_service = ActiveStorage::Blob.services.fetch(active_storage_service_name)
    allow(active_storage_service).to receive(:upload).and_return(nil)

    Imgproxy.extend_active_storage!
  end

  it "builds URL for ActiveStorage::Attached::One" do
    expect(Imgproxy.url_for(user.avatar)).to end_with \
      "/plain/#{Rails.application.routes.url_helpers.url_for(user.avatar)}"
  end

  it "builds URL for ActiveStorage::Attachment" do
    expect(Imgproxy.url_for(user.avatar.attachment)).to end_with \
      "/plain/#{Rails.application.routes.url_helpers.url_for(user.avatar)}"
  end

  it "builds URL for ActiveStorage::Blob" do
    expect(Imgproxy.url_for(user.avatar.attachment.blob)).to end_with \
      "/plain/#{Rails.application.routes.url_helpers.url_for(user.avatar)}"
  end

  context "with mirror" do
    let(:active_storage_service_name) { :mirror_local }

    it "uses primary service to build URL" do
      expect(Imgproxy.url_for(user.avatar)).to end_with \
        "/plain/#{Rails.application.routes.url_helpers.url_for(user.avatar)}"
    end
  end

  describe "extension" do
    it "builds URL with ActiveStorage extension" do
      expect(user.avatar.imgproxy_url(width: 200)).to eq(
        "http://imgproxy.test/unsafe/w:200" \
        "/plain/#{Rails.application.routes.url_helpers.url_for(user.avatar)}",
      )
    end

    it "builds info URL with ActiveStorage extension" do
      expect(user.avatar.imgproxy_info_url).to eq(
        "http://imgproxy.test/info/unsafe" \
        "/plain/#{Rails.application.routes.url_helpers.url_for(user.avatar)}",
      )
    end
  end

  context "when using s3://... urls" do
    let(:active_storage_service_name) { :s3 }

    before { Imgproxy.config.use_s3_urls = true }

    it "builds URL for ActiveStorage::Attached::One" do
      expect(Imgproxy.url_for(user.avatar)).to end_with \
        "/plain/s3://uploads/#{user.avatar.key}"
    end

    it "builds URL for ActiveStorage::Attachment" do
      expect(Imgproxy.url_for(user.avatar.attachment)).to end_with \
        "/plain/s3://uploads/#{user.avatar.key}"
    end

    it "builds URL for ActiveStorage::Blob" do
      expect(Imgproxy.url_for(user.avatar.attachment.blob)).to end_with \
        "/plain/s3://uploads/#{user.avatar.key}"
    end

    context "with mirror" do
      let(:active_storage_service_name) { :mirror_s3 }

      it "uses primary service to build URL" do
        expect(Imgproxy.url_for(user.avatar)).to end_with \
          "/plain/s3://uploads/#{user.avatar.key}"
      end
    end

    describe "extension" do
      it "builds URL with ActiveStorage extension" do
        expect(user.avatar.imgproxy_url(width: 200)).to eq(
          "http://imgproxy.test/unsafe/w:200/plain/s3://uploads/#{user.avatar.key}",
        )
      end
    end
  end

  context "when using gs://... urls" do
    let(:active_storage_service_name) { :gcs }

    before do
      Imgproxy.config.use_gcs_urls = true
      Imgproxy.config.gcs_bucket = "uploads"
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

    context "with mirror" do
      let(:active_storage_service_name) { :mirror_gcs }

      it "uses primary service to build URL" do
        expect(Imgproxy.url_for(user.avatar)).to end_with \
          "/plain/gs://uploads/#{user.avatar.key}"
      end
    end

    describe "extension" do
      it "build URL with ActiveStorage extension" do
        expect(user.avatar.imgproxy_url(width: 200)).to eq(
          "http://imgproxy.test/unsafe/w:200/plain/gs://uploads/#{user.avatar.key}",
        )
      end
    end
  end

  describe "for custom service" do
    before do
      Imgproxy.config.service(:custom).endpoint = "https://custom-service.com/"
    end

    it "builds URL for ActiveStorage::Attached::One" do
      expect(Imgproxy.url_for(user.avatar, service: :custom)).to end_with(
        "/plain/#{Rails.application.routes.url_helpers.url_for(user.avatar)}",
      ).and start_with(
        "https://custom-service.com/",
      )
    end
  end
end
