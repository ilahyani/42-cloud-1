#! /bin/bash

set -e
trap 'echo "Deployment Failed. Exiting..."; exit 1;' ERR

sudo apt-get update && sudo apt-get upgrade -y
sudo apt-get install -y wget unzip openssh-client

cd /tmp

sudo wget "https://releases.hashicorp.com/terraform/1.9.8/terraform_1.9.8_linux_amd64.zip"
sudo unzip "terraform_1.9.8_linux_amd64.zip"
sudo mv terraform /usr/bin
sudo terraform -v

sudo wget "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip"
sudo unzip "awscli-exe-linux-x86_64.zip"
sudo ./aws/install
sudo aws --version

sudo aws configure set aws_access_key_id "$AWS_ACCESS_KEY_ID"
sudo aws configure set aws_secret_access_key "$AWS_SECRET_ACCESS_KEY"
sudo aws configure set region "$AWS_REGION"

cd /cloud/infrastructure
sudo terraform init
sudo terraform apply --auto-approve -var="aws_access_key=$AWS_ACCESS_KEY_ID" -var="aws_secret_key=$AWS_SECRET_ACCESS_KEY"

INSTANCE_IP=$(terraform output -raw public_ip)
instanceid=$(terraform output -raw instance_id)
echo -e "" | tee  -a /cloud/inception/.env > /dev/null
echo -e "AWS_REGION=$AWS_REGION" | tee  -a /cloud/inception/.env > /dev/null
echo -e "GF_ACCESS_KEY_ID=$(terraform output -raw access_key_id)" | tee  -a /cloud/inception/.env > /dev/null
echo -e "GF_SECRET_ACCESS_KEY=$(terraform output -raw secret_access_key)" | tee  -a /cloud/inception/.env > /dev/null

cd /cloud

sudo scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i infrastructure/aws_ec2_key.pem inception/.env ubuntu@"${INSTANCE_IP}":inception/.env
sudo ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i infrastructure/aws_ec2_key.pem ubuntu@"${INSTANCE_IP}" << EOF
    sed -i "s/\\\$instanceid/${instanceid}/g" inception/services/grafana/dashboards/files/ec2.json
    sed -i "s/localhost/${INSTANCE_IP}/g" inception/.env
    sudo apt update && sudo apt install -y make
    sudo snap install docker
    sudo make -C inception
EOF

echo "DEPLOYED TO ~> https://${INSTANCE_IP}"