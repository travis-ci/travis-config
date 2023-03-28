describe Travis::Config do
  let(:config) { Travis::Test::Config.load }

  describe 'Hashr behaviour' do
    after :each do
      ENV.delete('travis_config')
    end

    it { expect(config).to be_kind_of(Hashr) }

    describe 'returns Hashr instances on subkeys' do
      before { ENV['travis_config'] = YAML.dump('redis' => { 'url' => 'redis://localhost:6379' }) }

      it { expect(config.redis).to be_kind_of(Hashr) }
    end

    describe 'returns Hashr instances on subkeys that were set to Ruby Hashes' do
      before { config.foo = { :bar => { :baz => 'baz' } } }

      it { expect(config.foo.bar).to be_kind_of(Hashr) }
    end

    describe 'can access nested keys' do
      it { expect(config.amqp.username).to eq('guest') }
    end
  end

  describe 'reads custom config files' do
    file 'config/travis.yml', YAML.dump('test' => { 'travis' => 'travis', 'shared' => 'travis' })
    file 'config/travis/foo.yml', YAML.dump('test' => { 'foo' => 'foo' })
    file 'config/travis/bar.yml', YAML.dump('test' => { 'bar' => 'bar', 'shared' => 'bar' })

    it { expect(config.travis).to eq('travis') }
    it { expect(config.foo).to eq('foo') }
    it { expect(config.bar).to eq('bar') }
    it { expect(config.shared).to eq('bar') }
  end

  describe 'deep symbolizes arrays, too' do
    let(:config) { Travis::Config.new('queues' => [{ 'slug' => 'rails/rails', 'queue' => 'rails' }]) }

    it { expect(config.queues.first.values_at(:slug, :queue)).to eq(['rails/rails', 'rails']) }
  end

  describe 'logs_database config' do
    env DATABASE_URL: 'postgres://username:password@hostname:1234/database'

    describe 'given logs_database is defined in a config file' do
      file 'config/travis.yml', YAML.dump('test' => { 'logs_database' => { 'database' => 'from_file' } })

      it { expect(config.logs_database.database).to eq 'from_file' }
    end

    describe 'given logs_database is defined in the keychain' do
      env travis_config: YAML.dump('logs_database' => { 'database' => 'keychain' })

      it { expect(config.logs_database.database).to eq 'keychain' }
    end

    describe 'given logs_database is not defined anywhere it does not default to database' do
      it { expect(config.logs_database).to eq nil }
    end
  end

  describe 'loading from keychain and env' do
    env travis_config: YAML.dump('redis' => { 'url' => 'redis://url' }, 'queues' => ['queue' => 'from_keychain']),
        TRAVIS_QUEUES_0_QUEUE: 'from_env'

    it { expect(config.redis.url).to eq 'redis://url' }
    it { expect(config.queues).to eq [queue: 'from_env'] }
  end
end
