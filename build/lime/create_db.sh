#!/usr/bin/env bash
APPDIR=/code/survey
cd /docker
envsubst < 'config_pgsql.php.template' > $APPDIR/application/config/config.php
cd $APPDIR/application/commands
php ./console.php install $ADMIN_NAME $ADMIN_PASS $ADMIN_FULL_NAME $ADMIN_EMAIL
