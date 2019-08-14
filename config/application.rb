require_relative 'boot'

require 'action_cable/engine'
require 'action_controller/railtie'
require 'rails/test_unit/railtie'
require 'sprockets/railtie'


# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module AirportHangoutFrontend
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    # Add app to load path to get our custom "non-MVC" code
    config.autoload_paths += %W(#{config.root}/app/)

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
  end
end
