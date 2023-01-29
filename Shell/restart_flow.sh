#!/bin/bash

echo -e "\033[36m""Docker容器""\033[0m"
echo $(date +%Y-%m-%d\ %H:%M:%S)

echo -e "\033[36m""查看容器运行状态""\033[0m"

sudo /usr/local/bin/docker ps -a
sleep 5

echo -e "\033[36m""重启haha-flow......""\033[0m"

sudo /usr/local/bin/docker restart haha-flow
sleep 10
echo -e "\033[36m""查看容器运行状态""\033[0m"

sudo /usr/local/bin/docker ps -a

echo $(date +%Y-%m-%d\ %H:%M:%S)
