# The environment (production, staging, qa etc.)
variable "environment" {
    description = "Environment name to tag EC2 resources with (tag=environment)"
}

# AWS EC2 Region
variable "region" {
    default = "eu-west-1"
    description = "The AWS region"
}

# What to call the ECS instances
variable "instance_name_prefix" {
    description = "Prefix for the EC2 instance names"
    default = {
        production = "prod-ecs"
        staging = "stg-ecs"
        qa = "qa-ecs"
    }
}

# The ECS Cluster name
variable "cluster_name" {
    description = "The name of the ECS Cluster"
    default = {
        production = "production"
        staging = "staging"
        qa = "qa"
    }
}

# Which AMI to launch (AWS ECS AMIs)
variable "ami" {
    description = "Base AMI to launch the instances with"
    default = {
        us-east-1 = "ami-cb2305a1"
        us-west-1 = "ami-bdafdbdd"
        us-west-2 = "ami-ec75908c"
        eu-west-1 = "ami-13f84d60"
        eu-central-1 = "ami-c3253caf"
        ap-northeast-1 = "ami-e9724c87"
        ap-southeast-1 = "ami-5f31fd3c"
        ap-southeast-2 = "ami-83af8ae0"
    }
}

# SSH key name to use
variable "key_name" {
    default = "ops"
    description = "SSH key name in your AWS account for AWS instances."
}

# IAM Instance profile
variable "iam_instance_profile" {
    description = "IAM Profile to use"
    default = {
        production = "ecs_production"
        staging = "ecs_staging"
        qa = "ecs_qa"
    }
}

# Availability zones to launch instances in to
variable "availability_zones" {
    default = "eu-west-1a,eu-west-1b"
    description = "Comma separated list of EC2 availability zones to launch instances, must be within region"
}

# VPC IDs
variable "vpc_id" {
    default = {
        production = "vpc-25b11540"
        staging = "vpc-3b30a75e"
        qa = "vpc-713daa14"
    }
    description = "VPC ID"
}

# Comma separated list of subnets in the VPC to place instances
variable "subnet_ids" {
    default = {
        production = "subnet-XXXXXXXX,subnet-XXXXXXXX"
        staging = "subnet-XXXXXXXX,subnet-XXXXXXXX"
        qa = "subnet-XXXXXXXX,subnet-XXXXXXXX"
    }
    description = "Comma separated list of subnet ids, must match availability zones"
}

# Comma separated list of all cidr blocks for the VPC
variable "vpc_cidr_blocks" {
    description = "CIDR block to allow access for this VPC"
    default = {
        production = "10.0.0.0/16"
        staging = "10.10.0.0/16"
        qa = "10.20.0.0/16"
   }
}

variable "instance_type" {
    description = "Name of the AWS instance type"
}

variable "volume_size" {
    description = "The size of the volume for an instance"
}

variable "min_size" {
    default = "1"
    description = "Minimum number of instances to run in the group"
}

variable "max_size" {
    default = "10"
    description = "Maximum number of instances to run in the group"
}

variable "desired_capacity" {
    description = "Desired number of instances to run in the group"
}

variable "health_check_grace_period" {
    default = "300"
    description = "Time after instance comes into service before checking health"
}

