require 'travis/config/helpers'
require 'travis/config/heroku/database'

module Travis
  class Config
    class Heroku
      include Helpers

      # TODO add rabbitmq, redis, memcached addons etc
      def load
        compact(database: database, logs_database: logs_database)
      end

      private

        def database
          Database.new.config
        end

        def logs_database
          Database.new(prefix: 'logs').config
        end
    end
  end
end
