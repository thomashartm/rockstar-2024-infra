locals {
  gh_version             = "master"
  stage                  = "test"
  # VPC settings
  vpc_name               = "chataem-network-test"
  vpc_azs                = ["eu-central-1a", "eu-central-1b", "eu-central-1c"]
  vpc_cidr               = "10.0.0.0/16"
  #vpc_private_subnets    = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  #vpc_public_subnets     = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
  #vpc_database_subnets     = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
  vpc_enable_nat_gateway = true
  vpc_enable_vpn_gateway = true
  vpc_tag                = "chataem-vpc-test"
  public_subnet_tag      = "chataem_public"
  private_subnet_tag     = "chataem_private"
  database_subnet_tag    = "chataem_database"
  internal_sg_name       = "chataem-nc-sg"
  security_group_names   = ["chataem-nc-sg"]
  db_name                = "chataemdocs"

}