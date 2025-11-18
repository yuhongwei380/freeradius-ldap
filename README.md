
## 本项目主要是对接AzureAD-LDAP-wrapper 项目；变相实现 freeradius对接到Azure AD （现在是Entra ID）

## 说明：新增预认证的逻辑,首次登陆即可触发认证，Freeradius才能正确进行用户认证。


## Docker 镜像仓库地址：
https://hub.docker.com/repository/docker/yuhongwei1997/freeradius-ldap-wrapper/general </p>
TAG:1.0 & test-251112 </p>
```
目前的问题： </p>
1.windows这边采用 PEAP+MSCHAPV2，且需要手动关闭：受保护的eap设置- 关闭通过验证证书来验证服务器的身份。 
2.手机端仍然使用PAP-TTLS 
3.MACOS/IOS端使用 描述文件，TTLS
``
TAG:test 测试镜像:用于windows解决pap-ttls的问题；未解决，不可使用</p>

# 一、说明:

目前的问题：</p>
1.windows这边采用 PEAP+MSCHAPV2，且需要手动关闭：受保护的eap设置- 关闭通过验证证书来验证服务器的身份。</p>
2.手机端仍然使用PAP-TTLS</p>
3.MACOS/IOS端使用 描述文件，TTLS</p>

# 二、部署环境
## 环境：
```
OS：ubuntu22.04 LTS
cpu: 4C
MEM: 8G
```


## 三、使用方法

### 1.Docker镜像
需要自行准备ssl证书
```
radius.crt
radius.key
radius_ca.pem
```
按照项目里的`docker-compose.yml` 和 `.env` 来进行配置 你的ldap服务器；推荐是配置在一台服务器里，保证网络连接。
```
cp docker-compose.yml.template  docker-compose.yml
```


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


发现azure中组里有成员，需要修改配置：按照提示`If using Active Directory you are likely to need "group"  instead of "posixGroup". 修改

```
filter = '(objectClass=Group)'
```
### 3.SSL profile
ssl 二进制部署的话：
```
chmod 644 /etc/freeradius/3.0/certs/ssl/radius.crt
chmod 644 /etc/freeradius/3.0/certs/ssl/radius.key
chmod 644 /etc/freeradius/3.0/certs/ssl/radius_ca.pem
chmod 755 /etc/freeradius/3.0/certs/ssl
```
docker ：
```
chmod 644 ssl/radius.crt
chmod 644 ssl/radius.key
chmod 644 ssl/radius_ca.pem
chmod 755 ssl
```

### 4.本地测试
test in Linux:
```
radtest <user> <pwd>  192.168.8.50  1812 nebula
```










