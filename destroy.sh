#! /bin/bash

set -e
trap 'echo "Failed To Destroy Deployment. Exiting..."; exit 1;' ERR

apt-get update && apt-get upgrade -y
apt-get install -y wget unzip

cd /tmp

wget "https://releases.hashicorp.com/terraform/1.9.8/terraform_1.9.8_linux_amd64.zip"
unzip "terraform_1.9.8_linux_amd64.zip"
mv terraform /usr/bin
terraform -v

wget "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip"
unzip "awscli-exe-linux-x86_64.zip"
./aws/install
aws --version

aws configure set aws_access_key_id "$AWS_ACCESS_KEY_ID"
aws configure set aws_secret_access_key "$AWS_SECRET_ACCESS_KEY"
aws configure set region "$AWS_REGION"

cd /cloud/infrastructure
terraform init
terraform destroy --auto-approve -var="aws_access_key=$AWS_ACCESS_KEY_ID" -var="aws_secret_key=$AWS_SECRET_ACCESS_KEY"

echo 'Destroyed Deployment Successfully'