require_relative "boot"

require "rails"
# Frameworks we use:
require "active_model/railtie"
require "active_record/railtie"
require "active_storage/engine"
require "action_mailer/railtie"
require "action_controller/railtie"
require "rails/test_unit/railtie"
# require "sprockets/railtie"


# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module DesafioNinja
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.1

    # Configuration for the application, engines, and railties goes here.
    config.time_zone = 'Brasilia'

    # Rails doesn't load validators by default, this line make it load
    config.autoload_paths += %W["#{config.root}/lib/validators/"]

    # Only loads a smaller set of middleware suitable for API only apps.
    # Middleware like session, flash, cookies can be added back manually.
    # Skip views, helpers and assets when generating a new resource.
    config.api_only = true
  end
end
