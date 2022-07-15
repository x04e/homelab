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
- Create a Linux 
- 
- Ensure nmcli connects to the network on startup

    ```ini

    ```

- Install realmd
- Change hostname
- This is the default configuration that will be created after running `realm join example.internal`:

    ```ini
    [sssd]
    domains = example.internal
    config_file_version = 2
    services = nss, pam

    [domain/example.internal]
    ad_domain = example.internal
    krb5_realm = EXAMPLE.INTERNAL
    realmd_tags = manages-system joined-with-samba 
    cache_credentials = True
    id_provider = ad
    krb5_store_password_if_offline = True
    default_shell = /bin/bash
    ldap_id_mapping = True
    use_fully_qualified_names = True
    fallback_homedir = /home/%u@%d
    access_provider = ad
    ```

- Change `use_fully_qualified_names` to `False` to allow logins without a domain component each time, e.g. logging in with `john.doe` instead of `john.doe@example.internal`. This should also mean that every user's home folder will be their just their username, e.g. `/home/john.doe/`. If for whatever reason this is not the case and sssd uses the domain in the home folder name (`/home/john.doe@example.internal/`), you can add `override_homedir = /home/%u` to `sssd.conf` and restart the `sssd` service to override that behaviour

