require 'active_model'
require 'active_copy/attributes'
require 'active_copy/finders'
require 'active_copy/paths'

# Base class for an +ActiveCopy+ model.
module ActiveCopy
  class Base
    include ActiveModel::Model,
            ActiveModel::Callbacks,
            ActiveCopy::Attributes,
            ActiveCopy::Paths
    extend ActiveCopy::Finders

    attr_accessor :id

    # Take YAML front matter given by id.
    def attributes
      @attributes ||= yaml_front_matter.with_indifferent_access
    end

    # Test if the source file is present on this machine.
    def present?
      File.exists? source_path
    end

    # Return the raw String source of the Markdown document, including
    # the YAML front matter.
    def raw_source
      @raw ||= File.read source_path
    end

    # Return the String source of the Markdown document without the YAML
    # front matter. This is what is passed into ActionView to render the
    # Markdown from this file.
    def source
      @source ||= raw_source.split("---\n")[2]
    end

    def tags
      attributes[:tags].split(',').map(&:strip)
    end

    class << self
      # New and create are the same thing, here.
      alias create new
    end

    # Files are persisted when they are present on disk.
    alias persisted? present?

    def method_missing method, *arguments
      super method, *arguments unless attribute? "#{method}"
      attributes[method]
    end

    private
    def yaml_front_matter
      HashWithIndifferentAccess.new \
        YAML::load(raw_source.split("---\n")[1])
    end

    def attribute? key
      attributes.keys.include? key
    end

    def matches? query
      query.reduce(true) do |matches, (key, value)|
        matches = if key == 'tag'
          return false unless tags.present?
          tags.include? value
        else
          attributes[key] == value
        end
      end
    end
  end
end
