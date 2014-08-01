require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module AgbApplication
  class Application < Rails::Application
    config.middleware.use Rack::JSONP
    config.middleware.use Rack::Cors do
      allow do
        origins '*'
        resource '*', 
          headers: :any,
          methods: [:get, :post, :put, :delete]
      end
    end
  end
end
