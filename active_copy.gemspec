$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "active_copy/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "active_copy"
  s.version     = ActiveCopy::VERSION
  s.authors     = ["Tom Scott"]
  s.email       = ["tubbo@psychedeli.ca"]
  s.homepage    = "http://github.com/tubbo/active_copy"
  s.summary     = "Use the Rails model layer as a backend for static files"
  s.description = s.summary

  s.files = `git ls-files`.split "\n"
  s.test_files = s.files.grep(/\Aspec/)

  s.add_dependency "rails"
  s.add_dependency 'pygments.rb', '~> 0.3'
  s.add_dependency 'redcarpet'

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "rspec"
  s.add_development_dependency "yard"
end
