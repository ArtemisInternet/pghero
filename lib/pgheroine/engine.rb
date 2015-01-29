require %|pgheroine/configuration|

module PGHeroine
  class << self
    attr_accessor :application_root
  end

  class Engine < ::Rails::Engine
    isolate_namespace PGHeroine

    initializer(%|pgheroine.load_application_root|) do |app|
        PGHeroine.application_root = app.root
    end

    initializer(%|pgheroine.add_inflection|) do |_app|
      ActiveSupport::Inflector.inflections do |inflect|
        inflect.acronym %|PG|
      end
    end
  end
end
