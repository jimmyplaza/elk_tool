#!/bin/sh

if [ -z $1 ];
then
    echo ""
    echo "    Usage:"
    echo "        `basename $0` \$INDEX_NAME"
    echo ""
    echo ""
    echo ""
    exit
fi

MY_DIR=`pwd`
TAR_FILE=dump_elasticsearch_`date +'%Y%m%d%H%M%S'`.tar

cd /tmp
rm -rf tmp_elasticsearch_snapshot > /dev/null 2>&1

curl -XPUT 'http://localhost:9200/_snapshot/tmp_elasticsearch_snapshot' -d '{
    "type": "fs",
    "settings": {
        "location": "/tmp/tmp_elasticsearch_snapshot",
        "compress": true
    }
}'

curl -XPUT "localhost:9200/_snapshot/tmp_elasticsearch_snapshot/snapshot_1" -d "{
    \"indices\": \"$1\",
    \"ignore_unavailable\": \"true\",
    \"include_global_state\": false
}"


tar cvf "$TAR_FILE" tmp_elasticsearch_snapshot/
gzip $TAR_FILE

mv $TAR_FILE.gz $MY_DIR/$TAR_FILE.gz
if [ $? -eq 0 ];
then
    echo ""
    echo "  Done! dumped indexes is locate at: $MY_DIR/$TAR_FILE.gz"
    echo ""
else
    echo ""
    echo "  Failed!"
    echo ""
fi
