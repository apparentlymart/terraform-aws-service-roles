provider "aws" {
  region = "us-west-2"
}

module "under_test" {
  source = "../"

  role_name_prefix      = "service-group-"
  service_group_tag_key = "ServiceGroup"
  service_groups = {
    ec2       = ["ec2.amazonaws.com", "application-autoscaling.amazonaws.com"],
    ecs       = ["ecs.amazonaws.com"]
    ecs-tasks = ["ecs-tasks.amazonaws.com"],
  }
}

output "result" {
  value = module.under_test
}
