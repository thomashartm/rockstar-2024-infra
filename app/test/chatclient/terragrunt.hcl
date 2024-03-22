include "root" {
  path   = find_in_parent_folders()
  expose = true
}

# required dependency as the cluster and ALB needs to be existing before creating the module
dependency "ecs_shared" {
  config_path = "../sharedecs"
  mock_outputs = {
    lb_tg_arn = "arn:aws:elasticloadbalancing:eu-central-1::targetgroup/summitchataem-app-tg-test/x"
    lb_https_listener_arn = "arn:aws:elasticloadbalancing:eu-central-1::listener/app/summitchataem-alb-test/y"
  }
}

include "component" {
  path   = "${dirname(find_in_parent_folders())}/_common/ecs-chatclient.hcl"
  expose = true
}

inputs = {
  lb_tg_arn = dependency.ecs_shared.outputs.lb_tg_arn
  lb_listener_arn = dependency.ecs_shared.outputs.lb_https_listener_arn
}