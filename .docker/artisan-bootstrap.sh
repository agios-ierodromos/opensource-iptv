#!/bin/bash

# This script is ran when the docker image is created
# see: https://dockerfile.readthedocs.io/en/latest/content/Customization/provisioning.html

# Do fresh database migration and seeding
/usr/local/bin/php /var/www/html/artisan migrate:fresh --seed

# Clear caches
/usr/local/bin/php /var/www/html/artisan cache:clear
