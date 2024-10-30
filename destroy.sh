#! /bin/bash

cd /cloud/infrastructure
terraform destroy --auto-approve -var="aws_access_key=$AWS_ACCESS_KEY_ID" -var="aws_secret_key=$AWS_SECRET_ACCESS_KEY"

echo 'SUCCESS'