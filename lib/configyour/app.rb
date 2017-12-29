require 'aws-sdk-ssm'

module Configyour
  class App

    def initialize(name: Configyour.configuration.application_name, region: Configyour.configuration.region)
      @name = name
      @region = region
    end

    def generate(file_path: Configyour.configuration.file_path, environment: Configyour.configuration.environment, rebuild: Configyour.configuration.rebuild)
      return unless @name
      return if File.exist?(file_path) && !rebuild

      config_hash = {}

      parameter_set = fetch_parameter_set(environment)

      parameter_set.each do |param|
        config_hash[param.name.split('/').last.upcase] = param.value
      end

      File.open(file_path, 'w') { |file| file.write(config_hash.to_yaml) }
    end

    private

    def client
      @client ||= Aws::SSM::Client.new(region: @region)
    end

    def fetch_parameter_set(environment, parameters = [], token = nil)
      response = client.get_parameters_by_path(path: "/#{@name}/#{environment}", recursive: true, with_decryption: true, next_token: token)
      parameters << response.parameters if response.parameters.any?
      if response.next_token
        fetch_parameter_set(environment, parameters, response.next_token)
      else
        parameters.flatten.sort_by(&:name)
      end
    end
  end
end
