_gen-cert component encrypt_key:
  @# generate {{ component }} key and csr
  openssl req -newkey rsa -sha256 \
  {{ if encrypt_key == "encrypt-key" { "" } else { "-nodes" } }} \
  -out generated/{{ component }}.csr \
  -config config/{{ component }}.cnf \
  -extensions v3_req -quiet

  @# generate {{ component }} server cert
  openssl x509 -req -in generated/{{ component }}.csr \
  -CA generated/cacerts.pem -CAkey generated/rootCAkey.pem \
  -out generated/{{ component }}.pem \
  -days 1825 -sha256 -extfile \
  config/{{ component }}.cnf \
  -extensions v3_req

# Generate CA certificate
gen-ca-cert:
  @mkdir -p generated
  openssl req -x509 -new -nodes \
  -newkey rsa -sha256 \
  -days 3650 \
  -out generated/cacerts.pem \
  -config config/root-ca.cnf -quiet

# Check cert
_check-cert file:
  openssl x509 -in {{ file }} -text -noout
