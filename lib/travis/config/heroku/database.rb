require 'travis/config/heroku/url'

module Travis
  class Config
    class Heroku
      class Database < Struct.new(:options)
        include Helpers

        DEFAULTS = { adapter: 'postgresql', encoding: 'unicode', application_name: ENV['DYNO'] || $0 }

        def config
          config = parse_url
          config = DEFAULTS.merge(config) unless config.empty?
          config[:pool] = pool.to_i if pool
          config
        end

        private

          def parse_url
            compact(Url.parse(url).to_h)
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

          def options
            super || {}
          end
      end
    end
  end
end
