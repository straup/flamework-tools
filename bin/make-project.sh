#!/bin/sh

WHOAMI=`readlink -f $0`
WHEREAMI=`dirname $WHOAMI`
TOOLS=`dirname $WHEREAMI`

PROJECT=$1

mkdir -p ${PROJECT}
mkdir -p ${PROJECT}/www

git clone git://github.com/straup/flamework.git ${PROJECT}/www/

rm -rf ${PROJECT}/www/.git
rm -f ${PROJECT}/www/.gitattributes
rm -f ${PROJECT}/www/.gitmodules
rm -f ${PROJECT}/www/README.markdown

rm -rf ${PROJECT}/www/cron
rm -rf ${PROJECT}/www/docs
rm -rf ${PROJECT}/www/tests

cp ${PROJECT}/www/include/config.php.example ${PROJECT}/www/include/config.php

mv ${PROJECT}/www/schema ${PROJECT}/

# sudo chown -R www-data ${PROJECT}/www/templates_c

cp -r ${TOOLS}/flamework-bin ${PROJECT}/bin

# generate a bunch of secrets
# TODO: squirt these in to the config file automatically

php -q ${PROJECT}/bin/generate_secret.php
php -q ${PROJECT}/bin/generate_secret.php
php -q ${PROJECT}/bin/generate_secret.php
