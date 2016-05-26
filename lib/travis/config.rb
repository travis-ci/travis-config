require 'hashr'

module Travis
  class Config < Hashr
    require 'travis/config/docker'
    require 'travis/config/env'
    require 'travis/config/files'
    require 'travis/config/heroku'

    include Hashr::Delegate::Conditional

    class << self
      include Helpers

      def env
        @env ||= ENV['ENV'] || ENV['RAILS_ENV'] || ENV['RACK_ENV'] || 'development'
      end

      def load(*names)
        config = load_from(*names)
        config = normalize(config)
        new(config)
      end

      private

        def load_from(*names)
          loaders(*names).inject({}) do |data, loader|
            deep_merge(data, deep_symbolize_keys(loader.load))
          end
        end

        def loaders(*names)
          names = [:files, :env, :heroku, :docker] if names.empty?
          names.map { |name| const_get(camelize(name)).new }
        end

        def normalize(config)
          config[:logs_database] = config[:database] if blank?(config[:logs_database])
          config
        end
    end

    def env
      self.class.env
    end
  end
end
