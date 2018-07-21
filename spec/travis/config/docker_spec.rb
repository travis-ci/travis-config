describe Travis::Config::Docker do
  let(:config) { Travis::Test::Config.load(:docker) }

  describe 'loads POSTGRESQL_PORT to config.database' do
    env POSTGRESQL_PORT: 'tcp://172.17.0.11:5432'

    it 'loads host and port from the env var' do
      expect(config.database.values_at(:host, :port)).to eq(['172.17.0.11', '5432'])
    end

    it 'keeps adapter, database, encoding from the regular config' do
      expect(config.database.values_at(:adapter, :database, :encoding)).to eq(['postgresql', 'test', 'unicode'])
    end
  end

  describe 'loads RABBITMQ_PORT to config.amqp' do
    env RABBITMQ_PORT: 'tcp://172.17.0.11:5672'

    it 'loads host and port from the env var' do
      expect(config.amqp.values_at(:host, :port)).to eq(['172.17.0.11', '5672'])
    end

    it 'keeps username, password, prefetch from the regular config' do
      expect(config.amqp.values_at(:username, :password, :prefetch)).to eq(['guest', 'guest', 1])
    end
  end

  describe 'loads REDIS_PORT' do
    env REDIS_PORT: 'tcp://172.17.0.7:6379'

    it 'loads the port to redis.url as a redis:// url' do
      expect(config.redis.to_h).to eq({ url: 'redis://172.17.0.7:6379' })
    end
  end
end
