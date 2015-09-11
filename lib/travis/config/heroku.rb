require 'hashr'
require 'travis/config/helpers'

module Travis
  class Config < Hashr
    class Heroku
      include Helpers

      DATABASE_URL = %r((?:.+?)://(?<username>.+):(?<password>.+)@(?<host>[^:]+):?(?<port>.*)/(?<database>.+))

      def load
        compact(database: database, logs_database: logs_database)
      end

      private

        def database
          config = parse_database_url(database_url)
          config = config.merge(pool: pool_size.to_i) if pool_size
          config
        end

        def logs_database
          config = parse_database_url(logs_database_url)
          config = config.merge(pool: logs_pool_size.to_i) if logs_pool_size
          config.merge(adapter: 'postgresql', encoding: 'unicode') unless config.empty?
        end

        def parse_database_url(url)
          matches = DATABASE_URL.match(url.to_s)
          matches ? compact(Hash[matches.names.zip(matches.captures)]) : {}
        end

        def pool_size
          ENV.values_at('DB_POOL', 'DATABASE_POOL_SIZE').compact.first
        end

        def logs_pool_size
          ENV.values_at('LOGS_DB_POOL', 'LOGS_DATABASE_POOL_SIZE').compact.first
        end

        def database_url
          ENV.values_at('DATABASE_URL', 'SHARED_DATABASE_URL').compact.first
        end

        def logs_database_url
          ENV.values_at('LOGS_DATABASE_URL', 'SHARED_LOGS_DATABASE_URL').compact.first
        end
    end
  end
end
