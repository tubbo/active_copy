require 'active_copy/attributes'
require 'active_copy/base'
require 'active_copy/markdown'
require 'active_copy/template'
require 'active_copy/utils'
require 'active_copy/view_helper'
require 'active_copy/version'

# ActiveCopy reads Markdown files in +app/documents+ instead of a
# database for your Rails models. Inspired by Jekyll, it uses compatible
# YAML front matter to set up the metadata for each page, then renders its
# content using +ActionView+. In production, +Rake+ tasks are provided to
# precompile the Markdown files to pure HTML for performance purposes.
module ActiveCopy
  VERSION = 'alpha1'

  def self.content_path
    @content_path = if ENV['RAILS_ENV'] == 'test'
      'spec/fixtures'
    else
      'app/views'
    end
  end
end
