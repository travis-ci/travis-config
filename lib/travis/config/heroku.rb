require 'travis/config/helpers'
require 'travis/config/heroku/database'
require 'travis/config/heroku/memcached'

module Travis
  class Config
    class Heroku
      include Helpers

      def load
        compact(
          database: database,
          logs_database: logs_database,
          amqp: amqp,
          redis: redis,
          memcached: memcached
        )
      end

      private

        def database
          Database.new.config
        end

        def logs_database
          Database.new(prefix: 'logs').config
        end

        def amqp
          compact(Url.parse(ENV['RABBITMQ_URL']).to_h)
        end

        def redis
          compact(url: ENV['REDIS_URL'])
        end

        def memcached
          Memcached.new.config
        end
    end
  end
end
