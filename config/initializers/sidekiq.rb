Sidekiq.configure_server do |config|
  config.redis = if Rails.env.development? || Rails.env.test?
                   # { url: 'redis://192.168.31.78:6379/0' }
                   { url: 'redis://localhost:6379/0' }
                 else
                   { url: 'redis://localhost:6379/0', password: '34688f5da12d845c99d2fc760fdfbd78a75a808b12ec0a9812cfeac2846cce3ed101d6cbdf05ea0dd47870c95a139e47bbcaefd24761088a08d5053db72bb6ba' }
                 end
end

Sidekiq.configure_client do |config|
  config.redis = if Rails.env.development? || Rails.env.test?
                   # { url: 'redis://192.168.31.78:6379/0' }
                   { url: 'redis://localhost:6379/0' }
                 else
                   { url: 'redis://localhost:6379/0', password: '34688f5da12d845c99d2fc760fdfbd78a75a808b12ec0a9812cfeac2846cce3ed101d6cbdf05ea0dd47870c95a139e47bbcaefd24761088a08d5053db72bb6ba' }
                 end
end
