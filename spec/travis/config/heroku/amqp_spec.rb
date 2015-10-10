describe Travis::Config::Heroku, :Amqp do
  let(:config) { Travis::Test::Config.load(:heroku) }
  let(:url)    { 'amqp://username:password@hostname:1234/vhost' }

  before       { ENV['RABBITMQ_URL'] = url }
  after        { ENV.delete('RABBITMQ_URL') }

  it 'loads a RABBITMQ_URL' do
    expect(config.amqp).to eq(
      host:     'hostname',
      port:     1234,
      vhost:    'vhost',
      username: 'username',
      password: 'password',
      prefetch: 1
    )
  end
end
