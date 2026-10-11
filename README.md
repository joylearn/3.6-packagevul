# 3.6-packagevul
module 3.6 - package vulnerability scan

## Bootstrap AWS deployment access

The GitHub Actions deployment role must exist before a GitHub Actions job can
assume it. The AWS account in the screenshot already has the GitHub OIDC
provider (`token.actions.githubusercontent.com`) with audience
`sts.amazonaws.com`; the bootstrap configuration looks it up and does not
create another one. It creates the deployment policy and GitHub Actions role.
Run it from a machine with Terraform installed and AWS credentials configured
for AWS account `255945442255`. Terraform is explicitly restricted to that
account and will stop rather than operate in a different account. This is
separate from the Lambda deployment Terraform configuration in `terraform/`.

From the repository root, run:

```sh
terraform -chdir=terraform/bootstrap init
terraform -chdir=terraform/bootstrap validate
terraform -chdir=terraform/bootstrap plan
terraform -chdir=terraform/bootstrap apply
```

Review the plan and confirm the AWS account and region before approving the
apply. The role trust is restricted to pushes from this repository's `main`
branch. The role policy is scoped to this project's Lambda and its execution
role.

After the apply completes, get the role ARN with:

```sh
terraform -chdir=terraform/bootstrap output -raw github_actions_role_arn
```

In the GitHub repository, open **Settings → Secrets and variables → Actions**
and add a repository variable named `OIDC_ROLE` with that ARN as its value. Add
`SNYK_TOKEN` as a separate repository secret for the pull-request scan. Never
commit AWS credentials, secret values, or Terraform state files.

The bootstrap also creates an encrypted, versioned S3 bucket and DynamoDB lock
table for the Lambda deployment's Terraform state. After applying the bootstrap,
initialize the deployment's remote state from the repository root:

```sh
npm run package --prefix lambda
terraform -chdir=terraform init
terraform -chdir=terraform import aws_iam_role.lambda_exec hello-world-nodejs-exec
terraform -chdir=terraform plan
```

The Lambda execution role already exists in AWS but was not created by the
deployment's Terraform state. Importing it once prevents Terraform from trying
to create a duplicate.
Keep the resulting state in the configured S3 backend. Do not commit local
Terraform state files. CI validation initializes Terraform with
`-backend=false`; the deployment workflow uses the remote backend after
authenticating to AWS.
