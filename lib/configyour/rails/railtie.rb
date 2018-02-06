module Configyour
  class Railtie < ::Rails::Railtie
    config.before_configuration do
      configyour = Configyour::App.new(Configyour.configuration.parameter_root)

      case Configyour.configuration.mode
      when 'file'
        configyour.generate(Configyour.configuration.file_path, Configyour.configuration.environment || Rails.env)
      when 'direct'
        configyour.load(Configyour.configuration.environment || Rails.env)
      else
        configyour.generate(Configyour.configuration.file_path, Configyour.configuration.environment || Rails.env)
      end
    end
  end
end
