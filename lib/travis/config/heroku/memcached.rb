module Travis
  class Config
    class Heroku
      class Memcached
        include Helpers

        def config
          compact(servers: servers, options: options)
        end

        private

        def servers
          ENV['MEMCACHED_SERVERS']
        end

        def options
          { username: username, password: password }
        end

        def username
          ENV['MEMCACHED_USERNAME']
        end

        def password
          ENV['MEMCACHED_PASSWORD']
        end
      end
    end
  end
end
