require "spec_helper"

require_relative "dummy/config/environment.rb"

require "active_support"
require "active_job"
require "active_storage"
require "global_id"
require "tmpdir"

ActiveJob::Base.queue_adapter = :test
ActiveJob::Base.logger = ActiveSupport::Logger.new(nil)

ActiveStorage.logger = ActiveSupport::Logger.new(nil)
ActiveStorage.verifier = ActiveSupport::MessageVerifier.new("Testing")

ActiveStorage::Blob.service = ActiveStorage::Service::DiskService.new(
  root: Dir.mktmpdir("active_storage_tests"),
)

GlobalID.app = "ActiveStorageExampleApp"
ActiveRecord::Base.include GlobalID::Identification

Rails.application.routes.default_url_options[:host] = "example.com"

require "support/active_record"

RSpec.configure do |config|
  config.before :all do
    setup_database
  end

  config.before do
    ActiveStorage::Current.host = "https://example.com"
  end

  config.after do
    ActiveStorage::Current.reset
  end

  config.around do |example|
    orig_service = ActiveStorage::Blob.service
    example.run
    ActiveStorage::Blob.service = orig_service
  end
end
