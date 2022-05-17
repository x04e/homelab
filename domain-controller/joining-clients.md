# Joining Clients to a Windows Domain Controller

## Windows Client
Install Windows 10 on a VM. Go through the standard Personal installation. Install VMWare Tools.

**N.B.** Once Windows is installed, edit the VM settings in VMWare and change it's network adapter from NAT to your domain controller's VMNet

### Change Hostname
- Open File Explorer
- Right click "This PC" in the quick access menu on the left
- Click "Properties"
- Click "Rename this PC"
- Edit the computer name and click "OK", then restart the VM when prompted

### Join to Domain
- Open File Explorer
- Right click "This PC" in the quick access menu on the left
- Click "Advanced System Properties" to open the old Control Panel System window
- Go to the "Computer Name" tab and click "Change"
- Under "Member of", select "Domain" and enter your domain, e.g. "example.internal"
- Enter the domain administrator credentials when prompted ("EXAMPLE\Administrator")
- You should see a popup welcoming you to the domain. Click "OK". Restart the VM
- If you have set up DHCP, DNS, and Routing on your domain controller, you should be able to log in as a domain user or admin and access the internet from LAN

## Linux Client

