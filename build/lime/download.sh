#!/usr/bin/env bash

# exit on error
set -e

## Defined in docker-compose.yml
# $LIME_BIN_URL
# $LIME_SHA256 
##

APPDIR=/code/survey
mkdir -p $APPDIR
FILE=/tmp/downloads/limesurvey.tar.gz

# Download tarfile if it does not exist
if [ ! -f $FILE ]; then
    curl -L -o $FILE $LIME_BIN_URL
fi

# Raise an error if the sha256 doesn't match
echo "$LIME_SHA256 $FILE" | sha256sum -c --strict

# Extract tar file
tar --strip-components=1 -C $APPDIR -xvzf $FILE

cp /mnt/web/index.html /code

# Change directory ownership or php will complain
chown -R www-data:www-data /code
chown -R www-data:www-data $APPDIR
