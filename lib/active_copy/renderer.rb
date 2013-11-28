require 'pygments'
require 'redcarpet'

module ActiveCopy
  class Renderer < Redcarpet::Render::HTML
    def block_code(raw_code, language)
      code = "\n#{raw_code.strip}"
      #Rails.logger.info "Rendered highlighted #{language} code block"
      #Pygments.highlight code, lexer: language
      "<pre>#{code}\n</pre>"
    end
  end
end
