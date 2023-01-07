#!/bin/bash

# This script is ran when the container starts
# see: https://dockerfile.readthedocs.io/en/latest/content/Customization/provisioning.html

# Optimizing Configuration loading
/usr/local/bin/php /var/www/html/artisan config:cache

# Optimizing Route loading
/usr/local/bin/php /var/www/html/artisan route:cache

# Optimizing View loading
/usr/local/bin/php /var/www/html/artisan view:cache

/usr/local/bin/php /var/www/html/artisan optimize

# Updates the database whenever a new version of the image gets deployed
/usr/local/bin/php /var/www/html/artisan migrate
