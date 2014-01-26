module ActiveCopy
  module Paths
    # Return absolute path to public HTML file.
    def index_path
      "#{path}/index.html"
    end

    # Return absolute path to public cached copy.
    def path
      @public_path ||= if Rails.env.test?
                         "#{Rails.root}/tmp/site/#{relative_path}"
                       else
                         "#{Rails.root}/public/#{relative_path}"
                       end
    end

    # Return the collection_path in the instance.
    def collection_path
      self.class.collection_path
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
        File.join collection_path, "#{self.id}.md"
      else
        File.join root_path, collection_path, "#{self.id}.md"
      end
    end

    private
    def root_path
      return Rails.root if defined? Rails
      File.expand_path "../../", __FILE__
    end
  end
end
