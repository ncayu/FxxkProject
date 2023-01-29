#!/bin/sh

echo -e "\033[36m""《nginx-1.20.1.tar.gz一键安装脚本》""\033[0m\n\n"
# 全局参数区
# 安装目录指定为 /data/applications
NGINX_DIR="/data/applications/"
NGINX_CONF_DIR="/data/applications/nginx1.20.1/"
NGINX_PACKAGE=nginx-1.20.1.tar.gz
ZLIB_FILE="/data/applications/zlib-1.2.11.tar.gz"
PCRE_FILE="/data/applications/pcre-8.43.tar.gz"
OPENSSL_FILE="/data/applications/openssl-1.1.1k.tar.gz"
NGINX_FILE="/data/applications/nginx-1.20.1.tar.gz"


# 检查 /data/applications 目录是否存在；目录需要用户创建
if [ ! -d ${NGINX_DIR} ]
then
    echo -e "\033[31m"${NGINX_DIR}" 文件目录不存在, 请创建文件目录 !!! \033[0m"
    exit -1
fi


# 使用yum安装gcc gcc-c++ pcre pcre-devel zlib zlib-devel openssl* openssl-devel
echo -e "\033[32m""使用yum安装gcc gcc-c++ pcre pcre-devel zlib zlib-devel openssl* openssl-devel""\033[0m"
yum -y install gcc gcc-c++ pcre pcre-devel zlib zlib-devel openssl* openssl-devel


# 创建nginx用户
echo -e "\033[32m""创建nginx用户""\033[0m"
groupadd nginx
useradd -g nginx nginx


# 安装编译zlib-1.2.11
echo -e "\033[32m""安装编译zlib-1.2.11""\033[0m"
#判断文件是否存在
if [[ ! -f "$ZLIB_FILE" ]]; then
 echo -e "\033[32m""文件不存在,正在尝试连接网络下载""\033[0m"
 wget http://zlib.net/zlib-1.2.11.tar.gz
else
 echo -e "\033[32m""文件存在,即将开始编译zlib-1.2.11""\033[0m"
fi
sleep 5s

cd ${NGINX_DIR} 
tar -zxvf zlib-1.2.11.tar.gz -C ${NGINX_DIR}
cd ${NGINX_DIR}zlib-1.2.11
./configure 
make && make install


# 安装编译pcre-8.43
echo -e "\033[32m""安装编译pcre-8.43""\033[0m"
if [[ ! -f "$PCRE_FILE" ]]; then
 echo -e "\033[32m""文件不存在,请你上传文件到/data/applications目录下""\033[0m"
# wget https://netix.dl.sourceforge.net/project/pcre/pcre/8.43/pcre-8.43.tar.gz
else 
 echo -e "\033[32m""文件存在,即将开始编译pcre-8.43.tar.gz""\033[0m"
fi
sleep 5s

cd ${NGINX_DIR}
tar -zxvf pcre-8.43.tar.gz -C ${NGINX_DIR}
cd ${NGINX_DIR}pcre-8.43
./configure 
make && make install


# 安装编译openssl-1.1.1k
echo -e "\033[32m""安装编译openssl-1.1.1k""\033[0m"
if [[ ! -f "$OPENSSL_FILE" ]]; then
 echo -e "\033[32m""文件不存在,正在尝试连接网络下载""\033[0m"
 wget https://www.openssl.org/source/openssl-1.1.1k.tar.gz
else 
 echo -e "\033[32m""文件存在,即将开始编译openssl-1.1.1k.tar.gz""\033[0m"
fi
sleep 5s
cd ${NGINX_DIR}
tar -zxf openssl-1.1.1k.tar.gz
cd ${NGINX_DIR}openssl-1.1.1k
./config --prefix=/usr/local/ssl -d shared
make && make install
echo '/usr/local/ssl/lib' >> /etc/ld.so.conf
ldconfig -v 


# 解压Nginx文件 ......
if [[ ! -f "$NGINX_FILE" ]]; then
 echo -e "\033[32m""文件不存在,请你上传nginx文件到/data/applications目录下""\033[0m"
else 
 echo -e "\033[32m""文件存在,即将开始编译nginx""\033[0m"
fi
sleep 5s
cd ${NGINX_DIR}
echo -e "\033[36m""解压Nginx文件 ......""\033[0m" 

tar -zxvf ${NGINX_PACKAGE} -C ${NGINX_DIR}

cd ${NGINX_DIR}nginx-1.20.1

# 安装编译nginx
echo -e "\033[32m""安装编译nginx""\033[0m"
./configure --user=nginx --group=nginx \
--with-http_stub_status_module \
--with-http_gzip_static_module \
--with-http_realip_module \
--with-http_sub_module \
--with-http_ssl_module \
--prefix=/data/applications/nginx1.20.1 \
--with-pcre=/data/applications/pcre-8.43 \
--with-zlib=/data/applications/zlib-1.2.11 \
--with-openssl=/data/applications/openssl-1.1.1k \
--with-http_v2_module \
--with-stream

