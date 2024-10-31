provider "aws" {
  region = var.AWS_REGION

  assume_role {
    role_arn     = "arn:aws:iam::043309319757:role/Engineer"
    
  }
}

