# encoding: utf-8

require 'bundler/gem_tasks'

Dir.glob('tasks/*.rake').each { |r| import r }

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/*_test.rb'
end

if RUBY_VERSION =~ /1.9/
  require 'simplecov'
  desc "Simplecov"
  Rake::TestTask.new do |t|
    t.name = 'simplecov'
    t.loader = :direct
    t.libs.push 'test', 'spec', Dir.pwd
    t.test_files = FileList['test/**/*_test.rb']

    t.ruby_opts.push '-r', 'simplecov', '-e', 'SimpleCov.start()'.inspect
  end
end

task :default => :test
