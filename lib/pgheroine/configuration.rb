require 'pgheroine/error'

module PGHeroine
  ApplicationRootNotSet = Class.new(PGHeroine::Error)
  class << self
    attr_writer :configuration
    def configuration
      @configuration ||= Configuration.new
    end
  end

  class Configuration
    def initialize(&blk)
      self.configuration = new_configuration(&blk)
      PGHeroine.configuration = self
    end

    def new(&blk)
      self.class.new(&blk)
    end

    def reset!(&blk)
      new_configuration
    end

    private
    attr_accessor :configuration

    def new_configuration(&blk)
      block_given? ? DSL.new(&blk) : DSL.new
    end

    def method_missing(method_name, *args, &blk)
      if configuration.respond_to?(method_name)
        define_proxy_method(method_name).call(*args, &blk)
      else
        super
      end
    end

    def define_proxy_method(method_name)
      self.class.send(:delegate, method_name, to: :configuration) unless respond_to?(method_name)
      method(method_name)
    end
  end

  class DSL
    attr_writer :application_root

    def initialize
      yield self if block_given?
    end

    def application_root
      @application_root ||= PGHeroine.application_root
    end

    def configuration_file_path
      self.relative_configuration_file_path = 'config/pgheroine.yml' unless @configuration_file_path
      @configuration_file_path
    end

    def relative_configuration_file_path=(path)
      raise ApplicationRootNotSet, "Set application_root in an initializer" unless Dir.exist?(application_root)
      full_path = File.join(File.expand_path(application_root), path.to_s).freeze
      raise DatabaseConfigurationFileNotFound, "Set configuration_file_path in an initializer" unless File.file?(full_path)

      @configuration_file_path = full_path
    end
  end
end
