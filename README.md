Terraform ECS configuration
===========================

Before you run this, you will need to set your VPC and Subnet IDs in **variables.tf**. You will also need to install terraform either by downloading it from the [Terraform Website](https://www.terraform.io/downloads.html) or if you use homebrew:

    $ brew install terraform

## Small staging environment

This is an example of creating a small ECS cluster staging environment.

To view the plan (dry run) of what will be created/updated/destroyed run:

    $ terraform plan -var-file=staging.tfvars -state=staging.tfstate

If you are happy, apply the configuration/changes:

    $ terraform apply -var-file=staging.tfvars -state=staging.tfstate

## Larger Production environment

To create a larger cluster for your production environment you just need to use the **production.tfvars** file instead and run:

    $ terraform plan -var-file=production.tfvars -state=production.tfstate

Then, apply the configuration/changes:

    $ terraform apply -var-file=production.tfvars -state=production.tfstate

## ECS Instances

This repo will set-up ECS clusters using the official [Amazon Linux ECS Optimized AMIs](http://docs.aws.amazon.com/AmazonECS/latest/developerguide/launch_container_instance.html).

Once the instances boot, they run the following user-data script:

    #!/bin/bash
    yum install -y -q aws-cli
    aws s3 cp s3://ecs/ecs.config.template /etc/ecs/ecs.config.template
    sed "s/__CLUSTERNAME__/${lookup(var.cluster_name, var.environment)}/g" /etc/ecs/ecs.config.template > /etc/ecs/ecs.config"

This will download a simple ECS config file template from S3 that is used to configure the instances ECS agent in order for them to connect to the right ECS cluster. The template is simple:

    ECS_CLUSTER=__CLUSTERNAME__
    ECS_ENGINE_AUTH_TYPE=dockercfg
    ECS_ENGINE_AUTH_DATA={"https://index.docker.io/v1/":{"auth":"put your docker token here","email":"put your email here"}}

You will need to set your Docker ID email address and token in the template and upload it to a S3 bucket, then amend the path in **main.tf**. You can get the token by running 'docker login', to log in and then get the token from the auth field of the config file **~/.docker/config.json**.

This file and the environment variables you can use are documented nicely on the [Amazon ECS docs site](http://docs.aws.amazon.com/AmazonECS/latest/developerguide/private-auth.html).

## Destroying stuff

When you are done, you can destroy the cluster with the following two steps:

View what is about to be destroyed:

    $ terraform plan -destroy -var-file=staging.tfvars -state=staging.tfstate

Then, when you are ready to destroy run:

    $ terraform destroy -var-file=staging.tfvars -state=staging.tfstate

