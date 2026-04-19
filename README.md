
## 本项目主要是对接AzureAD-LDAP-wrapper 项目；变相实现 freeradius对接到Azure AD （现在是Entra ID）

## 说明：新增预认证的逻辑,首次登陆即可触发认证，Freeradius才能正确进行用户认证。


## Docker 镜像仓库地址：
https://hub.docker.com/repository/docker/yuhongwei1997/freeradius-ldap-wrapper/general </p>
TAG:1.0 & test-251112 </p>
```
当前策略（推荐）：</p>
1.统一使用 EAP-TTLS + PAP（外层 TTLS，内层 PAP）</p>
2.Windows 端请优先使用 TTLS + PAP（Windows 8+），并保持“验证服务器证书”开启</p>
3.iOS/macOS 可继续使用描述文件下发 TTLS 配置</p>
``
TAG:test 测试镜像:用于历史兼容验证，不作为当前推荐方案</p>

# 一、说明:

当前策略：</p>
1.统一采用 EAP-TTLS + PAP。</p>
2.不建议关闭“验证服务器证书”，请在终端侧导入并信任 CA 后开启校验。</p>
3.MACOS/IOS 仍可使用描述文件下发 TTLS。</p>

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


发现azure中组里有成员，需要修改配置：按照提示`If using Active Directory you are likely to need "group"  instead of "posixGroup".`修改
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

test EAP-TTLS/PAP:
```
# 先按项目 scripts/eapol_test-ttls-pap.conf.example 生成你的配置
./wpa_supplicant/eapol_test -s <radius_secret> -c ./scripts/eapol_test-ttls-pap.conf
```








