require 'travis/config/helpers'
module Travis
  class Config
    class Heroku < Struct.new(:defaults)
      require 'travis/config/heroku/database'
      require 'travis/config/heroku/memcached'

      include Helpers

      def load
        compact(
          database: database,
          logs_database: logs_database,
          logs_readonly_database: logs_readonly_database,
          amqp: amqp,
          redis: redis,
          memcached: memcached,
          sentry: sentry
        )
      end

      private

        def database
          Database.new.config
        end

        def logs_database
          Database.new(prefix: 'logs').config
        end

        def logs_readonly_database
          Database.new(prefix: 'logs_readonly').config
        end

        def amqp
          compact(Url.parse(amqp_url).to_h)
        end

        def redis
          compact(url: redis_url, pool: { size: redis_pool_size })
        end

        def sentry
          compact(dsn: sentry_dsn)
        end

        def memcached
          Memcached.new.config
        end

        def amqp_url
          # rabbitmq-bigwig add-ons can only be attached as RABBITMQ_BIGWIG
          ENV['TRAVIS_RABBITMQ_URL'] || ENV['RABBITMQ_URL'] || ENV['RABBITMQ_BIGWIG_URL']
        end

        def redis_url
          ENV['TRAVIS_REDIS_URL'] || ENV['REDIS_URL']
        end
      
      def redis_pool_size
          ENV['TRAVIS_REDIS_POOL_SIZE'] || ENV['REDIS_POOL_SIZE']
        end

        def sentry_dsn
          ENV['TRAVIS_SENTRY_DSN'] || ENV['SENTRY_DSN']
        end
    end
  end
end
