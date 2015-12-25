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

  // Build.
  function build() {

    // Download Drupal.
    $this->_exec('bin/drupal site:new drupalcore ' . $this->projectProperties['properties']['drupal.version']);
    $this->taskRsync()
      ->fromPath('drupalcore/')
      ->toPath(__DIR__ . '/web/')
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
      ->exclude('sites/default/')
      ->run();
    $this->_exec('rm -rf drupalcore');

    // Config directory.
    $this->_exec('rm -r ' .  __DIR__ . '/config');
    $this->_exec('mkdir ' .  __DIR__ . '/config');
    $this->_exec('mkdir ' .  __DIR__ . '/config/active');
    $this->_exec('mkdir ' .  __DIR__ . '/config/staging');
    $this->_exec('mkdir ' .  __DIR__ . '/config/sync');
    $this->_exec('mkdir -m 777 ' .  __DIR__ . '/web/sites/default/files');

    // Config files.
    $this->_exec('chmod 755 ' .  __DIR__ . '/web/sites/default/');
    $this->_exec('chmod 755 ' .  __DIR__ . '/web/sites/default/services.yml');
    $this->_exec('chmod 755 ' .  __DIR__ . '/web/sites/default/settings.php');
    $this->_exec('rm ' .  __DIR__ . '/web/sites/default/services.yml');
    $this->_exec('rm ' .  __DIR__ . '/web/sites/default/settings.php');

    // Append config settings to settings.php and services.yml to manage file configuration.
    $this->taskConcat([
      __DIR__ . '/web/sites/default/default.services.yml',
      __DIR__ . '/base_files/default.services.yml.dist',
    ])
      ->to(__DIR__ . '/web/sites/default/services.yml')
      ->run();

    $this->taskConcat([
      __DIR__ . '/web/sites/default/default.settings.php',
      __DIR__ . '/base_files/default.settings.php.dist',
    ])
      ->to(__DIR__ . '/web/sites/default/settings.php')
      ->run();

    $this->taskReplaceInFile(__DIR__ . '/web/sites/default/settings.php')
      ->from('%%SETTINGS_INSTALL_PROFILE%%')
      ->to($this->projectProperties['properties']['site.profile'])
      ->run();

    // Drop db.
    $dropString = 'mysqldump -u ' . $this->projectProperties['properties']['db.user.name'] . ' -p' . $this->projectProperties['properties']['db.user.pass'];
    $dropString .= ' ' . $this->projectProperties['properties']['db.name'] . ' --no-data -h ' . $this->projectProperties['properties']['db.host'];
    $dropString .= ' -P ' . $this->projectProperties['properties']['db.port'];
    $dropString .=' | grep ^DROP | mysql -u ';
    $dropString .=  $this->projectProperties['properties']['db.user.name'] . ' -p' . $this->projectProperties['properties']['db.user.pass'];
    $dropString .= ' -h ' . $this->projectProperties['properties']['db.host'];
    $dropString .= ' -P ' . $this->projectProperties['properties']['db.port'];
    $dropString .= ' --one-database ' . $this->projectProperties['properties']['db.name'];
    $this->_exec($dropString);

    // Install Drupal.
    $this->_exec('bin/drupal site:install ' . $this->projectProperties['params'] . ' ' . $this->projectProperties['properties']['site.profile'])->stopOnFail();

    // Update dependencies.
    $this->taskComposerUpdate()->run();

    // Contrib modules.
    $this->installContribModules();

    // Languages.
    $this->enableLanguages();

    // Custom modules.
    $this->installCustomModules();

    $this->say('Build complete');
  }

  private function getProjectProperties() {
    // Parse the properties file.
    $properties = Yaml::parse(file_get_contents(__DIR__ . '/properties.yml'));

    $properties['root'] = __DIR__ . '/' . $properties['root'];

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
      '--root='         => $properties['root'],
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

  // Enable languages.
  private function enableLanguages() {
    foreach ($this->projectProperties['properties']['languages'] as $language) {
      $this->_exec('bin/drupal locale:language:add --root=' . $this->projectProperties['properties']['root'] . ' -e=' . $this->projectProperties['properties']['env'] . ' ' . $language)->stopOnFail();
    }
  }

  // Install contrib modules.
  private function installContribModules() {
    foreach ($this->projectProperties['properties']['modules']['contrib'] as $module) {
      $this->_exec('bin/drupal module:install --root=' . $this->projectProperties['properties']['root'] . ' -e=' . $this->projectProperties['properties']['env'] . ' ' . $module)->stopOnFail();
    }
  }

  // Install custom modules.
  private function installCustomModules() {
    foreach ($this->projectProperties['properties']['modules']['custom'] as $module) {
      $this->_exec('bin/drupal module:install --root=' . $this->projectProperties['properties']['root'] . ' -e=' . $this->projectProperties['properties']['env'] . ' --overwrite-config ' . $module)->stopOnFail();
    }
  }
}