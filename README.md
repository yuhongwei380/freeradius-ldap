# Environment:
OS: Ubuntu 22.04 LTS
CPU: 4 cores
Memory: 8GB

This project primarily interfaces with the AzureAD-LDAP-wrapper project; it indirectly enables FreeRADIUS to integrate with Azure AD (now known as Entra ID).

# Important Note: A user's password must first be authenticated once by the AzureAD-LDAP-wrapper service before it is encrypted and stored. Only then can FreeRADIUS successfully authenticate the user. (Issue Resolved)
Solution: Added pre-authentication logic.

# Usage Instructions

## 1. Docker Image Deployment
You need to prepare your own SSL certificates.

```
chmod 644 ssl/radius.crt
chmod 644 ssl/radius.key
chmod 644 ssl/radius_ca.pem
chmod 755 ssl/
```

Configure your LDAP server according to the `docker-compose.yml` and `.env` files in the project. It is recommended to deploy on the same server to ensure network connectivity.


# 2.Binary Deployment
## 2.1 Standard Installation:
```
apt update && apt install freeradius  freeradius-ldap
```
## 2.2 Modify Configuration Files
Uncomment the sections related to LDAP in the following files, as shown in the config directory:
```

/etc/freeradius/3.0/sites-available/default

/etc/freeradius/3.0/sites-available/inner-tunnel
```
Modify the LDAP configuration file according to the example in the project (ldap file in config):
```
/etc/freeradius/3.0/sites-available/ldap
```


Modify the password section in the LDAP file as shown in the project's example, or copy it directly (remember to replace variables like ldap_server etc.).

If groups in Azure AD contain members, you need to adjust the configuration. Follow the hint If using Active Directory you are likely to need "group" instead of "posixGroup". and change:

```
filter = '(objectClass=Group)'
```
Set permissions for SSL certificates:
```
chmod 644 /etc/freeradius/3.0/certs/ssl/radius.crt
chmod 644 /etc/freeradius/3.0/certs/ssl/radius.key
chmod 644 /etc/freeradius/3.0/certs/ssl/radius_ca.pem
chmod 755 /etc/freeradius/3.0/certs/ssl
```





