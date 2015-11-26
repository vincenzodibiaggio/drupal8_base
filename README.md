# drupal8 Base

Drupal 8 Base is a fresh and clean repo to begin with a new installation of Drupal 8 but with the Configuration
Management based on the File and not the Database storage. It provide also a Phing build script to create a new
Drupal 8 installation.

Like the official composer-project command provide a starting point for your project but without some crucial files
like `settings.php` and `services.php` that are under version control on official repository.

After the `composer install` you will have all files updated at latest develop version of Drupal, a directory tree free
from any repository (autoclean) and your next project ready to be installed.

This repo assumes that we have 3 environments: loc (local development), stage, production and provides basic config files
to manage them differences.

## Requirements
1. Capistrano v3 - capistranorb.com
2. Composer - getcomposer.org

## Starting point (loc).
1. Just clone this repo and launch `composer install`.
2. Copy the `build.loc.properties.dist` file to `build.loc.properties` and replace default values with your env values.
3. Launch the command `./bin/phing build-app -Denv=loc`.
4. Init a git repo, then commit and push the code.

### At this point we have a clean installation of Drupal 8

4. Just develop.
5. Export the configuration from Home - Configuration - Configuration synchronization.
6. Rename the exported package to config.tar.gz and place it in the root project.
7. Git commit + push.

### At this we need to move code and config to stage and Drushistrano 2 will help us.

7. Copy the `build.stage.properties.dist` file to `build.stage.properties` and replace default values with your env values.
8. Update infos in the files `deploy/stages/*.dist` and `deploy/deploy.rb.dist` (look the pharagraph `Capistrano settings`) and save them without `dist` file extension (one file for env. Loc env is
needed only for maintenance tasks).
9. Git commit + push.
10. Launch the command `cap stage drushistano:build:do`
11. This command, launched for the first time, ends with an error because we need to
12. Update the file `build.stage.properties.dist` in your env server. This file contains confidential infos that should not be
saved under version control.
13. Relaunch the command `cap drushistano:build:do`
14. For CI provisioning/builds, launch the `cap drushistrano:build:ci` command.

### At this we need to move code and config to production and Drushistrano 2 will help us.
15. Repeat the points from 9 to 14 and pray :)

## Capistrano settings

Some settings will be overwrited by `deploy/stages/ENV.rb` files, pay attention.

### deploy/deploy.rb
REPO_URL - the url of the repository used to get the project code.
YOUR_LOCAL_PROJECT_PATH - Root path of the project
YOUR_REMOTE_PROJECT_PATH - Remote root path of the project

### settings of `deploy/stages/ENV.rb`

YOUR_STAGE_USER - Remote user used to make the deploy.
YOUR_STAGE_APP_PATH - Root path of the project.
YOUR_STAGE_HOST - Your stage host.

## Common commands

# `./bin/phing build-app -Denv=loc` - Build the local project from scratch and erase all data from the database.
# `./bin/phing build-app -Denv=loc -Dci=true` - Update project dependencies and import the configuration without erase data.
# `cap ENV drushistano:build:do` - Publish and build the project to the ENV environment (ERASE ALL THE DATA)
# `cap ENV drushistano:build:ci` - Publish and update the dependencies of the project to the ENV environment.