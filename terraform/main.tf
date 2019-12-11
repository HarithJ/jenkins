terraform {
  backend "gcs" {
    bucket  = "andela-jenkins-tf"
    prefix  = "terraform/state"
  }
}

module "gke" {
  source = "./modules/gke"
  gcp-project-id = "${var.gcp-project-id}"
  region = "${var.region}"
  zone = "${var.zone}"
  product = "jenkins"
  owner = "${var.owner}"
  maintainer = "${var.maintainer}"
  cluster-name = "${var.cluster-name}"
}
