### SSH连接工具

```bash
# 工具一：xshell
这是个熟悉的软件啦，目前我正在使用Xshell_7
# 工具二：FinalShell
国产软件，有windows和MAC版本；使用方便而且免费，但是软件比较占用内存。但是都2021年了，笔记本电脑内存都16G起步，问题不大的。
# 工具三：SecureCRT
软件比较专业，一般是英文界面；经常使用linux,使用这款软件是不错的选择。
```

##

### 查看系统版本信息

```bash
# lsb_release -a 有的linux系统里面没有这个命令
# 可以使用 cat /etc/centos-release查看

[root@ncayu618 ~]#  lsb_release -a
LSB Version:    :core-4.1-amd64:core-4.1-noarch
Distributor ID: CentOS
Description:    CentOS Linux release 7.9.2009 (Core)
Release:        7.9.2009
Codename:       Core

#查看 Linux 版本名称.

[root@ncayu8847 ~]# cat /etc/centos-release
CentOS Linux release 7.5.1804 (Core) 

#显示正在运行的内核版本。

[root@ncayu8847 ~]# cat /proc/version
Linux version 3.10.0-862.14.4.el7.x86_64 (mockbuild@kbuilder.bsys.centos.org) (gcc version 4.8.5 20150623 (Red Hat 4.8.5-28) (GCC) ) #1 SMP Wed Sep 26 15:12:11 UTC 2018

#显示电脑以及操作系统的相关信息。

[root@ncayu8847 ~]# uname -a
Linux ncayu8847 3.10.0-862.14.4.el7.x86_64 #1 SMP Wed Sep 26 15:12:11 UTC 2018 x86_64 x86_64 x86_64 GNU/Linux

#查看Linux系统架构，这样我们就可以下载对应的软件包进行安装。

[root@ncayu8847 ~]# arch
x86_64
```

* 

### 查看IP地址

```bash
# linux中查看IP地址
ifconfig （通常使用）
ip addr （可以代替ifconfig）可以简写成ip a
# 过滤出IP地址，可用于写shell脚本。
ifconfig -a | grep inet | grep -v 127.0.0.1 | grep -v inet6 | awk '{print $2}'|tr -d "addr:"|awk 'BEGIN{RS="\n";ORS=" ";}{print $0}'
```

```bash
[root@ncayu8847 ~]# ip addr
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 00:16:3e:16:3c:2b brd ff:ff:ff:ff:ff:ff
    inet 172.18.3.0/20 brd 172.18.15.255 scope global dynamic eth0
       valid_lft 310954450sec preferred_lft 310954450sec
[root@ncayu8847 ~]# ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 00:16:3e:16:3c:2b brd ff:ff:ff:ff:ff:ff
    inet 172.18.3.0/20 brd 172.18.15.255 scope global dynamic eth0
       valid_lft 310954378sec preferred_lft 310954378sec
```

### 查看cpu信息

```bash
# 查看CPU信息
cat /proc/cpuinfo

# 查看内存信息
cat /proc/meminfo

#显示系统时间和平均负载
uptime   w    who    top  命令

top 命令
* 使用top命令后可以按键盘数字“1”；可以查看单个CPU的使用情况
* 使用top命令后可以按键盘数字“2”；可以查看单个内存的使用情况

# 日志管理：分析工具：ELK
# 出现问题一定要先查看日志，/var/log  message日志，如果系统出现问题，首先检查的就是这个日志文件。

# 查看内存，磁盘
df -h
free -m

```

### 查看内存磁盘信息

```bash
# 磁盘信息

[root@ncayu8847 ~]# df -h
文件系统        容量  已用  可用 已用% 挂载点
/dev/vda1        40G   32G  5.4G   86% /
devtmpfs        1.9G     0  1.9G    0% /dev
tmpfs           1.9G     0  1.9G    0% /dev/shm
tmpfs           1.9G  720K  1.9G    1% /run
tmpfs           1.9G     0  1.9G    0% /sys/fs/cgroup
tmpfs           379M     0  379M    0% /run/user/0
/dev/vdb        100G   63G   38G   63% /ncayu

# 内存信息

[root@ncayu8847 ~]# free -m
              total        used        free      shared  buff/cache   available
Mem:           3789        1768         118           0        1902        1736
Swap:             0           0           0

```



* 

