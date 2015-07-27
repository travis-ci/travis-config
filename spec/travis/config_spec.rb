describe Travis::Config do
  let(:config) { Travis::Test::Config.load(:files, :env, :heroku, :docker) }

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

    it 'can access all keys recursively' do
      access = proc do |config|
        config.keys.each do |key|
          expect(proc { config.send(key) }).to_not raise_error
          access.call(config.send(key)) if config[key].is_a?(Hash)
        end
      end
      access.call(config)
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
end
