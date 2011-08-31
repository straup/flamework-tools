#!/bin/sh

WHOAMI=$0
WHEREAMI=`dirname $WHOAMI`

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

# sudo chown -R www-data ${PROJECT}/www/templates_c