### 文件上传下载

```bash
## linux 命令行下载文件到本地

yum install lrzsz

# rz  上传
# sz  下载

还可以设置一下上传和下载的目录

option----session options ---- files transfer  下可以设置上传和下载的目录

```



# 

*

### windows 查看CPU核心数，线程数

```bash
# 1.cmd窗口输入命令“wmic”

# 2.然后在出现的窗口输入
cpu get Name   #查看物理CPU名

cpu get NumberOfCores   #查看CPU核心数

cpu get NumberOfLogicalProcessors   #查看CPU线程数

```

### linux中查找文件（find）

```bash
linux 查找某文件所在路径
find 路径 -name 文件名
例如：find / -name logo_web.png  查找/路径下logo_web.png文件路径

[root@dsjpt07 data]# find / -name demo-springboot-starter-0.0.1-SNAPSHOT.jar
/usr/local/tools/demo-springboot-starter-0.0.1-SNAPSHOT.jar
```



### 查看用户组

```bash
linux如何查看所有的用户和组信息的方法：
1、cat /etc/passwd
2、cat /etc/group
修改用户组时，需要把cat 换成 vim ；比如vim /etc/group
```

##

### 修改root账号密码

```bash
linux下修改root密码方法

以root身份登陆，执行：

passwd 用户名
然后根据提示，输入新密码，再次输入新密码，系统会提示成功修改密码。

具体示例如下：

[root@ncayu618 ~]# passwd root
Changing password for user root.
New UNIX password:
BAD PASSWORD: it is based on a dictionary word
Retype new UNIX password:
passwd: all authentication tokens updated successfully.
```



*

### 查看linux主机的IP地址

```BASH
ifconfig  #查看所有的IP地址

## 过滤出IP地址，可用于写shell脚本。
ifconfig -a | grep inet | grep -v 127.0.0.1 | grep -v inet6 | awk '{print $2}'|tr -d "addr:"|awk 'BEGIN{RS="\n";ORS=" ";}{print $0}'
```

##

*

##

*

### 通过进程号查看端口

```bash
netstat -nap | grep 21587
###通过进程id查看端口号
```



### 通过进程号查看启动路径

```bash
# 更据进程号，查询组件位置
[root@ncayu8847 ~]# ll /proc/31303/cwd
lrwxrwxrwx 1 nginx nginx 0 Aug 18 18:52 /proc/31303/cwd -> /data/applications/nginx
[root@ncayu8847 ~]# 
[root@ncayu8847 ~]# ll /proc/13687/cwd
lrwxrwxrwx 1 root root 0 10月 29 11:31 /proc/13687/cwd -> /data/prometheus_hy/grafana-7.4.0
```





### 在linux上校验MD5值

在windows上校验MD5的方式比较繁琐，在linux上会更加简单，首先打开虚拟机上的Center OS7并用
Xshell进行远程连接，新建一个文件11.txt，用md5sum给出11.txt的MD5值，结果如下图所示。touch
11.txt的意思是创建一个名称为11.txt的文件，md5sum 后接路径可以得到文件的MD5值

```bash
[root@Pengfei test02]# md5sum cions.txt #获取cions.txt 的md5值
472a616feeac128d47c058af07001e2d cions.txt
[root@Pengfei test02]# md5sum data.txt #获取data.txt 的md5值
37e07e96f2ad41760cd30ba15146be0b data.txt
##应用场景
#验证Percona mysql的MD5值
[root@ncayu8847 software]# md5sum Percona-Server-5.7.33-36-Linux.x86_64.glibc2.12.tar.gz
6992b38f1085b6b0b30c8df833f043dc  Percona-Server-5.7.33-36-Linux.x86_64.glibc2.12.tar.gz

```



### sha256sum命令使用

```bash
sha256sum [OPTION]... [FILE]...

# 查看docker-20.10.6.tgz的sha256值

[root@ncayu8847 data]# sha256sum docker-20.10.6.tgz
e3b6c3b11518281a51fb0eee73138482b83041e908f01adf8abd3a24b34ea21e  docker-20.10.6.tgz
```





### 解压命令

```bash
gzip  -d  abcsql.gz

unzip  abcsql.zip

tar xzvf abcsql.tar.gz
```

#



### top命令

```bash
和top类似的工具：
#   glances
#   htop
```

