# Common spec-related code goes here

require 'simplecov'
SimpleCov.start
SimpleCov.at_exit do
  SimpleCov.result.format!
  open("#{SimpleCov.coverage_dir}/covered_percent", "w") do |f|
    f.puts SimpleCov.result.covered_percent.to_s
  end
end

STACK_OVERFLOW_DEPTH = if RUBY_ENGINE == "ruby"
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
