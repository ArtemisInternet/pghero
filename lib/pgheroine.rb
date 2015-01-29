require 'pgheroine/engine'

module PGHeroine
  autoload :Configuration, 'pgheroine/configuration'

  autoload :ConnectionBuilder, 'pgheroine/connection_builder'
    autoload :DatabaseConfigurationFileNotFound, 'pgheroine/connection_builder'
    autoload :DatabaseConfigurationNotFound, 'pgheroine/connection_builder'

  autoload :QueryCoordinator, 'pgheroine/query_coordinator'
  autoload :QueryRunner, 'pgheroine/query_runner'
end