这两个工具需要下载安装，体验还是蛮不错的。

glances 是一款用于 Linux、BSD 的开源命令行系统监视工具，它使用 Python 语言开发，能够监视 CPU、负载、内存、磁盘 I/O、网络流量、文件系统、系统温度等信息。

glances 可以为 Unix 和 Linux 性能专家提供监视和分析性能数据的功能，其中包括：

- CPU 使用率
- 内存使用情况
- 内核统计信息和运行队列信息
- 磁盘 I/O 速度、传输和读/写比率
- 文件系统中的可用空间
- 磁盘适配器
- 网络 I/O 速度、传输和读/写比率
- 页面空间和页面速度
- 消耗资源最多的进程
- 计算机信息和系统资源

glances 工具可以在用户的终端上实时显示重要的系统信息，并动态地对其进行更新。这个高效的工具可以工作于任何终端屏幕。另外它并不会消耗大量的 CPU 资源，通常低于百分之二。glances 在屏幕上对数据进行显示，并且每隔两秒钟对其进行更新。您也可以自己将这个时间间隔更改为更长或更短的数值。glances 工具还可以将相同的数据捕获到一个文件，便于以后对报告进行分析和绘制图形。输出文件可以是电子表格的格式 (.csv) 或者 html 格式。



### 通过pid查看端口

```bash
[root@ncayu618 ncayu618]# netstat -antup|grep 2150
tcp        0     52 172.18.55.8:22          116.237.140.20:36130    ESTABLISHED 2150/sshd: root@pts 
[root@ncayu618 ncayu618]# 
#通过应用查询端口和pid
$ ss -naltp|grep prometheus
```



### 查看防火墙是否开启

```bash
1、查看firewall服务状态

systemctl status firewalld

出现Active: active (running)切高亮显示则表示是启动状态。

2、查看firewall的状态

firewall-cmd --state
3、开启、重启、关闭、firewalld.service服务

开启
service firewalld start
重启
service firewalld restart
关闭
service firewalld stop
4、查看防火墙规则

firewall-cmd --list-all
5、查询、开放、关闭端口

查询端口是否开放
firewall-cmd --query-port=8080/tcp
开放80端口
firewall-cmd --permanent --add-port=80/tcp
移除端口
firewall-cmd --permanent --remove-port=8080/tcp
#重启防火墙(修改配置后要重启防火墙)
firewall-cmd --reload

参数解释
1、firwall-cmd：是Linux提供的操作firewall的一个工具；
2、–permanent：表示设置为持久；
3、–add-port：标识添加的端口；

 一、防火墙的开启、关闭、禁用命令

（1）设置开机启用防火墙：systemctl enable firewalld.service

（2）设置开机禁用防火墙：systemctl disable firewalld.service

（3）启动防火墙：systemctl start firewalld

（4）关闭防火墙：systemctl stop firewalld

（5）检查防火墙状态：systemctl status firewalld 

#centos6.x查看防火墙
[root@centos6 ~]# service iptables status
iptables：未运行防火墙。
开启防火墙：
[root@centos6 ~]# service iptables start
关闭防火墙：
[root@centos6 ~]# service iptables stop
重启防火墙
[root@centos6 ~]# service iptables restart

#centos6.x 添加防火墙端口
1.开放80，22，8080 端口

/sbin/iptables -I INPUT -p tcp --dport 80 -j ACCEPT
/sbin/iptables -I INPUT -p tcp --dport 61616 -j ACCEPT
/sbin/iptables -I INPUT -p tcp --dport 9100 -j ACCEPT

2.保存
/etc/rc.d/init.d/iptables save

3.查看打开的端口
/etc/init.d/iptables status

4、关闭端口（以7777端口为例）

vi /etc/sysconfig/iptables  打开配置文件加入如下语句:

-A INPUT -p tcp -m state --state NEW -m tcp --dport 7777 -j DROP

```

### 查询所有被占用的端口

```bash
netstat -tulnp

-t(tcp)只显示tcp相关的

-u(udp)只显示udp相关的

-l(listening)只显示监听服务的端口

-n(numeric)不解析名称,能用数字表示的就不用别名(例如:localhost会转成127.0.0.1)

-p(programs)显示端口的PID和程序名称

查询单个端口是否被占用。
可以通过netstat -tulnp | grep 端口号查看当前端口号是否被占用

例如：

netstat -tulnp|grep 3306
```

