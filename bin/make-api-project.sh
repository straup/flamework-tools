#!/bin/sh

WHOAMI=`python -c 'import os, sys; print os.path.realpath(sys.argv[1])' $0`

WHEREAMI=`dirname $WHOAMI`
TOOLS=`dirname $WHEREAMI`

PROJECT=$1
PROJET_NAME=`basename ${PROJECT}`

${TOOLS}/make-api.sh ${PROJECT}

TMP_API="${TOOLS}/tmp-api"
mkdir ${TMP_API}

git clone https://github.com/whosonfirst/flamework-api.git ${TMP_API}

${TMP_API}/bin/setup.sh ${PROJECT}
rm -rf ${TMP_API}

echo "all done";
echo "------------------------------";
echo ""

exit 0