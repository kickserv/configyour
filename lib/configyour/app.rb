require 'aws-sdk-ssm'

module Configyour
  class App

    attr_accessor :parameter_root
    attr_accessor :logger

    def initialize(parameter_root: Configyour.configuration.parameter_root, region: Configyour.configuration.region, logger: Configyour.configuration.logger)
      @parameter_root = parameter_root
      @region = region
      @logger = logger
    end

    def generate(file_path: Configyour.configuration.file_path, environment: Configyour.configuration.environment, rebuild: Configyour.configuration.rebuild)
      return unless @parameter_root
      return if File.exist?(file_path) && !rebuild

      config_hash = {}

      parameter_set = fetch_parameter_set(environment)

      parameter_set.each do |param|
        config_hash[param.name.split('/').last.upcase] = param.value
      end

      File.open(file_path, 'w') { |file| file.write(config_hash.to_yaml) }
    end

    def load(environment: Configyour.configuration.environment)
      return unless @parameter_root

      parameter_set = fetch_parameter_set(environment)

      parameter_set.each do |param|
        ENV[param.name.split('/').last.upcase] = param.value
      end
    end

    def push(file_path:, environment: Configyour.configuration.environment, overwrite: false, schema_only: false)
      parameter_set = JSON.parse(File.read(file_path))

      parameter_set['parameters'].each do |parameter|
        params = {
          name: build_parameter_key(environment, parameter['name']),
          description: parameter['description'],
          type: parameter['type'],
          value: schema_only ? ' ' : parameter['value'],
          overwrite: overwrite
        }

        begin
          client.put_parameter(params)
        rescue Aws::SSM::Errors::ParameterAlreadyExists
          puts "#{parameter['name']} already exists in Parameter Store (specify --overwrite to force)"
        else
          puts "#{overwrite ? 'Updating' : 'Adding' } #{parameter['name']} to Parameter Store"
        end
      end
    end

    private

    def client
      @client ||= Aws::SSM::Client.new(region: @region)
    end

    def fetch_parameter_set(environment, parameters = [], token = nil)
      begin
        response = client.get_parameters_by_path(path: parameter_path(environment), recursive: true, with_decryption: true, next_token: token)
        parameters << response.parameters if response.parameters.any?
        if response.next_token
          fetch_parameter_set(environment, parameters, response.next_token)
        else
          parameters.flatten.sort_by(&:name)
        end
      rescue Aws::Errors::MissingCredentialsError
        logger&.warn "Configyour: Unable to fetch parameters without credentials"
        parameters.flatten.sort_by(&:name)
      end
    end

    def parameter_path(environment)
      "/#{parameter_root}/#{environment}"
    end

    def build_parameter_key(environment, name)
      [parameter_path(environment), name].join('/')
    end
  end
end