make && make install
echo -e "\033[32m""安装编译完成""\033[0m"
sleep 5s

# 创建文件夹cache
echo -e "\033[36m""创建文件夹cache""\033[0m"

if [ ! -d ${NGINX_CONF_DIR}cache ];then
   mkdir -p ${NGINX_CONF_DIR}cache
fi
#cd ${NGINX_CONF_DIR}
#mkdir cache


# 备份初始文件 nginx.conf
if [ -f "/data/applications/nginx1.20.1/conf/nginx.conf" ]
then
    echo -e "\033[31m备份初始文件 nginx.conf => nginx.conf_bak \033[0m"
    mv ${NGINX_CONF_DIR}conf/nginx.conf ${NGINX_CONF_DIR}conf/nginx.conf_bak
fi


# 文件内容写入nginx.conf脚本
echo -e "\033[36m""《文件内容写入nginx.conf脚本》""\033[0m\n\n"

sudo cat>${NGINX_CONF_DIR}conf/nginx.conf <<END
#user  nobody;
worker_processes  4;

#error_log  logs/error.log;
#error_log  logs/error.log  notice;
#error_log  logs/error.log  info;

#pid        logs/nginx.pid;


events {
    worker_connections  4096;
}


http {
	include mime.types;
	default_type application/octet-stream;
	
	#access_log  logs/access.log  main;
	
	send_timeout          60s;
    sendfile off;#关闭目录索引
	server_tokens off;#隐藏版本
    
    keepalive_timeout  80s;
	# X-Frame-Options是防止从“点击劫持”攻击
	add_header X-Frame-Options SAMEORIGIN;

	#禁用内容类型在一些浏览器嗅探。
	add_header X-Content-Type-Options nosniff;

	#这个头使跨站点脚本(XSS)过滤器
	add_header X-XSS-Protection "1; mode=block";

	#这将执行HTTP浏览到HTTPS和ssl避免剥离攻击
	add_header Strict-Transport-Security "max-age=31536000; includeSubdomains;";
	tcp_nopush on; #防止网络阻塞
    tcp_nodelay on; #防止网络阻塞
	
	
	#gzip模块设置
    gzip on; #开启gzip压缩输出
    gzip_min_length 1k; #最小压缩文件大小
    gzip_buffers 4 16k; #压缩缓冲区
    gzip_comp_level 2; #压缩等级
    gzip_types text/plain application/javascript application/x-javascript text/css application/xml text/javascript application/x-httpd-php image/jpeg image/gif image/png; #压缩类型
    gzip_vary on;
	# 设置缓存路径并且使用一块最大100M的共享内存，用于硬盘上的文件索引，包括文件名和请求次数，每个文件在1天内若不活跃（无请求）则从硬盘上淘汰，硬盘缓存最大10G，满了则根据LRU算法自动清除缓存。
	proxy_cache_path /data/applications/nginx1.20.1/cache levels=1:2 keys_zone=imgcache:100m inactive=1d max_size=10g;
	
	client_max_body_size 100m;

##################################################################	
	server {
        listen 80;
		root   html;
		server_name localhost;
		
		location /{
			root html;
		}	
	}
##########################################################################	

}
END
echo -e "\033[36m""nginx.conf文件写入完成""\033[0m"



# 测试配置文件是否正确
echo -e "\033[36m""测试配置文件是否正确 ......""\033[0m"
${NGINX_CONF_DIR}sbin/nginx -t


# 查看nginx版本
echo -e "\033[36m""查看nginx版本""\033[0m"
${NGINX_CONF_DIR}sbin/nginx -V
sleep 3s
# 删除nginx-1.20.1解压文件
echo -e "\033[36m""删除nginx-1.20.1解压文件""\033[0m"
rm -rf ${NGINX_DIR}nginx-1.20.1
# nginx 安装完成
echo -e "\n"
echo -e "\033[36m""nginx 安装完成 !!!""\033[0m"
echo -e "\033[36m""nginx的配置文件路径为${NGINX_CONF_DIR}conf/;""\033[0m"
echo -e "\033[36m""nginx启动路径为${NGINX_CONF_DIR}sbin/;""\033[0m"
echo -e "\n"
echo -e "\033[36m""./nginx -t        #测试配置文件是否正确""\033[0m"
echo -e "\033[36m""./nginx           #启动nginx""\033[0m"
echo -e "\033[36m""./nginx -s reload #重新载入nginx配置文件：""\033[0m"
echo -e "\033[36m""./nginx -s stop   #快速关闭nginx""\033[0m"
echo -e "\033[36m""./nginx -s quit   #关闭nginx""\033[0m"



