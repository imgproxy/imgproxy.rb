require "spec_helper"

require_relative "../dummy/config/environment"

require "active_support"
require "active_job"
require "active_storage"
require "global_id"
require "fileutils"

ActiveJob::Base.queue_adapter = :test
ActiveJob::Base.logger = ActiveSupport::Logger.new(nil)

ActiveStorage.logger = ActiveSupport::Logger.new(nil)
ActiveStorage.verifier = ActiveSupport::MessageVerifier.new("Testing")

GlobalID.app = "ActiveStorageExampleApp"
ActiveRecord::Base.include GlobalID::Identification

Rails.application.routes.default_url_options[:host] = "example.com"

require_relative "../support/active_record"

RSpec.describe Imgproxy::UrlAdapters::ActiveStorage do
  let(:active_storage_service) do
    ActiveStorage::Service.configure(
      :local,
      local: {
        service: "Disk",
        root: "tmp/active_storage_tests",
      },
    )
  end

  let(:user) do
    User.create!.tap do |user|
      user.avatar.attach(
        io: StringIO.new("AVATAR"), filename: "avatar.jpg", content_type: "image/jpeg",
      )
    end
  end

  before(:all) { setup_database }

  before do
    ActiveStorage::Current.url_options = { host: "https://example.com" }
    ActiveStorage::Blob.service = active_storage_service
    ActiveStorage::Blob.services = { active_storage_service.name.to_s => active_storage_service }

    allow(active_storage_service).to receive(:upload).and_return(nil)

    Imgproxy.extend_active_storage!
  end

  after { ActiveStorage::Current.reset }

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
    let(:active_storage_service) do
      ActiveStorage::Service.configure(
        :mirror,
        mirror: {
          service: "Mirror",
          primary: :local,
          mirrors: [],
        },
        local: {
          service: "Disk",
          root: "tmp/active_storage_tests",
        },
      )
    end

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
    let(:active_storage_service) do
      ActiveStorage::Service.configure(
        :s3,
        s3: {
          service: "S3",
          access_key_id: "access",
          secret_access_key: "secret",
          region: "us-east-1",
          bucket: "uploads",
        },
      )
    end

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
      let(:active_storage_service) do
        ActiveStorage::Service.configure(
          :mirror,
          mirror: {
            service: "Mirror",
            primary: :s3,
            mirrors: [],
          },
          s3: {
            service: "S3",
            access_key_id: "access",
            secret_access_key: "secret",
            region: "us-east-1",
            bucket: "uploads",
          },
        )
      end

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
    let(:active_storage_service) do
      ActiveStorage::Service.configure(
        :gcs,
        gcs: {
          service: "GCS",
          project: "test",
          credentials: {},
          bucket: "uploads",
        },
      )
    end

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
      let(:active_storage_service) do
        ActiveStorage::Service.configure(
          :mirror,
          mirror: {
            service: "Mirror",
            primary: :gcs,
            mirrors: [],
          },
          gcs: {
            service: "GCS",
            project: "test",
            credentials: {},
            bucket: "uploads",
          },
        )
      end

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
      expect(Imgproxy.url_for(user.avatar, service: :custom)).to end_with \
        "/plain/#{Rails.application.routes.url_helpers.url_for(user.avatar)}"

      expect(Imgproxy.url_for(user.avatar, service: :custom)).to start_with \
        "https://custom-service.com/"
    end
  end
end
