#------------------------------------------------------------------------------
# Bootstrap Compute Engine in Google Cloud
#------------------------------------------------------------------------------

###############################################################################
# Enable APIs - Enable required APIs for deployment
###############################################################################

resource "google_project_service" "compute" {
  service                    = "compute.googleapis.com"
  disable_dependent_services = false
  disable_on_destroy         = false
}

resource "google_project_service" "service_networking" {
  service                    = "servicenetworking.googleapis.com"
  disable_dependent_services = false
  disable_on_destroy         = false
}

########################################################################################
# Create local Custom VPC Network and VPC Subnet
########################################################################################

resource "google_compute_network" "vpc_network" {
  name                            = var.local_vpc_awesomename_network_name
  project                         = var.gcp_project_id
  delete_default_routes_on_create = true
  auto_create_subnetworks         = false
}

resource "google_compute_subnetwork" "vpc_network" {
  name          = var.local_vpc_awesomename_subnet_name
  ip_cidr_range = "10.1.20.0/24"
  region        = var.gcp_region
  network       = google_compute_network.vpc_network.id
}

###############################################################################
# Create Service Account for Compute Engine Instance 
###############################################################################

#Create Service Account. Defined project in resource.
resource "google_service_account" "awesomename-sa-ce-env" {
  project      = var.gcp_project_id
  display_name = "Compute Engine Service Account"
  account_id   = "awesomename-sa-ce-env"
}

#Add role IAM ServiceAccountUser to created Service Account.
resource "google_service_account_iam_member" "service_account_user_awesomename-sa-ce-env" {
  service_account_id = google_service_account.awesomename-sa-ce-env.name
  member             = format("serviceAccount:%s", google_service_account.awesomename-sa-ce-env.email)
  role               = "roles/iam.serviceAccountUser"
}

###############################################################################
# Deploy Compute Instance with static internal and public IPv4 address
###############################################################################

# Static Public IPv4 address or Compute Engine Instance
resource "google_compute_address" "public_static_ip" {
  name   = "ce-awesomename-external-ip"
  region = var.gcp_region
}

# Static Internal IPv4 address for Compute Engine Instance
resource "google_compute_address" "private_static_ip" {
  address_type = "INTERNAL"
  region       = var.gcp_region
  name         = "ce-awesomename-internal-ip"
  subnetwork   = var.local_vpc_awesomename_subnet_name
  address      = "10.1.20.21"
}

resource "google_compute_instance" "awesomename" {
  name                      = var.compute_engine_instance_name
  zone                      = var.gcp_zone_primary
  machine_type              = "e2-highmem-8"
  tags                      = ["http", "https", "ping"]
  project                   = var.gcp_project_id
  can_ip_forward            = false
  allow_stopping_for_update = true

  #Primary local VPC network (NIC0)

  network_interface {
    network    = google_compute_network.vpc_network.id
    network_ip = google_compute_address.private_static_ip.address
    subnetwork = var.local_vpc_awesomename_subnet_name

    access_config {
      nat_ip = google_compute_address.public_static_ip.address
    }
  }

  boot_disk {
    initialize_params {
      image = "debian-12-bookworm-v2024021"
      type  = "pd-ssd"
      size  = "30"
    }
  }

  shielded_instance_config {
    enable_secure_boot          = true
    enable_vtpm                 = true
    enable_integrity_monitoring = true
  }

  #Define API scopes for GCE Service Account.
  service_account {
    email  = google_service_account.awesomename-sa-ce-env.email
    scopes = var.sa-ce-scopes
  }

  metadata = {
    block-project-ssh-keys = true
    enable-os-login        = true
    serial-port-enable     = false
  }
}

###############################################################################
# Create firewall rules to allow incoming traffic to Compute Engine
###############################################################################

# FW Rule 1 - Allow ingress HTTP

resource "google_compute_firewall" "ingress-http-traffic" {
  name    = "allow-ingress-http"
  network = var.local_vpc_awesomename_network_name

  direction = "INGRESS"
  allow {
    protocol = "tcp"
    ports    = ["80"]
  }
  source_ranges = [
    "0.0.0.0/0"
  ]
  target_tags = ["http"]
}

# FW Rule 2 - Allow ingress HTTPS

resource "google_compute_firewall" "ingress-https-traffic" {
  name    = "allow-ingress-https"
  network = var.local_vpc_awesomename_network_name

  direction = "INGRESS"
  allow {
    protocol = "tcp"
    ports    = ["443"]
  }
  source_ranges = [
    "0.0.0.0/0"
  ]
  target_tags = ["https"]
}

# FW Rule 3 - Allow ping

resource "google_compute_firewall" "ingress-ping-traffic" {
  name    = "allow-ingress-ping"
  network = var.local_vpc_awesomename_network_name

  direction = "INGRESS"
  allow {
    protocol = "icmp"
  }
  source_ranges = [
    "0.0.0.0/0"
  ]
  target_tags = ["ping"]
}

# FW Rule 4  - Allow IAP SSH traffic

resource "google_compute_firewall" "ingress-awesomename-ssh-traffic" {
  name    = "allow-ingress-awesomename-ssh"
  network = var.local_vpc_awesomename_network_name

  direction = "INGRESS"
  priority  = "65534"

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  source_ranges = [
    "35.235.240.0/20"
  ]
  target_tags = ["allow-iap-ssh"]
}
