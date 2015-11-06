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
