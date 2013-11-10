#!/usr/bin/env rake
require "bundler/gem_tasks"
require "rspec/core/rake_task"
require "yard"
require "pathname"

HAMSTER_ROOT = Pathname.new(__FILE__).join('../..')
BENCH_ROOT   = HAMSTER_ROOT.join('bench')


RSpec::Core::RakeTask.new(:spec)

desc "Generate all of the docs"
YARD::Rake::YardocTask.new do |config|
  config.files = Dir["lib/**/*.rb"]
end

desc "Default: run tests and generate docs"
task default: [ :spec, :yard ]


def bench_task_name(file_name)
  file_name.relative_path_from(HAMSTER_ROOT).sub(/\_bench.rb$/, '').to_s.tr('/', ':')
end

bench_suites = Dir[HAMSTER_ROOT.join('bench/*')].map(&method(:Pathname)).select(&:directory?)

bench_suites.each do |bench_suite|
  bench_files = Dir[File.join(bench_suite, '/**/*.rb')].map(&method(:Pathname))

  bench_files.each do |bench_file|
    name = bench_task_name(bench_file)

    desc "Benchmark #{name}"
    task name do
      begin
        $LOAD_PATH.unshift HAMSTER_ROOT.join('lib')
        load bench_file
      rescue LoadError => e
        if e.path == 'benchmark/ips'
          STDERR.puts "Please install the benchmark-ips gem"
        else
          STDERR.puts e
        end
      end
    end
  end

  desc "Benchmark #{bench_task_name(bench_suite)}"
  task bench_task_name(bench_suite) => bench_files.map(&method(:bench_task_name))
end

desc "Run all benchmarks"
task bench: bench_suites.map(&method(:bench_task_name))
