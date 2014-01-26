
# Methods for extracting the source of the Markdown document.

module ActiveCopy
  module Source
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
  end
end
