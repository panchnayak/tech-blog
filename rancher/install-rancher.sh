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
cat > /var/lib/rancher/k3s/server/manifests/ingress-nginx.yaml <<EOF
apiVersion: helm.cattle.io/v1
kind: HelmChart
metadata:
  name: ingress-nginx
  namespace: kube-system
spec:
  chart: ingress-nginx
  repo: https://kubernetes.github.io/ingress-nginx
  targetNamespace: ingress-nginx
  set:
  valuesContent: |-
    fullnameOverride: ingress-nginx
    ingressClassResource:
        default: true
    controller:
      watchIngressWithoutClass: true
      kind: DaemonSet
      hostNetwork: true
      hostPort:
        enabled: true
      service:
        enabled: false
      publishService:
        enabled: false
      metrics:
        enabled: true
        serviceMonitor:
          enabled: true
      config:
        use-forwarded-headers: "true"
EOF

#Install Cert-Manager
cat > /var/lib/rancher/k3s/server/manifests/cert-manager.yaml <<EOF
apiVersion: helm.cattle.io/v1
kind: HelmChart
metadata:
  name: cert-manager
  namespace: cert-manager
spec:
  repo: https://charts.jetstack.io
  chart: cert-manager
  targetNamespace: cert-manager
  valuesContent: |
    installCRDs: true
EOF

#Install Rancher
cat > /var/lib/rancher/k3s/server/manifests/rancher.yaml <<EOF
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