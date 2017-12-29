module Configyour
  class Railtie < ::Rails::Railtie
    config.before_configuration do
      Configyour::App.new(name: Configyour.configuration.application_name).generate(environment: Configyour.configuration.environment || Rails.env, file_path: Configyour.configuration.file_path)
    end
  end
end
