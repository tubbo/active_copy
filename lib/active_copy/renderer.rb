require 'redcarpet'
require 'pygments'

module ActiveCopy
  class Renderer < Redcarpet::Render::HTML
    def block_code(text, language)
      Pygments.highlight text, lexer: language
    end
  end
end
