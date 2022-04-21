
# Creating Linux VMs on Virtual Box or Vmware Workstation

Here I am using VMware Fusion on my MacbookPro to create and manage the VMs, you can use any virtualization software like VirtualBox for your laptop or desktop.

![](/linux/images/vmware-fusion-vm.jpg)

* I ll explain here how to create the VM on VirtualBox of VMware workstation here.

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