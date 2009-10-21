require "spec/rake/spectask"

desc "Run specifications"
Spec::Rake::SpecTask.new(:spec) do |t|
  t.spec_opts << "--options" << "spec/spec.opts" if File.exists?("spec/spec.opts")
end
