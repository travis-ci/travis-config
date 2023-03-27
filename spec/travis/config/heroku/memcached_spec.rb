describe Travis::Config::Heroku, :Memcached do
  let(:config) { Travis::Test::Config.load(:heroku) }
  let(:servers) { 'hostname:1234' }
  let(:username) { 'username' }
  let(:password) { 'password' }

  %i[servers username password].each do |key|
    env "MEMCACHED_#{key.to_s.upcase}" => -> { send(key) }
  end

  it 'loads a MEMCACHED_SERVERS' do
    expect(config.memcached.servers).to eq(servers)
  end

  it 'loads a MEMCACHED_USERNAME' do
    expect(config.memcached.options.username).to eq(username)
  end

  it 'loads a MEMCACHED_PASSWORD' do
    expect(config.memcached.options.password).to eq(password)
  end
end
