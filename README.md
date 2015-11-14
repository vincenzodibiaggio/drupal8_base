# drupal8 Base

Drupal 8 Base is a fresh and clean repo to begin with a new installation of Drupal 8 but with the Configuration
Management based on the File and not the Database storage. It provide also a Phing build script to create a new
Drupal 8 installation.

Like the official composer-project command provide a starting point for your project but without some crucial files
like `settings.php` and `services.php` that are under version control on official repository.

After the `composer install` you will have all files updated at latest develop version of Drupal, a directory tree free
from any repository (autoclean) and your next project ready to be installed with the Configuration Management based on
file and not database sorage.

## Requirements
1. Capistrano v3

## Howto
1. Just clone this repo and launch the `cap install STAGES=loc,stage,prod` command
2. Copy the standard build properties file to `build.loc.properties`
3. Fix the properties file with your env values
4. Launch the command `./bin/phing build-app -Denv=loc`
2. Update infos in the files `deploy/stages/*.dist` and save them without `dist` file extension (one file for env)
3. Launch the command `cap drushistano:build:do`
4. This command, launched for the first time, ends with an error because we need to
5. Update the file `build.ENV.properties` in your env server. This file contains confidential infos that should not be
saved under version control.
6. Relaunch the command `cap drushistano:build:do`
7. For CI provisioning/builds, launch the `cap drushistrano:build:ci` command.
