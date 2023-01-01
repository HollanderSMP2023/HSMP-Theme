#!/bin/bash

if (( $EUID != 0 )); then
    echo "Please run as root"
    exit
fi

repairPanel(){
    cd /var/www/pterodactyl

    php artisan down
    
    npx browserslist@latest --update-db

    rm -r /var/www/pterodactyl/resources

    curl -L https://github.com/pterodactyl/panel/releases/latest/download/panel.tar.gz | tar -xzv

    chmod -R 755 storage/* bootstrap/cache
    
    npx browserslist@latest --update-db

    composer install --no-dev --optimize-autoloader

    php artisan view:clear

    php artisan config:clear
    
    npx browserslist@latest --update-db

    php artisan migrate --seed --force

    chown -R www-data:www-data /var/www/pterodactyl/*
    
    npx browserslist@latest --update-db

    php artisan queue:restart

    curl -sL https://deb.nodesource.com/setup_14.x | sudo -E bash -

    apt update
    
    npx browserslist@latest --update-db

    apt install -y nodejs

    npm i -g yarn
    
    npx browserslist@latest --update-db

    yarn
    
    npx browserslist@latest --update-db

    yarn build:production
    
    npx browserslist@latest --update-db

    sudo php artisan optimize:clear

    php artisan up
}

while true; do
    read -p "Are you sure [y/N]? " yn
    case $yn in
        [Yy]* ) repairPanel; break;;
        [Nn]* ) exit;;
        * ) exit;;
    esac
done
