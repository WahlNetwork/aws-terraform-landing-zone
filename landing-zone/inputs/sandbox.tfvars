environment                         = "sandbox"
project_name                        = "landing-zone"
budget_name                         = "Sandbox Monthly Budget"
budget_amount                       = 5
budget_time_unit                    = "MONTHLY"
budget_notification_email           = "aws-alerts@example.com"
budget_threshold                    = 100
terraform_state_bucket_name         = "wn-sandbox-terraform-state"
terraform_state_kms_alias_name      = "alias/wn-sandbox-terraform-state"
terraform_state_dynamodb_table_name = "landing-zone-terraform-state-lock"
terraform_state_sso_principal_name  = "AWSReservedSSO_AWSAdministratorAccess"
