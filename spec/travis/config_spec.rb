require 'spec_helper'

module Travis::Test
  class Config < Travis::Config
    define amqp: { username: 'guest', password: 'guest', host: 'localhost', prefetch: 1 }
    define database: { adapter: 'postgresql', database: 'test', encoding: 'unicode' }
  end
end

describe Travis::Config do
  let(:config) { Travis::Test::Config.load(:files, :env, :heroku, :docker) }

  describe 'Hashr behaviour' do
    after :each do
      ENV.delete('travis_config')
    end

    it 'is a Hashr instance' do
      expect(config).to be_kind_of(Hashr)
    end

    it 'returns Hashr instances on subkeys' do
      ENV['travis_config'] = YAML.dump('redis' => { 'url' => 'redis://localhost:6379' })
      expect(config.redis).to be_kind_of(Hashr)
    end

    it 'returns Hashr instances on subkeys that were set to Ruby Hashes' do
      config.foo = { :bar => { :baz => 'baz' } }
      expect(config.foo.bar).to be_kind_of(Hashr)
    end
  end

  describe 'using DATABASE_URL for database configuration if present' do
    after :each do
      ENV.delete('DATABASE_URL')
    end

    it 'works when given a url with a port' do
      ENV['DATABASE_URL'] = 'postgres://username:password@hostname:port/database'

      expect(config.database.to_hash).to eq(
        :adapter => 'postgresql',
        :host => 'hostname',
        :port => 'port',
        :database => 'database',
        :username => 'username',
        :password => 'password',
        :encoding => 'unicode'
      )
    end

    it 'works when given a url without a port' do
      ENV['DATABASE_URL'] = 'postgres://username:password@hostname/database'

      expect(config.database.to_hash).to eq(
        :adapter => 'postgresql',
        :host => 'hostname',
        :database => 'database',
        :username => 'username',
        :password => 'password',
        :encoding => 'unicode'
      )
    end
  end

  describe 'the example config file' do
    let(:data) { {} }

    it 'can access all keys recursively' do
      nested_access = lambda do |config, data|
        data.keys.each do |key|
          expect(-> { config.send(key) }).to_not raise_error
          nested_access.call(config.send(key), data[key]) if data[key].is_a?(Hash)
        end
      end
      nested_access.call(config, data)
    end
  end

  describe 'reads custom config files' do
    before :each do
      Dir.stubs(:[]).returns ['config/travis.yml', 'config/travis/foo.yml', 'config/travis/bar.yml']
      YAML.stubs(:load_file).with('config/travis.yml').returns('test' => { 'travis' => 'travis', 'shared' => 'travis' })
      YAML.stubs(:load_file).with('config/travis/foo.yml').returns('test' => { 'foo' => 'foo' })
      YAML.stubs(:load_file).with('config/travis/bar.yml').returns('test' => { 'bar' => 'bar', 'shared' => 'bar' })
    end

    it 'still reads the default config file' do
      expect(config.travis).to eq('travis')
    end

    it 'merges custom files' do
      expect(config.foo).to eq('foo')
      expect(config.bar).to eq('bar')
    end

    it 'overwrites previously set values with values loaded later' do
      expect(config.shared).to eq('bar')
    end
  end

  describe 'loads docker-style env vars' do
    after :each do
      %w(POSTGRESQL_PORT RABBITMQ_PORT REDIS_PORT).each do |key|
        ENV.delete(key)
      end
    end

    describe 'loads POSTGRESQL_PORT to config.database' do
      before :each do
        ENV['POSTGRESQL_PORT'] = 'tcp://172.17.0.11:5432'
      end

      it 'loads host and port from the env var' do
        expect(config.database.values_at(:host, :port)).to eq(['172.17.0.11', '5432'])
      end

      it 'keeps adapter, database, encoding from the regular config' do
        expect(config.database.values_at(:adapter, :database, :encoding)).to eq(['postgresql', 'test', 'unicode'])
      end
    end

    describe 'loads RABBITMQ_PORT to config.amqp' do
      before :each do
        ENV['RABBITMQ_PORT'] = 'tcp://172.17.0.11:5672'
      end

      it 'loads host and port from the env var' do
        expect(config.amqp.values_at(:host, :port)).to eq(['172.17.0.11', '5672'])
      end

      it 'keeps username, password, prefetch from the regular config' do
        expect(config.amqp.values_at(:username, :password, :prefetch)).to eq(['guest', 'guest', 1])
      end
    end

    it 'loads REDIS_PORT' do
      ENV['REDIS_PORT'] = 'tcp://172.17.0.7:6379'
      expect(config.redis).to eq({ url: 'tcp://172.17.0.7:6379' })
    end
  end

  it 'deep symbolizes arrays, too' do
    config = Travis::Config.new('queues' => [{ 'slug' => 'rails/rails', 'queue' => 'rails' }])
    expect(config.queues.first.values_at(:slug, :queue)).to eq(['rails/rails', 'rails'])
  end
end


