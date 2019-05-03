Sidekiq.configure_server do |config|
  if Rails.env.development?
    config.redis = { url: 'redis://192.168.0.8:6379/0' }
  else
    config.redis = { url: 'redis://localhost:6379/0', password: '34688f5da12d845c99d2fc760fdfbd78a75a808b12ec0a9812cfeac2846cce3ed101d6cbdf05ea0dd47870c95a139e47bbcaefd24761088a08d5053db72bb6ba'}
  end
end

Sidekiq.configure_client do |config|
  if Rails.env.development?
    config.redis = { url: 'redis://192.168.0.8:6379/0' }
  else
    config.redis = { url: 'redis://localhost:6379/0', password: '34688f5da12d845c99d2fc760fdfbd78a75a808b12ec0a9812cfeac2846cce3ed101d6cbdf05ea0dd47870c95a139e47bbcaefd24761088a08d5053db72bb6ba'}
  end
end