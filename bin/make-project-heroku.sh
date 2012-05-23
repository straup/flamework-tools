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

echo "# cloning dependencies"

git clone git://github.com/straup/flamework.git ${PROJECT}/
git clone git://github.com/yandod/phpinfo-heroku ${PROJECT}/phpinfo-heroku/

rm -rf ${PROJECT}/.git
rm -f ${PROJECT}/.gitattributes

rm -rf ${PROJECT}/phpinfo-heroku/.git
rm -f ${PROJECT}/phpinfo-heroku/.gitattributes

echo "# setting up README files"

mv ${PROJECT}/README.md	${PROJECT}/README.FLAMEWORK.md

echo ${HEROKU_NAME} > ${PROJECT}/README.md
echo "--" >> ${PROJECT}/README.md

echo "# removing unnecessary files"

rm -rf ${PROJECT}/www/cron
rm -rf ${PROJECT}/docs
rm -rf ${PROJECT}/tests

echo "# doing the mbstring dance"

mkdir ${PROJECT}/www/heroku/
cp ${PROJECT}/phpinfo-heroku/mbstring.so ${PROJECT}/www/heroku/
cp ${TOOLS}/apache/.htaccess-deny ${PROJECT}/www/heroku/.htaccess

cp ${PROJECT}/phpinfo-heroku/php.ini ${PROJECT}/www/
echo "" >> ${PROJECT}/www/.htaccess
echo "# Heroku stuff" >> ${PROJECT}/www/.htaccess
echo "RewriteRule  ^php.ini	- [R=404,L]" >> ${PROJECT}/www/.htaccess

echo "# setting up config files"

cp ${PROJECT}/www/include/config.php.example ${PROJECT}/www/include/config.php
echo "*~" >> ${PROJECT}/www/.gitignore

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