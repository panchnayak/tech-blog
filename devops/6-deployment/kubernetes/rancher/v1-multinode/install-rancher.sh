#!/bin/bash

#set our rancher hostname
rancherHostName=cloud.bigopen.io
hostNameChoice=n
domainRegex='(?:[a-z0-9](?:[a-z0-9-]{0,61}[a-z0-9])?.)+[a-z0-9][a-z0-9-]{0,61}[a-z0-9]'
while [ "$hostNameChoice" != "y" ]
do
    echo 'set your rancher hostname (IE: 192.168.1.100.bigopen.pnayak.com)'
    read rancherHostName
    echo "you set your rancherHostName to $rancherHostName"
    read -p "Is this right (y/n)? " hostNameChoice
    printf "\n"
done

if echo "$rancherHostName" | grep -q -v -P $domainRegex
then
  echo "$rancherHostName does not match a normal domain name"
  exit
fi

#create the namespaces we need
kubectl create namespace ingress-nginx
kubectl create namespace cert-manager
kubectl create namespace cattle-system

#create a label for cert manager
kubectl label namespace cert-manager certmanager.k8s.io/disable-validation=true

#Install Nginx Ingress
sudo cp ingress-nginx.yaml /var/lib/rancher/k3s/server/manifests/ingress-nginx.yaml

#Install Cert-Manager
sudo cp cert-manager.yaml /var/lib/rancher/k3s/server/manifests/cert-manager.yaml
#Install Rancher
cat > rancher.yaml <<EOF
apiVersion: helm.cattle.io/v1
kind: HelmChart
metadata:
  name: rancher
  namespace: cattle-system
spec:
  repo: https://releases.rancher.com/server-charts/latest
  chart: rancher
  targetNamespace: cattle-system
  valuesContent: |
    replicas: 1
    hostname: $rancherHostName
EOF

sudo cp rancher.yaml /var/lib/rancher/k3s/server/manifests/rancher.yaml


