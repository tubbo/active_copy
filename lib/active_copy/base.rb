require 'active_model'
require 'active_copy/attributes'
require 'active_copy/finders'
require 'active_copy/paths'

# Base class for an +ActiveCopy+ model.
module ActiveCopy
  class Base
    include ActiveModel::Model,
            ActiveCopy::Attributes,
            ActiveCopy::Paths
    extend ActiveCopy::Finders

    attr_reader :attributes, :id, :collection_path

    # Instantiate using the filename as an ID, set the YAML front matter
    # to a Hash called +attributes+, and define a reader method for each 
    # attribute that has a corresponding key in the +attr_accessible+
    # definition for this model.
    def initialize with_filename=nil, options=nil
      @attributes = options || yaml_front_matter
      @id = if with_filename.blank?
        options[:filename]
      else
        with_filename
      end

      define_attributes_as_methods!
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

    ## NOTE: The following two methods are necessary for mocking

    alias new create
    def persisted?
      true
    end

  private
    def yaml_front_matter
      HashWithIndifferentAccess.new \
        YAML::load(raw_source.split("---\n")[1])
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

    def define_attributes_as_methods!
      accessible_attrs.each do |attribute|
        class_eval do
          define_method(attribute) { attributes[attribute] }
        end
      end
    end

    def accessible_attrs
      self._accessible_attributes
    end
  end
end
