
K3S come with its own service load balancer named Klipper. 

You need to disable it in order to run MetalLB. To disable Klipper, run the server with the --disable servicelb

--disable servicelb

Installation By Manifest
To install MetalLB, apply the manifest:

```
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.12.1/manifests/namespace.yaml
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.12.1/manifests/metallb.yaml
```