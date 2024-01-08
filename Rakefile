require 'bundler/gem_tasks'
require 'bundler/setup'
require 'rubocop/rake_task'
require 'rspec/core/rake_task'

RuboCop::RakeTask.new(:rubocop) do |task|
  task.patterns = %w[lib/**/*.rb]
end

RSpec::Core::RakeTask.new(:spec)

task default: :spec
