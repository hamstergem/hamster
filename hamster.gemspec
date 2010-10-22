require 'lib/hamster/version'

Gem::Specification.new do |s|
  s.name             = "hamster"
  s.version          = Hamster::VERSION.dup
  s.platform         = Gem::Platform::RUBY
  s.required_ruby_version = ">= 1.8.7"
  s.has_rdoc         = true
  s.extra_rdoc_files = ["README.rdoc", "History.rdoc", "LICENSE"]
  s.summary          = "Efficient, Immutable, Thread-Safe Collection classes for Ruby"
  s.description      = s.summary
  s.author           = "Simon Harris"
  s.email            = "haruki_zaemon@mac.com"
  s.homepage         = "http://github.com/harukizaemon/hamster"
  s.require_path     = "lib"
  s.files            = Dir["lib/**/*", "spec/**/*", "tasks/**/*", "Rakefile"] + s.extra_rdoc_files
  s.add_development_dependency("rspec", ">= 2.0.0")
  s.add_development_dependency("diff-lcs", ">= 1.1.2")
end
