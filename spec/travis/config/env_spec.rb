module Travis::Test::Env
  class Config < Travis::Config
    define database: { adapter: nil, variables: { statement_timeout: nil } },
           hash:    { under_scored: nil, nested: { foo: nil } },
           array:   [],
           integer: nil,
           float:   nil,
           true:    nil,
           yes:     nil,
           on:      nil,
           false:   nil,
           no:      nil,
           off:     nil,
           nil:     nil


    Env.prefix :travis
  end
end

describe Travis::Config::Env do
  let(:config) { Travis::Test::Env::Config.load(:env) }

  describe 'cast' do
    env TRAVIS_HASH_UNDER_SCORED: 'under_scored',
        TRAVIS_HASH_NESTED_FOO: 'foo',
        TRAVIS_INTEGER: '10',
        TRAVIS_FLOAT: '10.0',
        TRAVIS_TRUE: 'true',
        TRAVIS_YES: 'yes',
        TRAVIS_ON: 'on',
        TRAVIS_FALSE: 'false',
        TRAVIS_NO: 'no',
        TRAVIS_OFF: 'off',
        TRVIS_NIL: nil

    it { expect(config.hash.under_scored).to eq 'under_scored' }
    it { expect(config.hash.nested.foo).to eq 'foo' }
    it { expect(config.integer).to be 10 }
    it { expect(config.float).to be 10.0 }
    it { expect(config.true).to be true }
    it { expect(config.yes).to be true }
    it { expect(config.on).to be true }
    it { expect(config.false).to be false }
    it { expect(config.no).to be false }
    it { expect(config.off).to be false }
    it { expect(config.nil).to be nil }
  end

  describe 'database' do
    env TRAVIS_DATABASE_ADAPTER: 'postgres',
        TRAVIS_DATABASE_VARIABLES_STATEMENT_TIMEOUT: 10_000

    it { expect(config.database.adapter).to eq 'postgres' }
    it { expect(config.database.variables.statement_timeout).to eq 10_000 }
  end
end
