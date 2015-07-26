require 'yaml'
require 'hashr'
require 'travis/config/helpers'

module Travis
  class Config < Hashr
    class Files
      include Helpers

      def load
        filenames.inject({}) do |config, filename|
          deep_merge(config, load_file(filename)[Config.env] || {})
        end
      end

      private

        def load_file(filename)
          YAML.load_file(filename) || {} rescue {}
        end

        def filenames
          @filenames ||= Dir['config/{travis.yml,travis/*.yml}'].sort
        end
    end
  end
end
