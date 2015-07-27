require 'hashr'
require 'travis/config/docker'
require 'travis/config/env'
require 'travis/config/files'
require 'travis/config/heroku'

# patch Hashr to merge with existing definitions and defaults
class Hashr < Hash
  class << self
    def define(definition)
      definition = self.definition.merge(definition.deep_symbolize_keys)
      @definition = deep_accessorize(definition)
    end

    def default(defaults)
      defaults = self.defaults.merge(defaults)
      @defaults = deep_accessorize(defaults)
    end
  end
end

module Travis
  class Config < Hashr
    class << self
      include Helpers

      def env
        @env ||= ENV['ENV'] || ENV['RAILS_ENV'] || ENV['RACK_ENV'] || 'development'
      end

      def load(*loaders)
        loaders = [:files, :env, :heroku, :docker] if loaders.empty?

        data = loaders.inject({}) do |data, name|
          const = const_get(camelize(name)).new
          other = deep_symbolize_keys(const.load)
          deep_merge(data, other)
        end

        new(data)
      end
    end

    def env
      self.class.env
    end
  end
end
