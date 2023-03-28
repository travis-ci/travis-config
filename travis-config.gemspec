$LOAD_PATH.unshift File.expand_path('lib', __dir__)
require 'travis/config/version'

Gem::Specification.new do |s|
  s.platform              = Gem::Platform::RUBY
  s.name                  = 'travis-config'
  s.version               = TravisConfig::VERSION
  s.summary               = 'Travis CI config'
  s.description           = "#{s.summary}."

  s.authors               = ['Travis CI']
  s.email                 = 'contact@travis-ci.org'
  s.homepage              = 'https://github.com/travis-ci/travis-config'

  s.license               = 'MIT'

  s.files                 = Dir['lib/**/*', 'LICENSE']
  s.require_path          = 'lib'

  s.required_ruby_version = '>= 3.0', '< 3.3'

  s.add_runtime_dependency 'hashr', '~> 2.0'
end
