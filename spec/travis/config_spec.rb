describe Travis::Config do
  let(:config) { Travis::Test::Config.load(:files, :keychain, :heroku, :docker) }

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

    it 'can access nested keys' do
      expect(config.amqp.username).to eq('guest')
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

  it 'deep symbolizes arrays, too' do
    config = Travis::Config.new('queues' => [{ 'slug' => 'rails/rails', 'queue' => 'rails' }])
    expect(config.queues.first.values_at(:slug, :queue)).to eq(['rails/rails', 'rails'])
  end

  describe 'logs_database config' do
    before { ENV['DATABASE_URL'] = 'postgres://username:password@hostname:1234/database' }
    after  { ENV['DATABASE_URL'] = nil }

    describe 'given logs_database is defined in a config file' do
      before do
        Dir.stubs(:[]).returns ['config/travis.yml']
        YAML.stubs(:load_file).with('config/travis.yml').returns('test' => { 'logs_database' => { 'database' => 'config_file' } })
      end
      it { expect(config.logs_database.database).to eq 'config_file' }
    end

    describe 'given logs_database is defined in the keychain' do
      before { ENV['travis_config'] = YAML.dump('logs_database' => { 'database' => 'keychain' }) }
      after  { ENV['travis_config'] = nil }
      it { expect(config.logs_database.database).to eq 'keychain' }
    end

    describe 'given logs_database is not defined anywhere it does not default to database' do
      it { expect(config.logs_database).to eq nil }
    end
  end
end
