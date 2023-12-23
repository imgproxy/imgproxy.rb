# frozen_string_literal: true

require "spec_helper"

require "combustion"
begin
  Combustion.initialize!(:active_storage, :active_record) do
    config.active_storage.service = :local
    config.logger = Logger.new(nil)
    config.log_level = :fatal
  end
rescue StandardError => e
  $stdout.puts "Failed to load the app: #{e.message}\n#{e.backtrace.take(5).join("\n")}"
  exit(1)
end

require "rspec/rails"

class User < ActiveRecord::Base
  has_one_attached :avatar
end

Rails.application.routes.default_url_options[:host] = "http://example.com"

# Run activestorage migrations
active_storage_path = Gem::Specification.find_by_name("activestorage").gem_dir
ActiveRecord::MigrationContext.new(
  File.join(active_storage_path, "db/migrate"),
  ActiveRecord::SchemaMigration,
).migrate

RSpec.configure do |config|
  config.use_transactional_fixtures = true
end
