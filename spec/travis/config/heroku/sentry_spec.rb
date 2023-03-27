describe Travis::Config::Heroku, :Sentry do
  let(:config) { Travis::Test::Config.load(:heroku) }
  let(:dsn) { 'http://foo:bar@app.getsentry.com/1' }

  describe 'loads a SENTRY_DSN' do
    env SENTRY_DSN: -> { dsn }
    it { expect(config.sentry.to_h).to eq(dsn:) }
  end

  describe 'loads a TRAVIS_SENTRY_DSN' do
    env TRAVIS_SENTRY_DSN: -> { dsn }
    it { expect(config.sentry.to_h).to eq(dsn:) }
  end
end
