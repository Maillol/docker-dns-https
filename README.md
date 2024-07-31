# docker-dns-https




    Site                                     CA (Certificate Authority)                   Tool
     |                                              |                                      |
     |  -- Certificate Signing Request (CSR) -->    | |  create_signed_SSL_certificate(    |
     |                                              | |      /certs/${domain}.crt)         |
     |                                              | |  ---+                              |
     |                                              | |     |                              |
     |  <-- SSL certificate --------------------    | |  <--+                              |
     |                                              | |                                    |
     |                                              |  <-- get root ca certificate ------- |
     |                                              |  --- root ca certificate ----------> |
     |                                                                                     |
     | <---------------------------- curl https://example.fr ------------------------------|
     |                                                                                     |



## Créer une CSR

    mkdir ./certs

La commande ci-dessous créé deux CSR dans le volume "certs" pour les noms de domain "example.de" et "example.fr"

    docker compose run --rm site create_certificate_signing_request


## Signer un certificat 

Le container CA va créer un certificat signé dès qu'il voit une nouvelle CSR dans le volume "certs"


docker compose up -d site


## Ajouter le certificat racine et faire des requete en https sur site:

docker compose run --rm tool sh -c 'add_root_certificate && curl https://www.example.fr'
docker compose run --rm tool sh -c 'curl https://www.example.de'

