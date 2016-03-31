#!/usr/bin/env bash
service apache2 start
cd /home/app/reindeer
rails server -p 3000 -b '0.0.0.0'
