#!/bin/bash

source ./scripts/config.sh

log_message() {
    echo "$(date): $1" | tee -a "$(terraform -chdir=$TERRAFORM_DIR output -raw log_file)" >&2
}

cd "$TERRAFORM_DIR" || exit 1

ls
pwd
KEY_FILE=$(terraform output -raw key_path)

log_message "Deleting Key"
ls -l "$KEY_FILE"
rm -f $KEY_FILE
ls -l "$KEY_FILE"

log_message "Destroying resources"
terraform destroy -auto-approve -parallelism=11

log_message "Teardown Complete"
