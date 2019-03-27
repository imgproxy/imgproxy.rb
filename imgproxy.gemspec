lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "imgproxy/version"

Gem::Specification.new do |spec|
  spec.name        = "imgproxy"
  spec.version     = Imgproxy::VERSION
  spec.date        = "2019-03-25"
  spec.summary     = "imgproxy URL generator"
  spec.description = "A gem that easily generates imgproxy URLs for your images"
  spec.authors     = ["Sergey Alexandrovich"]
  spec.email       = "darthsim@gmail.com"
  spec.homepage    = "https://github.com/imgproxy/imgproxy.rb"
  spec.license     = "MIT"

  spec.files         = `git ls-files README.md LICENSE CHANGELOG.md lib`.split
  spec.require_paths = ["lib"]

  spec.add_development_dependency "rspec", "~> 3.8.0"
  spec.add_development_dependency "rubocop", "~> 0.66.0"
  spec.add_development_dependency "rubocop-rspec", "~> 1.32.0"

  spec.add_development_dependency "pry-byebug"
end
