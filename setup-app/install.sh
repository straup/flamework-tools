#!/bin/sh
ROOT=$1

mkdir -p ${ROOT}

cd ${ROOT}
git init

git submodule add git@github.com:exflickr/flamework.git ${ROOT}ext/flamework

# directories

mkdir -p ${ROOT}schema
mkdir -p ${ROOT}config

mkdir -p ${ROOT}www/include
mkdir -p ${ROOT}www/images
mkdir -p ${ROOT}www/javascript

cp -r ${ROOT}/ext/flamework/css ${ROOT}www/
cp -r ${ROOT}/ext/flamework/templates ${ROOT}www/
cp -r ${ROOT}/ext/flamework/templates_c ${ROOT}www/

echo "Don't forget to make sure ${ROOT}www/templates_c can be written to by your web server"

# app/init files

cp ${ROOT}setup/config/app.php ${ROOT}/config/app.php
cp ${ROOT}setup/config/app.php ${ROOT}/config/app.php.example
cp ${ROOT}setup/include-init.php ${ROOT}/www/include/init.php

# basic app file

cp ${ROOT}/ext/flamework/*.php ${ROOT}www/

# .gitignore files

cp ${ROOT}setup/.gitignore-php ${ROOT}config/.gitignore

# .htaccess files

cp ${ROOT}setup/.htaccess-www ${ROOT}www/.htaccess
cp ${ROOT}setup/.htaccess-deny ${ROOT}.htaccess
cp ${ROOT}setup/.htaccess-deny ${ROOT}config/.htaccess
cp ${ROOT}setup/.htaccess-deny ${ROOT}www/include/.htaccess
cp ${ROOT}setup/.htaccess-deny ${ROOT}www/templates/.htaccess
cp ${ROOT}setup/.htaccess-deny ${ROOT}www/templates_c/.htaccess

cp ${ROOT}setup/.htaccess-noindexes ${ROOT}www/javascript/.htaccess
cp ${ROOT}setup/.htaccess-noindexes ${ROOT}www/css/.htaccess
cp ${ROOT}setup/.htaccess-noindexes ${ROOT}www/images/.htaccess

# db schema(s)

cat ${ROOT}ext/flamework/schema/db_main.schema >> ${ROOT}schema/db_main.schema
