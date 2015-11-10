# Drushistrano
namespace :drushistrano do

  # Namespace that involve Drupal Configuration
  namespace :configuration do

    desc 'Export LOCAL Drupal Configuration to archive'
    task :export_local_configuration do
      on roles(:app) do
        within "#{fetch(:loc_app_path)}" do
          if export_local_config && export_local_config_via_ssh
            execute "cd #{fetch(:loc_app_path)}; #{fetch(:bin_console)} config:export #{fetch(:export_config_directory)}"
          end
        end
      end
    end

    desc 'Export REMOTE Drupal Configuration to archive'
    task :export_remote_configuration do
      on roles(:app) do
        within current_path do
          execute "cd #{fetch(:app_dir)}; #{fetch(:bin_console)} config:export #{fetch(:export_config_directory)}"
        end
      end
    end

    desc 'Import exported Drupal Configuration into remote from archive'
    task :import_local_configuration_to_remote do
      on roles(:app) do
        within current_path do
          if export_local_config
            # Abort if configuration file do not exist.
            abort 'Configuration archive do not exist' unless test("[ -f #{current_path}/config.tar.gz} ]")
            execute "cd #{fetch(:app_dir)}; #{fetch(:bin_console)} config:import #{fetch(:export_config_directory)}"
            execute "cd #{fetch(:export_config_directory)}; rm config.tar.gz"
          else
            puts 'Configuration not updated because esported file do not exist.'
            puts 'It\'s ok for first deploy or if you haven\'t exported from your local env'
          end
        end
      end
    end
  end

  # Namespace that involve Drupal App
  namespace :drupal do

    desc "Drupal cache rebuild"
    task :cache_rebuild do
      on roles(:app) do
        fetch(:domains).each do |domain|
          execute "cd #{fetch(:app_dir)}; #{fetch(:bin_console)} --uri=#{domain} cache:rebuild all"
        end
      end
    end
  end

  # Namespace that involve Composer
  # @TODO Integrate Composer gem
  namespace :composer do
    desc "Composer install"
    task :install do
      on roles(:app) do
        execute "cd #{fetch(:current_path)}; #{fetch(:bin_composer)} install"
      end
    end

    desc "Composer update"
    task :update do
      on roles(:app) do
        execute "cd #{fetch(:current_path)}; #{fetch(:bin_composer)} update"
      end
    end
  end

  # Namespace that involve Phing builds
  namespace :phing do
    desc "Build"
    task :build do
      on roles(:app) do
        execute "cd #{fetch(:current_path)}; #{fetch(:bin_phing)} build-app -Denv=#{fetch(:stage)}"
      end
    end

    desc "CI"
    task :ci do
      on roles(:app) do
        execute "cd #{fetch(:current_path)}; #{fetch(:bin_phing)} ci-app -Denv=#{fetch(:stage)}"
      end
    end
  end

  # namespace :install do
  #   desc "Install app"
  #   task :do do
  #     on roles(:app) do
  #       :deploy

  #       # invoke 'drushistrano:composer:install'
  #       invoke 'drushistrano:phing:build'
  #       invoke 'drushistrano:files:copy_to_shared'
  #     end
  #   end

  #   desc "CI app"
  #   task :ci do
  #     on roles(:app) do
  #       # invoke 'drushistrano:composer:update'
  #       invoke 'drushistrano:phing:ci'
  #     end
  #   end
  # end

  namespace :files do

    desc 'Touches linked files/dir (first deploy safe)'
    task :touch do
      on release_roles :all do
        within shared_path do
          fetch(:linked_files, []).each do |file|
            info "Making sure dir exists: #{File.dirname(file)}"
            execute :mkdir, '-p', File.dirname(file)
            execute :touch, file
            info "Touched: #{file}"
          end
        end
      end
    end

    before 'deploy:check:make_linked_dirs', 'drushistrano:files:touch'
    before 'deploy:check:linked_files', 'drushistrano:files:touch'
  end

  # Namespace that build the project and CI
  namespace :build do
    desc "Install app"
    task :do do
      on roles(:app) do
        invoke 'deploy'

        invoke 'drushistrano:composer:install'
        invoke 'drushistrano:phing:build'
      end
    end

    desc "CI app"
    task :ci do
      on roles(:app) do
        invoke 'deploy'

        invoke 'drushistrano:composer:update'
        invoke 'drushistrano:phing:ci'
      end
    end
  end
end
