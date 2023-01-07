#!/bin/bash

# This script is ran when the docker image is created
# see: https://dockerfile.readthedocs.io/en/latest/content/Customization/provisioning.html

# Clear caches
/usr/local/bin/php /var/www/html/artisan cache:clear

# Do fresh database migration and seeding
/usr/local/bin/php artisan sriptv:init
