#!/bin/bash

#set our rancher hostname
rancherHostName=bigopencloud.pnayak.com
hostNameChoice=n
domainRegex='(?:[a-z0-9](?:[a-z0-9-]{0,61}[a-z0-9])?.)+[a-z0-9][a-z0-9-]{0,61}[a-z0-9]'
while [ "$hostNameChoice" != "y" ]
do
    echo 'set your rancher hostname (IE: 192.168.1.100.bigopencloud.pnayak.com)'
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

sudo cp rancher.yaml /var/lib/rancher/k3s/server/manifests/rancher.yaml
