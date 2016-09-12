#!/usr/bin/env bash
set -e

cd $HOME
SETTINGS=config/settings.yml
DATABASE=config/database.yml

cp ${DATABASE}.example $DATABASE

export APP_SECRET=`rake secret`
export DEVISE_SECRET=`rake secret`
envsubst < 'config/settings.yml.example' > $SETTINGS
