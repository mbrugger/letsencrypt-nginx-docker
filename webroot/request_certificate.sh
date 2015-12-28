#!/bin/bash
mkdir -p /tmp/letsencrypt/www
docker run -it --rm --name letsencrypt \
    -v "/etc/letsencrypt:/etc/letsencrypt" \
    -v "/var/lib/letsencrypt:/var/lib/letsencrypt" \
    -v "/tmp/letsencrypt/www:/var/www" \
    quay.io/letsencrypt/letsencrypt:latest auth --authenticator webroot --webroot-path /var/www --renew-by-default --server \
    https://acme-v01.api.letsencrypt.org/directory -d my.example.com
