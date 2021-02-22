This repository is meant to create an aws environment and deploy the sample code for the Citrine Informatics skills test 

# The environment includes:
  * ECS Cluster
  * ECR Repository
  * IAM Role
  * VPC
  * Internet Gateway
  * Subnets
  * Security Groups
  * Load Balancers
  * Elastic IP Address
  * Autoscaling
  * Cloudwatch Alarms
  * Cloudwatch logs

# Local app requirements:
  * make
  * terraform
  * docker
  * aws

## Configuration - Change some configuration variables.

### Makefile
  * set AWS_PROFILE to match your IAM user.  Default is citrine-interview-admin

### citrine-sample-service-terraform/provider.tf
  * set the profile to match your IAM user.  Default is citrine-interview-admin

If you are creating a new user, the minimal IAM policy permissions are listed at the bottom of this file.

## Setup terraform and create the environment (only need to do this once)
  * `make terraform_init`
  * `make terraform_apply`

  update the ECR_REPOSITORY variable in the Makefile to match your repository

  also note the alb hostname, that is where you will be able to reach the application

### Connect your docker to the elastic container registry punch/sample-service
  * `aws ecr get-login-password --region us-west-2 --profile citrine-interview-admin | docker login --username AWS --password-stdin 624081292306.dkr.ecr.us-west-2.amazonaws.com/punch/sample-service`

### Clone sample-service from github
  * `make clone`

## To build and push updates (this will build master by default, see `make build` below for how to influence that)
  * `make build`
  * `make docker_tag`
  * `make docker_push`

---

# Reference

## Make targets:

* `make clone` - clones the citrine sample-service git repository
* `make build` - creates the sample-service docker image

  Optional arguments: GIT_HASH

    This will build a specific version of the docker image

    example: make build GIT_HASH=a6cf16ca0ce2c07ffc3727550db29b5dbd2fa9a1

* `make docker_tag` - tags the docker image to the amazon container registry
* `make docker_push` - pushes the docker image to the amazon container registry
* `make terraform_init` - initialize the terraform environment for the first time
* `make terraform_validate` - run terraform validate
* `make terraform_plan` - run terraform plan
* `make terraform_apply` - run terraform apply
* `make terraform_destroy` - run terraform destroy
* `make aws_check_error` - search the cloudtrail logs for a specific error

  Required arguments: REQ

    example: `make aws_check_error REQ=93d9650a-3595-48ca-9447-b9dedc99592d`

* `make aws_decode` - decode an encoded error message

  Required arguments: MSG

    example: `make aws_decode MSG=GLOeLQBdEEcXo04...`

