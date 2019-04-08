require "spec_helper"

require "shrine"
require "shrine/storage/file_system"
require "shrine/storage/s3"
require "tmpdir"

Shrine.storages = {
  cache: Shrine::Storage::FileSystem.new(Dir.mktmpdir("shrine_tests")),
  store: Shrine::Storage::FileSystem.new(Dir.mktmpdir("shrine_tests")),
}

RSpec.configure do |config|
  config.around do |example|
    orig_storages = Shrine.storages
    example.run
    Shrine.storages = orig_storages
  end
end
