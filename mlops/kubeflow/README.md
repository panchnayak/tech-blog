
Install kustomize on Mac

brew install yq
brew install kustomize

On Mac Install kind

curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.10.0/kind-darwin-amd64
chmod +x ./kind
mv ./kind /usr/local/bin/kind

Deploy kind cluster

kind create cluster --config kind/kind-cluster.yaml


kind create cluster --name cluster1 --image kindest/node:v1.21.1




Follow Document here

https://github.com/kubeflow/manifests#installation








