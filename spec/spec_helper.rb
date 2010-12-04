# Common spec-related code goes here

# This must be in the very beginning
if ENV['SimpleCov']
  require 'simplecov'
  SimpleCov.start
end

STACK_OVERFLOW_DEPTH = if RUBY_VERSION =~ /^(ruby |\d+\.\d+\.\d+$)/
  def calculate_stack_overflow_depth(n)
    calculate_stack_overflow_depth(n + 1)
  rescue SystemStackError
    n
  end
  calculate_stack_overflow_depth(2)
else
  16384
end

class DeterministicHash

  def initialize(value, hash)
    @value = value
    @hash = hash
  end

  def to_s
    @value.to_s
  end

  def inspect
    @value.inspect
  end

  def hash
    @hash
  end

end
