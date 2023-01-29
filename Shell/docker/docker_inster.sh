#!/bin/bash
# 移除掉旧的版本
sudo yum remove docker \
                  docker-client \
                  docker-client-latest \
                  docker-common \
                  docker-latest \
                  docker-latest-logrotate \
                  docker-logrotate \
                  docker-selinux \
                  docker-engine-selinux \
                  docker-engine

# 删除所有旧的数据
sudo rm -rf /var/lib/docker

#  安装依赖包
sudo yum install -y yum-utils \
  device-mapper-persistent-data \
  lvm2

# 添加源，使用了阿里云镜像
sudo yum-config-manager \
    --add-repo \
    http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo

# 配置缓存
sudo yum makecache fast

# 安装最新稳定版本的docker
sudo yum install -y docker-ce

sudo docker info | grep "Docker Root Dir"

#设置数据目录
sudo cp -rip /var/lib/docker /var/lib/docker_bak
sudo mkdir -p /data/docker
sudo /var/lib/docker /data/docker
sudo ln -s /data/docker /var/lib/docker

# 配置镜像加速器
sudo mkdir -p /etc/docker
sudo tee /etc/docker/daemon.json <<-'EOF'
{
  "registry-mirrors": ["http://hub-mirror.c.163.com"]
}
EOF

sudo docker info | grep "Docker Root Dir"

# 启动docker引擎并设置开机启动
sudo systemctl start docker
sudo systemctl enable docker

# 配置当前用户对docker的执行权限
sudo groupadd docker
sudo gpasswd -a ${USER} docker
sudo systemctl restart docker

#安装docker-compose
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
sudo docker-compose --version