#!/usr/bin/env bash
cd /docker
cd $APPDIR/application/commands
php ./console.php install $ADMIN_NAME $ADMIN_PASS $ADMIN_FULL_NAME $ADMIN_EMAIL
