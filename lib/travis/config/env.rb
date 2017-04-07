module Travis
  class Config
    class Env < Struct.new(:defaults)
      class Vars < Struct.new(:defaults, :prefix)
        TRUE  = /^(true|yes|on)$/
        FALSE = /^(false|no|off)$/

        def to_h
          defaults.deep_merge(read_env(prefix.dup, defaults))
        end

        private

          def read_env(prefix, defaults)
            defaults.inject({}) do |config, (key, default)|
              keys = prefix + [key]
              value = default.is_a?(Hash) ? read_env(keys, default) : var(keys, default)
              config.merge(key => value)
            end
          end

          def var(keys, default)
            key = keys.map(&:upcase).join('_')
            value = ENV.fetch(key, default)
            default.is_a?(Array) ? to_a(value) : cast(value, default)
          end

          def cast(value, default)
            case value
            when /^[\d]+\.[\d]+$/
              value.to_f
            when /^[\d]+$/
              value.to_i
            when TRUE
              true
            when FALSE
              false
            else
              value
            end
          end

          def to_a(value)
            value.respond_to?(:split) ? value.split(',') : Array(value)
          end
      end

      def self.prefix(prefix = nil)
        prefix ? @prefix = prefix : @prefix
      end

      def load
        Vars.new(defaults, [self.class.prefix.to_s.upcase]).to_h
      end
    end
  end
end
