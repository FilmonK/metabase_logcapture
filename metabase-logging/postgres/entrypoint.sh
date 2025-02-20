#!/bin/bash
set -e

# Ensure the log directory exists and has the correct permissions
mkdir -p /var/log/postgresql
chown -R postgres:postgres /var/log/postgresql
chmod 700 /var/log/postgresql

# Start PostgreSQL with the custom configuration file
exec postgres -c 'config_file=/etc/postgresql/postgresql.conf'
