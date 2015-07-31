#!/bin/bash

set -e

if [ $# -eq 0 ] ; then
	echo "Usage: ./update.sh <docker/notary tag or branch>"
	exit
fi

VERSION=$1

# cd to the current directory so the script can be run from anywhere.
cd `dirname $0`

echo "Fetching and building notary $VERSION..."

# Create a temporary directory.
TEMP=`mktemp -d /$TMPDIR/notary.XXXXXX`

git clone -b $VERSION https://github.com/docker/notary.git "$TEMP"
docker build -f "$TEMP/notary-server-Dockerfile" -t notary-server-builder "$TEMP"

# Create a dummy notary-build container so we can run a cp against it.
ID=$(docker create notary-server-builder)

# Update the local binary and config file.
docker cp $ID:/go/bin/notary-server notary-server
docker cp $ID:/go/src/github.com/docker/notary/cmd/notary-server/config.json notary-server
docker cp $ID:/go/src/github.com/docker/notary/fixtures notary-server

# Cleanup.
docker rm -f $ID
docker rmi notary-server-builder

echo "Done."
