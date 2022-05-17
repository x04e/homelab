# Adding Active Directory Users and Groups

## Prerequisites
Set up the domain controller (see [guide](./01-install-windows-server-2019.md))

## Adding Users
- Open Active Directory Users and Computers
- Click to expand the domain (e.g. "example.internal")
- By default a "Users" OU will exist. Right click on it and select New > User
- Enter a firstname, lastname, and logon name (e.g. "John", "Doe", and "john.doe")
- Click Next
- Enter a password for your new user
- Click "Password never expires" and click OK to dismiss the popup
- Click Next and Finish
- This user can now be used to log in on [Windows Clients](./03-joining-clients.md)

## Adding Groups
- Open Active Directory Users and Computers
- Click to expand the domain (e.g. "example.internal")
- Right click on the domain and select New > Organisational Unit. Name your new OU "Groups"
- Your new "Groups" OU will contain groups, as the "Users" OU contains users
- Right click "Groups" and click New > Group
- Name your new group
- Click OK

### Adding Users to Groups
- Open Active Directory Users and Computers
- Click to expand the domain (e.g. "example.internal")
- Find the group to which you wish to add a user or subgroup
- Right click the group and click "Add to Group"
- Search for users or groups by name
- Clicking "Check Names" will confirm the user or group
- Click OK