```
IAM policy permissions for the terraform admin user:

{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "ec2:AuthorizeSecurityGroupIngress",
                "ec2:AttachInternetGateway",
                "ec2:DeleteRouteTable",
                "ec2:CreateNetworkInterfacePermission",
                "ec2:CreateRoute",
                "ec2:CreateInternetGateway",
                "ec2:RevokeSecurityGroupEgress",
                "ec2:DeleteInternetGateway",
                "ec2:DescribeVpcClassicLinkDnsSupport",
                "ec2:DisassociateRouteTable",
                "ec2:RevokeSecurityGroupIngress",
                "ec2:CreateNetworkInterface",
                "ec2:DeleteNatGateway",
                "ec2:CreateSubnet",
                "ec2:DescribeSubnets",
                "ec2:CreateNatGateway",
                "ec2:CreateVpc",
                "ec2:DescribeVpcAttribute",
                "ec2:ModifySubnetAttribute",
                "ec2:DescribeAvailabilityZones",
                "ec2:ReleaseAddress",
                "ec2:DescribeSecurityGroups",
                "ec2:DescribeVpcs",
                "ec2:DeleteSubnet",
                "ec2:AssociateRouteTable",
                "ec2:DescribeInternetGateways",
                "ec2:DescribeAccountAttributes",
                "ec2:DescribeRouteTables",
                "ec2:DeleteNetworkInterface",
                "ec2:CreateRouteTable",
                "ec2:DetachInternetGateway",
                "ec2:DescribeVpcClassicLink",
                "ec2:DeleteVpc",
                "ec2:DescribeAddresses",
                "ec2:DeleteNetworkInterfacePermission",
                "ec2:DescribeNetworkInterfaces",
                "ec2:CreateSecurityGroup",
                "ec2:AuthorizeSecurityGroupEgress",
                "ec2:DetachNetworkInterface",
                "ec2:DeleteRoute",
                "ec2:DescribeNatGateways",
                "ec2:AllocateAddress",
                "ec2:DeleteSecurityGroup",
                "ec2:AttachNetworkInterface",

                "elasticloadbalancing:ModifyListener",
                "elasticloadbalancing:CreateTargetGroup",
                "elasticloadbalancing:ModifyLoadBalancerAttributes",
                "elasticloadbalancing:CreateLoadBalancer",
                "elasticloadbalancing:DeleteTargetGroup",
                "elasticloadbalancing:DescribeTargetGroups",
                "elasticloadbalancing:DeleteListener",
                "elasticloadbalancing:RegisterTargets",
                "elasticloadbalancing:DeleteLoadBalancer",
                "elasticloadbalancing:DescribeLoadBalancers",
                "elasticloadbalancing:ModifyTargetGroupAttributes",
                "elasticloadbalancing:DeregisterTargets",
                "elasticloadbalancing:DescribeLoadBalancerAttributes",
                "elasticloadbalancing:DescribeTargetGroupAttributes",
                "elasticloadbalancing:CreateListener",
                "elasticloadbalancing:DescribeListeners",
                "elasticloadbalancing:DescribeTags",
                "elasticloadbalancing:SetSecurityGroups",
                "elasticloadbalancing:ModifyTargetGroup",

                "cloudwatch:DeleteAlarms",
                "cloudwatch:ListTagsForResource",
                "cloudwatch:PutMetricAlarm",
                "cloudwatch:DescribeAlarms",

                "ecr:DeleteRepository",
                "ecr:GetAuthorizationToken",
                "ecr:InitiateLayerUpload",
                "ecr:ListTagsForResource",
                "ecr:BatchCheckLayerAvailability",
                "ecr:CreateRepository",
                "ecr:GetDownloadUrlForLayer",
                "ecr:PutImage",
                "ecr:BatchGetImage",
                "ecr:UploadLayerPart",
                "ecr:CompleteLayerUpload",
                "ecr:DescribeRepositories",

                "ecs:DescribeTaskDefinition",
                "ecs:DeleteCluster",
                "ecs:DeregisterTaskDefinition",
                "ecs:UpdateService",
                "ecs:RegisterTaskDefinition",
                "ecs:CreateCluster",
                "ecs:DeleteService",
                "ecs:DescribeClusters",
                "ecs:CreateService",
                "ecs:DescribeServices",

                "cloudtrail:LookupEvents",

                "iam:GetRole",
                "iam:DeleteRole",
                "iam:ListInstanceProfilesForRole",
                "iam:PassRole",
                "iam:ListRoles",
                "iam:CreateServiceLinkedRole",
                "iam:CreateRole",
                "iam:AttachRolePolicy",
                "iam:DetachRolePolicy",
                "iam:ListAttachedRolePolicies",

                "application-autoscaling:DeleteScalingPolicy",
                "application-autoscaling:DescribeScalingPolicies",
                "application-autoscaling:RegisterScalableTarget",
                "application-autoscaling:PutScalingPolicy",
                "application-autoscaling:DescribeScalableTargets",
                "application-autoscaling:DeregisterScalableTarget",

                "logs:ListTagsLogGroup",
                "logs:DeleteLogStream",
                "logs:CreateLogStream",
                "logs:CreateLogGroup",
                "logs:DescribeLogStreams",
                "logs:DescribeLogGroups",
                "logs:DeleteLogGroup",
                "logs:PutLogEvents",
                "logs:PutRetentionPolicy",

                "sts:DecodeAuthorizationMessage",
                "sts:AssumeRole"
            ],
            "Resource": "*"
        }
    ]
}
```