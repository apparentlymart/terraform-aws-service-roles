# AWS Service IAM Roles Terraform Module

This is a Terraform module for easily creating AWS IAM roles that can be
assumed by particular AWS services.

Each service role must have an assume role policy that follows a predictable
pattern and differs only in the specific service identifier specified. This
module allows creating many service roles at once, specifying for each one
a set of identifiers for the services that are allowed to assume it.

```hcl
module "service_roles" {
  source = "apparentlymart/service-roles/aws"

  # A "service group" is a logical grouping of service identifiers that share
  # a single service role.
  service_groups = {
    # The simplest case is for a service group to contain only one service
    # identifier.
    redshift = ["redshift.amazonaws.com"]

    # We might group together services into a single group in order to attach
    # a common set of policies to them all.
    compute = [
        "autoscaling.amazonaws.com",
        "ecs.amazonaws.com",
        "elasticloadbalancing.amazonaws.com",
        "maintenance.elasticbeanstalk.amazonaws.com",
    ]
  }
}

# Attach policies to the individual IAM roles, selecting them from the module's
# roles map by service group name.
resource "aws_iam_role_policy" "redshift" {
  name = "redshift"
  role = module.service_roles.roles["redshift"].name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow",
        Resource = "*"
        Action   = ["s3:*"]
      },
    ]
  })
}

# Pass the individual IAM roles to the services that need them, selecting them
# from the module's roles map by service group name.
resource "aws_redshift_cluster" "example" {
  cluster_identifier = "example"
  database_name      = "example"
  master_username    = "example"
  master_password    = "exampleexample"
  node_type          = "dc1.large"
  cluster_type       = "single-node"

  iam_roles = [module.service_roles.roles["redshift"].arn]

  # Make sure the role's policy is attached before making the cluster, or else
  # the cluster might initially not have the expected access. Terraform can't
  # infer this dependency automatically.
  depends_on = [aws_iam_role_policy.redshift]
}
```

## The Generated Assume Role Policies

This module generates assume role policies in a formulaic way, producing a
policy document like the following:

```json
{
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Effect": "Allow",
            "Principal": {
                "Service": [
                    "application-autoscaling.amazonaws.com",
                    "ec2.amazonaws.com"
                ]
            }
        }
    ],
    "Version": "2012-10-17"
}
```

Only the `"Service"` property value varies between roles, reflecting the set
of service identifiers for a particular service group.
