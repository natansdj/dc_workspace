#!/bin/bash

# Docker entrypoint script to fix Laravel permissions
set -e

# Ensure storage directories exist with proper permissions
mkdir -p /app/storage/logs
mkdir -p /app/storage/framework/cache
mkdir -p /app/storage/framework/sessions  
mkdir -p /app/storage/framework/views
mkdir -p /app/storage/app/public
mkdir -p /app/bootstrap/cache

# Set permissions
chmod -R 775 /app/storage/
chmod -R 775 /app/bootstrap/cache/

# Change ownership to www-data if running as root
if [ "$(id -u)" = "0" ]; then
    chown -R www-data:www-data /app/storage/
    chown -R www-data:www-data /app/bootstrap/cache/
fi

# Execute the original command
exec "$@"
