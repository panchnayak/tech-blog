# Installing a Highly Available Rancher Server on k3s - V2

### In the Second Version of this tutorial I ll prepare a Highly available k3s Lightweight Kubernetes cluster and then install Rancher server on this kubernetes cluster

K3s is a lightweight, single executable file, which is less tahn 100MB from Rancher now owned by SUSE for creating a CNCF compliant, Production ready kubernets cluster.

To know more about k3s visit https://k3s.io/

Here I am using VMware Fusion on my MacbookPro to create and manage the VMs, you can use any virtualization software like VirtualBox for your laptop or desktop.

![](/rancher/images/vmware-fusion-vm.jpg)

* I ll not explain how to create the VM on VirtualBox of VMware workstation here.

Create 2 VMs or Clone your existing "CentOS 7" or "Ubuntu 20" VM on VirtualBox,Vmware workstation or Vmware Fusion , Run the VMs and Update the OS packages, you can install cockpit to update and install packages using web console for the VM.

For CentOS-7
```
sudo yum update -y
sudo yum install -y cockpit
```

for Ubuntu-20

```
sudo apt update
sudo apt install -y cockpit
```
Take a snapshot of the VM at this point, so that if you do anything wrong you can restore the state of the VM to this point.

Access the VM web Interfase using the http//IP_ADDRES:9090

![](/rancher/images/cockpit.jpg)

## Setting DNS for the VM

setup your DNS record for your domain

You can create a new NS record which points to "ns-aws.sslip.io." , this will bassically return the IP adress as the domain name. like if you try to get the domain name 192.168.1.100.bigopencloud.pnayak.com, it ll return you the IP address 192.168.1.100.

IP_ADDRESS.bigopencloud.pnayak.com

![](/rancher/iamges/mydns.jpg)

## Install PostgreSQL
```
sudo apt update 
sudo apt install postgres 
sudo apt install postgresql postgresql-contrib 
sudo systemctl enable --now  postgresql.service 
sudo -i -u postgres 
psql 
\q
exit
```
Change password
```
\password postgres 
```

Enter password as Abcd@1234 

To create a database for rancher excute the following.
```
createdb -h localhost -p 5432 -U postgres rancher-db 
\q 

 ```
To allow remote connectiong to postgresql 
```
vi /etc/postgresql/12/main/pg_hba.conf 
```

Add the following line 

host    all             all             all                      md5 
or
host    all             all             CIDR          md5 
```
vi /etc/postgresql/12/main/postgresql.conf 
```

Add the following line 
```
listen_addresses = '*'
sudo systemctl restart postgresql 
```

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

Create External Database,Here I am choosing PostgreSQL

Create Another VM to Install PostgreSQL on it.
After creating the VM run the following commands
```
sudo apt update
sudo apt install postgres
sudo -i -u postgres
psql
createdb kubernetes
```
Change the password
```
\password postgre
```
Create a new Database
```
createdb -h localhost -p 5432 -U postgres kubernetes
\q
```

Or 
```
sudo -u postgres createdb kubernetes
```
To allow remote connectiong to postgresql
```
vi pg_hba.conf
```
Add the following line
```
host all all all md5
vi postgresql.conf
```
Add the following line
```
listen_addresses = '*'
```
restart postgresql service
```
sudo systemctl restart postgresql
```


## Install k3s, the lightweight Kubernetes

Install k3s server without the traefik ingress controller, we are going to install and use nginx ingress controller latter.
```
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="--no-deploy traefik" sh -s -
or
curl -sfL https://get.k3s.io | sh -s - --datastore-endpoint="postgres://postgres:Abcd@1234@192.168.1.92:5432/k3s"
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
```
To test the config simple excute
```
kubectl get nodes
```
