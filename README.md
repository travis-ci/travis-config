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

### Doing a Rubygem release

Any tool works. The current releases were done with
[`gem-release`](https://github.com/svenfuchs/gem-release) which allows creating
a Git tag, pushing it to GitHub, building the gem and pushing it to Rubygems in
one go:

```bash
$ gem install gem-release
$ gem release --tag
```
