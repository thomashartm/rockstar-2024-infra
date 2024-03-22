variable "db_instance_name" {
  description = "DB instance name. Must be unique so ideally combine with stage"
  type        = string
}

variable "stage" {
  type = string
}

variable "tags" {
  type        = map(any)
  description = "Extra tags attached to the resources"
}

##########################
# VPC and networking
##########################
variable "vpc_tag" {
  type = string
}

variable "security_group_names" {
  type        = list(string)
  description = "List of VPC security group names to associate to the cluster in addition to the SG we create in this solution"
}

variable "subnet_tags" {
  type        = list(string)
  description = "A list of tags identifying a private subnet which hosts the application"
}

variable "create_source_sg" {
  type        = bool
  description = "Create a a security group to manage access from and to the database"
  default     = true
}

variable "create_db_subnet_group" {
  type        = bool
  description = "Create a security group for the database cluster (internal traffic)"
  default     = true
}

variable "from_port_sg" {
  type        = number
  description = "Incoming forwarding traffic port for the security group"
  default     = 5432
}

variable "to_port_sg" {
  type        = number
  description = "Outgoing forwarding traffic port for the security group"
  default     = 5432
}

######################
# DB Specific Settings
#####################
variable "allocated_storage" {
  type        = number
  description = "Storage allocated to database instance"
  default     = 32
}

variable "engine_version" {
  type        = string
  description = "Database engine version"
  default     = "16.2"
}

variable "param_group_family" {
  type        = string
  description = "Database parameter group family"
  default     = "postgres16"
}

variable "instance_type" {
  type        = string
  description = "Instance type for database instance"
  default     = "db.t3.micro"
}

variable "storage_type" {
  type        = string
  description = "Type of underlying storage for database"
  default     = "gp2"
}

variable "iops" {
  type        = number
  description = "The amount of provisioned IOPS"
  default     = 0
}

variable "snapshot_identifier" {
  type        = string
  description = "The name of the snapshot (if any) the database should be created from"
  default     = ""
}

variable "database_port" {
  type        = number
  description = "Port on which database will accept connections"
  default     = 5432
}

variable "backup_retention_period" {
  type        = number
  description = "Number of days to keep database backups"
  default     = 30
}

variable "backup_window" {
  type        = string
  description = "30 minute time window to reserve for backups"
  # 12:00AM-12:30AM ET
  default     = "04:00-04:30"
}

variable "maintenance_window" {
  type        = string
  description = "60 minute time window to reserve for maintenance"
  # SUN 12:30AM-01:30AM ET
  default     = "sun:04:30-sun:05:30"
}

variable "auto_minor_version_upgrade" {
  type        = bool
  description = "Minor engine upgrades are applied automatically to the DB instance during the maintenance window"
  default     = false
}

variable "final_snapshot_identifier" {
  type        = string
  description = "Identifier for final snapshot if skip_final_snapshot is set to false"
  default     = "chataem-postgresql-rds-snapshot"
}

variable "skip_final_snapshot" {
  type        = bool
  description = "Flag to enable or disable a snapshot if the database instance is terminated"
  default     = true
}

variable "copy_tags_to_snapshot" {
  type        = bool
  description = "Flag to enable or disable copying instance tags to the final snapshot"
  default     = false
}

variable "multi_availability_zone" {
  type        = bool
  description = "Flag to enable hot standby in another availability zone"
  default     = false
}

variable "storage_encrypted" {
  type        = bool
  description = "Flag to enable storage encryption"
  default     = true
}

variable "monitoring_interval" {
  default     = 0
  type        = number
  description = "The interval, in seconds, between points when Enhanced Monitoring metrics are collected"
}

variable "deletion_protection" {
  type        = bool
  description = "Flag to protect the database instance from deletion"
  default     = false
}

variable "cloudwatch_logs_exports" {
  type        = list(any)
  description = "List of logs to publish to CloudWatch Logs"
  default     = ["postgresql", "upgrade"]
}

variable "alarm_cpu_threshold" {
  type        = number
  description = "CPU alarm threshold as a percentage"
  default     = 75
}

variable "alarm_disk_queue_threshold" {
  type        = number
  description = "Disk queue alarm threshold"
  default     = 10
}

variable "alarm_free_disk_threshold" {
  # 5GB
  type        = number
  description = "Free disk alarm threshold in bytes"
  default     = 5000000000
}

variable "alarm_free_memory_threshold" {
  # 128MB
  type        = number
  description = "Free memory alarm threshold in bytes"
  default     = 128000000
}

variable "alarm_cpu_credit_balance_threshold" {
  type        = number
  description = "CPU credit balance threshold (only for db.t* instance types)"
  default     = 30
}

variable "alarm_actions" {
  type        = list(any)
  description = "List of ARNs to be notified via CloudWatch when alarm enters ALARM state"
}

variable "ok_actions" {
  type        = list(any)
  description = "List of ARNs to be notified via CloudWatch when alarm enters OK state"
}

variable "insufficient_data_actions" {
  type        = list(any)
  description = "List of ARNs to be notified via CloudWatch when alarm enters INSUFFICIENT_DATA state"
}

######################
# DB Pool
#####################

variable "max_connections_percent" {
  type        = number
  default     = 100
  description = "Maximum number of proxy connections to db"
}

variable "max_idle_connections_percent" {
  type        = number
  default     = 75
  description = "Controls how actively the proxy closes idle database connections in the connection pool. A high value enables the proxy to leave a high percentage of idle connections open. A low value causes the proxy to close idle client connections and return the underlying database connections to the connection pool"
}

variable "proxy_idle_client_timeout" {
  type        = number
  default     = 600
  description = "The number of seconds that a connection to the proxy can be inactive before the proxy disconnects it."
}


######################
# Settings Parameter
#####################

variable "db_settings_param_name" {
  type        = string
  default     = "chataem-db-settings"
  description = "Database connection settings parameter name which stores ARN of the DB and proxy."
}
