module Travis
  class Config
    class Env < Struct.new(:defaults)
      class UnexpectedString < ArgumentError
        MSG = 'Expected %s to be an array of hashes, but it is a string: %s'

        def initialize(*args)
          super(MSG % args)
        end
      end

      class Vars < Struct.new(:defaults, :prefix)
        TRUE  = /^(true|yes|on)$/
        FALSE = /^(false|no|off)$/

        def to_h
          hash(ENV, prefix.dup, defaults)
        end

        private

          def hash(env, prefix, defaults)
            hash = defaults.inject({}) do |config, (key, default)|
              config.merge key => obj(env, prefix + [key], default)
            end
            compact(hash)
          end

          def obj(env, keys, default)
            case default
            when Hash
              hash(env, keys, default)
            when Array
              vars = array(env, keys, default)
              vars.any? ? vars : var(env, keys, default)
            else
              var(env, keys, default)
            end
          end

          def array(env, keys, defaults)
            vars(env, keys, defaults).map.with_index do |var, ix|
              obj(var, [], defaults[ix] || defaults[0] || {})
            end
          end

          def var(env, key, default)
            key = key.map(&:upcase).join('_')
            value = env[key]
            raise UnexpectedString.new(key, value) if value.is_a?(String) && hashes?(default)
            default.is_a?(Array) ? split(value) : cast(value, default)
          end

          def vars(env, keys, default)
            pattern = /^#{keys.map(&:upcase).join('_')}_([\d]+)_?/
            vars = env.select { |key, _| key =~ pattern }
            vars = vars.map { |key, value| [key.sub(pattern, ''), value, $1] }
            vars.group_by(&:pop).values.map(&:to_h)
          end

          def cast(value, default = nil)
            case value
            when /^[\d]+\.[\d]+$/
              value.to_f
            when /^[\d]+$/
              value.to_i
            when TRUE
              true
            when FALSE
              false
            when ''
              nil
            else
              value && default.is_a?(Symbol) ? value.to_sym : value
            end
          end

          def split(value)
            values = value.respond_to?(:split) ? value.split(',') : Array(value)
            values.map { |value| cast(value) }
          end

          def hashes?(obj)
            obj.is_a?(Array) && obj.first.is_a?(Hash)
          end

          def compact(hash)
            hash.reject { |_, value| present?(value) }
          end

          def present?(value)
            value.nil? || value.respond_to?(:empty?) && value.empty?
          end
      end

      def self.prefix(prefix = nil)
        prefix ? @prefix = prefix : @prefix ||= 'travis'
      end

      def load
        Vars.new(defaults, [self.class.prefix.to_s.upcase]).to_h
      end
    end
  end
end
