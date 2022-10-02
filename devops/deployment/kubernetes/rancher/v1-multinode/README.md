

# Installing Rancher on k3s - V1

### In the First Version of this tutorial I ll prepare a k3s Lightweight Kubernetes cluster and then install Rancher server on this kubernetes cluster

K3s is a lightweight, single executable file, which is less tahn 100MB from Rancher now owned by SUSE for creating a CNCF compliant, Production ready kubernets cluster.

To know more about k3s visit https://k3s.io/

Here I am using VMware Fusion on my MacbookPro to create and manage the VMs, you can use any virtualization software like VirtualBox for your laptop or desktop.

![](/linux/images/vmware-fusion-vm.jpg)

* I ll not explain how to create the VM on VirtualBox of VMware workstation here.

Create a new VM or Clone your existing "CentOS 7" or "Ubuntu 20" VM on VirtualBox,Vmware workstation or Vmware Fusion , Run the VM and Update the OS packages, you can install cockpit to update and install packages using web console for the VM

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

Access the VM web Interfase using the http//IP_ADDRESS:9090

![](/linux/images/cockpit.jpg)

## Clone this repository

git clone https://github.com/panchnayak/tech-blog.git

## Setting DNS for the VM

Setup your DNS record for your domain

You can create a new NS record which points to "ns-aws.sslip.io." , this will bassically return the IP adress as the domain name. like if you try to get the domain name 192.168.1.100.bigopencloud.pnayak.com, it ll return you the IP address 192.168.1.100.

IP_ADDRESS.bigopencloud.pnayak.com

![](/kubernetes/rancher/iamges/mydns.jpg)

## Install HELM
```
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh
```
## Install kubernetes CLI kubectl

Download and install kubectl the Kubernetes CLI with whom you can communicate with Kubernetes Cluster

```
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl
sudo mv kubectl /usr/local/bin
```

## Install k3s, the lightweight Kubernetes

Install k3s server without the traefik ingress controller, we are going to install and use nginx ingress controller latter.
```
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="--no-deploy traefik" sh -s -

or with external postgres DB as follows

curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="--no-deploy traefik" sh -s - --datastore-endpoint="postgres://postgres:Abcd@1234@192.168.1.92:5432/k3s"

```
Get the Kubernetes cluster details
```
sudo k3s kubectl get nodes
sudo k3s kubectl describe all
```

If you dont want to excute the "k3s kubectl" and use only kubectl to get communicate to the cluster do the following
```
sudo cp /etc/rancher/k3s/k3s.yaml ~/.kube/config
sudo chown pnayak ~/.kube/config

pnayak@rancher-server-1:~/tech-blog/rancher/v1$ sudo cp /etc/rancher/k3s/k3s.yaml ~/.kube/config
pnayak@rancher-server-1:~/tech-blog/rancher/v1$ cd
pnayak@rancher-server-1:~$ sudo chown pnayak ~/.kube/config
pnayak@rancher-server-1:~$ kubectl get nodes
NAME               STATUS   ROLES                  AGE     VERSION
rancher-server-1   Ready    control-plane,master   13m     v1.22.7+k3s1
```
To test the config simple excute
```
kubectl get nodes
```
## Install a worker node to the master node

Create or clone another VM, Prepare it as a Worker node.I cloned the master VM.

Get the masternode IP and token from the master node
```
ip a
sudo cat /var/lib/rancher/k3s/server/node-token

pnayak@rancher-server-1:~/tech-blog/rancher/v1$ sudo cat /var/lib/rancher/k3s/server/node-token
K10ae766aee26c6e3e645a4f1abf7e620ea43235e3a1b5c3f2fbc2958ec87f3aecc::server:e3b1f376bef51250d8b019971a75b96d
```
Excute the following commands on the worker node VM terminal
```
curl -sfL https://get.k3s.io | K3S_URL=https://192.168.1.103:6443 K3S_TOKEN="K10ae766aee26c6e3e645a4f1abf7e620ea43235e3a1b5c3f2fbc2958ec87f3aecc::server:e3b1f376bef51250d8b019971a75b96d" sh -
```

