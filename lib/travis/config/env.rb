require 'hashr'

module Travis
  class Config < Hashr
    class Env
      def load
        ENV['travis_config'] ? YAML.load(ENV['travis_config']) : {}
      end
    end
  end
end
