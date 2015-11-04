#!/bin/sh

mkdir -P config/active
mkdir config/staging
mkdir web
ln -s "../vendor/drush/drush/drush" "web/drush8"
