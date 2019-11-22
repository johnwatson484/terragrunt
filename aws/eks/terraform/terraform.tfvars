terragrunt = {

  remote_state  {
    backend = "s3"
    config {
      bucket = "johnwatsonaws1-eks-terraform-shared-state"
      key = "${path_relative_to_include()}/terraform.tfstate"
      region = "eu-west-2"
      encrypt = true     
    }
  }
  
  terraform {
    source = "git::git@github.com:johnwatson484/terraform.git//aws//eks//eks_cluster"
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
