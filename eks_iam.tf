# Define data source for the current AWS account
data "aws_caller_identity" "current" {}

# Create IAM role for EKS access
resource "aws_iam_role" "eks_user_role" {
  name = "eks-user-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Principal = {
          Service = "eks.amazonaws.com"
        }
        Effect = "Allow"
        Sid    = ""
      }
    ]
  })
}

# Attach managed policies to the role
resource "aws_iam_role_policy_attachment" "eks_user_policy" {
  role       = aws_iam_role.eks_user_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

resource "aws_iam_role_policy_attachment" "eks_worker_policy" {
  role       = aws_iam_role.eks_user_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "eks_worker_policy" {
  role       = aws_iam_role.eks_user_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_iam_role_policy_attachment" "eks_worker_policy" {
  role       = aws_iam_role.eks_user_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

# Custom policy for additional EKS access
resource "aws_iam_role_policy" "custom_eks_access" {
  name   = "CustomEKSAccessPolicy"
  role   = aws_iam_role.eks_user_role.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "eks:DescribeCluster",
          "eks:ListClusters",
          "eks:ListFargateProfiles",
          "eks:DescribeFargateProfile",
          "eks:ListNodegroups",
          "eks:DescribeNodegroup",
          "eks:ListUpdates",
          "eks:DescribeUpdate"
        ],
        Resource = "*"
      }
    ]
  })
}

# Policy allowing IAM user to assume the role
resource "aws_iam_policy" "eks_assume_role_policy" {
  name        = "eks-assume-role-policy"
  description = "Policy for allowing user to assume EKS role"
  policy      = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = "sts:AssumeRole",
        Resource = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/eks-user-role"
      }
    ]
  })
}

# Attach the assume role policy to the IAM user
resource "aws_iam_user_policy_attachment" "user_assume_role_attachment" {
  user       = "manojvaddi"
  policy_arn = aws_iam_policy.eks_assume_role_policy.arn
}
