module Travis
  class Config
    class Keychain < Struct.new(:defaults)
      def load
        ENV['travis_config'] ? YAML.safe_load(ENV['travis_config'], aliases: true) : {}
      end
    end
  end
end
