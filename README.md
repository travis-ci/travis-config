# Travis Config

Shared way of loading and reading configuration in Travis CI.

Users can either set defaults and include logic directly to the class
`Travis::Config` or extend the class to, e.g. `Travis::Logs::Config`.

E.g.

```ruby
require 'travis/config'

module Travis
  class Config < Hashr
    define  host:  'travis-ci.org'

    def foo
      :foo
    end
  end
end
```

Or:

```ruby
require 'travis/config'

module Travis::Logs
  class Config < Travis::Config
    define  host:  'logs.travis-ci.org'

    def foo
      :foo
    end
  end
end
```

### Config sources

Serveral config sources are supported:

* Files: All files `config/travis.yml` and `config/travis/*.yml` are read and
  merged (alpabetically sorted).
* Env: `ENV['travis_config']` is parsed as YAML and merged, if present.
* Heroku: The env vars `DATABASE_URL` or `SHARED_DATABASE_URL`, and `DB_POOL`
  or `DATABASE_POOL_SIZE` are merged into the database config.
* Docker: The env vars `POSTGRESQL_PORT`, `RABBITMQ_PORT`, and `REDIS_PORT` are
  interpreted as resource URLs, and merged into the database config.

Configuration from all sources is merged before it is passed to the `Hashr`
instance. All merging is deep merging of Hashes on any level.

### Doing a Rubygem release

Any tool works. The current releases were done with
[`gem-release`](https://github.com/svenfuchs/gem-release) which allows creating
a Git tag, pushing it to GitHub, building the gem and pushing it to Rubygems in
one go:

```bash
$ gem install gem-release
$ gem release --tag
```
