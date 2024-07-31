FROM alpine/openssl


COPY <<EOF /root/passphrase
11111111-1111-1111-1111-111111111111
EOF
RUN openssl genrsa -des3 -out /root/myCA.key -passout file:/root/passphrase 2048

COPY --chmod=755 ./entrypoint.sh /entrypoint.sh


VOLUME ["/certs"]
ENTRYPOINT ["/entrypoint.sh"]
