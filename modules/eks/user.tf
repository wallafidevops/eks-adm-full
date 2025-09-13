# Resource: AWS IAM User - Admin User (Has Full AWS Access)
resource "aws_iam_user" "admin_user" {
  name = "${terraform.workspace}-eksadmin"  
  path = "/"
  force_destroy = true

}

# Resource: Admin Access Policy - Attach it to admin user
resource "aws_iam_user_policy_attachment" "admin_user" {
  user       = aws_iam_user.admin_user.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}


# Resource: AWS IAM User - Basic User (No AWSConsole Access for AWS Services)
resource "aws_iam_user" "basic_user" {
  name = "${terraform.workspace}-eksadmin2"  
  path = "/"
  force_destroy = true
}

# Resource: AWS IAM User Policy - EKS Full Accessv
resource "aws_iam_user_policy" "basic_user_eks_policy" {
  name = "${terraform.workspace}-eks-full-access-policy"
  user = aws_iam_user.basic_user.name

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "iam:ListRoles",
          "eks:*",
          "ssm:GetParameter"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}
