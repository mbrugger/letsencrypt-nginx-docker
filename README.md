# letsencrypt-nginx-docker
Samples configs and documentation for configuring letsencrypt using nginx and the dockerized client

In this little guide I want to show an easy setup on how to integrate let's encrypt with an nginx/docker setup.

Also the nginx letsencrypt-auto integration is currently broken and I would not want an automated tool to change my configuration files anyways.

Therefore I did take the following approach to create a setup which is capable of automatic updates.

The frontend nginx as reverse proxy is in my case redirecting requests to different docker applications
![container setup](containers.png)

## Setup
Always find&replace my.example.com with your hostname.

1. I added a location in each relevant server block redirecting the letsencrypt requests to the letsencrypt docker container (listening on port 1086/1087) instead of the real application.
(See `nginx-vhost.conf`)

        location /.well-known/acme-challenge {
                proxy_pass http://localhost:1086;
                proxy_set_header Host            $host;
                proxy_set_header X-Forwarded-For $remote_addr;
                proxy_set_header X-Forwarded-Proto https;
        }
The application continues normal operation without any configuration changes which I think is the best way of integrating letsencrypt certificates.

2. The script to run the docker container for requesting a certificate now only needs to be executed with the correct ports mapped. (See `request_certificate.sh`)

        #!/bin/bash
        docker run -it --rm -p 1086:80 -p 1087:443 --name letsencrypt \
            -v "/etc/letsencrypt:/etc/letsencrypt" \
            -v "/var/lib/letsencrypt:/var/lib/letsencrypt" \
            quay.io/letsencrypt/letsencrypt:latest auth --agree-dev-preview --renew-by-default --server \
            https://acme-v01.api.letsencrypt.org/directory -d my.example.com

Issuing the certificate works this way without a problem.
~~Unfortunately running the same command a second time to request an updated certificate always fails with different error messages.~~
Meanwhile the renewal also works. To fully automate the renewal process I added the following parameter "--renew-by-default".
