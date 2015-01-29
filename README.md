# PGHeroine

## Installation

### Add gem to Gemfile

filename: `Gemfile`

```ruby
gem %q|pgheroine|
```

### Mount engine

filename: `config/routes.rb`

```ruby
MyApp::Application.routes.draw do
  ...
  mount PGHeroine::Engine => %q|/pgheroine|
  ...
end
```

## Configure

PGHeroin includes a simple configuration class that you can use in an intializer if you dislike the defaults for whatever stupid reason.

The configuration is available at `PGHeroine.configuration`

filename: `config/initializers/pgheroine.rb`

```ruby
require 'pgheroine/configuration'

PGHeroine.configuration.new do |config|
  config.application_root = Rails.root
  config.relative_configuration_file_path = 'config/pgheroine.yml'
end
```

filename: `config/pgheroine.yml`

```yaml
default: &default
  adapter: postgresql
  encoding: unicode
  pool: 5
  username: postgres

fakes: &fakes
  fake_1:
    <<: *default
    database: fake_1
  fake_2:
    <<: *default
    database: fake_2
  fake_3:
    <<: *default
    database: fake_3

development:
  <<: *fakes

test:
  <<: *fakes
```

### Resetting configuration

If you need to reset the configuration, perhaps for tests.

```ruby
PGHeroine.configuration.reset!
```

## Testing
If you want to integrate against pgheroine with multiple databases, you'll probably need to set up those databases.  
One way that the authors of pgheroine do this is by adding entries into config/database.yml and then running the `db:create:all` task.

See `test/dummy/config/database.yml` for examples.

This project rocks and uses MIT-LICENSE.
