
## Traefik Proxy 2.x Tutorial

## Install k3s kubernetes cluster
```
curl -sfL https://get.k3s.io | sh -s - --write-kubeconfig-mode 644
```
## download kubectl and intall it.
```
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl
sudo mv kubectl /usr/local/bin
export KUBECONFIG=/etc/rancher/k3s/k3s.yaml
```
### Describe the AddOns installed with k3s
```
kubectl describe AddOn traefik -n kube-system
```

➜  ~ kubectl describe AddOn traefik -n kube-system
Name:         traefik
Namespace:    kube-system
Labels:       <none>
Annotations:  <none>
API Version:  k3s.cattle.io/v1
Kind:         Addon
Metadata:
  Creation Timestamp:  2022-04-29T20:23:53Z
  Generation:          2
  Managed Fields:
    API Version:  k3s.cattle.io/v1
    Fields Type:  FieldsV1
    fieldsV1:
      f:spec:
      f:status:
    Manager:         deploy@rancher-server-1
    Operation:       Update
    Time:            2022-04-29T20:23:53Z
  Resource Version:  383
  UID:               298f5442-c4ae-40ca-b87c-3ba8ad7b2649
Spec:
  Checksum:  c7541e33cac61cf20483fd4327971fa2767c4522ab6fccca7102418d4e7bf76a
  Source:    /var/lib/rancher/k3s/server/manifests/traefik.yaml
Status:
Events:  <none>

pnayak@k3s-master-1:~$ kubectl -n kube-system get all
NAME                                          READY   STATUS      RESTARTS   AGE
pod/coredns-96cc4f57d-zbndr                   1/1     Running     0          9m50s
pod/local-path-provisioner-84bb864455-qnq77   1/1     Running     0          9m50s
pod/helm-install-traefik-crd--1-fjjlg         0/1     Completed   0          9m50s
pod/helm-install-traefik--1-wdtdr             0/1     Completed   1          9m50s
pod/svclb-traefik-wqlgm                       2/2     Running     0          9m25s
pod/metrics-server-ff9dbcb6c-dj6jm            1/1     Running     0          9m50s
pod/traefik-56c4b88c4b-8m2d6                  1/1     Running     0          9m26s
pod/svclb-traefik-xfbpr                       2/2     Running     0          6m42s
pod/svclb-traefik-g7xvb                       2/2     Running     0          6m32s
pod/svclb-traefik-hsp8j                       2/2     Running     0          6m11s

NAME                     TYPE           CLUSTER-IP     EXTERNAL-IP                                               PORT(S)                      AGE
service/kube-dns         ClusterIP      10.43.0.10     <none>                                                    53/UDP,53/TCP,9153/TCP       10m
service/metrics-server   ClusterIP      10.43.16.20    <none>                                                    443/TCP                      10m
service/traefik          LoadBalancer   10.43.146.41   192.168.1.108,192.168.1.110,192.168.1.111,192.168.1.112   80:31314/TCP,443:30641/TCP   9m26s

NAME                           DESIRED   CURRENT   READY   UP-TO-DATE   AVAILABLE   NODE SELECTOR   AGE
daemonset.apps/svclb-traefik   4         4         4       4            4           <none>          9m25s

NAME                                     READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/coredns                  1/1     1            1           10m
deployment.apps/local-path-provisioner   1/1     1            1           10m
deployment.apps/metrics-server           1/1     1            1           10m
deployment.apps/traefik                  1/1     1            1           9m26s

NAME                                                DESIRED   CURRENT   READY   AGE
replicaset.apps/coredns-96cc4f57d                   1         1         1       9m50s
replicaset.apps/local-path-provisioner-84bb864455   1         1         1       9m50s
replicaset.apps/metrics-server-ff9dbcb6c            1         1         1       9m50s
replicaset.apps/traefik-56c4b88c4b                  1         1         1       9m26s

NAME                                 COMPLETIONS   DURATION   AGE
job.batch/helm-install-traefik-crd   1/1           25s        10m
job.batch/helm-install-traefik       1/1           25s        10m


### k3s configures Traefik Proxy to handle incoming HTTP and HTTPS requests and it also enables the API and the dashboard.

