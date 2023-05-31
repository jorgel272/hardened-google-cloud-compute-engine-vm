###############################################################################
# General variables for creating Compute Engine in Google Cloud
###############################################################################

variable "gcp_project_id" {
  type    = string
  default = "name-of-your-google-cloud-project"
}

variable "gcp_region" {
  description = "Default region for Google provider"
  default     = "europe-west4"
  type        = string
}

variable "gcp_zone_primary" {
  description = "GCP Primary region, zone in Netherlands"
  default     = "europe-west4-c"
  type        = string
}

###############################################################################
# Variables for Compute Engine deployment
###############################################################################

variable "compute_engine_instance_name" {
  description = "Name of the Compute Engine Instance"
  type        = string
  default     = "awesome-name-for-your-compute-engine-instance"
}

variable "sa-ce-scopes" {
  type = list(string)

  default = [
    "https://www.googleapis.com/auth/compute.readonly",
    "https://www.googleapis.com/auth/cloud.useraccounts.readonly",
    "https://www.googleapis.com/auth/devstorage.read_only",
    "https://www.googleapis.com/auth/servicecontrol",
    "https://www.googleapis.com/auth/service.management.readonly",
    "https://www.googleapis.com/auth/logging.write",
    "https://www.googleapis.com/auth/trace.append",
    "https://www.googleapis.com/auth/monitoring.write",
  ]
}

variable "local_vpc_AweSomeName_network_name" {
  description = "Name of the local created VPC Network"
  type        = string
  default     = "local-vpc-awesomename"
}

variable "local_vpc_AweSomeName_subnet_name" {
  description = "Name of the local created subnet."
  type        = string
  default     = "awesomename-country-code" #CustomerName-NL
}

variable "private_static_ip" {
  description = "The static private IP address for Compute Engine. Only IPv4 is supported."
  type        = string
  default     = null
}

variable "public_static_ip" {
  description = "The static external IP address for Compute Engine instance. Only IPv4 is supported. Set by the API if undefined."
  type        = string
  default     = null
}
