require 'uri'

module Travis
  class Config
    class Heroku
      module Url
        Base     = Struct.new(:username, :password, :host, :port, :database)
        Postgres = Class.new(Base)
        Redis    = Class.new(Base)

        class Amqp < Base
          alias :vhost :database

          def to_h
            super.reject { |key, value| key == :database }.merge(vhost: vhost)
          end
        end

        class << self
          def parse(url)
            return {} if url.nil? || url.empty?
            uri   = URI.parse(url)
            const = const_get(camelize(uri.scheme))
            const.new(uri.user, uri.password, uri.host, uri.port, uri.path[1..-1])
          end

          def camelize(string)
            string.to_s.split('_').collect(&:capitalize).join
          end
        end
      end
    end
  end
end
