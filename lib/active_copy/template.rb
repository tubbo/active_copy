# The ActionView template handler that parses Markdown files into HTML
# using our custom Markdown handler. Also checks for YAML front matter
# and parses it out before rendering the Markdown source into HTML.
module ActiveCopy
  module Template
    def self.call template
      source = if template.respond_to? :split
        template.split("---\n")[2]
      else
        template.source.split("---\n")[2]
      end

      <<-RUBY
        markdown = ActiveCopy::Markdown.new
        markdown.render %(#{source})
      RUBY
    end
  end
end

