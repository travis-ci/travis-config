describe Travis::Config::Heroku, :Database do
  let(:config) { Travis::Test::Config.load(:heroku) }
  let(:vars)   { %w(DATABASE_URL DB_POOL DATABASE_POOL_SIZE LOGS_DATABASE_URL LOGS_DB_POOL LOGS_DATABASE_POOL_SIZE DYNO) }
  after        { vars.each { |key| ENV.delete(key) } }
  before       { ENV['DYNO'] = 'app_name' }

  it 'loads a DATABASE_URL with a port' do
    ENV['DATABASE_URL'] = 'postgres://username:password@hostname:1234/database'

    expect(config.database.to_h).to eq(
      application_name: 'travis-config/specs',
      adapter:  'postgresql',
      host:     'hostname',
      port:     1234,
      database: 'database',
      username: 'username',
      password: 'password',
      encoding: 'unicode'
    )
  end

  it 'loads a DATABASE_URL without a port' do
    ENV['DATABASE_URL'] = 'postgres://username:password@hostname/database'

    expect(config.database.to_h).to eq(
      application_name: 'travis-config/specs',
      adapter:  'postgresql',
      host:     'hostname',
      database: 'database',
      username: 'username',
      password: 'password',
      encoding: 'unicode'
    )
  end

  it 'loads DB_POOL' do
    ENV['DATABASE_URL'] = 'postgres://username:password@hostname:1234/database'
    ENV['DB_POOL'] = '25'

    expect(config.database.to_h).to eq(
      application_name: 'travis-config/specs',
      adapter:  'postgresql',
      host:     'hostname',
      port:     1234,
      database: 'database',
      username: 'username',
      password: 'password',
      encoding: 'unicode',
      pool:     25
    )
  end

  it 'loads DATABASE_POOL_SIZE' do
    ENV['DATABASE_URL'] = 'postgres://username:password@hostname:1234/database'
    ENV['DATABASE_POOL_SIZE'] = '25'

    expect(config.database.to_h).to eq(
      application_name: 'travis-config/specs',
      adapter:  'postgresql',
      host:     'hostname',
      port:     1234,
      database: 'database',
      username: 'username',
      password: 'password',
      encoding: 'unicode',
      pool:     25
    )
  end

  it 'loads a LOGS_DATABASE_URL with a port' do
    ENV['LOGS_DATABASE_URL'] = 'postgres://username:password@hostname:1234/logs_database'

    expect(config.logs_database.to_h).to eq(
      application_name: 'travis-config/specs',
      adapter:  'postgresql',
      host:     'hostname',
      port:     1234,
      database: 'logs_database',
      username: 'username',
      password: 'password',
      encoding: 'unicode'
    )
  end

  it 'loads a LOGS_DATABASE_URL without a port' do
    ENV['LOGS_DATABASE_URL'] = 'postgres://username:password@hostname/logs_database'

    expect(config.logs_database.to_h).to eq(
      application_name: 'travis-config/specs',
      adapter:  'postgresql',
      host:     'hostname',
      database: 'logs_database',
      username: 'username',
      password: 'password',
      encoding: 'unicode'
    )
  end

  it 'loads LOGS_DB_POOL' do
    ENV['LOGS_DATABASE_URL'] = 'postgres://username:password@hostname:1234/logs_database'
    ENV['LOGS_DB_POOL'] = '1'

    expect(config.logs_database.to_h).to eq(
      application_name: 'travis-config/specs',
      adapter:  'postgresql',
      host:     'hostname',
      port:     1234,
      database: 'logs_database',
      username: 'username',
      password: 'password',
      encoding: 'unicode',
      pool:     1
    )
  end

  it 'loads LOGS_DATABASE_POOL_SIZE' do
    ENV['LOGS_DATABASE_URL'] = 'postgres://username:password@hostname:1234/logs_database'
    ENV['LOGS_DATABASE_POOL_SIZE'] = '25'

    expect(config.logs_database.to_h).to eq(
      application_name: 'travis-config/specs',
      adapter:  'postgresql',
      host:     'hostname',
      port:     1234,
      database: 'logs_database',
      username: 'username',
      password: 'password',
      encoding: 'unicode',
      pool:     25
    )
  end

  it 'sets logs_database to nil if no logs db url given' do
    expect(config.logs_database).to be_nil
  end
end
