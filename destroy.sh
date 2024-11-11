#! /bin/bash

set -e
trap 'echo "Destruction Failed. Exiting..."; exit 1;' ERR

cd /cloud/infrastructure
sudo terraform init
sudo terraform destroy --auto-approve -var="aws_access_key=$AWS_ACCESS_KEY_ID" -var="aws_secret_key=$AWS_SECRET_ACCESS_KEY"

echo 'Destroyed Deployment Successfully'