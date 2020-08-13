#!/bin/bash
set -o errexit
set -o pipefail
set -o nounset
set -o xtrace
# set -eox pipefail #safety for script

#https://istio.io/latest/docs/setup/getting-started/
echo "===============================Install Istio with Helm==========================================================="
# Add Istio Helm repository
export ISTIO_VER="1.2.3"
helm repo add istio.io https://storage.googleapis.com/istio-release/releases/${ISTIO_VER}/charts

# Installing the Istio custom resource definitions
helm upgrade -i istio-init istio.io/istio-init --wait --namespace istio-system

# Wait for Istio CRDs to be deployed
# kubectl -n istio-system wait --for=condition=complete job/istio-init-crd-10
# kubectl -n istio-system wait --for=condition=complete job/istio-init-crd-11
# kubectl -n istio-system wait --for=condition=complete job/istio-init-crd-12

echo "Waiting for Istio CRDs to be deployed"
for i in {1..150}; do # Timeout after 5 minutes, 60x5=300 secs
      if kubectl get pods --namespace=istio-system  | grep ContainerCreating ; then
        sleep 10
      else
        break
      fi
done


# Create a secret for Grafana credentials
# generate a random password
PASSWORD=$(head -c 12 /dev/urandom | shasum| cut -d' ' -f1)

kubectl -n istio-system create secret generic grafana \
--from-literal=username=admin \
--from-literal=passphrase="$PASSWORD"

# Configure Istio with Prometheus, Jaeger, and cert-manager and set your load balancer IP
helm upgrade --install istio istio.io/istio \
--namespace=istio-system \
-f ./my-istio.yaml

# Verify that Istio workloads are running:
# watch kubectl -n istio-system get pods
echo "Waiting for Istio workloads to be deployed"
for i in {1..150}; do # Timeout after 5 minutes, 60x5=300 secs
      if kubectl get pods --namespace=istio-system  | grep ContainerCreating ; then
        sleep 10
      else
        break
      fi
done


