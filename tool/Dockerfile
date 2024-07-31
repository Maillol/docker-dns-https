FROM alpine

RUN apk add --upgrade --no-cache ca-certificates curl

COPY --chmod=755 ./add_root_certificate /usr/bin/add_root_certificate

