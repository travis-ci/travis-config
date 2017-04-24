module Travis
  class Config
    class Keychain < Struct.new(:defaults)
      def load
        ENV['travis_config'] ? YAML.load(ENV['travis_config']) : {}
      end
    end
  end
end
