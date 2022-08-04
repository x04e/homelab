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

### Base VM setup
- Create a Linux VM using a disk image, like the CentOS 7 Minimal (no GUI) image
- When prompted, select "Install CentOS 7"
- Go through the installer and select a language and disk to install to
- Turn on the network adapter in the installer and change the hostname to something like "change-me", so we will rememeber to change it each time we need a new machine
- Disable the annoying PC speaker beeps with the following:

    ```sh
    $ echo "blacklist pcspkr" > /etc/modprobe.d/bell.conf
    $ reboot
    ```

- Ensure that the network is connected by checking `nmcli`
- Update packages with `yum makecache` and then `yum update`
- Install required packages:

    ```sh
    $ yum makecache
    $ yum install open-vm-tools vim net-tools sssd realmd oddjob oddjob-mkhomedir adcli samba-common samba-common-tools krb5-workstation openldap-clients policycoreutils-python
    ```

- Change the GRUB wait time from 5 seconds to 1 second to speed up booting. Edit `/etc/default/grub` and change `GRUB_TIMEOUT=5` to `GRUB_TIMEOUT=1`. Finally, run `grub2-mkconfig -o /boot/grub2/grub.cfg` and reboot to see if the changes have persisted
- Copy the [`/tmp/setup`](./vm-setup.sh) script to your VM (using scp, for example): `scp ./vm-setup.sh root@<vm-ip>:/tmp` and make it executable on the VM with `chmod +x /tmp/vm-setup.sh`
- Finally, create a snapshot of your VM at this point. This snapshot will be the base VM from which you clone all other Linux hosts

### Join to Domain
- Clone your base VM from [Base VM Setup](#base-vm-setup)
- Run `/tmp/vm-setup.sh` to configure your new hostname and join a domain (e.g. example.internal). This script will also set sssd to use short usernames over fully-qualified usernames and short home directories over something like `/home/user@example.internal/`

