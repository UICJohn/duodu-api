# Load the Rails application.
require_relative 'application'

# Initialize the Rails application.
Rails.application.initialize!

if Rails.env.development?
  Rails.application.routes.default_url_options[:host] = 'localhost'
end
