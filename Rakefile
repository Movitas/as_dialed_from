# encoding: utf-8

require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "as_dialed_from"
  gem.homepage = "http://github.com/Movitas/as_dialed_from"
  gem.license = "Apache"
  gem.summary = "Figure out how a number should be dialed from another country"
  gem.description = "Figure out how a number should be dialed from another country. A fork of a port of Google's libphonenumber."
  gem.email = "jcampbell@movitas.com"
  gem.authors = ["Justin Campbell"]
  # dependencies defined in Gemfile
end
Jeweler::RubygemsDotOrgTasks.new

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

if RUBY_VERSION =~ /1.9/
  require 'simplecov'
  desc "Simplecov"
  Rake::TestTask.new do |t|
    t.name = 'simplecov'
    t.loader = :direct # uses require() which skips PWD in Ruby 1.9
    t.libs.push 'test', 'spec', Dir.pwd
    t.test_files = FileList['{test,spec}/**/*_{test,spec}.rb']

    t.ruby_opts.push '-r', 'simplecov', '-e', 'SimpleCov.start()'.inspect
  end
end

task :default => :test

Dir.glob('tasks/*.rake').each { |r| import r }
