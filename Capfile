# default deploy_config_path is 'config/deploy.rb'
set :deploy_config_path, 'deploy/deploy.rb'
set :stage_config_path, 'deploy/stages'

# Load DSL and set up stages
require 'capistrano/setup'

# Include default deployment tasks
require 'capistrano/deploy'

# Include tasks from other gems included in your Gemfile
#
# For documentation on these, see for example:
#
#   https://github.com/capistrano/rvm
#   https://github.com/capistrano/rbenv
#   https://github.com/capistrano/chruby
#   https://github.com/capistrano/bundler
#   https://github.com/capistrano/rails
#   https://github.com/capistrano/passenger
#
# require 'capistrano/rvm'
# require 'capistrano/rbenv'
# require 'capistrano/chruby'
# require 'capistrano/bundler'
# require 'capistrano/rails/assets'
# require 'capistrano/rails/migrations'
# require 'capistrano/passenger'

# Loads custom tasks from `lib/capistrano/tasks' if you have any defined.
Dir.glob('deploy/lib/capistrano/tasks/*.rb').each { |r| import r }
Dir.glob('deploy/lib/capistrano/**/*.rb').each { |r| import r }