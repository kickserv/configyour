begin
  require 'rails'
rescue LoadError
else
  require 'configyour/rails/railtie'
end
