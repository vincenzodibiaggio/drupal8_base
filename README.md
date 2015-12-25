# drupal8 Base

Drupal 8 Base is a fresh and clean repo to begin with a new installation of Drupal 8 but with the Configuration
Management based on the File and not the Database storage. It provide also a Robofile to create a new
Drupal 8 installation.

Like the official composer-project command provide a starting point for your project but without some crucial files
like `settings.php` and `services.php` that are under version control on official repository.

After the `composer install` you will have all files updated at latest develop version of Drupal, a directory tree free
from any repository (autoclean) and your next project ready to be installed.

## Requirements
1. mysql client (mysql CLI)
2. Composer - http://getcomposer.org

## Starting point (loc).
1. Just clone this repo and launch `composer install`
2. Copy the `properties.yml.dist` file to `properties.yml` and replace default values with your env values.
3. Launch the command `bin/robo build`.
4. Init a git repo, then commit and push the code.
