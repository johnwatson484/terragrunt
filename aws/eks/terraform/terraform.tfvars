terragrunt = {

  remote_state  {
    backend = "s3"
    config {
      bucket = "${get_aws_account_id()}-eu-west-2-eks-terraform-shared-state"
      key = "${path_relative_to_include()}/terraform.tfstate"
      region = "eu-west-2"
      encrypt = true
      dynamodb_table = "${get_aws_account_id()}-eu-west-2-eks-statedb"      
    }
  }
  
  terraform {
    source = "git::git@github.com:johnwatson484/terraform.git"
    extra_arguments "bucket" {
    commands = ["${get_terraform_commands_that_need_vars()}"]
    optional_var_files = [
      "${get_tfvars_dir()}/${find_in_parent_folders("global.tfvars", "ignore")}",
      "${get_tfvars_dir()}/${find_in_parent_folders("environment.tfvars", "ignore")}"
      ]
    }
  }
}

terraform = {
  backend "s3" {}
}
