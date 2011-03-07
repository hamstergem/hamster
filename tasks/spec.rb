require 'rspec/core/rake_task'

desc "Run specifications"
RSpec::Core::RakeTask.new(:spec)

# task :spec do
#   covered_threshold = 100
#   covered_percent = Float(File.read("coverage/covered_percent"))
#   if covered_percent < covered_threshold
#     $stderr.puts ""
#     raise "Insufficient unit-test coverage (#{covered_percent} < #{covered_threshold})"
#   end
# end
