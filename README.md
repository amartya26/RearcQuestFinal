# RearcQuestFinal
Assignment files for Rearc Quest

Final output with Secret word:
SECRET_WORD is: Hello Team Rearc
![image](https://github.com/user-attachments/assets/07e57b78-ef6e-43d1-aa8f-9d927fd55296)

AWS services used:
VPC, Subnet, ALB, EC2, S3, DynamoDB

Docker commands used:
docker ps
docker build -t amartya/nodeapp:01 .
docker run -p 3000:3000 -e SECRET_WORD="Hello Team Rearc" amartya797/nodeapp:01
docker stop <names>

To initialize node app:
npm init- y
npm install express

The application is hosted on EC2
