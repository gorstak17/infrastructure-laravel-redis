#!/bin/sh
set -e

echo "Clearing Laravel caches..."
php artisan config:clear
php artisan route:clear
php artisan view:clear

echo "Starting app..."
exec "$@"
