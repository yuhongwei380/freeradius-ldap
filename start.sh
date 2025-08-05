#!/bin/bash

# 打印环境变量的值
echo "LDAP Server: $ldap_server"
echo "LDAP Identity: $ldap_bind_identity"
echo "LDAP Password: $ldap_bind_password"
echo "LDAP Base DN: $ldap_basedn"

#chown freerad:freerad /etc/freeradius/3.0/mods-enabled/ldap
#ssl证书部分
sed -i '/private_key_file =/c\private_key_file = ${certdir}/ssl/radius.key' /etc/freeradius/3.0/mods-enabled/eap
sed -i '/certificate_file =/c\certificate_file = ${certdir}/ssl/radius.crt' /etc/freeradius/3.0/mods-enabled/eap
sed -i '/ca_file =/c\ca_file = ${cadir}/ssl/radius_ca.pem' /etc/freeradius/3.0/mods-enabled/eap


# LDAP配置替换 - 添加这部分
sed -i "s/ldap_server/$ldap_server/g" /etc/freeradius/3.0/mods-available/ldap
sed -i "s/ldap_bind_identity/$ldap_bind_identity/g" /etc/freeradius/3.0/mods-available/ldap
sed -i "s/ldap_bind_password/$ldap_bind_password/g" /etc/freeradius/3.0/mods-available/ldap
sed -i "s/ldap_basedn/$ldap_basedn/g" /etc/freeradius/3.0/mods-available/ldap

# 打印替换后的配置文件内容
echo "/etc/freeradius/3.0/proxy.conf:"
cat /etc/freeradius/3.0/proxy.conf
echo "/etc/freeradius/3.0/clients.conf:"
cat /etc/freeradius/3.0/clients.conf

# 启动 cron 守护进程（前台模式）
#cron -f &

# 启动程序
#exec freeradius -X
exec freeradius -X
