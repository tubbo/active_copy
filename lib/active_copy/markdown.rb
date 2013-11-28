require 'redcarpet'
require 'active_copy/renderer'

# Compiles a Markdown file using the +Redcarpet+ template engine. Used
# by +ActionView+ in +config/initializers/markdown.rb+ to initiate
# Markdown template compilation for files that are not already
# precompiled.
module ActiveCopy
  class Markdown
    # Create a new session with the compiler.
    def initialize
      @renderer = ActiveCopy::Renderer.new
      @options = {
        autolink: true,
        no_intra_emphasis: true,
        fenced_code_blocks: true,
        lax_html_blocks: true,
        strikethrough: true,
        superscript: true
      }
    end

    # Return an HTML String containing the rendered output of the Markdown
    # source.
    def render markdown_source
      markdown.render "#{markdown_source}"
    end

  private
    def markdown
      @client ||= Redcarpet::Markdown.new @renderer, @options
    end
  end
end
