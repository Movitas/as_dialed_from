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

if defined? RUBY_ENGINE and RUBY_ENGINE == "ruby"
  require 'rcov/rcovtask'
  Rcov::RcovTask.new do |test|
    test.libs << 'test'
    test.pattern = 'test/**/test_*.rb'
    test.verbose = true
    test.rcov_opts << '--exclude "gems/*"'
  end
end

task :default => :test

Dir.glob('tasks/*.rake').each { |r| import r }
