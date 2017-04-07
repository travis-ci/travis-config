ENV['ENV']  = 'test'
ENV['DYNO'] = 'travis-config/specs'

require 'mocha'
require 'travis/config'
require 'support/env'
require 'support/fakefs'

module Travis::Test
  class Config < Travis::Config
    define amqp:     { username: 'guest', password: 'guest', host: 'localhost', prefetch: 1 },
           database: { adapter: 'postgresql', database: 'test', encoding: 'unicode' },
           redis:    { url: 'redis://localhost:6379' }

    Env.prefix :travis
  end
end

RSpec.configure do |c|
  c.mock_with :mocha
  c.include Support::Env
  c.include Support::FakeFs
end

