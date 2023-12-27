# frozen_string_literal: true

require "yard"

module YARD
  # Fixes relative links in markdown files.
  module RelativeMarkdownLinks
    def resolve_links(text)
      return super unless options.files

      filenames = options.files.each_with_object({}) do |file, fns|
        fn = file.filename
        fns[fn] = fn
        fns["#{fn.tr(".", "_")}.html"] = fn
      end

      # puts text

      super(text.gsub(%r{<a href="([^"]+)"[^>]*>([^<]*)</a>}) do |str|
        href = Regexp.last_match(1)
        link_text = Regexp.last_match(2)

        next str unless filenames.key?(href)

        "{file:#{filenames[href]} #{link_text}}"
      end)
    end
  end

  Templates::Template.extra_includes << RelativeMarkdownLinks
end
