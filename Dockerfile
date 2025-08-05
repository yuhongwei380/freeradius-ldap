# 使用适当的基础镜像
#base on FreeRAIUD version: v3.2
FROM ubuntu:24.04

#设置时区
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y tzdata
RUN ln -fs /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
RUN dpkg-reconfigure --frontend noninteractive tzdata  
RUN apt-get update && apt-get install -y sudo curl

# 安装 FreeRADIUS 和其他依赖项
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    libjson-pp-perl \
    libwww-perl \
    git \
    vim \
    logrotate \
    cron 


# 更新 apt 软件包列表并安装 FreeRADIUS
RUN apt-get update && apt-get install -y freeradius freeradius-ldap 



# 下载配置文件并且拷贝
WORKDIR /tmp
RUN git clone https://github.com/yuhongwei380/freeradius-ldap
RUN cp freeradius-ldap/config/default /etc/freeradius/sites-available/default
RUN cp freeradius-ldap/config/inner-tunnel /etc/freeradius/sites-available/inner-tunnel
RUN cp freeradius-ldap/config/ldap.template /etc/freeradius/3.0/mods-available/ldap
RUN mkdir /etc/freeradius/certs/ssl

# 添加启动脚本
COPY start.sh /start.sh
RUN chmod +x /start.sh

# 设置启动命令
CMD ["/start.sh"]
