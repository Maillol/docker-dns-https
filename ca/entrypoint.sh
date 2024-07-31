#!/bin/sh

set -e

create_ca_root_certificate() {
 	## Vérifie si le certificat est expiré, va expirer dans moins de 24 heure ou n'existe pas.
 	if ! openssl x509 -checkend 86400 -noout -in /certs/myCA.pem
 	then
		openssl req -x509 -new -nodes -sha256 -days 1825 \
			-key /root/myCA.key \
			-out /certs/myCA.pem \
			-passin file:/root/passphrase \
			-subj '/C=FR/ST=Occitanie/L=Montpellier/CN=myCA.com/'
 	 	echo "Le certificat /certs/myCA.pem a été créé."
	fi
}


create_signed_SSL_certificate() {
	if [[ -z $1 ]]; then
		echo "Erreur, chemin vers csr_file manquant"
		return 1
    fi

	csr_file=$1
    file_name="${csr_file##*/}"
	domain="${file_name%.*}"

	if [ -f "/certs/${domain}.crt" ]
	then
		last_change_src=$(stat -c %Z "$csr_file")
		last_change_dest=$(stat -c %Z "/certs/${domain}.crt")
		if [  "$last_change_src" -lt "$last_change_dest" ]
		then
			return 0
		fi
	fi
	cat <<- EOF > "/tmp/${domain}.ext"
	authorityKeyIdentifier=keyid,issuer
	basicConstraints=CA:FALSE
	keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
	subjectAltName = @alt_names

	[alt_names]
	DNS.1 = ${domain}
	EOF

	openssl x509 -req -in "/certs/${domain}.csr" \
		-CA /certs/myCA.pem \
		-CAkey /root/myCA.key \
		-CAcreateserial \
		-out "/certs/${domain}.crt" \
		-days 825 \
		-sha256 \
		-extfile "/tmp/${domain}.ext" \
		-passin file:/root/passphrase
}


create_ca_root_certificate
while true; do
 	for file in $(find /certs/ -type f -name '*.csr')
 	do
 		create_signed_SSL_certificate $file
 	done
	sleep 2;
done
