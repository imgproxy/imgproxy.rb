lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "imgproxy/version"

Gem::Specification.new do |spec|
  spec.name        = "imgproxy"
  spec.version     = Imgproxy::VERSION
  spec.summary     = "imgproxy URL generator"
  spec.description = "A gem that easily generates imgproxy URLs for your images"
  spec.authors     = ["Sergey Alexandrovich"]
  spec.email       = "darthsim@gmail.com"
  spec.homepage    = "https://github.com/imgproxy/imgproxy.rb"
  spec.license     = "MIT"

  spec.files         = `git ls-files README.md LICENSE CHANGELOG.md lib`.split
  spec.require_paths = ["lib"]

  spec.required_ruby_version = ">= 2.0"

  spec.add_development_dependency "pry-byebug", "~> 3.6.0"
  spec.add_development_dependency "rspec", "~> 3.8.0"
  spec.add_development_dependency "rspec_junit_formatter", "~> 0.4.1"
  spec.add_development_dependency "rubocop", "~> 0.66.0"
  spec.add_development_dependency "rubocop-rspec", "~> 1.32.0"

  spec.add_development_dependency "aws-sdk-s3", "~> 1.35.0"
  spec.add_development_dependency "google-cloud-storage", "~> 1.11"
  spec.add_development_dependency "rails", "~> 5.2"
  spec.add_development_dependency "shrine", "~> 3.0"
  spec.add_development_dependency "sqlite3", "~>1.4.1"
end
