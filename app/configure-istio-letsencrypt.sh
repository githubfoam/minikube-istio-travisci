#!/bin/bash
set -o errexit
set -o pipefail
set -o nounset
set -o xtrace
# set -eox pipefail #safety for script

#https://istio.io/latest/docs/setup/getting-started/
echo "===============================Configure Istio Gateway with Let's Encrypt wildcard certificate==========================================================="

# Create a Istio Gateway in istio-system namespace with HTTPS redirect
kubectl apply -f ./istio-gateway.yaml
