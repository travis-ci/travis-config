# encoding: utf-8

$:.unshift File.expand_path('../lib', __FILE__)
require 'travis/config/version'

Gem::Specification.new do |s|
  s.name         = "travis-config"
  s.version      = Travis::Config::VERSION
  s.authors      = ["Travis CI"]
  s.email        = "contact@travis-ci.org"
  s.homepage     = "https://github.com/travis-ci/travis-core"
  s.summary      = "Travis CI config"
  s.description  = "#{s.summary}."
  s.license      = "MIT"

  s.files        = Dir['{lib/**/*,spec/**/*,[A-Z]*}']
  s.platform     = Gem::Platform::RUBY
  s.require_path = 'lib'
  s.rubyforge_project = '[none]'

  s.add_dependency 'hashr', '~> 0.0'
end
