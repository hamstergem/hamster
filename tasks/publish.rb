desc "Build and publish the latest gem"
task :publish do
  require File.expand_path('../../lib/hamster/version', __FILE__)

  gem_name = "hamster-#{Hamster::VERSION}.gem"

  sh <<-CMD
gem build hamster.gemspec &&
gem push #{gem_name} &&
rm #{gem_name}
CMD
end
