module Travis
  class Config
    module Helpers
      def deep_symbolize_keys(hash)
        hash.each_with_object({}) do |(key, value), result|
          key = key.to_sym if key.respond_to?(:to_sym)
          result[key] = case value
                        when Array
                          value.map { |value| value.is_a?(Hash) ? value.deep_symbolize_keys : value }
                        when Hash
                          value.deep_symbolize_keys
                        else
                          value
                        end
        end
      end

      def deep_merge(hash, other)
        merger = proc { |_key, v1, v2| v1.is_a?(Hash) && v2.is_a?(Hash) ? v1.merge(v2, &merger) : v2 || v1 }
        hash.merge(other, &merger)
      end

      def compact(obj)
        case obj
        when Array
          obj.map { |v| compact(v) }.reject { |v| blank?(v) }
        when Hash
          obj.map { |k, v| [k, compact(v)] }.reject { |_k, v| blank?(v) }.to_h
        else
          obj
        end
      end

      def blank?(obj)
        obj.respond_to?(:empty?) ? obj.empty? : !obj
      end

      def camelize(string)
        string.to_s
              .sub(/^[a-z\d]*/) { ::Regexp.last_match(0).capitalize }
              .gsub(%r{(?:_|(/))([a-z\d]*)}i) { "#{::Regexp.last_match(1)}#{::Regexp.last_match(2).capitalize}" }
              .gsub('/', '::')
      end
    end
  end
end
