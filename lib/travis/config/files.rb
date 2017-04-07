require 'yaml'
require 'travis/config/helpers'

module Travis
  class Config
    class Files < Struct.new(:defaults)
      include Helpers

      def load
        filenames.inject({}) do |config, filename|
          file_config = load_file(filename)
          if Config.env != "production" and file_config[Config.env].nil?
            puts "Warning: config in #{filename} has no data for current env #{Config.env}"
            puts "If you are expecting config to be loaded from this file, please make sure"
            puts "your config is indented under a key of the environment (#{Config.env})"
          end
          deep_merge(config, file_config[Config.env] || {})
        end
      end

      private

        def load_file(filename)
          YAML.load_file(filename) || {}
        rescue => e
          puts "Could not parse file #{filename} (#{e.message})"
          {}
        end

        def filenames
          @filenames ||= Dir['config/{travis.yml,travis/*.yml}'].sort
        end
    end
  end
end
