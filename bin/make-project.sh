#!/bin/sh

WHOAMI=`readlink -f $0`
WHEREAMI=`dirname $WHOAMI`
TOOLS=`dirname $WHEREAMI`

PROJECT=$1

mkdir -p ${PROJECT}
mkdir -p ${PROJECT}/www
mkdir -p ${PROJECT}/apache

git clone git://github.com/straup/flamework.git ${PROJECT}/www/

echo "*~" > ${PROJECT}/.gitignore
echo "*.conf" > ${PROJECT}/apache/.gitignore

rm -rf ${PROJECT}/www/.git
rm -f ${PROJECT}/www/.gitattributes
rm -f ${PROJECT}/www/.gitmodules
rm -f ${PROJECT}/www/README.markdown

rm -rf ${PROJECT}/www/cron
rm -rf ${PROJECT}/www/docs
rm -rf ${PROJECT}/www/tests

cp ${PROJECT}/www/include/config.php.example ${PROJECT}/www/include/config.php

mv ${PROJECT}/www/schema ${PROJECT}/

# TODO: figure out if sudo is necessary
sudo chown -R www-data ${PROJECT}/www/templates_c

cp -r ${TOOLS}/flamework-bin ${PROJECT}/bin

# TODO: squirt in project name/path here

cp ${TOOLS}/apache/example.conf ${PROJECT}/apache/{$PROJECT}.conf.example

# TODO: squirt these in to the config file automatically

COOKIE_SECRET=`php -q ${PROJECT}/bin/generate_secret.php`
CRUMB_SECRET=`php -q ${PROJECT}/bin/generate_secret.php`
PASSWORD_SECRET=`php -q ${PROJECT}/bin/generate_secret.php`

echo "";
echo "\t------------------------------";

echo "\t$GLOBALS['cfg']['crypto_cookie_secret'] = '${COOKIE_SECRET}';"
echo "\t$GLOBALS['cfg']['crypto_crumb_secret'] = '${CRUMB_SECRET}';"
echo "\t$GLOBALS['cfg']['crypto_password_secret'] = '${PASSWORD_SECRET}';"

echo "\t------------------------------";
echo "";