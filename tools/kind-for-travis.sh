#!/bin/bash
# See https://github.com/LiliC/travis-minikube for Travis+Minikube.
set -eu
set -x

curl -Lo kubectl https://storage.googleapis.com/kubernetes-release/release/v${KUBERNETES_VERSION}/bin/linux/amd64/kubectl
chmod +x kubectl
sudo mv kubectl /usr/local/bin/

curl -Lo minikube https://storage.googleapis.com/minikube/releases/v${MINIKUBE_VERSION}/minikube-linux-amd64
chmod +x minikube
sudo mv minikube /usr/local/bin/

mkdir -p $HOME/.kube $HOME/.minikube
touch $KUBECONFIG

sudo minikube start \
    --vm-driver=none \
    --extra-config=apiserver.authorization-mode=RBAC \
    --extra-config=apiserver.runtime-config=events.k8s.io/v1beta1=false \
    --kubernetes-version=v${KUBERNETES_VERSION}

sudo chown -R travis: /home/travis/.minikube/

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