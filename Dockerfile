# 使用适当的基础镜像
#base on FreeRAIUD version: v3.2
FROM ubuntu:24.04

#设置时区
# ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y sudo curl

# 安装 FreeRADIUS 和其他依赖项
RUN apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    libjson-pp-perl \
    libwww-perl \
    git \
    vim \
    logrotate \
    cron \
    iputils-ping \
    ldap-utils   #预认证ldap必需


# 更新 apt 软件包列表并安装 FreeRADIUS
RUN apt-get update && apt-get install -y freeradius freeradius-ldap 




# 下载配置文件并且拷贝
WORKDIR /tmp
RUN git clone https://github.com/yuhongwei380/freeradius-ldap
RUN cp -f freeradius-ldap/config/default /etc/freeradius/3.0/sites-available/default
RUN cp -f freeradius-ldap/config/inner-tunnel /etc/freeradius/3.0/sites-available/inner-tunnel
RUN cp -f freeradius-ldap/config/pap /etc/freeradius/3.0/mods-available/pap
RUN cp -f freeradius-ldap/config/eap /etc/freeradius/3.0/mods-available/eap
RUN ln -s  /etc/freeradius/3.0/mods-enabled/eap /etc/freeradius/3.0/mods-available/eap
RUN cp -f freeradius-ldap/config/ldap /etc/freeradius/3.0/mods-available/ldap
RUN mkdir /etc/freeradius/3.0/certs/ssl


# 添加启动脚本
COPY start.sh /start.sh
RUN chmod +x /start.sh

# 设置启动命令
CMD ["/start.sh"]
