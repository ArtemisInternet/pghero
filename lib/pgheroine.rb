require 'pgheroine/engine'
require 'pgheroine/queries'

module PGHeroine
  autoload :Configuration, 'pgheroine/configuration'
  autoload :ConnectionBuilder, 'pgheroine/connection_builder'

  autoload :DatabaseConfigurationFileNotFound, 'pgheroine/connection_builder'
  autoload :DatabaseConfigurationNotFound, 'pgheroine/connection_builder'
end

