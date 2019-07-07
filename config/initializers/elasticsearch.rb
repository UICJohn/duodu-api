if Rails.env.production?
  ENV["ELASTICSEARCH_URL"] = "http://192.168.3.1:9200"
elsif Rails.env.staging?
  ENV["ELASTICSEARCH_URL"] = "http://192.168.3.4:9200"
else
  ENV["ELASTICSEARCH_URL"] = "http://localhost:9200"
end