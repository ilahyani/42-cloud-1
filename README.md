# Cloud-1

## Project Overview

42-cloud-1 is a cloud infrastructure project designed to deploy and manage a multi-service application environment using Docker, Vagrant, and Terraform. The project includes services such as Grafana, MariaDB, Nginx, Prometheus, and WordPress, orchestrated using Docker Compose and managed through Terraform for infrastructure provisioning.

## Technologies Used

- **Docker**: Containerization of services.
- **Docker Compose**: Orchestration of multi-container Docker applications.
- **Vagrant**: Virtual developement environnement.
- **AWS**: Cloud Provider.
- **Terraform**: Infrastructure as Code (IaC) for provisioning cloud resources.
- **Grafana**: Monitoring and observability platform.
- **MariaDB**: Relational database management system.
- **Nginx**: Web server and reverse proxy.
- **Prometheus**: Monitoring and alerting toolkit.
- **WordPress**: Content management system.

## Getting Started

### Prerequisites

- Make sure you have Vagrant installed
- Make sure the following environnement variables are exported with your AWS credentials
  - AWS_ACCESS_KEY_ID
  - AWS_SECRET_ACCESS_KEY
  - AWS_REGION 

### Running the Project

1. **Clone the repository**:

2. **Set up environment variables**:
    Copy the `inception/env-template` to `inception/.env` and fill in the required values.

3. **Run vagrant**:
    ```sh
    vagrant up
    ```
4. **Open in browser**: After the deployment is done, you will see this message:
    ```DEPLOYED TO ~> https://X.X.X.X``` open the link in the browser to get the wordpress website (you might a 502 error in the beginning as wordpress takes some time to start). To access Grafana open the same IP with http and port 3000.

### Stopping and Cleaning Up

1. **Destroy Infrastructure**:
    ```sh
    vagrant ssh
    sudo bash /cloud/destroy.sh
    exit
    ```
2. **Stop and destroy Vagrant VM**:
    ```sh
    vagrant halt
    vagrant destroy
    ```
