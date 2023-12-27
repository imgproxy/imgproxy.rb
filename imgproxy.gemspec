# frozen_string_literal: true

lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "imgproxy/version"

Gem::Specification.new do |spec|
  spec.name = "imgproxy"
  spec.version = Imgproxy::VERSION
  spec.summary = "imgproxy URL generator"
  spec.description = "A gem that easily generates imgproxy URLs for your images"
  spec.authors = ["Sergei Aleksandrovich"]
  spec.email = "darthsim@gmail.com"
  spec.homepage = "https://github.com/imgproxy/imgproxy.rb"
  spec.license = "MIT"

  spec.files =
    Dir.glob("lib/**/*") +
    Dir.glob("docs/**/*") +
    Dir.glob("logo/**/*") +
    %w[README.md LICENSE CHANGELOG.md UPGRADE.md .yardopts]
  spec.require_paths = ["lib"]

  spec.required_ruby_version = ">= 2.5"

  spec.metadata = {
    "rubygems_mfa_required" => "true",
    "bug_tracker_uri" => "http://github.com/imgproxy/imgproxy.rb/issues",
    "changelog_uri" => "https://github.com/imgproxy/imgproxy.rb/blob/master/CHANGELOG.md",
    "documentation_uri" => "http://github.com/imgproxy/imgproxy.rb",
    "homepage_uri" => "http://github.com/imgproxy/imgproxy.rb",
    "source_code_uri" => "http://github.com/imgproxy/imgproxy.rb",
  }

  spec.add_dependency "anyway_config", "~> 2.6"

  spec.add_development_dependency "benchmark-memory", "~> 0.2"
  spec.add_development_dependency "combustion", "~> 1.3"
  spec.add_development_dependency "rspec", "~> 3.12"
  spec.add_development_dependency "rspec-rails", "~> 6.0"
  spec.add_development_dependency "rubocop-rspec", "~> 2.11"
  spec.add_development_dependency "standard", "~> 1.0"

  spec.add_development_dependency "aws-sdk-s3", "~> 1.64"
  spec.add_development_dependency "google-cloud-storage", "~> 1.11"
  spec.add_development_dependency "rails", "~> 7.0"
  spec.add_development_dependency "shrine", "~> 3.0"
  spec.add_development_dependency "sqlite3", "~>1.4"
end
