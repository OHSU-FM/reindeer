#!/usr/bin/env bash
cd /home/app
rake db:schema:load
rake seed:create:admin 
