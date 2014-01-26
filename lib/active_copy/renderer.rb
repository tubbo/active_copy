require 'redcarpet'

module ActiveCopy
  class Renderer < Redcarpet::Render::HTML
    def block_code(raw_code, language)
      code = "#{raw_code}".strip

      if defined? Pygments
        Rails.logger.info "Rendered highlighted #{language} code block"
        Pygments.highlight code, lexer: language
      else
        "<pre>#{code}</pre>"
      end
    end
  end
end
