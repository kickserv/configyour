require 'configyour/version'
require 'configyour/app'
require 'configyour/rails'

module Configyour
  class << self
    def configuration
      @configuration ||= Configuration.new
    end
  end

  def self.configure
    yield(configuration)
  end

  class Configuration
    attr_accessor :parameter_root
    attr_accessor :environment
    attr_accessor :file_path
    attr_accessor :rebuild
    attr_accessor :region
    attr_accessor :mode
    attr_accessor :logger

    def initialize
      @file_path = 'config/application.yml'
      @region = 'us-east-1'
      @rebuild = false
      @mode = 'file'
      @logger = nil
    end
  end
end