pnayak@rancher-worker-1:~$ curl -sfL https://get.k3s.io | K3S_URL=https://192.168.1.103:6443 K3S_TOKEN="K1083efac7e33d2e594ca2756b121019986c795b52337bb4b86e9ed6d5d9eb3c683::server:8e2aff8512d6a673a31c0686f0a2eaf3" sh -
[sudo] password for pnayak:
[INFO]  Finding release for channel stable
[INFO]  Using v1.22.7+k3s1 as release
[INFO]  Downloading hash https://github.com/k3s-io/k3s/releases/download/v1.22.7+k3s1/sha256sum-amd64.txt
[INFO]  Downloading binary https://github.com/k3s-io/k3s/releases/download/v1.22.7+k3s1/k3s
[INFO]  Verifying binary download
[INFO]  Installing k3s to /usr/local/bin/k3s
[INFO]  Skipping installation of SELinux RPM
[INFO]  Skipping /usr/local/bin/kubectl symlink to k3s, already exists
[INFO]  Creating /usr/local/bin/crictl symlink to k3s
[INFO]  Creating /usr/local/bin/ctr symlink to k3s
[INFO]  Creating killall script /usr/local/bin/k3s-killall.sh
[INFO]  Creating uninstall script /usr/local/bin/k3s-agent-uninstall.sh
[INFO]  env: Creating environment file /etc/systemd/system/k3s-agent.service.env
[INFO]  systemd: Creating service file /etc/systemd/system/k3s-agent.service
[INFO]  systemd: Enabling k3s-agent unit
Created symlink /etc/systemd/system/multi-user.target.wants/k3s-agent.service → /etc/systemd/system/k3s-agent.service.
[INFO]  systemd: Starting k3s-agent

Enable the agent so that it can be started after reboot
```
sudo systemctl enable --now k3s-agent
```
pnayak@rancher-server-1:~$ kubectl get nodes
NAME               STATUS   ROLES                  AGE     VERSION
rancher-worker-1   Ready    <none>                 3m51s   v1.22.7+k3s1
rancher-server-1   Ready    control-plane,master   13m     v1.22.7+k3s1


To manually start the k3s agent we can also use the options --server and --token inetad of the environment variables:

```
k3s agent --server https://192.168.1.103:6443 --token "K1083efac7e33d2e594ca2756b121019986c795b52337bb4b86e9ed6d5d9eb3c683::server:8e2aff8512d6a673a31c0686f0a2eaf3"
```

## Install Rancher on k3s

We will install rancher and the required components by copying some formatted yaml files provided here to the /var/lib/rancher/k3s/server/manifests/ directory, in the k3s server, which tells k3s to set up the components we need (nginx-ingress, cert-manager, and rancher). These files are referred to as helm chart CRDs.

Excute the given shell script in the repository.This will ask you to enter the DNS name for the rancher server. Enter the DNS name for the server as YOUR_VM_IP_ADDRESS.bigopencloud.pnayak.com or any other DNS name you want to give and the rest ll be done by the script.

```
./rancher/v1/install-rancher.sh
```
Check the status of the pods
```
kubectl get pods --all-namespaces | grep helm
```
pnayak@rancher-server:~$ kubectl get pods --all-namespaces | grep helm
cert-manager                helm-install-cert-manager--1-g9k9k        0/1     Completed          0             16m
cattle-system               helm-operation-dhxsx                      0/2     Completed          0             14m
cattle-system               helm-operation-nx54x                      0/2     Completed          0             14m
kube-system                 helm-install-ingress-nginx--1-7762k       0/1     Completed          4             16m
cattle-system               helm-operation-dhr9k                      0/2     Completed          0             14m
cattle-system               helm-install-rancher--1-wq9w7             0/1     CrashLoopBackOff   6 (53s ago)   7m1s


Wait for the Rancher server to be up and running,now the the following url on your local the browser
https://IP_ADDRESS.bigopencloud.pnayak.com

![](/kubernetes/rancher/images/rancher-login-page.jpg)

Get the bootstrap password by excuting the following
```
kubectl get secret --namespace cattle-system bootstrap-secret -o go-template='{{.data.bootstrapPassword|base64decode}}{{"\n"}}'
```
Copy the password and paste it on the browser as the bootstrap password
```
kubectl get secret --namespace cattle-system bootstrap-secret -o go-template='{{.data.bootstrapPassword|base64decode}}{{"\n"}}'
```
pnayak@rancher-server:~$ kubectl get secret --namespace cattle-system bootstrap-secret -o go-template='{{.data.bootstrapPassword|base64decode}}{{"\n"}}'
6gp5fpqk9b7ffjlr2zd446v5b5gjv4vrztwz5bcjdrzpv8jq59f459

Now set "your own password" for the rancher server as shown 

![](/kubernetes/rancher/images/rancher-password.jpg)

Login to rancher server with "admin" as the username and "your-own-password", you should be able to login successfully.

![](/kubernetes/rancher/images/rancher-login-success.jpg)

After login you can see the dashboard

![](/kubernetes/rancher/images/local-cluster-dashboard.jpg)

And

![](/kubernetes/rancher/images/cluster-nodes-view.jpg)

Now you can create more downstream kubernets clusters using rancher.

I ll update this page again.Stay tuned.

## Uninstall k3s singlenode kubernetes cluster from the VM

If you need to uninsatll the k3s Server from the VM you can do so just excuting the following command
```
sudo /usr/local/bin/k3s-uninstall.sh
```





