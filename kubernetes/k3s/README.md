K3s is a lightweight, single executable file, which is less tahn 100MB from Rancher now owned by SUSE for creating a CNCF compliant, Production ready kubernets cluster.

To know more about k3s visit https://k3s.io/

Here I am using VMware Fusion on my MacbookPro to create and manage the VMs, you can use any virtualization software like VirtualBox for your laptop or desktop.

![](/linux/images/vmware-fusion-vm.jpg)

* I ll not explain how to create the VM on VirtualBox of VMware workstation here.

For CentOS-7
```
sudo yum update -y
sudo yum install -y cockpit
```
Disbale the CentOS firewall,this is not recommended for production env.

```
sudo systemctl disable --now firewalld
```
for Ubuntu-20

```
sudo apt update
sudo apt install -y cockpit
```

Disable the ubuntu OS firewall, this is not recommended for production env

```
sudo ufw disable
```

Take a snapshot of the VM at this point, so that if you do anything wrong you can restore the state of the VM to this point.

Access the VM web Interfase using the http//IP_ADDRES:9090

![](/linux/images/cockpit.jpg)

## Install k3s, the lightweight Kubernetes, visit https://k3s.io/ to know more about k3s

Install k3s server .

If you don't want to give readable permission to all for the KUBECONFIG file
```
curl -sfL https://get.k3s.io | sh -
```
or The above command will create a KUBECYNFIG file which is readable by all
```
curl -sfL https://get.k3s.io | sh -s - --write-kubeconfig-mode 644
```
Get the Kubernetes cluster details
```
sudo k3s kubectl get nodes
sudo k3s kubectl describe all
```
If you dont want to excute the "k3s kubectl" CLI for k3s and use the standard "kubectl" CLI to communicate to the cluster do the following

## Install kubernetes CLI kubectl

Download and install kubectl, to communicate with K3S Kubernetes Cluster
```
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl
sudo mv kubectl /usr/local/bin
kubectl get nodes
```
you ll get the following error

pnayak@k3s-master-1:~$ kubectl get nodes
error: error loading config file "/etc/rancher/k3s/k3s.yaml": open /etc/rancher/k3s/k3s.yaml: permission denied

To fix this either you can reinstall k3s or explicitely change the permission of /etc/rancher/k3s/k3s.yaml

curl -sfL https://get.k3s.io | sh -s - --write-kubeconfig-mode 644
or
```
sudo chmod 644 /etc/rancher/k3s/k3s.yaml
export KUBECONFIG=/etc/rancher/k3s/k3s.yaml
```
Now you can communicate to the k3s cluster using kubectl 

```
kubectl get nodes
```

pnayak@k3s-master-1:~$ kubectl get nodes
NAME           STATUS   ROLES                  AGE   VERSION
k3s-server-1   Ready    control-plane,master   41m   v1.22.7+k3s1


## Install a worker node to the master node

Create or clone another VM, Prepare it as a Worker node.I cloned the master VM.

Get the masternode IP and token from the master node
```
ip a
sudo cat /var/lib/rancher/k3s/server/node-token
```
pnayak@k3s-master-1:~$ sudo cat /var/lib/rancher/k3s/server/node-token
K104c45a202e7f4ffd92e7d377c8c6140241e2b72025edc99e47281d75e43c89d33::server:c2bb99f3676ad5e64974dfe403dfa0e4
Excute the following commands on the worker node VM terminal
```
curl -sfL https://get.k3s.io | K3S_URL=https://192.168.1.108:6443 K3S_TOKEN="K104c45a202e7f4ffd92e7d377c8c6140241e2b72025edc99e47281d75e43c89d33::server:c2bb99f3676ad5e64974dfe403dfa0e4" sh -
```

pnayak@k3s-worker-1:~$ curl -sfL https://get.k3s.io | K3S_URL=https://192.168.1.108:6443 K3S_TOKEN="K104c45a202e7f4ffd92e7d377c8c6140241e2b72025edc99e47281d75e43c89d33::server:c2bb99f3676ad5e64974dfe403dfa0e4" sh -
[sudo] password for pnayak:
[INFO]  Finding release for channel stable
[INFO]  Using v1.22.7+k3s1 as release
[INFO]  Downloading hash https://github.com/k3s-io/k3s/releases/download/v1.22.7+k3s1/sha256sum-amd64.txt
[INFO]  Skipping binary downloaded, installed k3s matches hash
[INFO]  Skipping installation of SELinux RPM
[INFO]  Skipping /usr/local/bin/kubectl symlink to k3s, already exists
[INFO]  Skipping /usr/local/bin/crictl symlink to k3s, already exists
[INFO]  Skipping /usr/local/bin/ctr symlink to k3s, command exists in PATH at /usr/bin/ctr
[INFO]  Creating killall script /usr/local/bin/k3s-killall.sh
[INFO]  Creating uninstall script /usr/local/bin/k3s-agent-uninstall.sh
[INFO]  env: Creating environment file /etc/systemd/system/k3s-agent.service.env
[INFO]  systemd: Creating service file /etc/systemd/system/k3s-agent.service
[INFO]  systemd: Enabling k3s-agent unit
Created symlink /etc/systemd/system/multi-user.target.wants/k3s-agent.service → /etc/systemd/system/k3s-agent.service.
[INFO]  systemd: Starting k3s-agent

Repeat this for all your worker nodes

now if you excute kubectl on master node

pnayak@k3s-master-1:~$ kubectl get nodes
NAME           STATUS   ROLES                  AGE     VERSION
k3s-master-1   Ready    control-plane,master   55m     v1.22.7+k3s1
k3s-worker-1   Ready    <none>                 4m24s   v1.22.7+k3s1
k3s-worker-2   Ready    <none>                 3m14s   v1.22.7+k3s1
k3s-worker-3   Ready    <none>                 2m30s   v1.22.7+k3s1



