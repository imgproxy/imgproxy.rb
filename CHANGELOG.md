<!--
# @title Changelog
-->
# Changelog

## [Unreleased]
### Added
- Add `smart_subsample` argument to the `webp_options` processing option.
- Add `watermark_rotate` processing option support.
- Add `fill`, `focus_x`, and `focus_y` arguments to the `video_thumbnail_tile` processing option.

### Fixed

- Fix `calc_hashsums` info option name.

## [3.0.0] - 2023-12-28

⚠️ This is a major release. See [the migration guide](https://github.com/imgproxy/imgproxy.rb/blob/master/UPGRADE.md). ⚠️

### Added
- Added info options support.
- Added missing processing options.
- Added ecrypted source URLs support.
- Added extra services support.

## [2.1.0] - 2022-06-14
### Added
- Add `ActiveStorage::Service::MirrorService` support.
- Add `expires` and `return_attachment` options support.

## [2.0.0] - 2021-03-02

⚠️ This is a major release. See [the migration guide](https://github.com/imgproxy/imgproxy.rb/blob/master/UPGRADE.md). ⚠️

### Added
- Added missing processing options.

### Changed
- New processing options format.
- Active Storage and Shrine extensions are enabled _automagially_.
- Active Storage and Shrine extensions options are moved to the config.
- The gem can be configured with environment variables or config files. Thanks to [anyway_config](https://github.com/palkan/anyway_config).
- Unsupported processing options can be used with some limitations.
- `hex_key` and `hex_salt` config options are renamed to `key` and `salt`. `key` and `salt` config options are renamed to `raw_key` and `raw_salt`.

## [1.1.0] - 2019-10-14
### Added
- Add crop options;
- Add adjustment options;
- Add `pixelate` option;
- Add `watermark_url` option.

## [1.0.6] - 2019-09-24
### Fixed
- Escape spaces in source URLs;
- Fix URL combination.

## [1.0.5] - 2019-09-04
### Fixed
- Fix non-ascii URLs support

## [1.0.4] - 2019-08-22
### Fixed
- Only set host to Shrine if it presents

## [1.0.3] - 2019-08-21
### Fixed
- Don't modify builder options

## [1.0.2] - 2019-04-08
### Added
- Add host option to Imgproxy.extend_shrine!

### Changed
- Check Active Storage attachment service instead of ::ActiveStorage::Blob.service
- Better URL combination

## [1.0.1] - 2019-04-03
### Fixed
- Fixed URL signing

## [1.0.0] - 2019-04-03
### Added
- First production-ready release
