# Overrides
before 'deploy:starting', 'configuration:export_local_configuration'
after 'deploy:finishing', 'configuration:import_local_configuration_to_remote', 'drupal:cache_rebuild'