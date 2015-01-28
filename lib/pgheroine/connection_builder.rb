require 'pgheroine/error'
require 'ostruct' 
require 'yaml'

module PGHeroine
  DatabaseConfigurationFileNotFound = Class.new(Error)
  DatabaseConfigurationNotFound = Class.new(Error)

  class ConnectionBuilder
    attr_reader :connection

    def initialize(database_name) 
      self.connection = connections[database_name.to_sym]
    end

    private
    attr_writer :connection

    def connections
      self.class.send(:connections)
    end

    def self.connections
      @connections ||= Hash.new do |hash, key|
        symbolized_key = key.to_sym
        hash[symbolized_key] = database_configurations[symbolized_key]
      end
    end


    def self.database_configurations
      @database_configurations ||= setup_database_configurations
    end

    def self.setup_database_configurations
      Hash.new do |hash, key|
        hash[key] = if raw_config.key?(key.to_s)
          generate_anonymous_activerecord_class_for(key).connection
        else
          raise DatabaseConfigurationNotFound,
            "#{key} not found in #{configuration_file_path} for the #{Rails.env} environment"
        end
      end
    end

    def self.raw_config
      @raw_config ||= YAML.load_file(configuration_file_path)
      
      @raw_config.fetch(Rails.env) do |key|
        raise DatabaseConfigurationNotFound,
            "Environment #{key} key not found in #{configuration_file_path}"
      end
    end

    def self.configuration_file_path
      PGHeroine.configuration.configuration_file_path
    end

    def self.generate_anonymous_activerecord_class_for(database_name)
      config = raw_config[database_name] 
      class_name = %Q|#{database_name.capitalize}Connection|

      Class.new(ActiveRecord::Base) do
        self.table_name = %q|pgheroine_to_the_rescue|

        def self.name
          "PGHeroine::AnonymousConnectionClass"
        end

        establish_connection config
      end
    end

  end
end
