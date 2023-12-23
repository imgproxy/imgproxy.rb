# frozen_string_literal: true

begin
  require "debug" unless ENV["CI"]
rescue LoadError # rubocop:disable Lint/SuppressedException
end

ENV["RAILS_ENV"] = "test"

require "imgproxy"

RSpec.configure do |config|
  config.mock_with :rspec

  config.example_status_persistence_file_path = "tmp/rspec_examples.txt"
  config.filter_run :focus
  config.run_all_when_everything_filtered = true

  config.order = :random
  Kernel.srand config.seed

  config.before do
    Imgproxy.configure do |c|
      c.endpoint = "http://imgproxy.test/"
      c.key = nil
      c.salt = nil
      c.signature_size = 32
      c.use_short_options = true
      c.base64_encode_urls = false
      c.always_escape_plain_urls = false
      c.use_s3_urls = false
      c.use_gcs_urls = false
      c.gcs_bucket = nil
      c.shrine_host = nil
      c.source_url_encryption_key = nil
      c.always_encrypt_source_urls = false

      c.url_adapters.clear!
    end
  end
end
