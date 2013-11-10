# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "hamster/version"

  s.extra_rdoc_files = ["README.rdoc", "History.rdoc", "LICENSE"]
  s.add_development_dependency("rspec", "~> 2")
  s.add_development_dependency("simplecov", "~> 0.3")
Gem::Specification.new do |spec|
  spec.name          = "hamster"
  spec.version       = Hamster::VERSION
  spec.authors       = ["Simon Harris"]
  spec.email         = ["haruki_zaemon@mac.com"]
  spec.summary       = %q{Efficient, immutable, thread-safe collection classes for Ruby}
  spec.description   = spec.summary
  spec.homepage      = "http://harukizaemon.github.io/hamster"
  spec.platform      = Gem::Platform::RUBY
  spec.required_ruby_version = ">= 1.8.7"

  spec.files         = Dir["lib/**/*"]
  spec.executables   = Dir["bin/**/*"].map! { |f| f.gsub(/bin\//, '') }
  spec.test_files    = Dir["test/**/*", "spec/**/*"]
  spec.require_paths = ["lib"]
end
