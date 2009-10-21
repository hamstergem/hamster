require 'rubygems'

# Support running specs with "rake spec" and "spec"
lib = File.expand_path(File.dirname(__FILE__) + '/../lib')
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'hamster'
