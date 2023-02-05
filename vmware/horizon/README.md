
VMware Horizon Components

    VMware ESXi
    VMware vCenter Server
    Windows Active Directory
    MS SQL Server
    Horizon Connection Server
    Instant Clone
    App Volumes Manager
    Dynamic Environment Manager
    Windows 10 

https://techzone.vmware.com/resource/quick-start-tutorial-vmware-horizon-8

1.Download the following VMware Horizon Software

    Horizon Connection Server (64-bit)
    Horizon Agent (64-bit)
    Horizon GPO Bundle
    VMware Horizon Client
        https://customerconnect.vmware.com/en/downloads/details?downloadGroup=CART23FQ3_WIN_2209&productId=1027&rPId=97920

Download Windows Server 2019 ISO

    https://www.microsoft.com/en-us/evalcenter/download-windows-server-2019

Download MS SQL server 2019 Express

    https://www.microsoft.com/en-us/download/details.aspx?id=101064

Download Windows 10 ISO 

    https://www.microsoft.com/en-us/software-download/windows10ISO

2.Infrastructure Preparation

Implement VMware vSphere 8

    ESXi Server 8
    vCenter Server

The following VMs will be required

    Windows Server 2019 Vm for Image

From Image Create the Following VMs

    Windows VM for Active Directory
    Windows VM MS SQL server 2019 Express
    Windows VM for Horizon Connection Server
    Windows 10 VM for Desktop Image

Install Active Directory on Windows 2022 Server

https://learn.microsoft.com/en-us/windows-server/identity/ad-ds/deploy/install-active-directory-domain-services--level-100-

Automation to Create Optimized Windows Images for VMware Horizon VMs using Microsoft Deployment Toolkit (MDT)

https://techzone.vmware.com/using-automation-create-optimized-windows-images-vmware-horizon-vms#introduction

Install SQL Server

Enable Enabling SQL Server Authentication through SQL Management Studio

Install Horizon Connect Server
 and then crreate this file too access it remotely



Create a Windows 10 Image

After installing Start in Audit Mode by pressing Crtl+Shift+F3
Then Install VMware tool
Then Update all the Windows Updates
Install any Application you want

Install Horizon Agent
Install VMware Dinamic Env Manager
Install Windows OS Optimization Tool

C:\Program Files\VMware\VMware View\Server\sslgateway\conf\locked.properties
checkOrigin=false



