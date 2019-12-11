resource "google_compute_network" "jenkins-network" {
  name = "jenkins-vpc"
  auto_create_subnetworks = "false"
}

resource "google_compute_subnetwork" "jenkins-subnet" {
  name   = "jenkins-subnet"
  ip_cidr_range = "10.0.0.0/18"
  region = "${var.region}"
  network = "${google_compute_network.jenkins-network.self_link}"
  private_ip_google_access = "true"
}

resource "google_compute_address" "jenkins-ip-address" {
  name = "jenkins-ip-address"
  region = "${var.region}"
  labels = {
    product = "${var.product}"
    owner = "${var.owner}"
    maintainer = "${var.maintainer}"
    state = "in_use"
  }
}
