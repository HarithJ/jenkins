resource "google_container_cluster" "jenkins-cluster" {
  name               = "${var.cluster-name}"
  zone               = "${var.zone}"
  network = "${google_compute_network.jenkins-network.self_link}"
  subnetwork = "${google_compute_subnetwork.jenkins-subnet.self_link}"

  resource_labels = {
    product = "${var.product}"
    owner = "${var.owner}"
    maintainer = "${var.maintainer}"
    state = "in_use"
  }

  remove_default_node_pool = true
  initial_node_count = 1
}

resource "google_container_node_pool" "jenkins-node-pool" {
  name       = "jenkins-node-pool"
  cluster    = "${google_container_cluster.jenkins-cluster.name}"
  node_count = 1

  autoscaling {
    min_node_count = 1
    max_node_count = 20
  }

  node_config {
    machine_type = "n1-standard-4"

    oauth_scopes = [
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring.write",
      "https://www.googleapis.com/auth/service.management.readonly",
      "https://www.googleapis.com/auth/servicecontrol",
      "https://www.googleapis.com/auth/trace.append"
    ]
  }
}

resource "google_container_node_pool" "jenkins-extra-node-pool" {
  name       = "jenkins-extra-node-pool"
  cluster    = "${google_container_cluster.jenkins-cluster.name}"
  node_count = 0

  autoscaling {
    min_node_count = 0
    max_node_count = 20
  }

  node_config {
    machine_type = "n1-standard-16"

    oauth_scopes = [
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring.write",
      "https://www.googleapis.com/auth/service.management.readonly",
      "https://www.googleapis.com/auth/servicecontrol",
      "https://www.googleapis.com/auth/trace.append"
    ]
  }
}
