Sidekiq.configure_server do |config|
  config.redis = { url: 'redis://192.168.0.8:6379/0' }
end

Sidekiq.configure_client do |config|
  config.redis = { url: 'redis://192.168.0.8:6379/0' }
end