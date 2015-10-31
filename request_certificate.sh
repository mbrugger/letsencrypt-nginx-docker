#!/bin/bash
docker run -it --rm -p 1086:80 -p 1087:443 --name letsencrypt \
            -v "/etc/letsencrypt:/etc/letsencrypt" \
            -v "/var/lib/letsencrypt:/var/lib/letsencrypt" \
            quay.io/letsencrypt/letsencrypt:latest auth --agree-dev-preview --server \
      https://acme-v01.api.letsencrypt.org/directory -d my.example.com
