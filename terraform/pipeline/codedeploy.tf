
resource "aws_codedeploy_app" "codedeploy_app" {
  compute_platform = "ECS"
  name             = "airport_hangout_frontend_app"
}

resource "aws_codedeploy_deployment_config" "codedeploy_config" {
  deployment_config_name = "airport_hangout_frontend_app_deploy_config"

  minimum_healthy_hosts {
    type  = "HOST_COUNT"
    value = 2
  }
}
