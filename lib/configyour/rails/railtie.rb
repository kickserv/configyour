module Configyour
  class Railtie < ::Rails::Railtie
    config.before_configuration do
      configyour = Configyour::App.new(parameter_root: Configyour.configuration.parameter_root)

      case Configyour.configuration.mode
      when 'file'
        configyour.generate(environment: Configyour.configuration.environment || Rails.env, file_path: Configyour.configuration.file_path)
      when 'direct'
        configyour.load(environment: Configyour.configuration.environment || Rails.env)
      else
        configyour.generate(environment: Configyour.configuration.environment || Rails.env, file_path: Configyour.configuration.file_path)
      end
    end
  end
end
