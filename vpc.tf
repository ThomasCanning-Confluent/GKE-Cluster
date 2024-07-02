variable "project_id" {
  description = "project id"
}

variable "region" {
  description = "region"
}

provider "google" {
  project = var.project_id
  region  = var.region
}

# a google compute network is the aws equivalent of a vpc
resource "google_compute_network" "vpc" {
  name                    = "tcanning-test-vpc"
  auto_create_subnetworks = "false"
}

# a google compute subnetwork is the aws equivalent of a subnet
resource "google_compute_subnetwork" "subnet" {
  name          = "tcanning-test-subnet"
  region        = var.region
  network       = google_compute_network.vpc.name
  ip_cidr_range = "10.10.0.0/24"
}
