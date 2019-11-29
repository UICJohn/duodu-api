source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.0'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
# gem 'rails', '~> 5.2.2', '>= 5.2.2.1'
gem 'rails', github: 'rails/rails'
# Use sqlite3 as the database for Active Record
gem 'pg'

# Use Puma as the app server
gem 'puma', '~> 4.2.1'

gem 'devise-jwt'
# gem 'devise'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder

gem 'jbuilder', '~> 2.9.1'

# Use Redis adapter to run Action Cable in production
gem 'redis'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.5', require: false

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
# gem 'rack-cors'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'parallel_tests', group: :development
  gem 'rubocop', require: false
  gem 'rubocop-performance'
  gem 'rubocop-rails'
  gem 'rubocop-rspec'
end

group :development do
  gem 'listen', '>= 3.2.0'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'capistrano', '~> 3.11.2', require: false
  gem 'capistrano-bundler'
  gem 'capistrano-rails', '~> 1.4', require: false
  gem 'capistrano-rvm'
  gem 'capistrano-sidekiq', github: 'seuros/capistrano-sidekiq'
  gem 'capistrano3-puma'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.1'
end

group :test do
  gem 'factory_bot_rails'
  gem 'mock_redis'
  gem 'rspec-rails'
  gem 'rspec-sidekiq'
end

# # Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

gem 'sidekiq'

gem 'redis-rails'

gem 'devise-async'

gem 'kaminari'

gem 'searchkick'

gem 'countries', require: 'countries/global'

gem 'aliyun-sms'

gem 'rack-cors'

gem 'exception_notification'

gem 'globalize'

gem 'omniauth-wechat-oauth2'

gem 'hiredis'

gem 'aliyun-sdk'

gem 'activestorage-aliyun'

gem 'strip_attributes'

gem 'active_storage_validations', github: 'igorkasyanchuk/active_storage_validations'

gem 'geocoder'

gem 'whenever', :require => false