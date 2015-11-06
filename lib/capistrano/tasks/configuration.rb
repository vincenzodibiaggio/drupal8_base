# Namespace that involve Drupal Configuration
namespace :configuration do

  desc 'Export LOCAL Drupal Configuration to archive'
  task :export_local_configuration do
    on roles(:app) do
      within "#{fetch(:loc_app_dir)}" do
        execute "cd #{fetch(:loc_app_dir)}#{fetch(:app_dir)}; #{fetch(:bin_console)} config:export #{fetch(:export_config_directory)}"
      end
    end
  end

  desc 'Export REMOTE Drupal Configuration to archive'
  task :export_remote_configuration do
    on roles(:app) do
      within current_path do
        puts "------------------------- #{current_path} #{:app_dir}"
        puts release_path
        execute "cd #{fetch(:app_dir)}; #{fetch(:bin_console)} config:export #{fetch(:export_config_directory)}"
      end
    end
  end

  desc 'Import exported Drupal Configuration into remote from archive'
  task :import_configuration do
    on roles(:app) do
      within release_path.join(fetch(:app_dir)) do
        # execute "cd #{fetch(:app_dir)}; #{fetch(:bin_console)} config:import #{fetch(:export_config_directory)}"
      end
    end
  end
end
