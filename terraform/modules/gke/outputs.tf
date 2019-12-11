output "ip-address" {
  value = "${google_compute_address.jenkins-ip-address.address}"
  sensitive   = true
}

output "cluster-name" {
  value = "${google_container_cluster.jenkins-cluster.name}"
}

output "cluster-zone" {
  value = "${google_container_cluster.jenkins-cluster.zone}"
}

output "gcp-project-id" {
  value = "${google_container_cluster.jenkins-cluster.project}"
}
