# 环境：
OS：ubuntu22.04 LTS
cpu: 4C
MEM: 8G 
本项目主要是对接AzureAD-LDAP-wrapper 项目；变相实现 freeradius对接到Azure AD （现在是Entra ID）
# 一、常规安装
## 1.常规安装：
```
apt update && apt install freeradius  freeradius-ldap
```
## 2.修改配置文件
按照config中的去取消注释关于ldap的部分
```
/etc/freeradius/3.0/sites-available/default
/etc/freeradius/3.0/sites-available/inner-tunnel
```
按照config中的，修改ldap文件

```
/etc/freeradius/3.0/sites-available/ldap
```
note：
密码部分需要修改成：
```
		control:Password-With-Header	+= 'sambaNTPassword'
		control:NT-Password 		:= 'sambaNTPassword'
```
发现azure中组里有成员，需要修改配置：按照提示`If using Active Directory you are likely to need "group"  instead of "posixGroup".`修改
```
filter = '(objectClass=Group)'
```
ssl
```
chmod 644 /etc/freeradius/3.0/certs/ssl/radius.crt
chmod 644 /etc/freeradius/3.0/certs/ssl/radius.key
chmod 644 /etc/freeradius/3.0/certs/ssl/radius_ca.pem
chmod 755 /etc/freeradius/3.0/certs/ssl
```

# Docker镜像

chmod 644 ssl/radius.crt
chmod 644 ssl/radius.key
chmod 644 ssl/radius_ca.pem
chmod 755 ssl/





