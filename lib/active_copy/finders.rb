
# Methods for finding records on the filesystem.

module ActiveCopy
  module Finders
    # Return the folder where all documents are stored for this model.
    def collection_path
      @collection_path ||= "#{ActiveCopy.content_path}/#{name.tableize}/content"
    end

    # Find this model by its filename.
    def find by_filename
      if File.exists? "#{Rails.root}/#{collection_path}/#{by_filename}.md"
        new by_filename
      else
        nil
      end
    end

    # Read all files from the +collection_path+, then instantiate them
    # as members of this model. Return as an +Array+.
    def all
      Dir["#{absolute_collection_path}/*.md"].reduce([]) do |articles, md_path|
        unless md_path == "#{Rails.root}/#{collection_path}"
          file_name = File.basename(md_path).gsub('.md', '')
          articles << self.new(file_name)
        end
      end
    end


    # Look for all of the matching key/value pairs in the YAML front
    # matter, and return an array of models that match them.
    def where query={}
      all.reject { |a| a.nil? }.reduce([]) do |results, article|
        results << article if article.matches? query
        results
      end
    end

    private
    def absolute_collection_path
      "#{Rails.root}/#{collection_path}"
    end
  end
end
