require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module DemoAdisonPublisher
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    # Rails.logger = Logger.new(STDOUT)
    # config.logger = ActiveSupport::Logger.new("log/#{Rails.env}.log")
    # config.log_level = :debug
    # config.active_record.query_log_tags_enabled = true

    config.autoload_paths << "#{Rails.root}/lib"
    config.time_zone = "Asia/Seoul"
  end
end
