class CopyGenerator < ::Rails::Generators::NamedBase
  source_root File.expand_path("../templates", __FILE__)
  desc "Creates a new ActiveCopy model"

  def model_class
    template "app/models/#{file_name}.rb", 'model.rb.erb'
  end

  def test_file
    template "spec/models/#{file_name}_spec.rb", 'test.rb.erb'
  end

  def model_generator
    template "#{generator_dir}/#{file_name}_generator.rb", 'generator.rb.erb'
    template "#{generator_dir}/templates/#{file_name}.rb.erb", 'view.md.erb'
  end

  private
  def file_name
    human_name.parameterize
  end

  def table_name
    human_name.tableize
  end

  def generator_dir
    "lib/generators/#{file_name}"
  end
end
