# config valid only for current version of Capistrano
lock '3.4.0'

set :application, 'drupal8_base'
set :repo_url, 'gitlab@gitlab.sparkfabrik.com:vincenzo.dibiaggio/sparkadmin.git'
set :branch, 'master'

# Local path of application. Needed for some tasks
set :loc_app_path, "/home/vincenzodb/Development/drupal8_base/"

# Remote path where deploy the files.
set :deploy_to, "/REMOTE_FILESYSTEM_DIRECTORY/#{fetch(:application)}/"

# Current release path.
set :current_path, "#{fetch(:deploy_to)}current/"

# Path of application. Tipically where execute commands that need an highter bootstrap level.
set :app_dir, "#{fetch(:current_path)}web"

# Relative path where export configuration files.
# The root of the current release because commands need the application path.
set :export_config_directory, "../"

# Drush configuration (could be overrided on stages.rb)
set :bin_drush, "./../bin/drush"
set :bin_console, "./../bin/console"

set :user, "deploy"

set :use_sudo, true

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
# set :deploy_to, '/var/www/my_app_name'

# Default value for :scm is :git
set :scm, :git
set :scm_verbose, true

# Default value for :format is :pretty
set :format, :pretty

# Default value for :log_level is :debug
set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/secrets.yml')

# Default value for linked_dirs is []
# set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
set :keep_releases, 5

namespace :deploy do

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end
end