ENV["RAILS_ENV"] ||= "test"

require "bundler/setup"
require "pry-byebug"

require "imgproxy"

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec

  config.shared_context_metadata_behavior = :apply_to_host_groups
  config.filter_run_when_matching :focus
  config.run_all_when_everything_filtered = true
  config.disable_monkey_patching!
  config.profile_examples = 5
  config.order = :random

  # Fixes random seed when running with spring
  config.seed = srand % 0xFFFF unless ARGV.any? { |arg| arg =~ /seed/ }

  config.default_formatter = "doc" if config.files_to_run.one?

  config.raise_errors_for_deprecations!

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
