describe Travis::Config::Heroku, :Database do
  let(:config) { Travis::Test::Config.load(:heroku) }
  env DYNO: 'app_name'

  describe 'loads a TRAVIS_DATABASE_URL with a port' do
    env TRAVIS_DATABASE_URL: 'postgres://username:password@hostname:1234/database'

    it do
      expect(config.database.to_h).to eq(
        adapter:   'postgresql',
        host:      'hostname',
        port:      1234,
        database:  'database',
        username:  'username',
        password:  'password',
        encoding:  'unicode',
        variables: { application_name: 'travis-config/specs', statement_timeout: 10_000 }
      )
    end
  end

  describe 'loads a DATABASE_URL with a port' do
    env DATABASE_URL: 'postgres://username:password@hostname:1234/database'

    it do
      expect(config.database.to_h).to eq(
        adapter:   'postgresql',
        host:      'hostname',
        port:      1234,
        database:  'database',
        username:  'username',
        password:  'password',
        encoding:  'unicode',
        variables: { application_name: 'travis-config/specs', statement_timeout: 10_000 }
      )
    end
  end

  describe 'loads a DATABASE_URL without a port' do
    env DATABASE_URL: 'postgres://username:password@hostname/database'

    it do
      expect(config.database.to_h).to eq(
        adapter:   'postgresql',
        host:      'hostname',
        database:  'database',
        username:  'username',
        password:  'password',
        encoding:  'unicode',
        variables:  { application_name: 'travis-config/specs', statement_timeout: 10_000 }
      )
    end
  end

  describe 'loads TRAVIS_DATABASE_POOL_SIZE' do
    env TRAVIS_DATABASE_URL: 'postgres://username:password@hostname:1234/database'
    env TRAVIS_DATABASE_POOL_SIZE: '25'

    it do
      expect(config.database.to_h).to eq(
        adapter:   'postgresql',
        host:      'hostname',
        port:      1234,
        database:  'database',
        username:  'username',
        password:  'password',
        encoding:  'unicode',
        pool:      25,
        variables: { application_name: 'travis-config/specs', statement_timeout: 10_000 }
      )
    end
  end

  describe 'loads DATABASE_POOL_SIZE' do
    env DATABASE_URL: 'postgres://username:password@hostname:1234/database'
    env DATABASE_POOL_SIZE: '25'

    it do
      expect(config.database.to_h).to eq(
        adapter:   'postgresql',
        host:      'hostname',
        port:      1234,
        database:  'database',
        username:  'username',
        password:  'password',
        encoding:  'unicode',
        pool:      25,
        variables: { application_name: 'travis-config/specs', statement_timeout: 10_000 }
      )
    end
  end

  describe 'loads DB_POOL' do
    env DATABASE_URL: 'postgres://username:password@hostname:1234/database'
    env DB_POOL: '25'

    it do
      expect(config.database.to_h).to eq(
        adapter:   'postgresql',
        host:      'hostname',
        port:      1234,
        database:  'database',
        username:  'username',
        password:  'password',
        encoding:  'unicode',
        pool:      25,
        variables: { application_name: 'travis-config/specs', statement_timeout: 10_000 }
      )
    end
  end

  describe 'loads a TRAVIS_LOGS_DATABASE_URL with a port' do
    env TRAVIS_LOGS_DATABASE_URL: 'postgres://username:password@hostname:1234/logs_database'

    it do
      expect(config.logs_database.to_h).to eq(
        adapter:   'postgresql',
        host:      'hostname',
        port:      1234,
        database:  'logs_database',
        username:  'username',
        password:  'password',
        encoding:  'unicode',
        variables: { application_name: 'travis-config/specs', statement_timeout: 10_000 }
      )
    end
  end

  describe 'loads a LOGS_DATABASE_URL with a port' do
    env LOGS_DATABASE_URL: 'postgres://username:password@hostname:1234/logs_database'

    it do
      expect(config.logs_database.to_h).to eq(
        adapter:   'postgresql',
        host:      'hostname',
        port:      1234,
        database:  'logs_database',
        username:  'username',
        password:  'password',
        encoding:  'unicode',
        variables: { application_name: 'travis-config/specs', statement_timeout: 10_000 }
      )
    end
  end

  describe 'loads a LOGS_DATABASE_URL without a port' do
    env LOGS_DATABASE_URL: 'postgres://username:password@hostname/logs_database'

    it do
      expect(config.logs_database.to_h).to eq(
        adapter:   'postgresql',
        host:      'hostname',
        database:  'logs_database',
        username:  'username',
        password:  'password',
        encoding:  'unicode',
        variables: { application_name: 'travis-config/specs', statement_timeout: 10_000 }
      )
    end
  end

  describe 'loads LOGS_DB_POOL' do
    env LOGS_DATABASE_URL: 'postgres://username:password@hostname:1234/logs_database'
    env LOGS_DB_POOL: '1'

    it do
      expect(config.logs_database.to_h).to eq(
        adapter:   'postgresql',
        host:      'hostname',
        port:      1234,
        database:  'logs_database',
        username:  'username',
        password:  'password',
        encoding:  'unicode',
        pool:      1,
        variables: { application_name: 'travis-config/specs', statement_timeout: 10_000 }
      )
    end
  end

  describe 'loads TRAVIS_LOGS_DATABASE_POOL_SIZE' do
    env TRAVIS_LOGS_DATABASE_URL: 'postgres://username:password@hostname:1234/logs_database'
    env TRAVIS_LOGS_DATABASE_POOL_SIZE: '25'

    it do
      expect(config.logs_database.to_h).to eq(
        adapter:   'postgresql',
        host:      'hostname',
        port:      1234,
        database:  'logs_database',
        username:  'username',
        password:  'password',
        encoding:  'unicode',
        pool:      25,
        variables: { application_name: 'travis-config/specs', statement_timeout: 10_000 }
      )
    end
  end

  describe 'loads LOGS_DATABASE_POOL_SIZE' do
    env LOGS_DATABASE_URL: 'postgres://username:password@hostname:1234/logs_database'
    env LOGS_DATABASE_POOL_SIZE: '25'

    it do
      expect(config.logs_database.to_h).to eq(
        adapter:   'postgresql',
        host:      'hostname',
        port:      1234,
        database:  'logs_database',
        username:  'username',
        password:  'password',
        encoding:  'unicode',
        pool:      25,
        variables: { application_name: 'travis-config/specs', statement_timeout: 10_000 }
      )
    end
  end

  describe 'sets logs_database to nil if no LOGS_DATABASE_URL is given' do
    it { expect(config.logs_database).to be_nil }
  end

  describe 'does not overwrite variables given as defaults' do
    before { Travis::Test::Config.defaults[:database][:variables] = { statement_timeout: 1 } }
    env TRAVIS_DATABASE_URL: 'postgres://username:password@hostname:1234/database'
    it { expect(config.database.variables.statement_timeout).to eq 1 }
  end
end
