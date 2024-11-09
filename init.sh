#! /bin/bash

set -e
trap 'echo "Deployment Failed. Exiting..."; exit 1;' ERR

apt-get update && apt-get upgrade -y
apt-get install -y wget unzip openssh-client

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
terraform apply --auto-approve -var="aws_access_key=$AWS_ACCESS_KEY_ID" -var="aws_secret_key=$AWS_SECRET_ACCESS_KEY"

INSTANCE_IP=$(terraform output -raw public_ip)
instanceid=$(terraform output -raw instance_id)
echo -e "" | tee  -a /cloud/inception/.env
# echo -e "INSTANCE_IP=$INSTANCE_IP" | tee  -a /cloud/inception/.env
# echo -e "instanceid=$instanceid" | tee  -a /cloud/inception/.env
echo -e "AWS_REGION=$AWS_REGION" | tee  -a /cloud/inception/.env
echo -e "GF_ACCESS_KEY_ID=$(terraform output -raw access_key_id)" | tee  -a /cloud/inception/.env
echo -e "GF_SECRET_ACCESS_KEY=$(terraform output -raw secret_access_key)" | tee  -a /cloud/inception/.env

cd /cloud

    # instanceid=$(cat inception/.env | grep instanceid | cut -d '=' -f 2)
    # INSTANCE_IP=$(cat inception/.env | grep INSTANCE_IP | cut -d '=' -f 2)
scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i infrastructure/aws_ec2_key.pem inception/.env ubuntu@"${INSTANCE_IP}":inception/.env
ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i infrastructure/aws_ec2_key.pem ubuntu@"${INSTANCE_IP}" << EOF
    sed -i "s/\\\$instanceid/${instanceid}/g" inception/services/grafana/dashboards/files/ec2.json
    sed -i "s/localhost/${INSTANCE_IP}/g" inception/.env
    sudo apt update && sudo apt install -y make
    sudo snap install docker
    sudo make -C inception
EOF

echo "DEPLOYED TO ~> https://${INSTANCE_IP}"