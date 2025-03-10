# Terraform AWS Infrastructure Module 🚀

This Terraform module sets up and manages various AWS resources for a sandbox environment. Below is a description of the resources being created and managed by this module.

## Commands

These commands are used in the [YouTube video](https://youtu.be/PASG0NTKUQA?si=A6ngP_xhJLRLP1tA):

```bash
terraform init

terraform plan --var-file="inputs/sandbox.tfvars"

terraform apply --var-file="inputs/sandbox.tfvars"

terraform init --backend-config="inputs/sandbox.backend"

```

## Resources 📦

### Budgets and Billing 💰

- **AWS Budget**: Creates a monthly budget to monitor and control costs.
  - **Name**: `${var.budget_name}`
  - **Amount**: `${var.budget_amount} USD`
  - **Time Unit**: `${var.budget_time_unit}`
  - **Notification**: Sends an email to `${var.budget_notification_email}` when the budget exceeds `${var.budget_threshold}%`.

### Terraform Bootstrap Resources 🛠️

- **S3 Bucket**: Creates an S3 bucket to store Terraform state files.

  - **Bucket Name**: `${var.terraform_state_bucket_name}`
  - **Tags**: `Name = ${var.terraform_state_bucket_name}`

- **KMS Key**: Creates a KMS key to encrypt objects in the S3 bucket.

  - **Description**: "This key is used to encrypt bucket objects"
  - **Deletion Window**: 10 days

- **KMS Key Alias**: Creates an alias for the KMS key.

  - **Alias Name**: `alias/terraform-state-bucket`
  - **Target Key ID**: `${aws_kms_key.terraform_state_bucket.key_id}`

- **S3 Bucket Server-Side Encryption Configuration**: Configures server-side encryption for the S3 bucket using the KMS key.

  - **KMS Master Key ID**: `${aws_kms_key.terraform_state_bucket.arn}`
  - **SSE Algorithm**: `aws:kms`

- **S3 Bucket Versioning**: Enables versioning for the S3 bucket.

  - **Status**: Enabled

- **S3 Bucket Policy**: Restricts access to specific IAM roles and enforces secure transport.

  - **Policy**: Denies access if `aws:SecureTransport` is false and allows access to `${var.terraform_state_role_arn}`.

- **DynamoDB Table**: Creates a DynamoDB table for Terraform state locking.
  - **Table Name**: `${var.terraform_state_dynamodb_table_name}`
  - **Billing Mode**: `PAY_PER_REQUEST`
  - **Hash Key**: `LockID`
  - **Tags**: `Name = ${var.terraform_state_dynamodb_table_name}`

## Architecture Diagram 🏗️

```plaintext
+---------------------------+
|        AWS Budget         |
+---------------------------+
            |
            v
+---------------------------+
|        S3 Bucket          |
|  (Terraform State Files)  |
+---------------------------+
            |
            v
+---------------------------+
|         KMS Key           |
|  (Encrypt S3 Objects)     |
+---------------------------+
            |
            v
+---------------------------+
|      DynamoDB Table       |
| (Terraform State Locking) |
+---------------------------+
```

## Outputs 📤

- **Budget ARN**: `${aws_budgets_budget.monthly_budget.arn}`
- **Terraform State Bucket ARN**: `${aws_s3_bucket.terraform_state_bucket.arn}`
- **KMS Key ARN**: `${aws_kms_key.terraform_state_bucket.arn}`
- **KMS Key Alias ARN**: `${aws_kms_alias.terraform_state_bucket.arn}`
- **DynamoDB Table ARN**: `${aws_dynamodb_table.terraform_state_lock.arn}`

## Providers 🌐

- **AWS Provider**: Configures the AWS provider with the region `us-west-2` and default tags.

## Backend Configuration 🗄️

- **S3 Backend**: Configures the backend to use an S3 bucket for storing the Terraform state.

## Variables 🔧

- **environment**: The environment for the resources.
- **project_name**: The name of the project.
- **budget_name**: The name of the budget.
- **budget_amount**: The amount of the budget in USD.
- **budget_time_unit**: The time unit for the budget (MONTHLY, QUARTERLY, ANNUALLY).
- **budget_notification_email**: The email address to send budget notifications.
- **budget_threshold**: The budget threshold percentage for budget notifications.
- **terraform_state_bucket_name**: The name of the S3 bucket to store Terraform state.
- **terraform_state_role_arn**: The ARN of the IAM role that has access to the S3 bucket.
- **terraform_state_dynamodb_table_name**: The name of the DynamoDB table for Terraform state locking.
