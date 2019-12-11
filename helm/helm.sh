#!/bin/bash

# Connect to the cluster using gcloud command.
# Function takes 3 arguments;
#   first argument is the cluster name
#   second argument is the zone in which the cluster is in
#   thirs argument is the GCP project ID the cluster is in
connectToCluster() {
  gcloud container clusters get-credentials $1 --zone $2 --project $3
}

# Create service account and cluster role bindings for tiller and
#   install tiller on to the cluster.
helmIns() {
 kubectl -n kube-system create serviceaccount tiller
 kubectl create clusterrolebinding tiller --clusterrole cluster-admin --serviceaccount=kube-system:tiller
 helm init --service-account=tiller --wait
}

# Remove tiller from the cluster, together with sevice account and
#   cluster role bindings created for tiller.
helmDel() {
 kubectl -n kube-system delete deployment tiller-deploy
 kubectl delete clusterrolebinding tiller
 kubectl -n kube-system delete serviceaccount tiller
}

# Install jenkins and nginx ingress helm chart.
# Function takes 4 arguments;
#   first argument is setting the value of IP address in the nginx ingress chart
#   second argument is setting the admin username for logging in Jenkins
#   third argument is setting the password that would be used to login to Jenkins
#   fourth argument is setting the Admin email for Jenkins
jenkinsIns() {
  helm install --name nginx-ingress stable/nginx-ingress --set rbac.create=true --set controller.service.loadBalancerIP=$1
  helm install --name jenkins stable/jenkins -f helm/jenkins-values.yml
}

# This would enable to upgrade Jenkins installation after changing
#   its values file.
jenkinsUpgrade() {
  helm upgrade jenkins stable/jenkins -f helm/jenkins-values.yml
}

# Delete nginx ingress and jenkins helm chart
jenkinsDel() {
  helm del --purge nginx-ingress
  helm del --purge jenkins
}

$@
