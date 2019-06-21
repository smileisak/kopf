#!/bin/bash
# See https://github.com/LiliC/travis-minikube for Travis+Minikube.
set -eu
set -x

# Download and install kubectl
curl -LO https://storage.googleapis.com/kubernetes-release/release/${KUBERNETES_VERSION}/bin/linux/amd64/kubectl && chmod +x kubectl && sudo mv kubectl /usr/local/bin/

# Download and install KinD
curl -Lo ./kind-linux-amd64 https://github.com/kubernetes-sigs/kind/releases/download/v0.3.0/kind-linux-amd64
chmod +x ./kind-linux-amd64
mv ./kind-linux-amd64 /usr/local/bin/kind

# Create a new Kubernetes cluster using KinD
kind create cluster

# Set KUBECONFIG environment variable
cp "$(kind get kubeconfig-path)"  ~/.kube/config