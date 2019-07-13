# yml_datas = YAML::load()
# wechat_config =  File.expand_path("../config/wechat.yml", __FILE__)
wechat_config = Rails.root.join("config", "wechat.yml")
if File.exist?(wechat_config)
  YAML.load_file(wechat_config)["app"].each do |key, value|
    ENV[key.to_s] = value.to_s
  end
end

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :wechat, ENV["wechat_app_id"], ENV["wechat_app_secrets"]
end