#!/bin/bash

ROOT=$(pwd)

vendor/drush/drush/drush dl drupal-8 --destination=/tmp --drupal-project-rename=drupal-8 --quiet -y

rsync -avz --delete /tmp/drupal-8/ $ROOT/web \
 --exclude=.gitkeep \
 --exclude=autoload.php \
 --exclude=composer.json \
 --exclude=core \
 --exclude=drush \
 --exclude=example.gitignore \
 --exclude=LICENSE.txt \
 --exclude=README.txt \
 --exclude=vendor \
 --exclude=default/files

rm -rf /tmp/drupal-8
