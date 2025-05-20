# frozen_string_literal: true

require "uri"
require "yard"

module YARD
  # Replaces <picture> tags with <img> and relative src with absolute ones
  module ReplacePicture
    def html_markup_markdown(text)
      new_text = text.gsub(%r{<picture>.*(<img [^>]*>).*</picture>}m) do
        Regexp.last_match(1)
      end

      new_text = new_text.gsub(/<img [^>]*src="(([^>?]+)(\?[^>]*)?)"[^>]*>/m) do |str|
        src = Regexp.last_match(1)
        next str unless URI.parse(src).relative?
        str.gsub(src, url_for_file(Regexp.last_match(2)))
      end

      super(new_text)
    end
  end

  Templates::Template.extra_includes << ReplacePicture
end
