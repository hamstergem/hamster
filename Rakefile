Dir[File.expand_path("tasks/**/*.rb")].each do |task_file|
  require task_file
end

task :default => [ :rspec ]
