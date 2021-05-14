# Terraform
## Cloud Networks
![alt text](https://cdn.discordapp.com/attachments/836898832637624370/841615996284043274/public-private-hybrid-clouds.png)

## What is Terraform?
Terraform is a tool for building, changing, and versioning infrastructure safely and efficiently. Terraform can manage existing and popular service providers as well as custom in-house solutions. Configuration files describe to Terraform the components needed to run a single application or your entire datacenter.

## What are the benefits of Terraform?
- Simple to install
- Improved multi-cloud infrastructure deployment
- Simple to use
- Reduced development costs
- Reduced time to provision

## Using Terraform
![alt text](https://miro.medium.com/max/1052/1*ONt5L9S_sNaLQoIoECflWQ.png)

### Installing Terraform
- Download desired Terraform version as a zipped file
- Unzip to desired location
- Open advanced system settings and environment variables
- Add path to Terraform file
- `terraform --version` to test installed correctly

### Terrafrom most used commands
- `terraform init`
- `terraform plan` checks syntax
- `terraform apply` runs main.tf
- `terraform destroy` destroys resources from main.tf

### Using Terraform with AWS
#### Securing AWS keys with Terraform
- Open advanced system settings and environment variables
- Add new variables
	- `AWS_ACCESS_KEY_ID`
	- `AWS_SECRET_ACCESS_KEY`

#### Using main.tf
- Create VPC
- Create Internet Gateway
- Create Route Table
- Create subnet for app instance
- Create subnet for db instance
- Associate route tables with created subnets
- Create app security group
- Create database security group
- Create db instance
- Create app instance
```
provider "aws"{
	region = "eu-west-1"
}

resource "aws_instance" "app_instance"{
	ami = "ami-08412dcc11680fa41"
	instance_type = "t2.micro"
	associate_public_ip_address = true

	tags = {
		Name = "eng84_jordan_terraform_app"
	}
}
```
- Run a shell script in the app instance to run the app
```
#!/bin/bash
# Change DB_HOST to db private ip
echo export DB_HOST=mongodb://32.34.2.42:27017/posts >> /home/ubuntu/.bashrc
source ~/.bashrc
echo $DB_HOST

# Run app
cd /etc/systemd/system
sudo touch webapp.service
echo -e "
[Service]
Type=simple
Restart=on-failure
Environment=NODE_PORT=3000
Environment=DB_HOST=mongodb://32.34.2.42:27017/posts
ExecStart=/usr/bin/nodejs /home/ubuntu/app/app.js
User=ubuntu
# Note Debian/Ubuntu uses 'nogroup', RHEL/Fedora uses 'nobody'
Group=nogroup
Environment=PATH=/usr/bin:/usr/local/bin
Environment=NODE_ENV=production
WorkingDirectory=/home/ubuntu/app

[Install]
WantedBy=multi-user.target
" | sudo tee webapp.service

sudo systemctl start webapp
```

## Application Load Balancer
### What is an Application Load Balancer?
A load balancer serves as the single point of contact for users. The load balancer distributes incoming application traffic across multiple targets, such as EC2 instances, in multiple Availability Zones. This increases the availability of the application.

It monitors the health of its registered targets, and routes traffic only to healthy targets. Elastic Load Balancing also scales the load balancer as incoming traffic changes over time.
![alt text](https://miro.medium.com/max/1200/0*UCFdX5MLOV2Pt3bL)

### How does an Application Load Balancer work?
When creating a load balancer, you add one or more listeners. A listener checks for connection requests from clients, using the protocol and port configuration. The rules that are defined for a listener determine how the load balancer routes requests to its registered targets. Each rule consists of a priority, one or more actions, and one or more conditions. When the conditions for the rule are met, then its actions are performed.

Each target group routes requests to one or more registered targets, such as EC2 instances, using the protocol and port number specified. A target can be registered with multiple target groups. Health checks can also be set up on target groups which are performed on all targets registered to the target group and is specified in a listener rule for the load balancer.

![alt text](https://docs.aws.amazon.com/elasticloadbalancing/latest/application/images/component_architecture.png)

### What are the benefits of an Application Load Balancer?
- Highly available as the application can be run in multiple locations and redirected from listener
- Can structure the application as smaller services, routing requests to the correct service based on URL
- Support for monitoring the health of each service at the target group level
- If the application fails in a target group, the load balancer will redirect traffic to a healthy group

### Using Application Load Balancers
#### Using AWS Console

#### Using IAC with Terraform

## Autoscaling Groups
### What is an Autoscaling Group?
Auto Scaling monitors applications and automatically adjusts capacity to maintain steady, predictable performance at the lowest possible cost. At moments of higher traffic, the autoscaling group will scale to support the additional users, and at lower traffic reduce to fit the needs.
![alt text](https://docs.aws.amazon.com/autoscaling/ec2/userguide/images/as-sample-web-architecture-diagram-with-asgs.png)

### What are the benefits of an Autoscaling Group?
- Scale out to support higher traffic to ensure steady performance for users
- Scale in for lower traffic to reduce cost on servers not being used
- Maintain optimal performance and availability
- Remove excess resource capacity to reduce cost

### Using Autoscaling Groups
#### Using AWS Console

#### Using IAC with Terraform
