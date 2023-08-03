require 'yaml'
require 'travis/config/helpers'

module Travis
  class Config
    class Files < Struct.new(:defaults)
      include Helpers

      MSGS = {
        empty: <<-MSG.split("\n").map(&:strip).join("\n")
          Warning: config in %{filename} has no data for current env %{env}.
          If you are expecting config to be loaded from this file, please make sure
          your config is indented under a key of the environment (%{env}).
        MSG
      }.freeze

      def load
        filenames.inject({}) do |result, filename|
          config = load_file(filename)
          warn_empty(filename) if warn_empty? && config[env].nil?
          deep_merge(result, config[env] || {})
        end
      end

      private

      def load_file(filename)
        YAML.load_file(filename, aliases: true) || {}
      rescue => e
        puts "Could not parse file #{filename} (#{e.message})"
        {}
      end

      def warn_empty(filename)
        puts MSGS[:empty] % { filename: filename, env: env }
      end

      def warn_empty?
        !%w[production test].include?(Config.env)
      end

      def filenames
        @filenames ||= Dir['config/travis.yml'] + Dir['config/travis/*.yml']
      end

      def env
        Config.env
      end
    end
  end
end
