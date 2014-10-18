require 'yaml'
require 'hashr'
require 'travis/config/helpers'

module Travis
  class Config < Hashr
    class Files
      include Helpers

      def load
        filenames.inject({}) do |config, filename|
          deep_merge(config, load_file(filename)[env] || {})
        end
      end

      private

        def env
          ENV['ENV'] || ENV['RAILS_ENV'] || ENV['RACK_ENV'] || 'development'
        end

        def load_file(filename)
          YAML.load_file(filename) || {} rescue {}
        end

        def filenames
          @filenames ||= Dir['config/{travis.yml,travis/*.yml}'].sort
        end
    end
  end
end
