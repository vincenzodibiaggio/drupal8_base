<?php
/**
 * This is project's console commands configuration for Robo task runner.
 *
 * @see http://robo.li/
 */

use Symfony\Component\Yaml\Yaml;


class RoboFile extends \Robo\Tasks
{
  private $projectProperties;

  function __construct() {
    $this->projectProperties = $this->getProjectProperties();
  }


  // First build.
  function build() {

    // Drop db.
    $this->_exec('bin/drush sql-drop -y');

    // Download Drupal.
    $this->_exec('bin/drupal site:new /tmp/drupal8 ' . $this->projectProperties['properties']['drupal.version']);
    $this->taskRsync()
      ->fromPath('/tmp/drupal8')
      ->toPath(__DIR__)
      ->archive()
      ->verbose()
      ->compress()
      ->delete()
      ->progress()
      ->humanReadable()
      ->excludeVcs()
      ->exclude('autoload.php')
      ->exclude('composer.json')
      ->exclude('core')
      ->exclude('drush')
      ->exclude('example.gitignore')
      ->exclude('README.txt')
      ->exclude('LICENSE.txt')
      ->exclude('vendor')
      ->exclude('modules')
      ->run();
    $this->_exec('rm -rf /tmp/drupal8');

    // Config directory.
    $this->_exec('mkdir config');
    $this->_exec('mkdir config/active');
    $this->_exec('mkdir config/staging');
    $this->_exec('mkdir config/sync');
    $this->_exec('mkdir -m 777 web/sites/default/files');

    // Append config settings to settings.php and services.yml to manage file configuration.
    $this->taskConcat([
      __DIR__ . '/web/sites/default/default.services.yml.dist',
      __DIR__ . '/base_files/default.services.yml.dist',
    ])
    ->to(__DIR__ . '/web/sites/default/services.yml')
    ->run();

    $this->taskConcat([
      __DIR__ . '/web/sites/default/default.settings.php.dist',
      __DIR__ . '/base_files/default.settings.php.dist',
    ])
    ->to(__DIR__ . '/web/sites/default/settings.php')
    ->run();



    // Drop db.
    $this->_exec('bin/drush sql-drop -y');

    // Install Drupal.
    $this->_exec('bin/drupal site:install ' . $this->projectProperties['params'] . ' ' . $this->projectProperties['properties']['site.profile']);
  }

  // Common functions.
  function composerInstall()
  {
    $this->taskComposerInstall()->run();
  }

  function composerUpdate()
  {
    $this->taskComposerUpdate()->run();
  }

  private function getProjectProperties() {
    // Parse the properties file.
    $properties = Yaml::parse(file_get_contents(__DIR__ . '/properties.yml'));
    $arr_arguments = array(
      '--langcode='     => $properties['site.langcode'],
      '--db-type='      => $properties['db.type'],
      '--db-host='      => $properties['db.host'],
      '--db-name='      => $properties['db.name'],
      '--db-user='      => $properties['db.user.name'],
      '--db-pass='      => $properties['db.user.pass'],
      '--db-prefix='    => $properties['db.prefix'],
      '--db-port='      => $properties['db.port'],
      '--site-name='    => $properties['site.name'],
      '--site-mail='    => $properties['site.mail'],
      '--account-name=' => $properties['site.account.name'],
      '--account-mail=' => $properties['site.account.mail'],
      '--account-pass=' => $properties['site.account.pass'],
      '--env='          => $properties['env'],
      '--root='         => __DIR__ . '/web',
    );

    $params_string = '';
    foreach ($arr_arguments as $key => $value) {
      $params_string .= $key . '"' . $value . '" ';
    }

    return array(
      'properties' => $properties,
      'params' => $params_string,
    );

  }
}
