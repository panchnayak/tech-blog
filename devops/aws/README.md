
# My AWS learnings

How to start an EC2 instanmce using AWS CLI

aws ec2 run-instances --image-id ami-xxxxxxxx --count 1 --instance-type t2.micro --key-name your-kp --security-group-ids sg-048c3xxxxxxxxxx4 --subnet-id subnet-xxxxxxxxxxxx

How to Terrminate an EC2 Instance using AWS CLI

Get the Instance ID of the EC2 Instance

aws ec2 describe-instances 

aws ec2 terminate-instances --instance-id i-0f5fce3xxxxxxx8b951d

AWS Systems Manager

To Create SSM Alias for AMI ID using CLI

aws ssm put-parameter --name "web-server" --value "ami-0dfcb1ef8550277af" --type "String" --datatype "aws:ec2:image"

aws ssm get-parameters --names /aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2 --region us-east-1 

Launch Instance using AMI Parameter Store

ws ec2 run-instances --image-id $(aws ssm get-parameters --names /aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2 --query 'Parameters[0].[Value]' --output text) --count 1 --instance-type m4.large

aws ec2 run-instances \
    --image-id resolve:ssm:/aws/service/canonical/ubuntu/server-minimal/16.04/meta/end-of-extended-security-maintenance-date
    --count 1 \
    --instance-type t2.micro \
    --key-name tdash-kp \
    --security-groups default

aws ec2 run-instances --image-id "resolve:ssm:web-server" --instance-type t2-micro






