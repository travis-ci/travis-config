describe Travis::Config::Heroku, :Memcached do
  let(:config)   { Travis::Test::Config.load(:heroku) }
  let(:servers)  { 'hostname:1234' }
  let(:username) { 'username' }
  let(:password) { 'password' }

  [:servers, :username, :password].each do |key|
    before { ENV["MEMCACHED_#{key.to_s.upcase}"] = send(key) }
    after  { ENV.delete("MEMCACHED_#{key.to_s.upcase}") }
  end

  it 'loads a MEMCACHED_SERVERS' do
    expect(config.memcached.servers).to eq(servers)
  end

  it 'loads a MEMCACHED_USERNAME' do
    expect(config.memcached.options.username).to eq(username)
  end

  it 'loads a MEMCACHED_SERVERS' do
    expect(config.memcached.options.password).to eq(password)
  end
end
