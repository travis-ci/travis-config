describe Travis::Config::Heroku, :Sentry do
  let(:config) { Travis::Test::Config.load(:heroku) }
  let(:dsn)    { 'http://foo:bar@app.getsentry.com/1' }

  before       { ENV[key] = dsn }
  after        { ENV.delete('SENTRY_DSN') }

  describe 'loads a SENTRY_DSN' do
    let(:key)  { 'SENTRY_DSN' }
    it { expect(config.sentry.to_h).to eq(dsn: dsn) }
  end

  describe 'loads a TRAVIS_SENTRY_DSN' do
    let(:key)  { 'TRAVIS_SENTRY_DSN' }
    it { expect(config.sentry.to_h).to eq(dsn: dsn) }
  end
end
