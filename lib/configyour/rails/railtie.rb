module Configyour
  class Railtie < ::Rails::Railtie
    config.before_configuration do
      environment = Configyour.configuration.environment || Rails.env
      logger = Configyour.configuration.logger || Rails.logger

      configyour = Configyour::App.new(parameter_root: Configyour.configuration.parameter_root, logger: logger)

      case Configyour.configuration.mode
      when 'file'
        configyour.generate(environment: environment, file_path: Configyour.configuration.file_path)
      when 'direct'
        configyour.load(environment: environment)
      else
        configyour.generate(environment: environment, file_path: Configyour.configuration.file_path)
      end
    end
  end
end
