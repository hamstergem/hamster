require 'rspec/core/rake_task'

if RUBY_VERSION=~/^1\.9\./
  desc "Generate coverage report using SimpleCov"
  task :simplecov do
    ENV['SimpleCov']='1'
    Rake::Task['rspec'].invoke
  end
end
