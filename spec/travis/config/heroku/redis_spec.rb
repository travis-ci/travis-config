describe Travis::Config::Heroku, :Redis do
  let(:config) { Travis::Test::Config.load(:heroku) }
  let(:url)    { 'redis://username:password@hostname:1234/database' }

  env REDIS_URL: -> { url }

  it 'loads a REDIS_URL' do
    expect(config.redis.to_h).to eq(url: url)
  end
end
