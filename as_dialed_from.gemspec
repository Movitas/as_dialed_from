# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "as_dialed_from/version"

Gem::Specification.new do |s|
  s.name        = "as_dialed_from"
  s.version     = AsDialedFrom::VERSION
  s.authors     = ["Justin Campbell"]
  s.email       = ["jcampbell@justincampbell.me"]
  s.homepage    = "http://github.com/Movitas/as_dialed_from"
  s.summary     = %q{Figure out how a number should be dialed from another country}
  s.description = %q{Figure out how a number should be dialed from another country. A fork of a port of Google's libphonenumber.}

  s.rubyforge_project = "as_dialed_from"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- test/*`.split("\n")
  s.require_paths = ["lib"]

  s.add_development_dependency 'guard-test'
  s.add_development_dependency 'shoulda'
  s.add_development_dependency 'test-unit'
  s.add_development_dependency 'xml-simple'

  if RUBY_VERSION =~ /1.9/
    s.add_development_dependency 'simplecov'
  end

  if RUBY_PLATFORM =~ /darwin/
    s.add_development_dependency 'growl'
    s.add_development_dependency 'rb-fsevent'
  end
end
