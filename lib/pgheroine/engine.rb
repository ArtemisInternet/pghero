require 'pgheroine/configuration'

module PGHeroine
  class << self
    attr_accessor :application_root
  end

  class Engine < ::Rails::Engine
    isolate_namespace PGHeroine

    initializer("pgheroine.load_application_root") do |app|
        PGHeroine.application_root = app.root

    end
  end
end
