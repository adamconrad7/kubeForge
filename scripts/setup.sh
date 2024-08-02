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

INSTANCE_IP=$(terraform output -json instance_public_ips | jq -r '.[0]')
EC2_USER=$(terraform output -raw ssh_user)
KEY_FILE=$(terraform output -raw key_path)

cd ..

# should have config file
echo ansible --version

ansible-playbook ansible/site.yml -i ansible/inventory/hosts.yml

log_message "Setup Complete"

