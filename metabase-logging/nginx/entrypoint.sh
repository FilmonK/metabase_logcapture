#!/bin/bash

# Ensure the log directory and files have the correct permissions
mkdir -p /var/tmp/nginx
touch /var/tmp/nginx/error.log /var/tmp/nginx/metabase_access.log
chown -R www-data:www-data /var/tmp/nginx
chmod -R 755 /var/tmp/nginx

# Start Nginx
nginx -g 'daemon off;'
