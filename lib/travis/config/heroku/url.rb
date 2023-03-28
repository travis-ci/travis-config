require 'uri'

module Travis
  class Config
    class Heroku
      module Url
        class Base < Struct.new(:username, :password, :host, :port, :database)
          def to_h
            each_pair.to_a.to_h
          end
        end

        Generic = Class.new(Base)
        Postgres = Class.new(Base)
        Redis = Class.new(Base)
        Mock = Class.new(Base) # e.g. mock:// used for Sequel::Mock

        class Amqp < Base
          alias vhost database

          def to_h
            super.reject { |key, _value| key == :database }.merge(vhost: vhost)
          end
        end

        # The amqps:// protocol needs to also pass along that it has SSL enabled
        # for adapters such as march_hare
        class Amqps < Amqp
          def ssl
            true
          end

          def to_h
            super.merge(ssl: ssl)
          end
        end

        class << self
          def parse(url)
            return Generic.new if url.nil? || url.empty?

            uri = URI.parse(url)
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
