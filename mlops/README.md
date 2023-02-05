## Deploy K3S Kubernets Cluster

Create 4 VMs, one for master and 3 for Marker Nodes
```
sudo hostnamectl set-hostname k3s-master.local
sudo hostnamectl set-hostname k3s-worker-1.local
sudo hostnamectl set-hostname k3s-worker-2.local
sudo hostnamectl set-hostname k3s-worker-3.local
```
### Install k3s on master node
```
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="--write-kubeconfig-mode 644  --node-taint k3s-controlplane=true:NoExecute" sh -s - server
```
Disable the firewalld and get the token
```
sudo systemctl disable firewalld --now
sudo cat /var/lib/rancher/k3s/server/node-token

```

Install k3s on worker nodes

Disable the firewalld

sudo systemctl disable firewalld --now

```
curl -sfL https://get.k3s.io | K3S_URL=https://10.1.19.83:6443 K3S_TOKEN="K103050d2c188d8dce5b2c3c23e1a4f59fc572489f030c328b3e334b7b176674005::server:1f4332f5a11d7177985430a032a59b71" sh -

kubectl label node k3s-worker-1.local node-role.kubernetes.io/worker=worker
kubectl label node k3s-worker-2.local node-role.kubernetes.io/worker=worker
kubectl label node k3s-worker-3.local node-role.kubernetes.io/worker=worker
```

### Deploy Kubeflow Pipeline

