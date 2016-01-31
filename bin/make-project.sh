#!/bin/sh

WHOAMI=`python -c 'import os, sys; print os.path.realpath(sys.argv[1])' $0`

WHEREAMI=`dirname $WHOAMI`
TOOLS=`dirname $WHEREAMI`

PROJECT=$1
PROJECT_NAME=`basename ${PROJECT}`

echo "cloning dependencies"
echo "------------------------------";

git clone https://github.com/whosonfirst/flamework.git ${PROJECT}/

echo "configuting git things"
echo "------------------------------";

echo "*~" >> ${PROJECT}/.gitignore
rm -rf ${PROJECT}/.git
rm -f ${PROJECT}/.gitattributes

echo "setting up README files"
echo "------------------------------";

echo ${PROJECT_NAME} > ${PROJECT}/README.md
echo "--" >> ${PROJECT}/README.md

echo "removing unnecessary files"
echo "------------------------------";

rm -rf ${PROJECT}/www/cron
rm -rf ${PROJECT}/docs
rm -rf ${PROJECT}/tests
rm -f ${PROJECT}/.travis.yml
rm -f ${PROJECT}/Vagrantfile
rm -f ${PROJECT}/LICENSE
rm -f ${PROJECT}/www/paging.php
rm -f ${PROJECT}/www/templates/page_paging.txt

# TODO: figure out if sudo is necessary
# sudo chown -R www-data ${PROJECT}/www/templates_c

echo "setting up apache files"
echo "------------------------------";

mkdir -p ${PROJECT}/apache
echo "*.conf" >> ${PROJECT}/apache/.gitignore

cp ${TOOLS}/apache/example.conf ${PROJECT}/apache/${PROJECT_NAME}.conf.example

perl -p -i -e "s/__PROJECT_ROOT__/${PROJECT}/" ${PROJECT}/apache/${PROJECT_NAME}.conf.example
perl -p -i -e "s/__PROJECT_NAME__/${PROJECT_NAME}/" ${PROJECT}/apache/${PROJECT_NAME}.conf.example

echo "cloning ubuntu utilities"
echo "------------------------------";

cp -r ${TOOLS}/ubuntu $PROJECT}/

echo "setting up .htaccess files"
echo "------------------------------";

cp ${TOOLS}/apache/.htaccess-deny ${PROJECT}/apache/.htaccess
cp ${TOOLS}/apache/.htaccess-deny ${PROJECT}/schema/.htaccess
cp ${TOOLS}/apache/.htaccess-deny ${PROJECT}/bin/.htaccess
cp ${TOOLS}/apache/.htaccess-noindexes ${PROJECT}/.htaccess

echo "setting up (application) config files"
echo "------------------------------"

cp ${PROJECT}/www/include/secrets.php.example ${PROJECT}/www/include/secrets.php
# rm ${PROJECT}/www/include/secrets.php.example

echo "all done";
echo "------------------------------"
echo ""
