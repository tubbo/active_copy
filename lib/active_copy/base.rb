require 'active_model'
require 'active_copy/attributes'
require 'active_copy/finders'
require 'active_copy/paths'
require 'active_copy/source'

# Base class for an +ActiveCopy+ model.

module ActiveCopy
  class Base
    include ActiveModel::Model
    include Attributes, Finders, Paths, Source

    attr_accessor :id

    # Serialize comma-separated tags to an array.
    def tags
      attributes[:tags].split(',').map(&:strip)
    end

    class << self
      # New and create are the same thing.
      alias create new
    end

    # Files are persisted when they are present on disk.
    alias persisted? present?

    def method_missing method, *arguments
      super method, *arguments unless attribute? "#{method}"
      attributes[method]
    end
  end
end
