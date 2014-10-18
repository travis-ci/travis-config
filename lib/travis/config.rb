require 'hashr'
require 'travis/config/docker'
require 'travis/config/env'
require 'travis/config/files'
require 'travis/config/heroku'

module Travis
  class Config < Hashr
    class << self
      include Helpers

      def load(*loaders)
        data = loaders.inject({}) do |data, name|
          const = const_get(camelize(name)).new
          other = deep_symbolize_keys(const.load)
          deep_merge(data, other)
        end
        new(data)
      end
    end
  end
end
