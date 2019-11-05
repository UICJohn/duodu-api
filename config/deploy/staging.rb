set :port, 22
# set :pty,             true
set :user, 'deploy'
set :deploy_via, :remote_cache
set :use_sudo, false
set :branch, 'develop'

server '47.92.125.75',
       roles: %i[web app db sidekiq],
       port: fetch(:port),
       user: fetch(:user),
       primary: true

set :rails_env, 'staging'
set :conditionally_migrate, true

set :deploy_to, "/home/#{fetch(:user)}/#{fetch(:application)}"

set :puma_user, 'deploy'
set :ssh_options,
    forward_agent: true,
    auth_methods: %w[publickey],
    user: fetch(:user)

# namespace :config do
#   desc "upload config file after deploy"
#   task :upload do
#     on roles([:web, :db]) do |host|
#       upload!("config/storage.yml", "#{shared_path}/config/storage.yml")
#       upload!("config/wechat.yml", "#{shared_path}/config/wechat.yml")
#       upload!("config/map.yml", "#{shared_path}/config/map.yml")
#       upload!("config/master.key", "#{shared_path}/config/master.key")
#       upload!("config/master.key", "#{shared_path}/config/master.key")
#     end
#   end
# end