### 检查端口开放情况

```bash
netstat 工具检测开放端口

[root@DB-Server Server]# netstat -anlp | grep 3306


###nmap是一款网络扫描和主机检测的工具
关于nmap的使用，都可以长篇大写特写，这里不做展开。如下所示，nmap 127.0.0.1 查看本机开放的端口，会扫描所有端口。 当然也可以扫描其它服务器端口。

yum install nmap;

[root@ncayu618 ~]# nmap 127.0.0.1

Starting Nmap 6.40 ( http://nmap.org ) at 2021-05-19 11:14 CST
Nmap scan report for localhost (127.0.0.1)
Host is up (0.0000070s latency).
Not shown: 995 closed ports
PORT     STATE SERVICE
22/tcp   open  ssh
25/tcp   open  smtp
3000/tcp open  ppp
9090/tcp open  zeus-admin
9100/tcp open  jetdirect

Nmap done: 1 IP address (1 host up) scanned in 1.58 seconds

```

### linux创建新的用户



```bash
#1、添加用户，首先用adduser命令添加一个普通用户，命令如下：

adduser ncayu
#添加一个名为ncayu的用户
passwd ncayu   
#修改密码
Changing password for user ncayu.
New UNIX password:     #在这里输入新密码
Retype new UNIX password:  #再次输入新密码
passwd: all authentication tokens updated successfully.

#2、赋予root权限
#修改 /etc/sudoers 文件，找到下面一行，在root下面添加一行，如下所示：
## Allow root to run any commands anywhere
root    ALL=(ALL)     ALL
ncayu   ALL=(ALL)     ALL
#修改完毕，现在可以用ncayu帐号登录，然后用命令 sudo – ，即可获得root权限进行操作。
```



### 更改文件的用户组

```bash
二、使用 chown命令 更改文件拥有者
在 shell 中，可以使用 chown命令 来改变文件所有者。 chown命令 是change owner（改变拥有者）的缩写。需要要注意的是， 用户必须是已经存在系统中的，也就是只能改变为在 /etc/passwd这个文件中有记录的用户名称才可以 。
chown命令 的用途很多，还可以顺便直接修改用户组的名称。此外，如果要连目录下的所有子目录或文件同时更改文件拥有者的话，直接加上  -R 的参数即可。
基本语法：
chown [ -R]  账号名称  文件或 目录
chown [ -R]  账号名称: 用户组名称  文件或 目录
参数：
-R : 进行递归( recursive )的持续更改，即连同子目录下的所有文件、目录
都更新成为这个用户组。常常用在更改某一目录的情况。
# 例如：
chown ncayu:ncayu /prometheus

chown -R ncayu:ncayu /prometheus

```





### 查找JAVA_HOME路径

```bash
测试环境：阿里云  CentOS7.9
[root@ncayu8847 ~]# cat /etc/profile |grep JAVA_HOME |awk 'NR==1'| awk '{print $2}'
JAVA_HOME=/data/environment/jdk1.8.0_281


测试环境：本地虚拟机 版本：CentOs7.9
[root@localhost ~]# cat /etc/profile |grep JAVA_HOME |awk 'NR==1'
JAVA_HOME=/usr/java/jdk1.8.0_201-amd64
[root@localhost ~]# cat /etc/centos-release
CentOS Linux release 7.9.2009 (Core)


# 其他需求

echo JDK路径: $JAVA_HOME
echo 项目目录: $APP_HOME
echo 项目名称: $APP_NAME
echo 配置文件: $APP_CONF
echo JVM参数: $JAVA_OPTS
```



###

### awk命令基础

```bash
linux下AWK实现取输出结果第一行

awk 'NR==1'
```





### scp命令传输文件

```bash
scp jdk-8u281-linux-x64.tar.gz root@192.168.35.131:/usr/local
```



### screen命令

Linux screen命令用于多重视窗管理程序。

screen为多重视窗管理程序。此处所谓的视窗，是指一个全屏幕的文字模式画面。通常只有在使用telnet登入主机或是使用老式的终端机时，才有可能用到screen程序。

```bash
# 语法
screen [-AmRvx -ls -wipe][-d <作业名称>][-h <行数>][-r <作业名称>][-s <shell>][-S <作业名称>]
```

**参数说明**：

