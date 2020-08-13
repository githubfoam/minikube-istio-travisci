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

