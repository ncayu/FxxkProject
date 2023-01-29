#!/bin/sh

echo -e "\033[32m""当前操作的用户为""\033[0m"
who am i|awk '{print $1}'
who_am_i=`who am i|awk '{print $1}'`
if [ $who_am_i != "root" ]
then
    echo -e "\033[31m""请在 root 用户下运行脚本, 安装程序需要修改部分系统参数, 需要 root 权限 !!! ""\033[0m"
    exit -1
fi
date
hwclock
echo -e "\033[32m""时间源为ntp1.aliyun.com,正在同步时间，请稍等...""\033[0m"
ntpdate -u ntp1.aliyun.com
echo -e "\033[32m""将系统时间写入到硬件""\033[0m"
clock -w
echo -e "\033[32m""当前时间为""\033[0m"
date
hwclock
echo -e "\033[31m""时间同步完毕，请你确认同步时间是否正确""\033[0m"
