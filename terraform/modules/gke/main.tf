provider "google" {
  version = "~> 1.20.0"
  project = "${var.gcp-project-id}"
  region = "${var.region}"
  zone = "${var.zone}"
}
