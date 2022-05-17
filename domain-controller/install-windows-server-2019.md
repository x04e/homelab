# Install Windows Server 2019

Create a new VM in VMWare Workstation
    - Select Typical installation
    - Select "I will install the operating system later"
    - Select "Microsoft Windows" as the guest operating system and "Windows Server 2019" as the version
    - Provide a name and VM location
    - Select a disk size of approx. 60GB. 32GB is considered the bare minimum for storage
    - Click "Customise Hardware" and give the VM 2 CPUs and 4GB of memory
    - Click "Finish" and "Close"
    - Edit the VM settings and attach the Windows Server 2019 ISO as a removable disk
    - Start the VM

## Installer
- Press any key when prompted at startup
- Select your language, time, and keyboard settings
- Click "Install"
- Select "Windows Server 2019 Standard Evaluation (Desktop Experience)" and click "Next"
- Accept the license terms
- Click "Custom Install" and click "Next" on the disk setup screen. Windows Server will now install
- Set an Administrator password and log in

## Post Installation
- Install VMWare Tools on the newly created VM and reboot
- Create a Snapshot so you can restore the VM to its default state if needed

## Install AD Domain

### Prerequisites

#### Change Hostname
It is important to change the hostname of the server before promoting it to a domain controller as this cannot be changed later
- Open File Explorer
- Right click "This PC" in the quick access menu on the left
- Click "Properties"
- In the System window, under "Computer name, domain, and workgroup settings", click "Change settings"
- Click "Change..."
- Edit the computer name and click "OK"
- Click "OK" again and restart the VM

#### Network Configuration
- Open VMWare Workstation and click Edit > Virtual Network Editor (you may need to run VMWare Workstation as root if the editor window does not show up)
- Click "Add Network". Give the network a number and select "Host-Only" as its type, then click "Add"
- Click on your new network from the list
- Untick "Use local DHCP service to distribute IP addresses to VMs". We will be using the Windows Server DHCP role for this
- Give the network a Subnet IP and Mask (e.g. 172.16.10.0 and 255.255.255.0. The 172.16.*.* range is reserved for private addresses)
- Click "Save"
- If you had to open VMWare Workstation as root, close and relaunch it as your normal user
- Right click on your Windows Server VM and click "Settings"
- Under the Hardware tab, click "Add" and select "Network Adapter"
- Click the new network adapter and then click "Custom" for the network connection. Select your new VMNet virtual network from the list
- Click "Save"
- Boot up the Windows Server VM
- Right click the ethernet icon and click "Change adapter options"
- Rename Ethernet0 to "INTERNET" and Ethernet1 to "LAN"
- Edit the properties of both the INTERNET and LAN network adapters and untick "Internet Protocol Version 6 (TCP/IPv6)"
- For the LAN network adapter *only*, double click "Internet Protocol Version **4** (TCP/IPv**4**)"
- Click "use the following IP address"
- Enter 172.16.10.2 for the IP address (the first available IP on our subnet, 172.16.10.0 is the broadcast address and 172.16.10.1 is in use by something else)
- Enter 255.255.255.0 for the subnet mask
- Leave the default gateway empty for the LAN adapter
- Click "use the following DNS server addresses"
- Enter 172.16.10.2 for the DNS server
- Click "Ok"
- Open command prompt and run `ipconfig /all`. If "Ethernet adapter LOCAL" shows an IP like 169.254.*.*, it means that Windows Server has failed to obtain that IP. If it shows 172.16.10.2, continue

Your Windows Server VM should now have two network adapters. One for NAT and one for your new virtual network. We will set up our server as a domain controller, DHCP server, DNS server, and router later. Machines in our domain will be able to access the internet via our domain controller


### Promote Windows Server to Domain Controller
- Open Server Manager, then click "Add Roles and Features"
- Click "Next" and "Next"
- In the "Server Selection" tab of the wizard, you should see your server with the correct hostname and two IP addresses. One 172.16.10.2 IP and another 192.168.*.* address for the internet adapter
- Click "Next"
- In the "Server Roles" tab, under Roles select "Active Directory Domain Services" and click "Add Features" when prompted
- Click "Next" until you reach the "Confirmation" tab, then click "Install"
- Wait for the installer to finish. Once done, click "Close"
- In Server Manager, you should see a new notification in the top right. Open the notification and click "Promote this server to a domain controller"
- In the Active Directory Domain Services Configuration Wizard, select "Add a new forest" and specify a root domain name, e.g. example.internal
- Click "Next" and set a password for the Directory Services Restore Mode
- Click "Next" through all the options until you see the Prerequisites Check tab. Make sure there are no warnings (red). Errors (yellow) are fine
- Click "Install"
- Once the installer completes, the server will restart and you will log in as the domain administrator (e.g. "EXAMPLE\Administrator")

### Install Router
- In Server Manager, click "Tools", then "Add Roles and Features"
- Click "Next" until you get to the "Server Roles" tab
- Select "Remote Access"
- Click "Next" until you see the Role Services tab. Select "Routing", then "Add Features". This will automatically select "DirectAccess and VPN (RAS)"
- Click "Next" through the tabs, then "Install"
- In Server Manager, go to "Tools", then "Routing and Remote Access"
- Right click on the server name and click "Configure and Enable Routing and Remote Access" and click "Next"
- Select "NAT" and click "Next" and "Finish"
- When prompted, start the service

### Install the DHCP Server Role
- In Server Manager, click "Tools", then "Add Roles and Features"
- Click "Next" until you get to the "Server Roles" tab
- Select "DHCP" and click "Add Featues" and click "Next" and "Install"
- Once installed, open Server Manager, then "Tools" and "DHCP"
- In the DHCP window, right click the server in the tree menu and click "Authorize"
- Right click "IPv4" and click "New Scope", then "Next"
- Give the scope a name and/or description, then click "Next"
- Set the start and end IPs for the range (e.g. 172.16.10.10 - 172.16.10.254). For convenience, start with 10 so we don't have to set exclusions for the domain controller
- Set the subnet mask for the address range (e.g. length 24 and mask 255.255.255.0)
- Click "Next", then "Next", then set the lease duration to one day
- Click "Next"
- Select "Yes, I want to configure these options now" and click "Next"
- Enter the server's IP (172.16.10.2) and click "Add" for the router settings
- Click "Next" to go through the next few screens, then "Finish"
- If there is a notification in Server Manager, open it up and click "Skip AD Authorization"
- Add 8.8.8.8 as an additional DNS entry in Tools > DHCP

