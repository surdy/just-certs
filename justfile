import 'certs.just'

default := 'no'

# List available commands 
list:
  @just --list

# Check CA certificate
check-ca-cert: (_check-cert "generated/cacerts.pem")

# Generate Zookeeper Certificate
gen-zk-cert encrypt_key=default: (_gen-cert "zookeeper-server" encrypt_key)

# Generate Kafka Certificate
gen-kafka-cert encrypt_key=default: (_gen-cert "kafka-server" encrypt_key)

# Check Zookeeper certificate
check-zk-cert: (_check-cert "generated/zookeeper-server.pem")

# Check Kafka certificate
check-kafka-cert: (_check-cert "generated/kafka-server.pem")

# Delete secrets
delete-secrets: delete-crs
  -kubectl delete secret tls-zookeeper
  -kubectl delete secret tls-kafka

# Create secrets
create-secrets:
  kubectl create secret generic tls-zookeeper \
  --from-file=fullchain.pem=generated/zookeeper-server.pem \
  --from-file=cacerts.pem=generated/cacerts.pem \
  --from-file=privkey.pem=generated/zookeeper-server-key.pem \
  --namespace confluent

  kubectl create secret generic tls-kafka \
  --from-file=fullchain.pem=generated/kafka-server.pem \
  --from-file=cacerts.pem=generated/cacerts.pem \
  --from-file=privkey.pem=generated/kafka-server-key.pem \
  --namespace confluent

# Delete Kafka and ZK CRs
delete-crs:
  kubectl delete kafka --ignore-not-found=true kafka
  kubectl delete zk --ignore-not-found=true zookeeper
