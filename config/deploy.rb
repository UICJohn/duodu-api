# config valid for current version and patch releases of Capistrano
lock '~> 3.11.0'

set :application, 'duodu-api'
set :repo_url, 'git@github.com:UICJohn/duodu-api.git'

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
# set :deploy_to, "/home/deploy/duodu"

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# append :linked_files, "config/database.yml"

# Default value for linked_dirs is []
# append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system"

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for local_user is ENV['USER']
# set :local_user, -> { `git config user.name`.chomp }

# Default value for keep_releases is 5
# set :keep_releases, 5

# Uncomment the following to require manually verifying the host key before first deploy.
# set :ssh_options, verify_host_key: :secure
set :puma_init_active_record, true

set :linked_dirs, %w[log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system]

set :linked_files, %w[config/database.yml config/master.key config/map.yml config/wechat.yml config/storage.yml]

set :sidekiq_config, 'config/sidekiq.yml'

namespace :deploy do
  desc "Update crontab with whenever"
    task :update_cron do
      on roles(:app) do
        within current_path do
          execute :bundle, :exec, "whenever --update-crontab #{fetch(:application)}"
        end
      end
    end
  end
  after :restart, 'sidekiq:restart'
  after :restart, 'puma:restart'
  after :finishing, 'deploy:update_cron'
end
