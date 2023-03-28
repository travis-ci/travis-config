require 'travis/config/heroku/url'

module Travis
  class Config
    class Heroku
      class Database < Struct.new(:options)
        include Helpers

        VARIABLES = { application_name: ENV['DYNO'] || $PROGRAM_NAME, statement_timeout: 10_000 }.freeze
        DEFAULTS = { adapter: 'postgresql', encoding: 'unicode', variables: VARIABLES }.freeze

        def config
          config = compact(Url.parse(url).to_h)
          config = deep_merge(DEFAULTS, config) unless config.empty?
          config[:pool] = pool.to_i if pool
          config[:prepared_statements] = prepared_statements != 'false' if prepared_statements
          config
        end

        private

        def url
          env('DATABASE_URL').compact.first
        end

        def pool
          env('DATABASE_POOL_SIZE', 'DB_POOL').compact.first
        end

        def prepared_statements
          ENV['PGBOUNCER_PREPARED_STATEMENTS']
        end

        def env(*keys)
          ENV.values_at(*keys.map { |key| prefix(key) }.flatten)
        end

        def prefix(key)
          key = [options[:prefix], key].compact.join('_').upcase
          ["TRAVIS_#{key}", key]
        end

        def options
          super || {}
        end
      end
    end
  end
end
