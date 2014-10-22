require "benchmark/ips"
require "hamster/hash"

puts ""
puts "OS Name: #{`uname -a`}"
puts `sw_vers`
puts "Ruby Version: #{`ruby -v`}"
puts "RubyGems Version: #{`gem -v`}"
puts "RVM Version: #{`rvm -v`}"
puts ""

SMALL_HASH = { 1 => 2, 2 => 4, 3 => 6, 4 => 8 }
LARGE_HASH = (1..10_000).inject({}) do |hash, i|
  hash.merge(i => i * 2)
end

Benchmark.ips do |analysis|
  analysis.time = 5
  analysis.warmup = 2

  analysis.report("Hamster::Hash#each with small data") do
    Hamster::Hash.new(SMALL_HASH.dup).each do |k, v|
      k + v
    end
  end

  analysis.report("Hamster::Hash#each with large data") do
    Hamster::Hash.new(LARGE_HASH.dup).each do |k, v|
      k + v
    end
  end
end
