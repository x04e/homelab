# Nginx Setup

## Installation
### RHEL/CentOS
- Add the EPEL Software Repository
    `yum install epel-release`
- Install the Nginx package
    `yum install nginx`
- Start Nginx
    `systemctl start nginx`
- Add firewall rules for HTTP/S
    ```bash
    firewall-cmd --permanent --zone=public --add-service=http
    firewall-cmd --permanent --zone=public --add-service=https
    firewall-cmd --reload
    ```
- Enable the nginx service to run after reboots
    `systemctl enable nginx`
- Reboot the system and check that nginx is still running
    `systemctl status nginx`

## Load Balancing

## Use With Windows Server Domain Controller

