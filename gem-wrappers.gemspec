#!/usr/bin/env ruby
# -*- encoding: utf-8 -*-

require File.expand_path("../lib/gem/wrappers/version.rb", __FILE__)

Gem::Specification.new do |s|
  s.name = "gem-wrappers"
  s.version = Gem::Wrappers::VERSION
  s.authors = ["Michal Papis"]
  s.email = ["mpapis@gmail.com"]
  s.homepage = "https://github.com/rvm/gem-wrappers"
  s.summary = "Create gem wrappers for easy use of gems in cron and other system locations."
  s.license = "Apache 2.0"
  s.files = `git ls-files`.split("\n")
  s.test_files = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.required_ruby_version = ">= 2.0.0"
  %w{rake minitest simplecov coveralls redcarpet}.each do |name|
    s.add_development_dependency(name)
  end
  # s.add_development_dependency("smf-gem")
end
