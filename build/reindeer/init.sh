#!/usr/bin/env bash
set -e
cd /home/app

echo Creating config files
/docker/create_configs.sh

echo Loading rails schema
rake db:schema:load &> /dev/null

echo Creating admin user
rake seed:create:admin 
