Terraform ECS configuration
===========================

## Small staging environment

This is an example of creating a small ECS cluster staging environment.

To view the plan (dry run) of what will be created/updated/destroyed run:

    $ terraform plan -var-file="staging.tfvars"

If you are happy, apply the configuration/changes:

    $ terraform apply -var-file="staging.tfvars"

## Larger Production environment

To create a larger cluster for your production environment you just need to use the **production.tfvars** file instead and run:

    $ terraform plan -var-file="production.tfvars"

Then, apply the configuration/changes:

    $ terraform apply -var-file="production.tfvars"


## Destroying stuff

When you are done, you can destroy the cluster with the following two steps:

View what is about to be destroyed:

    $ terraform plan -destroy -var-file="staging.tfvars"

Then, when you are ready to destroy run:

    $ terraform destroy -var-file="staging.tfvars"

