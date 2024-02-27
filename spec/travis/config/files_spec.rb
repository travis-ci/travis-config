describe Travis::Config::Files do
  let(:config) { Travis::Test::Config.load(:files) }

  describe 'reads custom config files' do
    before do
      Dir.stubs(:[]).returns ['config/travis.yml', 'config/travis/foo.yml', 'config/travis/bar.yml']
      YAML.stubs(:load_file).with('config/travis.yml', aliases: true).returns('test' => { 'travis' => 'travis', 'shared' => 'travis' })
      YAML.stubs(:load_file).with('config/travis/foo.yml', aliases: true).returns('test' => { 'foo' => 'foo' })
      YAML.stubs(:load_file).with('config/travis/bar.yml', aliases: true).returns('test' => { 'bar' => 'bar', 'shared' => 'bar' })
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
