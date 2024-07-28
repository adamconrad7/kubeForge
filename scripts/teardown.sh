#!/bin/bash

source ./scripts/config.sh

#TERRAFORM_DIR="./terraform"

log_message() {
    echo "$(date): $1" | tee -a "$LOG_FILE" >&2
}

cd "$TERRAFORM_DIR" || exit 1

ls
pwd
KEY_FILE=$(terraform output -raw key_file)

log_message "Deleting Key"
ls -l "$KEY_FILE"
rm -f $KEY_FILE
ls -l "$KEY_FILE"

log_message "Destroying resources"
terraform destroy

log_message "Teardown Complete"
