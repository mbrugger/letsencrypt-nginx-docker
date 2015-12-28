#!/bin/bash
docker run -it --rm -p 1086:80 --name letsencrypt \
            -v "/etc/letsencrypt:/etc/letsencrypt" \
            -v "/var/lib/letsencrypt:/var/lib/letsencrypt" \
            quay.io/letsencrypt/letsencrypt:latest auth --server https://acme-staging.api.letsencrypt.org/directory \
	          --debug --renew-by-default --standalone-supported-challenges http-01 \
 	          --verbose -d my.example.com
