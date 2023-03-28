module Travis
  class Config
    class Keychain < Struct.new(:defaults)
      def load
        ENV['travis_config'] ? YAML.safe_load(ENV['travis_config']) : {}
      end
    end
  end
end
