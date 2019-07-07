set :port, 22
# set :pty,             true
set :user, 'ubuntu'
set :deploy_via, :remote_cache
set :use_sudo, false
set :branch, 'master'

server '129.28.32.202',
  roles: [:web, :app, :db, :sidekiq],
  port: fetch(:port),
  user: fetch(:user),
  primary: true

set :rails_env, 'staging'
set :conditionally_migrate, true

set :deploy_to,       "/home/#{fetch(:user)}/#{fetch(:application)}"

set :puma_user, 'ubuntu'
set :ssh_options, {
  forward_agent: true,
  auth_methods: %w(publickey),
  user: fetch(:user),
}