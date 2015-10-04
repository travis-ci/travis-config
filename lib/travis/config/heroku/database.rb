module Travis
  class Config
    class Heroku
      class Database
        include Helpers

        URL = %r((?:.+?)://(?<username>.+):(?<password>.+)@(?<host>[^:]+):?(?<port>.*)/(?<database>.+))
        DEFAULTS = { adapter: 'postgresql', encoding: 'unicode' }

        attr_reader :options

        def initialize(options = {})
          @options = options
        end

        def config
          parse_url.tap do |config|
            config[:pool] = pool.to_i if pool
          end
        end

        def parse_url
          matches = URL.match(url.to_s)
          matches ? compact(Hash[matches.names.zip(matches.captures)]).merge(DEFAULTS) : {}
        end

        def pool
          env('DB_POOL', 'DATABASE_POOL_SIZE').compact.first
        end

        def url
          env('DATABASE_URL').compact.first
        end

        def env(*keys)
          ENV.values_at(*keys.map { |key| prefix(key) })
        end

        def prefix(key)
          [options[:prefix], key].compact.join('_').upcase
        end
      end
    end
  end
end
