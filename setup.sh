#!/bin/bash

if [ ! -e .env ]; then
    echo "Create .env file..."
    cp .env.dist .env
fi

echo "Creating missing folder and files in folder 'services'..."
cp -vnr services.dist/. services/

echo

if [ ! -e docker-compose.override.yml ]; then

    read -p "Choose Environment (prod/dev) [prod]: " env
    env=${env:-prod}

    config_file="docker-compose.${env}.yml"
    ln -sf ${config_file} docker-compose.override.yml

    if [ "${env}" == "dev" ]; then
        if [ ! -e services/app/var/www ]; then
            mkdir -p services/app/var/www/html
            git clone https://github.com/laravel/quickstart-basic services/app/var/www/html
        fi
    fi

fi
