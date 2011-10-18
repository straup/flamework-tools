#!/bin/sh

echo "this doesn't work yet"
exit

DBNAME=$1
USERNAME=$2

# shell out to generate_secret.php ?
PASSWORD='???'

CREATE DATABASE ${DNAME};

CREATE user '${USERNAME}'@'localhost' IDENTIFIED BY '${PASSWORD}';

GRANT SELECT,UPDATE,DELETE, INSERT ON ${DBNAME}.* TO '${USERNAME}'@'localhost' IDENTIFIED BY '${PASSWORD}';

FLUSH PRIVILEGES;