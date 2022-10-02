
# Some Useful helm commands for Rancher

```
helm repo list

helm repo add rancher-latest https://releases.rancher.com/server-charts/latest

helm install rancher rancher-latest/rancher --namespace cattle-system --set hostname=192.168.1.96.sslip.io --set bootstrapPassword=admin --set replicas=3

helm list -n cattle-system
```

### Uninstall the chart
```
helm uninstall rancher -n cattle-system
helm repo remove
```
### Usefull helm commands to create helm chart
### To Create a new Helm chart

helm show

helm create bigopencloud

