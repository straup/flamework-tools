#!/bin/sh

if test $OSTYPE = "FreeBSD"
then
    WHOAMI=`realpath $0`
elif test $OSTYPE = "darwin"
then
    WHOAMI=`python -c 'import os, sys; print os.path.realpath(sys.argv[1])' $0`
else
    WHOAMI=`readlink -f $0`    
fi

WHEREAMI=`dirname $WHOAMI`
TOOLS=`dirname $WHEREAMI`

PROJECT=$1
PROJET_NAME=`basename ${PROJECT}`

git clone git://github.com/straup/flamework.git ${PROJECT}/

mkdir -p ${PROJECT}/apache

echo "*~" >> ${PROJECT}/.gitignore
echo "*.conf" >> ${PROJECT}/apache/.gitignore

rm -rf ${PROJECT}/.git
rm -f ${PROJECT}/.gitattributes
rm -f ${PROJECT}/README.markdown

rm -rf ${PROJECT}/www/cron
rm -rf ${PROJECT}/docs
rm -rf ${PROJECT}/tests

cp ${PROJECT}/www/include/config.php.example ${PROJECT}/www/include/config.php

# TODO: figure out if sudo is necessary
# sudo chown -R www-data ${PROJECT}/www/templates_c

# deprecated (probably)
# cp -r ${TOOLS}/flamework-bin ${PROJECT}/bin

cp ${TOOLS}/apache/example.conf ${PROJECT}/apache/${PROJECT_NAME}.conf.example
cp ${TOOLS}/apache/example.conf ${PROJECT}/apache/README.md

# in case the user is running out of a sub-directory

cp ${TOOLS}/apache/.htaccess-deny ${PROJECT}/apache/.htaccess
cp ${TOOLS}/apache/.htaccess-deny ${PROJECT}/schema/.htaccess
cp ${TOOLS}/apache/.htaccess-deny ${PROJECT}/bin/.htaccess
cp ${TOOLS}/apache/.htaccess-noindexes ${PROJECT}/.htaccess

# TODO: squirt these in to the config file automatically

COOKIE_SECRET=`php -q ${PROJECT}/bin/generate_secret.php`
CRUMB_SECRET=`php -q ${PROJECT}/bin/generate_secret.php`
PASSWORD_SECRET=`php -q ${PROJECT}/bin/generate_secret.php`

echo "";
echo "\t------------------------------";

echo "\t\$GLOBALS['cfg']['crypto_cookie_secret'] = '${COOKIE_SECRET}';"
echo "\t\$GLOBALS['cfg']['crypto_crumb_secret'] = '${CRUMB_SECRET}';"
echo "\t\$GLOBALS['cfg']['crypto_password_secret'] = '${PASSWORD_SECRET}';"

echo "\t------------------------------";
echo "";