require 'active_model'
require 'active_copy/attributes'

# Base class for an +ActiveCopy+ model.
module ActiveCopy
  class Base
    include ActiveModel::Model
    include ActiveCopy::Attributes

    attr_reader :attributes, :id, :collection_path

    # Instantiate using the filename as an ID, set the YAML front matter
    # to a Hash called +attributes+, and define a reader method for each 
    # attribute that has a corresponding key in the +attr_accessible+
    # definition for this model.
    def initialize with_filename="", options={}
      @id = if with_filename.blank?
              options[:filename]
            else
              with_filename
            end

      @attributes = if options.empty?
                      yaml_front_matter
                    else
                      options
                    end

      self._accessible_attributes.each do |attribute|
        class_eval do
          define_method(attribute) { @attributes[attribute] }
        end
      end
    end

    # Return absolute path to public HTML file.
    def index_path
      "#{path}/index.html"
    end

    def persisted?
      true
    end

    # Return absolute path to public cached copy.
    def path
      @public_path ||= if Rails.env.test?
                         "#{Rails.root}/tmp/site/#{relative_path}"
                       else
                         "#{Rails.root}/public/#{relative_path}"
                       end
    end

    # Return relative path with the Rails.root/public part out.
    def relative_path
      @rel_path ||= begin 
        date_array = id.split("-")[0..2]
        date_path = date_array.join("/")
        article_id = begin
          str = id.gsub date_array.join("-"), ''
          if str[0] == "-"
            str[1..-1] 
          else
            str
          end
        end
        "#{category}/#{date_path}/#{article_id}"
      end
    end

    # Return absolute path to Markdown file on this machine.
    def source_path options={}
      @source_path ||= if options[:relative]
                         File.join collection_path, "#{id}.md"
                       else
                         File.join Rails.root, collection_path, "#{id}.md"
                       end
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

    # Return the folder where all documents are stored for this model.
    def self.collection_path
      @collection_path ||= "#{ActiveCopy.content_path}/#{self.name.tableize}/content"
    end

    # Return the collection_path in the instance.
    def collection_path
      self.class.collection_path
    end

    # Find this model by its filename.
    def self.find by_filename
      if File.exists? "#{Rails.root}/#{collection_path}/#{by_filename}.md"
        new by_filename
      else
        nil
      end
    end

    # Read all files from the +collection_path+, then instantiate them
    # as members of this model. Return as an +Array+.
    def self.all
      Dir["#{absolute_collection_path}/*.md"].reduce([]) do |articles, md_path|
        unless md_path == "#{Rails.root}/#{collection_path}"
          file_name = File.basename(md_path).gsub('.md', '')
          articles << self.new(file_name)
        end
      end
    end

    def self.absolute_collection_path
      "#{Rails.root}/#{collection_path}"
    end

    # Look for all of the matching key/value pairs in the YAML front
    # matter, and return an array of models that match them.
    def self.where query={}
      all.reject { |a| a.nil? }.reduce([]) do |results, article|
        results << article if article.matches? query
        results
      end
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

    def tags
      attributes[:tags].split(',').map(&:strip)
    end

    # Create a mock model instance. Useful with FactoryGirl.
    def self.create
    end

  private
    def yaml_front_matter
      HashWithIndifferentAccess.new \
        YAML::load(raw_source.split("---\n")[1])
    end
  end
end
