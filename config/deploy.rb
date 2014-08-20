require 'pry'
require 'capistrano/rbenv'
require 'capistrano/bundler'
require 'capistrano/rails/assets'
require 'capistrano/rails/migrations'
# config valid only for Capistrano 3.1
lock '3.2.0'

application = 'soyuz'
server '109.120.166.48', roles: [:web, :app, :db, :workers], ssh_options: {
  user: "deploy",
  forward_agent: true
}
set :user, 'deploy'
set :application, 'soyuz'

set :repo_url, 'git@github.com:pozitive/soyuz.git'

set :default_environment, { 'PATH' => '$HOME/.rbenv/shims:$HOME/.rbenv/bin:$PATH' }
set :rbenv_type, :user # or :system, depends on your rbenv setup
set :rbenv_ruby, '2.1.0'
set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"
set :rbenv_map_bins, %w{rake gem bundle ruby rails}
set :rbenv_roles, :all # default value

# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }

# Default deploy_to directory is /var/www/my_app
set :deploy_to, "/home/deploy/apps/soyuz"
set :deploy_via, :remote_cache

# Default value for :scm is :git
set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# set :linked_files, %w{config/database.yml}

# Default value for linked_dirs is []
# set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

set(:executable_config_files, %w(
  unicorn_init.sh
))

after "deploy", "deploy:cleanup"

namespace :deploy do
  %w[start stop].each do |command|
    desc "#{command} unicorn server"
    task command  do
      on roles(:app) do
        execute "/etc/init.d/unicorn_#{application} #{command}"
      end
    end
  end

  task :graceful_stop do
    on roles(:app) do
      execute "lsof /tmp/unicorn.soyuz.sock | sed -n '2p' | awk '{print $2}' | xargs kill -QUIT"
    end
  end

  task :setup_config do
    on roles(:app) do
      sudo "ln -nfs #{current_path}/config/nginx.conf /etc/nginx/sites-enabled/soyuz"
      sudo "ln -nfs #{current_path}/config/unicorn_init.sh /etc/init.d/unicorn_soyuz"
      execute "mkdir -p #{current_path}/tmp/pids"
      execute "mkdir -p #{shared_path}/config"
    end
  end

  task :symlink_config do
    on roles(:app) do
      execute "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
    end
  end

  after :publishing, :restart

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

end
