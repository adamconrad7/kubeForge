#!/bin/bash


source ./scripts/config.sh

cd "$TERRAFORM_DIR" || exit 1

log_message() {
    echo "$(date): $1" | tee -a "$(terraform -chdir=$TERRAFORM_DIR output -raw log_file)" >&2
}
log_message "Starting setup script"


log_message "Creating resources"
terraform apply -auto-approve

terraform output -raw private_key > "$(terraform output -raw key_file)"
chmod 400 "$(terraform output -raw key_file)"
log_message "Set permissions on key file"
ls -l "$(terraform output -raw key_file)"

INSTANCE_IP=$(terraform output -json instance_public_ips | jq -r '.[0]')
EC2_USER=$(terraform output -raw ec2_user)
KEY_FILE=$(terraform output -raw key_file)

log_message "Instance IP: $INSTANCE_IP"
log_message "Attempting SSH connection"
ssh -i "$KEY_FILE" "$EC2_USER@$INSTANCE_IP"

log_message "Setup Complete"

