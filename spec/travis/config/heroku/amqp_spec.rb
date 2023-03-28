describe Travis::Config::Heroku, :Amqp do
  let(:config) { Travis::Test::Config.load(:heroku) }

  env RABBITMQ_URL: -> { url }

  describe 'using amqp as a protocol' do
    let(:url) { 'amqp://username:password@hostname:1234/vhost' }

    it 'loads a RABBITMQ_URL' do
      expect(config.amqp.to_h).to eq(
        host: 'hostname',
        port: 1234,
        vhost: 'vhost',
        username: 'username',
        password: 'password',
        prefetch: 1
      )
    end
  end

  describe 'using amqps as a protocol' do
    let(:url) { 'amqps://username:password@hostname:1234/vhost' }

    it 'loads a RABBITMQ_URL' do
      expect(config.amqp.to_h).to eq(
        host: 'hostname',
        port: 1234,
        vhost: 'vhost',
        username: 'username',
        password: 'password',
        ssl: true,
        prefetch: 1
      )
    end
  end
end