```
kubectl -n kube-system describe deploy traefik
```
pnayak@k3s-master-1:~$ kubectl -n kube-system get deploy
NAME                     READY   UP-TO-DATE   AVAILABLE   AGE
coredns                  1/1     1            1           17m
local-path-provisioner   1/1     1            1           17m
metrics-server           1/1     1            1           17m
traefik                  1/1     1            1           16m

pnayak@k3s-master-1:~$ kubectl -n kube-system describe deploy traefik
Name:                   traefik
Namespace:              kube-system
CreationTimestamp:      Wed, 20 Apr 2022 23:18:53 +0000
Labels:                 app.kubernetes.io/instance=traefik
                        app.kubernetes.io/managed-by=Helm
                        app.kubernetes.io/name=traefik
                        helm.sh/chart=traefik-10.14.100
Annotations:            deployment.kubernetes.io/revision: 1
                        meta.helm.sh/release-name: traefik
                        meta.helm.sh/release-namespace: kube-system
Selector:               app.kubernetes.io/instance=traefik,app.kubernetes.io/name=traefik
Replicas:               1 desired | 1 updated | 1 total | 1 available | 0 unavailable
StrategyType:           RollingUpdate
MinReadySeconds:        0
RollingUpdateStrategy:  1 max unavailable, 1 max surge
Pod Template:
  Labels:           app.kubernetes.io/instance=traefik
                    app.kubernetes.io/managed-by=Helm
                    app.kubernetes.io/name=traefik
                    helm.sh/chart=traefik-10.14.100
  Annotations:      prometheus.io/path: /metrics
                    prometheus.io/port: 9100
                    prometheus.io/scrape: true
  Service Account:  traefik
  Containers:
   traefik:
    Image:       rancher/mirrored-library-traefik:2.6.1
    Ports:       9100/TCP, 9000/TCP, 8000/TCP, 8443/TCP
    Host Ports:  0/TCP, 0/TCP, 0/TCP, 0/TCP
    Args:
      --global.checknewversion
      --global.sendanonymoususage
      --entrypoints.metrics.address=:9100/tcp
      --entrypoints.traefik.address=:9000/tcp
      --entrypoints.web.address=:8000/tcp
      --entrypoints.websecure.address=:8443/tcp
      --api.dashboard=true
      --ping=true
      --metrics.prometheus=true
      --metrics.prometheus.entrypoint=metrics
      --providers.kubernetescrd
      --providers.kubernetesingress
      --providers.kubernetesingress.ingressendpoint.publishedservice=kube-system/traefik
      --entrypoints.websecure.http.tls=true
    Liveness:     http-get http://:9000/ping delay=10s timeout=2s period=10s #success=1 #failure=3
    Readiness:    http-get http://:9000/ping delay=10s timeout=2s period=10s #success=1 #failure=1
    Environment:  <none>
    Mounts:
      /data from data (rw)
      /tmp from tmp (rw)
  Volumes:
   data:
    Type:       EmptyDir (a temporary directory that shares a pod's lifetime)
    Medium:
    SizeLimit:  <unset>
   tmp:
    Type:               EmptyDir (a temporary directory that shares a pod's lifetime)
    Medium:
    SizeLimit:          <unset>
  Priority Class Name:  system-cluster-critical
Conditions:
  Type           Status  Reason
  ----           ------  ------
  Available      True    MinimumReplicasAvailable
  Progressing    True    NewReplicaSetAvailable
OldReplicaSets:  <none>
NewReplicaSet:   traefik-56c4b88c4b (1/1 replicas created)
Events:
  Type    Reason             Age   From                   Message
  ----    ------             ----  ----                   -------
  Normal  ScalingReplicaSet  16m   deployment-controller  Scaled up replica set traefik-56c4b88c4b to 1

### Get the Traefik Proxy dashboard
```
kubectl port-forward -n kube-system deployment/traefik  9000:9000
or
kubectl port-forward -n kube-system "$(kubectl get pods -n kube-system| grep '^traefik-' | awk '{print $1}')" 9000:9000
```
### The Traefik dashboard is now accessible at http://localhost:9000/dashboard/

### Authentication

### Create Kubernetes Secret

```
htpasswd -c auth pnayak
kubectl create secret generic userssecret --from-file=auth -n dev
```
Apply the file to create the Middleware and Ingress

```
kubectl create -f whoami-auth.yaml
```
### TLS termination

