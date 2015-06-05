#!/bin/sh

if [ -z $2 ];
then
    echo ""
    echo "    Usage:"
    echo "        `basename $0` \$INDEX_NAME \$DUMPED_GZ_FILE"
    echo ""
    exit
fi

if [ ! -f $2 ];
then
    echo ""
    echo "    Error: $2 is not a file."
    echo ""
    exit
fi

INDEX=$1
GZ_FILE=$2

cd /tmp
tar xf $MY_DIR/$GZ_FILE

curl -XPUT 'http://localhost:9200/_snapshot/tmp_elasticsearch_snapshot' -d '{
    "type": "fs",
    "settings": {
        "location": "/tmp/tmp_elasticsearch_snapshot",
        "compress": true
    }
}'

curl -XPOST "localhost:9200/$INDEX/_close"
curl -XPOST 'http://localhost:9200/_snapshot/tmp_elasticsearch_snapshot/snapshot_1/_restore'
curl -XPOST "localhost:9200/$INDEX/_open"
