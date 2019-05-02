set :port, 22
# set :pty,             true
set :user, 'deploy'
set :deploy_via, :remote_cache
set :use_sudo, false
set :branch, 'master'

server '165.22.254.102',
  roles: [:web, :app, :db, :sidekiq],
  port: fetch(:port),
  user: fetch(:user),
  primary: true

set :rails_env, :staging
set :conditionally_migrate, true

set :deploy_to,       "/home/#{fetch(:user)}/#{fetch(:application)}"

set :puma_user, 'deploy'
set :ssh_options, {
  forward_agent: true,
  auth_methods: %w(publickey),
  user: fetch(:user),
}