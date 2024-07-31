FROM nginx

COPY --chmod=755 ./create_certificate_signing_request /usr/bin/create_certificate_signing_request
COPY ./nginx.conf /etc/nginx/nginx.conf
COPY ./html /var/www/html

VOLUME [ "/root/tls/private", "/certs" ]
