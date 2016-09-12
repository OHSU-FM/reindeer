#!/usr/bin/env bash

# exit on error
set -e

mkdir -p $APPDIR
TEMP_FILE=/tmp/limesurvey.tar.gz

# Download tarfile
curl -L -o $TEMP_FILE $LIME_BIN_URL

# Raise an error if the sha256 doesn't match
echo "$LIME_SHA256 $TEMP_FILE" | sha256sum -c --strict

# Extract tar file
tar --strip-components=1 -C $APPDIR -xvzf $TEMP_FILE

#cp /mnt/web/index.html /code
rm $TEMP_FILE

# Change directory ownership or php will complain
chown -R www-data:www-data `dirname $APPDIR`
chown -R www-data:www-data $APPDIR
