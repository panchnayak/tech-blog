K3s is a lightweight, single executable file, which is less tahn 100MB from Rancher now owned by SUSE for creating a CNCF compliant, Production ready kubernets cluster.

To know more about k3s visit https://k3s.io/

# Install MySQL as the Kubernetes External key Vlue Database

sudo apt update -y
sudo apt upgrade -y
sudo apt install mysql-server -y
sudo apt install mysql-client -y

sudo mysql
ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password by 'Abcd@1234';
sudo mysql_secure_installation

sudo systemctl status mysql

sudo mysql -u root -p

CREATE DATABASE k3s;

CREATE USER 'k3s'@'%' IDENTIFIED BY 'Abcd@1234';

ALTER USER 'k3s'@'%' IDENTIFIED BY 'Abcd1234';
GRANT ALL PRIVILEGES ON k3s.* TO 'k3s'@'%';
FLUSH PRIVILEGES;

SELECT User FROM mysql.user;
Edit file sudo vi /etc/mysql/mysql.conf.d/mysqld.cnf and edit the bind-address to your servewr IP

bind-address            = 192.168.1.81

![](/kubernetes/k3s/images/mysql-install-for-k3s.jpg)

/iamges/mysql-install-fork3s.jpg

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
or The below command will create a KUBECONFIG file which is readable by all
```
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="--tls-san x.x.x.x" sh -s - --write-kubeconfig-mode 644
```

with mysql external database

```
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="--write-kubeconfig-mode 644 --tls-san bigopen.cloud --node-taint k3s-controlplane=true:NoExecute" sh -s - server --datastore-endpoint="mysql://k3s:Abcd1234@tcp(192.168.1.81:3306)/k3s"

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
curl -sfL https://get.k3s.io | K3S_URL=https://192.168.1.82.k3s.pnayak.com:6443 K3S_TOKEN="K108b597a97f59acafd07fe4cbe338bc57d2201f690ffe60c63a432db6332cfff44::server:e70513f48d17ac741c3295aea1c53637" sh -
```

## Login to the MySQl server and see the database and tables

```
mysql -h 192.168.1.81 -u k3s -p
show databases
use k3s
show tables
select name from kine
```

pnayak@k3s-worker-1:~$ curl -sfL https://get.k3s.io | K3S_URL=https://192.168.1.82.k3s.pnayak.com:6443 K3S_TOKEN="K108b597a97f59acafd07fe4cbe338bc57d2201f690ffe60c63a432db6332cfff44::server:e70513f48d17ac741c3295aea1c53637" sh -
[sudo] password for pnayak:
[INFO]  Finding release for channel stable
[INFO]  Using v1.24.3+k3s1 as release
[INFO]  Downloading hash https://github.com/k3s-io/k3s/releases/download/v1.24.3+k3s1/sha256sum-amd64.txt
[INFO]  Downloading binary https://github.com/k3s-io/k3s/releases/download/v1.24.3+k3s1/k3s
[INFO]  Verifying binary download
[INFO]  Installing k3s to /usr/local/bin/k3s
[INFO]  Skipping installation of SELinux RPM
[INFO]  Creating /usr/local/bin/kubectl symlink to k3s
[INFO]  Creating /usr/local/bin/crictl symlink to k3s
[INFO]  Creating /usr/local/bin/ctr symlink to k3s
[INFO]  Creating killall script /usr/local/bin/k3s-killall.sh
[INFO]  Creating uninstall script /usr/local/bin/k3s-agent-uninstall.sh
[INFO]  env: Creating environment file /etc/systemd/system/k3s-agent.service.env
[INFO]  systemd: Creating service file /etc/systemd/system/k3s-agent.service
[INFO]  systemd: Enabling k3s-agent unit
Created symlink /etc/systemd/system/multi-user.target.wants/k3s-agent.service → /etc/systemd/system/k3s-agent.service.
[INFO]  systemd: Starting k3s-agent

Repeat this for all your worker nodes

now if you excute kubectl on master node

pnayak@k3s-server:~$ kubectl get nodes
NAME                 STATUS   ROLES                  AGE     VERSION
k3s-worker-1.local   Ready    <none>                 9m4s    v1.24.3+k3s1
k3s-server.local     Ready    control-plane,master   72m     v1.24.3+k3s1
k3s-worker-2.local   Ready    <none>                 7m39s   v1.24.3+k3s1
k3s-worker-3.local   Ready    <none>                 5m52s   v1.24.3+k3s1

Label the worker nodes

kubectl label node k3s-worker-1.local node-role.kubernetes.io/worker=worker
kubectl label node k3s-worker-2.local node-role.kubernetes.io/worker=worker
kubectl label node k3s-worker-3.local node-role.kubernetes.io/worker=worker

pnayak@k3s-server:~$ kubectl get nodes
NAME                 STATUS   ROLES                  AGE   VERSION
k3s-server.local     Ready    control-plane,master   78m   v1.24.3+k3s1
k3s-worker-1.local   Ready    worker                 14m   v1.24.3+k3s1
k3s-worker-2.local   Ready    worker                 13m   v1.24.3+k3s1
k3s-worker-3.local   Ready    worker                 11m   v1.24.3+k3s1

![](/kubernetes/k3s/images/k3s-nodes.jpg)

# Working with traefik dashboard

```
kubectl get pods -n kube-system| grep '^traefik-'

kubectl port-forward -n kube-system "$(kubectl get pods -n kube-system| grep '^traefik-' | awk '{print $1}')" 9000:9000
Forwarding from 127.0.0.1:9000 -> 9000
Forwarding from [::1]:9000 -> 9000

```
http://localhost:9000/dashboard/

![](/kubernetes/k3s/images/traeifik-dashboard.jpg)

## Uninstall k3s singlenode kubernetes cluster from the VM

If you need to uninsatll the k3s Server from the VM you can do so just excuting the following command
```
sudo /usr/local/bin/k3s-uninstall.sh
```

