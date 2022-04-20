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

```
curl -sfL https://get.k3s.io | sh -
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
sudo cp /etc/rancher/k3s/k3s.yaml ~/.kube/config
sudo chown $USER ~/.kube/config
```
Now you can communicate to the k3s cluster using kubectl 

```
kubectl get nodes
```
