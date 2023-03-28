module Travis
  class Config
    module Serialize
      class Env < Struct.new(:config, :opts)
        attr_reader :config, :opts

        def initialize(config, opts = {})
          super

          @config = config
          @opts = opts
        end

        def apply
          vars.to_a.map { |pair| pair.join('=') }
        end

        private

        def vars
          collect(Array(prefix), config).map do |keys, value|
            [keys.map(&:to_s).map(&:upcase).join('_'), value.to_s]
          end.to_h
        end

        def collect(keys, config)
          compact(config).inject({}) do |result, (key, value)|
            case value
            when Hash
              result.merge collect(keys + [key], value)
            else
              result.merge [[keys + [key], value]].to_h
            end
          end
        end

        def compact(hash)
          hash.compact.to_h
        end

        def prefix
          opts[:prefix]
        end
      end
    end
  end
end
