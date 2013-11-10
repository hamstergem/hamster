# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "hamster/version"

  s.version          = Hamster::VERSION.dup
  s.extra_rdoc_files = ["README.rdoc", "History.rdoc", "LICENSE"]
  s.homepage         = "http://github.com/harukizaemon/hamster"
  s.files            = Dir["lib/**/*", "spec/**/*", "tasks/**/*", "Rakefile"] + s.extra_rdoc_files
  s.add_development_dependency("rspec", "~> 2")
  s.add_development_dependency("simplecov", "~> 0.3")
Gem::Specification.new do |spec|
  spec.name          = "hamster"
  spec.authors       = ["Simon Harris"]
  spec.email         = ["haruki_zaemon@mac.com"]
  spec.summary       = %q{Efficient, immutable, thread-safe collection classes for Ruby}
  spec.description   = spec.summary
  spec.platform      = Gem::Platform::RUBY
  spec.required_ruby_version = ">= 1.8.7"
  spec.require_paths = ["lib"]
end
