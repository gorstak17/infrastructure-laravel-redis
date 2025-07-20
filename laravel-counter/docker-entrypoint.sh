#!/bin/sh
set -e

echo "👉 Fetching app_key from AWS SSM..."
export APP_KEY=$(aws ssm get-parameter --name "/laravel-counter/app_key" --with-decryption --query "Parameter.Value" --output text)

echo "👉 Fetching redis_endpoint from AWS SSM..."
export REDIS_HOST=$(aws ssm get-parameter --name "/laravel-counter/redis_endpoint" --query "Parameter.Value" --output text)

# if [ ! -f .env ]; then
#   echo ".env file not found! Exiting."
#   exit 1
# fi

echo "Updating .env with runtime values..."
sed -i "s|^APP_KEY=.*|APP_KEY=${APP_KEY}|" .env
sed -i "s|^REDIS_HOST=.*|REDIS_HOST=${REDIS_HOST}|" .env

echo "Clearing Laravel caches..."
php artisan config:clear
php artisan route:clear
php artisan view:clear

echo "Starting app..."
exec "$@"
