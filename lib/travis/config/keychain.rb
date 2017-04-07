module Travis
  class Config
    class Keychain
      def load
        ENV['travis_config'] ? YAML.load(ENV['travis_config']) : {}
      end
    end
  end
end
