## 环境：
OS：ubuntu22.04 LTS

cpu: 4C

MEM: 8G 

本项目主要是对接AzureAD-LDAP-wrapper 项目；变相实现 freeradius对接到Azure AD （现在是Entra ID）

## 说明： 密码需要先AzureAD-LDAP-wrapper 认证过一次，然后才会被加密保存，Freeradius才能正确进行用户认证。（已解决）
解决方法： 新增预认证的逻辑。

## 使用方法

### 1.Docker镜像
需要自行准备ssl证书 并且修改权限
```

chmod 644 ssl/radius.crt

chmod 644 ssl/radius.key

chmod 644 ssl/radius_ca.pem

chmod 755 ssl/
```

按照项目里的`docker-compose.yml` 和 `.env` 来进行配置 你的ldap服务器；推荐是配置在一台服务器里，保证网络连接。


### 2.二进制部署
#### 2.1常规安装：
```
apt update && apt install freeradius  freeradius-ldap
```
#### 2.2 修改配置文件
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
密码部分参照项目中ldap文件修改。或者直接拷贝（需要修改掉变量ldap_server等）


发现azure中组里有成员，需要修改配置：按照提示`If using Active Directory you are likely to need "group"  instead of "posixGroup".`修改
```
filter = '(objectClass=Group)'
```
需要自行准备ssl证书 并且修改权限
```
chmod 644 /etc/freeradius/3.0/certs/ssl/radius.crt
chmod 644 /etc/freeradius/3.0/certs/ssl/radius.key
chmod 644 /etc/freeradius/3.0/certs/ssl/radius_ca.pem
chmod 755 /etc/freeradius/3.0/certs/ssl
```
