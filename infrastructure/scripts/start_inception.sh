#! /bin/bash

ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i ../ec2_key.pem ubuntu@${ec2_ip} << 'EOF'
    docker ps -aq | sudo xargs docker rm -f 2>/dev/null || true
    docker images -aq | sudo xargs docker rmi 2>/dev/null || true
    cd /home/cloud-1
    make
EOF