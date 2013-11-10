#!/usr/bin/env rake
require "bundler/gem_tasks"
require "rspec/core/rake_task"
require "yard"

RSpec::Core::RakeTask.new(:spec)

desc "Generate all of the docs"
YARD::Rake::YardocTask.new do |config|
  config.files = Dir["lib/**/*.rb"]
end

desc "Default: run tests and generate docs"
task default: [ :spec, :yard ]
