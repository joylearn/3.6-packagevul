output "github_actions_role_arn" {
  description = "Add this value to the repository Actions secret named OIDC_ROLE."
  value       = aws_iam_role.github_actions.arn
}
