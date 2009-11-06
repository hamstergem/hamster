require 'lib/hamster/version'

Gem::Specification.new do |s|
  s.name             = "hamster"
  s.version          = Hamster::VERSION
  s.platform         = Gem::Platform::RUBY
  s.has_rdoc         = true
  s.extra_rdoc_files = ["README.rdoc", "History.rdoc", "TODO", "LICENSE"]
  s.summary          = "Persistent Data Structures for Ruby"
  s.description      = s.summary
  s.author           = "Simon Harris"
  s.email            = "haruki.zaemon@gmail.com"
  s.homepage         = "http://github.com/harukizaemon/hamster"
  s.require_path     = "lib"
  s.files            = Dir["lib/**/*", "spec/**/*", "tasks/**/*", "Rakefile"] + s.extra_rdoc_files
end
