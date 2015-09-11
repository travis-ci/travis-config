ENV['ENV'] = 'test'

require 'mocha'
require 'travis/config'

module Travis::Test
  class Config < Travis::Config
    define amqp: { username: 'guest', password: 'guest', host: 'localhost', prefetch: 1 }
    define database: { adapter: 'postgresql', database: 'test', encoding: 'unicode' }
  end
end

RSpec.configure do |config|
  config.mock_with :mocha
end
