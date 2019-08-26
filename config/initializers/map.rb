map_config = Rails.root.join("config", "map.yml")
if File.exist?(map_config)
  YAML.load_file(map_config)["app"].each do |key, value|
    ENV[key.to_s] = value.to_s
  end
end
