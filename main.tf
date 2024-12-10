module "eks" {
 
  source          = "terraform-aws-modules/eks/aws"
  version         = "18.29.0" # Ensure compatibility with your Terraform version
  cluster_name    = "event-booking-cluster"
  cluster_version = "1.22"
  vpc_id          = var.vpc_id
  subnet_ids      = ["subnet-0f7ebc9c2fe25589c"] # Replace with your private subnet IDs
  
  node_groups = {
    eks_nodes = {
      desired_capacity = 2
      max_capacity     = 3
      min_capacity     = 1
      instance_type    = "t3.medium"
    }
  }
}

output "cluster_name" {
  value = module.eks.cluster_name
}
