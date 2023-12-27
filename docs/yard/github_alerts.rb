# frozen_string_literal: true

require "uri"
require "yard"

module YARD
  # Add some formatting to the GitHub alert tags since they are not supported
  # by YARD
  module GithubAlerts
    def html_markup_markdown(text)
      super(text.gsub(/\[!(IMPORTANT|TIP|NOTE)\]/) { "**#{Regexp.last_match(1)}:**" })
    end
  end

  Templates::Template.extra_includes << GithubAlerts
end
