describe Travis::Config::Heroku do
  let(:config) { Travis::Test::Config.load(:heroku) }
  let(:vars)   { %w(DATABASE_URL POOL_SIZE) }
  after        { vars.each { |key| ENV.delete(key) } }
  before       { ENV['DATABASE_URL'] = 'postgres://username:password@hostname:port/database' }
  before       { ENV['LOGS_DATABASE_URL'] = 'postgres://username:password@hostname:port/logs_database' }

  it 'loads a DATABASE_URL with a port' do
    expect(config.database.to_hash).to eq(
      adapter:  'postgresql',
      host:     'hostname',
      port:     'port',
      database: 'database',
      username: 'username',
      password: 'password',
      encoding: 'unicode'
    )
  end

  it 'loads a DATABASE_URL without a port' do
    ENV['DATABASE_URL'] = 'postgres://username:password@hostname/database'

    expect(config.database.to_hash).to eq(
      adapter:  'postgresql',
      host:     'hostname',
      database: 'database',
      username: 'username',
      password: 'password',
      encoding: 'unicode'
    )
  end

  it 'loads DB_POOL' do
    ENV['DB_POOL'] = '25'

    expect(config.database.to_hash).to eq(
      adapter:  'postgresql',
      host:     'hostname',
      port:     'port',
      database: 'database',
      username: 'username',
      password: 'password',
      encoding: 'unicode',
      pool:     25
    )
  end

  it 'loads DATABASE_POOL_SIZE' do
    ENV['DATABASE_POOL_SIZE'] = '25'

    expect(config.database.to_hash).to eq(
      adapter:  'postgresql',
      host:     'hostname',
      port:     'port',
      database: 'database',
      username: 'username',
      password: 'password',
      encoding: 'unicode',
      pool:     25
    )
  end

  it 'loads a LOGS_DATABASE_URL with a port' do
    expect(config.logs_database.to_hash).to eq(
      adapter:  'postgresql',
      host:     'hostname',
      port:     'port',
      database: 'logs_database',
      username: 'username',
      password: 'password',
      encoding: 'unicode'
    )
  end

  it 'loads a LOGS_DATABASE_URL without a port' do
    ENV['LOGS_DATABASE_URL'] = 'postgres://username:password@hostname/logs_database'

    expect(config.logs_database.to_hash).to eq(
      adapter:  'postgresql',
      host:     'hostname',
      database: 'logs_database',
      username: 'username',
      password: 'password',
      encoding: 'unicode'
    )
  end

  it 'loads LOGS_DB_POOL' do
    ENV['LOGS_DB_POOL'] = '25'

    expect(config.logs_database.to_hash).to eq(
      adapter:  'postgresql',
      host:     'hostname',
      port:     'port',
      database: 'logs_database',
      username: 'username',
      password: 'password',
      encoding: 'unicode',
      pool:     25
    )
  end

  it 'loads LOGS_DATABASE_POOL_SIZE' do
    ENV['LOGS_DATABASE_POOL_SIZE'] = '25'

    expect(config.logs_database.to_hash).to eq(
      adapter:  'postgresql',
      host:     'hostname',
      port:     'port',
      database: 'logs_database',
      username: 'username',
      password: 'password',
      encoding: 'unicode',
      pool:     25
    )
  end
end
