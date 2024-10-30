#! /bin/bash

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
export INSTANCE_IP=$(terraform output -raw public_ip)

cd /cloud
scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i infrastructure/aws_ec2_key.pem inception/.env ubuntu@${INSTANCE_IP}:.env
ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i infrastructure/aws_ec2_key.pem ubuntu@${INSTANCE_IP} << EOF
    sudo snap install docker
    sudo apt install make
    sudo make -C inception
EOF

echo "DEPLOYED TO ~> https://${INSTANCE_IP}"