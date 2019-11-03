ENV['ELASTICSEARCH_URL'] = if Rails.env.production?
                             'http://192.168.3.1:9200'
                           elsif Rails.env.staging?
                             'http://localhost:9200'
                           else
                             'http://192.168.31.78:9200'
                           end
