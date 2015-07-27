require 'hashr'
require 'travis/config/helpers'

module Travis
  class Config < Hashr
    class Heroku
      include Helpers

      DATABASE_URL = %r((?:.+?)://(?<username>.+):(?<password>.+)@(?<host>[^:]+):?(?<port>.*)/(?<database>.+))

      def load
        { database: database }
      end

      private

        def database
          config = parse_database_url(database_url)
          config = config.merge(pool: pool_size.to_i) if pool_size
          config
        end

        def parse_database_url(url)
          matches = DATABASE_URL.match(url.to_s)
          matches ? compact(Hash[matches.names.zip(matches.captures)]) : {}
        end

        def pool_size
          ENV.values_at('DB_POOL', 'DATABASE_POOL_SIZE').first
        end

        def database_url
          ENV.values_at('DATABASE_URL', 'SHARED_DATABASE_URL').first
        end
    end
  end
end
