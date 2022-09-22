# Terraform Configuration for AWS VPC, EC2 and RDS

### This project contains terraform configuration files on creating EC2 and RDS instances inside a Custom VPC on AWS. Here is the architecture of what will be created:

![Custom VPC architecture for AWS](https://miro.medium.com/max/700/1*Oxp7FZT4Z9RWqpnJn-hHqw.png)

## Background
Scenario: Your team has been working on a web application that uses a database. You have been tasked with setting up the VPC, EC2, and RDS instances using Terraform. Your team will be using EC2 instances to deploy the web application and MySQL RDS for the database.
### Requirements
- EC2 instances should be accessible anywhere on the internet via HTTP
- only you should  be able to access the EC2 instances via SSH
- RDS should be on a private subnet and inaccessible via the internet
- Only the EC2 intances should be able to communicate with RDS
## Set Up
### Prerequisites
- [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html) installed and configuration
- [Terraform](https://www.terraform.io/downloads) installed

### Creating the EC2 Instance
This is going to contain 3 parts:
- Creating the key pair. This should be done in the terraform directory on your local.
  use command: `ssh-keygen -t rsa -b 4096 -m pem -f demo_kp && openssl rsa -in demo_kp -outform pem && mv demo_kp demo_kp.pem && chmod 400 demo_kp.pem` 
  This key should  be made an AWS key pair by adding it to the main.tf file.
- Creating the EC2 Instance. You can choose your flavor and modify the codes. Here I am 
  using Ubuntu 20.04. Before creating the EC2 instance, you need to create the data object that
  will hold the most recent version of ubuntu 20.04 (if you choose that)
- Create the Elastic IP and attach it to the EC2 instance.
### Create the Secrets file
Create a secrets file called ***secrets.tfvars*** and populate it with the follow secrets:
  - **db_username** <-- this is going to be the master user for RDS
  - **db_password** <-- this is going to be the RDS master user's password
  - **my_ip** <-- this is going to be your public IP

## Running the Configuration
### Initializing the Terraform directory
Run the command: `terraform init`
- when prompted for a value, enter: yes
- if you have issues running `terraform init`, try runing this command:
  `terraform init -upgrade`. This will install the latest module and provider versions.
Run the command: `terraform plan`
### Apply the Terraform Config to AWS
Run the command: `terraform apply -var-file="secrets.tfvars"`

## Verify SSH into EC2 instance and communicate with RDS
- -**make note of the database_endpoint and database_port
- run the command: `ssh -i "demo_kp.pem" ubuntu@$(terraform output -raw web_public_dns)`
  if you have issues connecting to EC2 instance, try this command:
  `ssh  -o 'identitiesOnly yes' -i "demo_kp.pem" ubuntu@$(terraform output -raw web_public_dns)`
  if you still have issues, verify that your outbounds rules or firewalls on your local allow external access.
- Once connected to the EC2 instance, connect to the RDS instance. First install MySQL client
  run the command: `sudo apt-get update -y && sudo apt-get install mysql-client -y`
  run this command to connect: `mysql -h <database-endpoint> -P <database-port> -u <db-username> -p`
  When prompted, enter the password of the DB user (found in the `secrets file`)
  run the command: `show DATABASES;` in the MySQL terminal to verify that our database is created
### To destroy everything that was created by the Terraform Config
Run the command: `terraform destroy -var-file="secrets.tfvars"`
