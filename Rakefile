require 'bundler/setup'
require 'rdoc/task'
require 'rspec/core/rake_task'

Bundler::GemHelper.install_tasks

RSpec::Core::RakeTask.new :test

task :default => %w(test build)
