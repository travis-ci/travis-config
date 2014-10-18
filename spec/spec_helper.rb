ENV['ENV'] = 'test'

require 'mocha'
require 'travis/config'

RSpec.configure do |config|
  config.mock_with :mocha
end
