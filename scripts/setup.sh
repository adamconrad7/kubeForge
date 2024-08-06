#!/bin/bash

source ./scripts/config.sh

cd "$TERRAFORM_DIR" || exit 1

log_message() {
    echo "$(date): $1" | tee -a "$(terraform -chdir=$TERRAFORM_DIR output -raw log_file)" >&2
}
log_message "Starting setup script"

log_message "Creating resources"
terraform apply -auto-approve -parallelism=11

terraform output -raw private_key > "$(terraform output -raw key_path)"
chmod 400 "$(terraform output -raw key_path)"
log_message "Set permissions on key file"
ls -l "$(terraform output -raw key_path)"

cd ..

ansible-playbook ansible/site.yml -i ansible/inventory/hosts.yml

export KUBECONFIG=ansible/kubeconfig

kubectl get pods -A
kubectl get services -A
#kubectl create ns cilium-test
#kubectl apply -n cilium-test -f https://raw.githubusercontent.com/cilium/cilium/1.16.0/examples/kubernetes/connectivity-check/connectivity-check.yaml
#kubectl get pods -n cilium-test
kubectl get gateway -A
kubectl get all -A

#kubectl create namespace monitoring
#kubectl apply -f monitoring/grafana.yaml

log_message "Setup Complete"

