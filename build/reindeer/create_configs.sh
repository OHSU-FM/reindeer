#!/usr/bin/env bash
set -e

cd $HOME
SETTINGS=config/settings.yml
DATABASE=config/database.yml

#if [ ! -f $DATABASE ]; then
    cp ${DATABASE}.example $DATABASE
#fi

export APP_SECRET=`rake secret`
export DEVISE_SECRET=`rake secret`
#if [ ! -f $SETTINGS ]; then
    envsubst < 'config/settings.yml.example' > $SETTINGS
#fi