- -A 　将所有的视窗都调整为目前终端机的大小。
- -d<作业名称> 　将指定的screen作业离线。
- -h<行数> 　指定视窗的缓冲区行数。
- -m 　即使目前已在作业中的screen作业，仍强制建立新的screen作业。
- -r<作业名称> 　恢复离线的screen作业。
- -R 　先试图恢复离线的作业。若找不到离线的作业，即建立新的screen作业。
- -s<shell> 　指定建立新视窗时，所要执行的shell。
- -S<作业名称> 　指定screen作业的名称。
- -v 　显示版本信息。
- -x 　恢复之前离线的screen作业。
- -ls或--list 　显示目前所有的screen作业。
- -wipe 　检查目前所有的screen作业，并删除已经无法使用的screen作业。

```bash
# 创建 screen 终端
screen

# 创建 screen 终端 并执行任务

screen vi ~/main.c //创建 screen 终端 ，并执行 vi命令

# 离开 screen 终端
screen vi ~/main.c //创建 screen 终端 ，并执行 vi命令

#include 

main ()
{

}

"~/mail.c"       0,0-1    

在 screen 终端 下 按下 Ctrl+a d键

```

```bash
# 重新连接离开的 screen 终端

# screen -ls  //显示已创建的screen终端 
There are screens on:
2433.pts-3.linux    (2013年10月20日 16时48分59秒)    (Detached)
2428.pts-3.linux    (2013年10月20日 16时48分05秒)    (Detached)
2284.pts-3.linux    (2013年10月20日 16时14分55秒)    (Detached)
2276.pts-3.linux    (2013年10月20日 16时13分18秒)    (Detached)
4 Sockets in /var/run/screen/S-root.

# screen -r 2276 //连接 screen_id 为 2276 的 screen终端
```

使用

```bash
# 创建screen窗口

screen -S ncayu168

# 查看当前的screen作业
[root@ncayu8847 ~]# screen -ls
There are screens on:
        27980.ncayu8847 (Attached)
        27550.ncayu168  (Attached)
2 Sockets in /var/run/screen/S-root.

# 连接 screen_id 为 27550 的 screen终端
screen -r 27550 
```



### 文件排序工具sort

sort是排序工具，它完美贯彻了Unix哲学："只做一件事，并做到完美"。它的排序功能极强、极完整，只要文件中的数据足够规则，它几乎可以排出所有想要的排序结果，是一个非常优质的工具

```bash
# 语法
sort [-bcdfimMnr][-o<输出文件>][-t<分隔字符>][+<起始栏位>-<结束栏位>][--help][--verison][文件][-k field1[,field2]]

# 文件大小排序
du -s * | sort -nr
# 查看前五
du -s * | sort -nr | head -5

# 使用 -k 参数设置对第三列的值进行重排
[root@ncayu8847 test_hy]# sort -k 3 -nr system.txt
5       SUSE    4000    300
2       winxp   4000    300
1       mac     2000    500
4       linux   1000    200
3       bsd     1000    600
6       Debian  600     200
```

示例：

```bash
[root@ncayu8847 data]# du -s * | sort -nr
1500156 software
751272  prometheus_hy
742184  tidb_tool
695692  applications
491672  environment
386764  maven
89772   minio
68008   docker-20.10.6.tgz
46176   squashfs-root
20920   mc
14308   nvim.appimage
9800    lsof_4.91
1080    lsof_4.91.tar.gz
504     libtirpc-1.3.2.tar.bz2
252     code
100     test_hy
64      speedtest.py
24      numactl-devel-2.0.12-5.el7.x86_64.rpm
8       sqlfile
8       apache2
4       tidb
4       backup_svn

[root@ncayu8847 data]# du -s * | sort -nr | head -5
1500156 software
751620  prometheus_hy
742184  tidb_tool
695692  applications
491672  environment
```





### 文本处理相关命令

```bash
# 相关命令： 
sort, uniq, comm, cmp, diff, tr, sed, awk, perl, cut, paste, column, pr
```



### uniq命令

