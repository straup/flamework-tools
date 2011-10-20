#!/bin/sh

WHOAMI=`readlink -f $0`
WHEREAMI=`dirname $WHOAMI`
TOOLS=`dirname $WHEREAMI`

PROJECT=$1
DBNAME=$2
USERNAME=$3

PASSWORD=`php -q ${PROJECT}/bin/generate_secret.php`

echo "CREATE DATABASE ${DBNAME};" > /tmp/${DBNAME}.sql
echo "CREATE user '${USERNAME}'@'localhost' IDENTIFIED BY '${PASSWORD}';" >> /tmp/${DBNAME}.sql
echo "GRANT SELECT,UPDATE,DELETE,INSERT ON ${DBNAME}.* TO '${USERNAME}'@'localhost' IDENTIFIED BY '${PASSWORD}';" >> /tmp/${DBNAME}.sql
echo "FLUSH PRIVILEGES;" >> /tmp/${DBNAME}.sql

echo "USE ${DBNAME};" >> /tmp/${DBNAME}.sql;

for f in `ls -a ${PROJECT}/schema/*.schema`
do
	echo "" >> /tmp/${DBNAME}.sql
	cat $f >> /tmp/${DBNAME}.sql
done

mysql -u root -p < /tmp/${DBNAME}.sql
unlink /tmp/${DBNAME}.sql

# write to disk?

echo ""
echo "\t------------------------------";

echo "\t\$GLOBALS['cfg']['db_main'] = array(";
echo "\t\t'host' => 'localhost',";
echo "\t\t'user' => '${USERNAME}',";
echo "\t\t'pass' => '${PASSWORD}',";
echo "\t\t'name' => '${DBNAME}',";
echo "\t\t'auto_connect' => 0,";
echo "\t);";

echo "\t------------------------------";
echo "";