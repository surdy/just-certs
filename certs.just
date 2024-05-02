_gen-cert component:
  @# generate {{ component }} CSR key
  openssl genrsa -out generated/{{ component }}-key.pem 2048

  @# generate {{ component }} csr
  openssl req -new -key generated/{{ component }}-key.pem \
  -out generated/{{ component }}.csr \
  -config config/{{ component }}-domain.cnf \
  -extensions v3_req

  @# generate {{ component }} server cert
  openssl x509 -req -in generated/{{ component }}.csr \
  -CA generated/cacerts.pem -CAkey generated/rootCAkey.pem \
  -out generated/{{ component }}.pem \
  -days 1825 -sha256 -extfile \
  config/{{ component }}-domain.cnf \
  -extensions v3_req

# Generate SSL Key
_gen-ca-key:
  @mkdir -p generated
  openssl genrsa -out generated/rootCAkey.pem 2048

# Check cert
_check-cert file:
  openssl x509 -in {{ file }} -text -noout
