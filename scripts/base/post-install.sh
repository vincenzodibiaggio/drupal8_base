#!/bin/sh

# Create symlinks for drush and drupal console.
if [ ! -L web/console ]
  then
    ln -s "../vendor/drupal/console/bin/console" "web/console"
fi
if [ ! -L web/drush8 ]
  then
    ln -s "../vendor/drush/drush/drush" "web/drush8"
fi

# Preparing to enable file storage configuration before installation.
echo "\$settings['bootstrap_config_storage'] = array('Drupal\Core\Config\BootstrapConfigStorageFactory', 'getFileStorage');" >> web/sites/default/settings.php
echo "\$config_directories = array(CONFIG_ACTIVE_DIRECTORY => './../config/active/', CONFIG_STAGING_DIRECTORY => './..//config/staging/',);" >> web/sites/default/settings.php
echo "services:\n  config.storage:\n    class: Drupal\Core\Config\CachedStorage\n    arguments: ['@config.storage.active', '@cache.config']\n  config.storage.active:\n    class: Drupal\Core\Config\FileStorage\n    factory: Drupal\Core\Config\FileStorageFactory::getActive" >> web/sites/default/services.yml

# Replace .gitignore with .gitignore.final"
mv -f .gitignore.final .gitignore

# Remove Git related files and directories
rm -r .git
rm README.md
