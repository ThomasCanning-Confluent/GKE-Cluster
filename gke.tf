
variable "gke_username" {
  default     = ""
  description = "gke username"
}

variable "gke_password" {
  default     = ""
  description = "gke password"
}

#We are creating a GKE with 2 nodes
variable "gke_num_nodes" {
  default     = 2
  description = "number of gke nodes"
}

# Provides you with the versions of gke available in the region that start with 1.27
data "google_container_engine_versions" "gke_version" {
  location = var.region
  version_prefix = "1.27."
}

# Create a GKE cluster
resource "google_container_cluster" "primary" {
  name     = "tcanning-test-gke"
  location = var.region

  # We can't create a cluster with no node pool defined, but we want to only use
  # separately managed node pools. So we create the smallest possible default
  # node pool and immediately delete it.
  remove_default_node_pool = true
  initial_node_count       = 1

  # Network refers to the vpc, subnetwork refers to the subnet
  network    = google_compute_network.vpc.name
  subnetwork = google_compute_subnetwork.subnet.name
}

# Separately Managed Node Pool
# A node pool is a group of nodes in a cluster, with the same configuration
# It is where your applications run
resource "google_container_node_pool" "primary_nodes" {
  name       = "${google_container_cluster.primary.name}-node-pool"
  location   = var.region
  cluster    = google_container_cluster.primary.name

  version    = "1.29.4-gke.1043002" # Specify a valid version within one minor version of master
  node_count = var.gke_num_nodes

  node_config {
    # oauth scopes are the permissions that the node has
    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]

    labels = {
      env = var.project_id
    }

    machine_type = "n1-standard-1"
    tags         = ["gke-node", "${var.project_id}-gke"]
    metadata = {
      disable-legacy-endpoints = "true"
    }
  }
}