# RearcQuestFinal
Assignment files for Rearc Quest 

This assignment provisions a highly available web infrastructure on AWS using Terraform code. 
It deploys a node js Express app inside a Docker container hosted on an EC2 instance. 
Terraform also manages remote state using an S3 bucket and DynamoDB(for locking).



Final output with Secret word:
SECRET_WORD is: Hello Team Rearc
You can check the output here: 107.23.238.158:80

Below is the screenhot:
![image](https://github.com/user-attachments/assets/07e57b78-ef6e-43d1-aa8f-9d927fd55296)

Overveiw:
-VPC with public subnets in 2 AZs (us-east-1a and us-east-1b)
-Internet Gateway and public route table
-Security Group allowing SSH, HTTP, and HTTPS
-EC2 instance with Docker and Node.js app
-Application Load Balancer routing to EC2 via Target Group
-Terraform state stored in S3 with DynamoDB for locking

Stack used:
AWS (VPC, EC2, ALB, S3, DynamoDB)
Terraform for Infrastructure as Code (IaC)
Node.js with Express web server
Docker for containerization

Docker commands used:
docker ps
docker build -t amartya/nodeapp:01 .
docker run -p 3000:3000 -e SECRET_WORD="Hello Team Rearc" amartya797/nodeapp:01
docker stop <names>

Terraform command used:
terraform init
terraform plan
terraform apply

To initialize node app:
npm init- y
npm install express

