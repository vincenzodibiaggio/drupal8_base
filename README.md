# drupal8 Base

Drupal 8 Base is a fresh and clean repo to begin with a new installation of Drupal 8 but with the Configuration
Management based on the File and not the Database storage. It provide also a Phing build script to create a new
Drupal 8 installation.

Like the official composer-project command provide a starting point for your project but without some crucial files
like `settings.php` and `services.php` that are under version control on official repository.

After the `composer install` you will have all files updated at latest develop version of Drupal, a directory tree free
from any repository (autoclean) and your next project ready to be installed with the Configuration Management based on
file and not database sorage.

## Howto
1. Just clone this repo and launch the `composer install` command
2. Copy the standard build properties file to `build.YOUR_ENV.properties` (ex.: `YOUR_ENV` = `loc`)
3. Fix the properties file with your env values
4. Launch the command `./bin/phing build-app -Denv=YOUR_ENV`
