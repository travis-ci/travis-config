module Travis::Test::Env
  class Config < Travis::Config
    define database: { adapter: nil, variables: { statement_timeout: nil } },
           hash: { under_scored: nil, nested: { foo: nil } },
           symbol: :foo,
           integer: nil,
           float: nil,
           true: nil,
           yes: nil,
           on: nil,
           false: nil,
           no: nil,
           off: nil,
           nil: nil
  end
end

describe Travis::Config::Env do
  let(:config) { Travis::Test::Env::Config.load(:env) }

  describe 'cast' do
    env TRAVIS_HASH_UNDER_SCORED: 'under_scored',
        TRAVIS_HASH_NESTED_FOO: 'foo',
        TRAVIS_SYMBOL: 'bar',
        TRAVIS_INTEGER: '10',
        TRAVIS_FLOAT: '10.0',
        TRAVIS_TRUE: 'true',
        TRAVIS_YES: 'yes',
        TRAVIS_ON: 'on',
        TRAVIS_FALSE: 'false',
        TRAVIS_NO: 'no',
        TRAVIS_OFF: 'off',
        TRAVIS_NIL: nil

    it { expect(config.hash.under_scored).to eq 'under_scored' }
    it { expect(config.hash.nested.foo).to eq 'foo' }
    it { expect(config.symbol).to eq :bar }
    it { expect(config.integer).to eq 10 }
    it { expect(config.float).to eq 10.0 }
    it { expect(config.true).to be true }
    it { expect(config.yes).to be true }
    it { expect(config.on).to be true }
    it { expect(config.false).to be false }
    it { expect(config.no).to be false }
    it { expect(config.off).to be false }
    it { expect(config.nil).to be_nil }
  end

  describe 'database' do
    env TRAVIS_DATABASE_ADAPTER: 'postgres',
        TRAVIS_DATABASE_VARIABLES_STATEMENT_TIMEOUT: 10_000

    it { expect(config.database.adapter).to eq 'postgres' }
    it { expect(config.database.variables.statement_timeout).to eq 10_000 }
  end
end

module Travis::Test::Env::Arrays
  class Config < Travis::Config
    define hashes_one: [foo: 'foo'],
           hashes_two: [foo: 1, bar: true],
           strings: []

    Env.prefix :travis
  end
end

describe Travis::Config::Env, 'arrays' do
  let(:config) { Travis::Test::Env::Arrays::Config.load(:env) }

  describe 'cast' do
    env TRAVIS_HASHES_ONE_0_FOO: 'bar',
        TRAVIS_HASHES_ONE_1_FOO: 'baz',
        TRAVIS_HASHES_TWO_0_FOO: 1,
        TRAVIS_HASHES_TWO_0_BAR: 'true',
        TRAVIS_HASHES_TWO_1_FOO: 1.1,
        TRAVIS_HASHES_TWO_1_BAR: 'false',
        TRAVIS_STRINGS: 'foo,bar'

    it { expect(config.hashes_one).to eq [{ foo: 'bar' }, { foo: 'baz' }] }
    it { expect(config.hashes_two).to eq [{ foo: 1, bar: true }, { foo: 1.1, bar: false }] }
    it { expect(config.strings).to eq %w[foo bar] }
  end

  describe 'unexpected string' do
    env TRAVIS_HASHES_ONE: 'foo'

    it { expect { config }.to raise_error(described_class::UnexpectedString) }
  end
end

module Travis::Test::Env::Queues
  class Config < Travis::Config
    define queues: [queue: 'queue', services: ['service']]

    Env.prefix :travis
  end
end

describe Travis::Config::Env, 'queues' do
  let(:defaults) { { queues: [queue: 'queue', services: ['service']] } }
  let(:config) { described_class.new(defaults).load }

  describe 'nested array' do
    env TRAVIS_QUEUES_0_QUEUE: 'one',
        TRAVIS_QUEUES_0_SERVICES_0: 'docker'

    it { expect(config[:queues][0]).to eq queue: 'one', services: ['docker'] }
  end

  describe 'does not set empty arrays' do
    it { expect(config[:queues]).to be_nil }
  end
end
