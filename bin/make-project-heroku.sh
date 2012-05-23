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

echo "cloning dependencies"
echo "------------------------------";

git clone git://github.com/straup/flamework.git ${PROJECT}/
git clone git://github.com/yandod/phpinfo-heroku ${PROJECT}/phpinfo-heroku/

rm -rf ${PROJECT}/.git
rm -f ${PROJECT}/.gitattributes

rm -rf ${PROJECT}/phpinfo-heroku/.git
rm -f ${PROJECT}/phpinfo-heroku/.gitattributes

echo "setting up README files"
echo "------------------------------";

mv ${PROJECT}/README.md	${PROJECT}/README.FLAMEWORK.md

echo ${HEROKU_NAME} > ${PROJECT}/README.md
echo "--" >> ${PROJECT}/README.md

echo "removing unnecessary files"
echo "------------------------------";

rm -rf ${PROJECT}/www/cron
rm -rf ${PROJECT}/docs
rm -rf ${PROJECT}/tests

echo "doing the mbstring dance"
echo "------------------------------";

mkdir ${PROJECT}/www/heroku/
cp ${PROJECT}/phpinfo-heroku/mbstring.so ${PROJECT}/www/heroku/
cp ${TOOLS}/apache/.htaccess-deny ${PROJECT}/www/heroku/.htaccess

echo "extension=/app/www/heroku/mbstring.so" > ${PROJECT}/www/php.ini

echo "" >> ${PROJECT}/www/.htaccess
echo "# Heroku stuff" >> ${PROJECT}/www/.htaccess
echo "RewriteRule  ^php.ini	- [R=404,L]" >> ${PROJECT}/www/.htaccess

echo "setting up config files"
echo "------------------------------";

cp ${PROJECT}/www/include/config.php.example ${PROJECT}/www/include/config.php
echo "*~" >> ${PROJECT}/www/.gitignore

${TOOLS}/bin/configure-secrets.sh ${PROJECT}

echo "all done";
echo "------------------------------";
echo "your flamework project is ready to be uploaded to Heroku in:"
echo "\t${PROJECT}/www/";
echo ""

# http://www.gravitywell.co.uk/blog/post/deploying-php-apps-to-heroku

echo "that's work you'll need to do yourself, for example:";
echo "------------------------------";
echo "$> cd ${PROJECT}/www"
echo "$> git init";
echo "$> git add .";
echo "$> git commit -m 'initial commit'";
echo "$> heroku create --stack cedar";
echo "$> git push heroku master"
echo "";