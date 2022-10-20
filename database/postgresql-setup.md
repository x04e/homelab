# Postgresql Setup

## Prerequisites
- You must have a user with sudo privileges
- Install packages. The standard RHEL postgresql is version 9. To install version 12, do the following
- Add the postgresql repo
    `sudo yum install https://download.postgresql.org/pub/repos/yum/reporpms/EL-7-x86_64/pgdg-redhat-repo-latest.noarch.rpm`
- Install the postgresql 12 package
    ```bash
    sudo yum install epel-release yum-utils
    sudo yum-config-manager --enable pgdg12
    sudo yum install postgresql12-server postgresql12
    ```
- Initialise database
    `sudo /usr/pgsql-12/bin/postgresql-12-setup initdb`
- Enable and start postgresql
    `sudo systemctl enable --now postgresql-12`
- Open required ports
    ```bash
    sudo firewall-cmd --add-service=postgresql --permanent
    sudo firewall-cmd --reload
    ```
- Change the postgres user password
    ```bash
    $ sudo su - postgres
    postgres$ pgsql -c "alter user postgres with password '<new-password>';"
    postgres$ exit
    ```
- Set the listen address to your server's IP address (can be obtained via `hostname -i` or `nmcli`)
    ```ini
    # /var/lib/pgsql/12/data/postgresql.conf
    listen_addresses = '<your-database-server-ip>'
    ```
- Change the listen address to allow connections from your domain's subnet
    ```ini
    # /var/lib/pgsql/12/data/pg_hba.conf
    # Connections allowed from domain subnet
    host all all 172.16.10.0/24 md5
    ```
- Restart the postgresql service
    `sudo systemctl restart postgresql-12`
- Test the connection using an application server or a tool like [DBeaver](https://dbeaver.io/)

### Troubleshooting
If the service fails to start, the log files for postgres can be found in `/var/lib/pgsql/12/data/log`

## Installing Postgresql