```bash
[root@ncayu8847 test_hy]# cat test.txt 
test 30  
test 30  
test 30  
Hello 95  
Hello 95  
Hello 95  
Hello 95  
Linux 85  
Linux 75

# 去除重复的内容

[root@ncayu8847 test_hy]# uniq test.txt 
test 30  
Hello 95  
Linux 85  
Linux 75
[root@ncayu8847 test_hy]#

# 统计重复的内容出现的次数 

[root@ncayu8847 test_hy]# uniq -c test.txt 
      3 test 30  
      4 Hello 95  
      1 Linux 85  
      1 Linux 75

# 先排序，后去重
当重复的行并不相邻时，uniq 命令是不起作用的，即若文件内容为以下时，uniq 命令不起作用：
这时我们就可以使用 sort：

[root@ncayu8847 test_hy]# sort  test.txt | uniq
Hello 95  
Linux 85
Linux 75  
test 30 

# 统计各行在文件中出现的次数：
[root@ncayu8847 test_hy]# sort test.txt | uniq -c
      4 Hello 95  
      1 Linux 85
      1 Linux 75  
      3 test 30
      

# 在文件中找出重复的行：
[root@ncayu8847 test_hy]# sort test.txt | uniq -d
Hello 95  
test 30

```



### seq命令详解

```bash
# 连续输出20到30
[root@ncayu8847 test_hy]# seq 20 30
20
21
22
23
24
25
26
27
28
29
30

# seq命令还可以实现步进输出 ，比如从20 开始，每次步进 3 ，最大到50
[root@ncayu8847 test_hy]# seq 20 3 50
20
23
26
29
32
35
38
41
44
47
50
```

seq命令还有一些常用选项:

* -s  指定输出的分隔符，默认为\n，即默认为回车换行

* -w  指定为定宽输出，不能和-f一起用

* -f  按照指定的格式输出，不能和-w一起使用

```bash
-s选项：指定分隔符

# 指定减号为分隔符
[root@ncayu8847 test_hy]# seq -s - 20 3 50
20-23-26-29-32-35-38-41-44-47-50

# 使用制表符（\t）作为分隔符
[root@ncayu8847 test_hy]# seq -s"`echo -e "\t"`" 20 25
20      21      22      23      24      25

注意：示例中使用了命令替换，也就是说，先使用echo命令输出制表符，然后用输出的制表符作为seq命令输出数字的连接符。

-w 选项：指定为定宽输出，例如下图，最大值为11，是两位数，那么不到两位的数前面自动用0补全，当然，如果指定的位数最大为三位数字，那么一位数和两位数前面的位数都会用0补全，也就是说，以最大值的位数为标准宽度，不足标准宽度的数字将会用0补位。

# 6到12
[root@ncayu8847 test_hy]# seq -w 6 12
06
07
08
09
10
11
12

# 98到102
[root@ncayu8847 test_hy]# seq -w 98 102
098
099
100
101
102

-f选项：按照指定的格式输出生成的数字，在没有使用-f选项指定格式时，默认格式为%g，可以理解为使用-f 指定模式为"%g",跟不指定格式没有任何区别.

[root@ncayu8847 test_hy]# seq 20 25
20
21
22
23
24
25
[root@ncayu8847 test_hy]# seq -f '%g' 20 25
20
21
22
23
24
25

# "%3g"这种格式表示指定"位宽"为三位，那么数字位数不足部分用空格补位

[root@ncayu8847 test_hy]# seq -f '%02g' 20 25
20
21
22
23
24
25
[root@ncayu8847 test_hy]# seq -f '%03g' 20 25
020
021
022
023
024
025
[root@ncayu8847 test_hy]# seq -f '%04g' 20 25
0020
0021
0022
0023
0024
0025
[root@ncayu8847 test_hy]# seq -f '%05g' 20 25
00020
00021
00022
00023
00024
00025

上述例子中的格式中，都包含一个'%',其实 % 前面还可以指定字符串

# 例如在屏幕上打印5个名为dir1 , dir2 .. dir5 的字符串，这时候就用到这种写法
[root@ncayu8847 test_hy]# seq -f 'dir%g' 1 5
dir1
dir2
dir3
dir4
dir5

所以，结合上述示例中的seq命令的特性，再结合其他命令，就能为我们带来许多方便。
例如一次性创建10个名为dir001 , dir002 .. dir010 的目录，这时候就用到这种写法。

mkdir $(seq -f 'dir%03g' 1 10)

或者如下命令，与上述命令的效果相同。

seq -f 'dir%03g' 1 5 | xargs mkdir
```



### 



###

