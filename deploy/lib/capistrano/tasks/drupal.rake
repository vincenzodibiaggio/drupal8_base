namespace :drupal do
  desc "Drupal cache rebuild"
  task :cache_rebuild do
    domains.each do |domain|
      run "cd #{app_dir}; #{bin_console} --uri=#{domain} cache:rebuild all"
    end
  end
end