module "db" {
  source = "terraform-aws-modules/rds/aws"

  identifier = "demodb"

  instance_class                      = "db.t4g.micro"
  engine                              = "postgres"
  engine_version                      = "14"
  port                                = 5432
  db_name                             = "replicaPostgresql"
  username                            = "replica_postgresql"
  password                            = "UberSecretPassword"
  iam_database_authentication_enabled = true
  allocated_storage                   = 20
  vpc_security_group_ids             = [module.db_security_group.security_group_id]
  family                              = "postgres14"
  manage_master_user_password         = false  # Set this to false
  apply_immediately                   = true

  backup_retention_period             = 7  # Set to 7 days to enable automated backups
  maintenance_window                  = "Mon:00:00-Mon:03:00"
  backup_window                       = "03:00-06:00"
  deletion_protection                 = false
  create_db_subnet_group             = true
  subnet_ids                          = module.vpc.database_subnets

  tags = {
    Owner       = "user"
    Environment = "dev"
  }
}

module "replica" {
  source = "terraform-aws-modules/rds/aws"

  identifier = "demodb-replica"

  # Source database. For cross-region use db_instance_arn
  replicate_source_db = module.db.db_instance_arn

  engine            = "postgres"
  engine_version    = "14"
  instance_class    = "db.t4g.micro"
  port              = 5432

  multi_az                = false
  vpc_security_group_ids  = [module.db_security_group.security_group_id]
  maintenance_window      = "Tue:00:00-Tue:03:00"
  backup_window           = "03:00-06:00"
  backup_retention_period = 7  # Set this to a non-zero value

  family              = "postgres14"
  skip_final_snapshot = true
}

