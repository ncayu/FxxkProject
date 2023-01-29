#!/bin/sh

echo -e "\033[36m""《Percona Mysql 一键安装脚本》\n\n适用于没有任何 MYSQL SERVER 环境 ......\n\nMYSQL版本范围: \nPercona-Server-8.0.19-10-Linux.x86_64.ssl101.tar.gz  \nPercona-Server-8.0.21-12-Linux.x86_64.glibc2.12.tar.gz  \nPercona-Server-5.7.29-32-Linux.x86_64.ssl101.tar.gz \nPercona-Server-5.7.30-33-Linux.x86_64.ssl101.tar.gz""\033[0m\n\n"

echo -e "\033[36m""Mysql 环境检查 ......""\033[0m"

who_am_i=`who am i|awk '{print $1}'`
if [ $who_am_i != "root" ]
then
    echo -e "\033[31m""请在 root 用户下运行脚本, 安装程序需要修改部分系统参数, 需要 root 权限 !!! ""\033[0m"
    exit -1
fi

openssl_check="openssl version"
eval ${openssl_check}
if [ $? -ne 0 ]
then
	echo -e "\033[31m""openssl 环境需要确认 [openssl version] !!! ""\033[0m"
    exit -1
fi

# 全局参数区
# 安装目录指定为 /data , 需要确认
DATA_DIR="/data/application"
MYSQL_8_0_19_MD5="d8de1f38187b15bf29eac87c0ab578a9"
MYSQL_5_7_29_MD5="d90ecda7c9acb410395c9bd3693fcf44"
MYSQL_5_7_30_MD5="f9f44dd162ef9f62a3feb1165425efa9"
MYSQL_8_0_21_MD5="db50b5b39403b19cc7c987fbed5b9ee9"

# 人机交互,等待时间(秒)
LOOP_TIME_OUT=255 	# stty: maximum option value is 255 -- time


while true;do
	stty -icanon min 0 time ${LOOP_TIME_OUT}			# end while ten seconds after
	echo -e "\033[36m""MysqlServer 将安装在 "${DATA_DIR}" 目录，请确认 ! (yes or no)?""\033[0m"
	read Arg
	case $Arg in
		Y|y|YES|yes)
			select_flag=true
	  		break;;
		N|n|NO|no)
			echo -e "\033[31m用户中止安装 !!! \033[0m"
	  		exit;;
		"")  #Autocontinue
			echo -e "\033[31m用户没有确认,中止安装 !!! \033[0m"
	  		exit;;
	esac
done

# 检查 /data 目录是否存在；目录需要用户创建
if [ ! -d ${DATA_DIR} ]
then
    echo -e "\033[31m"${DATA_DIR}" does not exist, please create it !!! \033[0m"
    exit -1
fi

# 验证入参
MYSQL_PACKAGE=$1
if [ ! ${MYSQL_PACKAGE} ]
then
    while true;do
		echo -e "\033[36m""请输入Mysql安装包路径 ...... ""\033[0m"
		read Arg

		if [ ${Arg} ] && [ -f ${Arg} ]
		then
			MYSQL_PACKAGE=${Arg}
			break;
		fi
	done
fi

MYSQL_PORT=$2
if [ ! ${MYSQL_PORT} ]
then
	while true;do
		echo -e "\033[36m""请输入MYSQL PORT [3306]:""\033[0m"
		read Arg

		if [ ! ${Arg} ]
		then
			MYSQL_PORT=3306
			break;
		else
			MYSQL_PORT=${Arg}
			break;
		fi
	done
fi

MYSQL_ROOT_DEFAULT_PASSWD=$3
if [ ! ${MYSQL_ROOT_DEFAULT_PASSWD} ]
then
	while true;do
		echo -e "\033[36m""请输入MYSQL ROOT PASSWORD [root]:""\033[0m"
		read Arg

		if [ ! ${Arg} ]
		then
			MYSQL_ROOT_DEFAULT_PASSWD="root"
			break;
		else
			MYSQL_ROOT_DEFAULT_PASSWD=${Arg}
			break;
		fi
	done
fi


# BASENAME
MYSQL_BASENAME=`basename ${MYSQL_PACKAGE}`

echo -e "\033[36m""校验文件内容 ......""\033[0m"
# 验证安装包MD5
package_md5=`md5sum ${MYSQL_PACKAGE} | awk '{print $1}'`
# echo $package_md5

if [ $package_md5 == ${MYSQL_8_0_19_MD5} ]
then
    echo -e "\033[36m""安装包为 Percona-Server-8.0.19-10-Linux.x86_64.ssl101.tar.gz ""\033[0m"
    current_mysql_version=8
elif [ $package_md5 == ${MYSQL_8_0_21_MD5} ]
then
	echo -e "\033[36m""安装包为 Percona-Server-8.0.21-12-Linux.x86_64.glibc2.12.tar.gz ""\033[0m"
	current_mysql_version=8
elif [ $package_md5 == ${MYSQL_5_7_29_MD5} ]
then
	echo -e "\033[36m""安装包为 Percona-Server-5.7.29-32-Linux.x86_64.ssl101.tar.gz ""\033[0m"
	current_mysql_version=5
elif [ $package_md5 == ${MYSQL_5_7_30_MD5} ]
then
	echo -e "\033[36m""安装包为 Percona-Server-5.7.30-33-Linux.x86_64.ssl101.tar.gz ""\033[0m"
	current_mysql_version=5
else
    echo -e "\033[31m无效安装包，请检查 !!! \033[0m"
    exit -1
fi 


# 验证系统包
openssl_package_exist=`rpm -qa|grep openssl|wc -l`
if [ $openssl_package_exist -le 0 ]
then
	echo -e "\033[31m""openssl 系统包需要安装 !!!""\033[0m"
	exit -1
fi

# 检查系统中是否有可能的mysql服务进程
echo -e "\033[33m""check service mysqld status""\033[0m"  
service mysqld status
echo -e "\n\n"


echo -e "\033[33m""check chkconfig –list | grep mysql""\033[0m"  
chkconfig –list | grep mysql
echo -e "\n\n"


echo -e "\033[33m""check process""\033[0m"  
ps -ef | grep mysql
echo -e "\n\n"

echo -e "\033[35m""请确认设备上没有任何MYSQL服务进程,安装程序会修改部分系统及MYSQL配置参数 !!!""\033[0m"  

while true;do
	# stty -icanon min 0 time ${LOOP_TIME_OUT}			# end while ten seconds after
	echo -e "\033[36m""请确认是否继续进行! (yes or no)?""\033[0m"
	read Arg
	case $Arg in
		Y|y|YES|yes)
			select_flag=true
	  		break;;
		N|n|NO|no)
			echo -e "\033[31m用户中止安装 !!! \033[0m"
	  		exit;;
		# "")  #Autocontinue
		# 	echo -e "\033[31m用户没有确认,中止安装 !!! \033[0m"
	 #  		exit;;
	esac
done

echo -e "\n\n"
# 检查mysql用户及用户组
mysql_user_exist=`id mysql |wc -l`
if [ $mysql_user_exist -le 0 ]
then
	echo -e "\033[36m""创建 mysql 用户及用户组 !!!""\033[0m"
	useradd -d /home/mysql mysql
else
	echo -e "\033[36m""存在 mysql 用户及用户组 !!!""\033[0m"
fi

echo -e "\n\n"
# 修改limit.conf参数
mysql_limit=`cat /etc/security/limits.conf | grep -E 'mysql\s*hard\s*nofile\s*65535' |wc -l`
if [ $mysql_limit -le 0 ]
then
	echo -e "\033[36m""添加MYSQL limits 系统参数 !!!""\033[0m"
	echo -e "mysql\thard\tnofile\t65535" >> /etc/security/limits.conf 
fi

echo -e "\033[36m""[MYSQL LIMIT 配置]\n`cat /etc/security/limits.conf | grep -E 'mysql\s*hard\s*nofile\s*65535'`""\033[0m" 


# 解压
echo -e "\n\n"
echo -e "\033[36m""解压文件 ......""\033[0m" 
tar -zxf ${MYSQL_PACKAGE}

# 文件夹的名称
mysql_directory=${MYSQL_BASENAME%.tar.gz*}

# 重命名文件夹
target_mysql_base="mybase$current_mysql_version"
mv $mysql_directory ${DATA_DIR}/$target_mysql_base

# mysql 基础软件路径
MYSQL_BASE=${DATA_DIR}/$target_mysql_base

# 移除系统 my.cnf
if [ -f "/etc/my.cnf" ]
then
    echo -e "\033[31m备份系统my.cnf文件 => my.cnf.bak !!! \033[0m"
    mv /etc/my.cnf /etc/my.cnf.bak
fi

MYSQL_HOME=${DATA_DIR}/mysql/my${MYSQL_PORT}

# create mysql home
echo -e "\033[36m""MYSQL HOME路径 => ${MYSQL_HOME}""\033[0m"
mkdir -p ${MYSQL_HOME}

# 初始化MYSQL HOME
cd ${MYSQL_HOME}
ln -s ${MYSQL_BASE}/bin/ bin
ln -s ${MYSQL_BASE}/share/ share
ln -s ${MYSQL_BASE}/support-files/ support-files
ln -s ${MYSQL_BASE}/lib/ lib

mkdir -p data log run tmp 


# 修改 MYSQL_HOME 用户属性
chown -R mysql:mysql ${MYSQL_BASE}
# /data/mysql/my3306
chown -R mysql:mysql ${MYSQL_HOME}/../

# 添加 .bash_profile_mysql
function create_bash_profile_mysql()
{
    echo -e "#!/bin/sh" >> /home/mysql/.bash_profile_mysql
    echo -e "echo -e \"\\\033[36m\"\"change to mysql \${MYSQL_PORT}\"\"\\\033[0m\"" >> /home/mysql/.bash_profile_mysql
    echo -e "export MYSQL_HOME=\"${DATA_DIR}/mysql/my\${MYSQL_PORT}\"" >> /home/mysql/.bash_profile_mysql
    echo -e "export MYSQL_BASE=\"${MYSQL_BASE}\"" >> /home/mysql/.bash_profile_mysql
    echo -e "export PATH=${DATA_DIR}/mysql/my\${MYSQL_PORT}/bin:\$PATH" >> /home/mysql/.bash_profile_mysql
    echo -e "export PS1=\"[\\\e[1;34m\"'mysql_\${MYSQL_PORT}'\"\\\e[0m \"\`hostname\`\":\\\e[1;32m mysql\\\e[m \\\w\\\e[0m ]\\\n\\$ \"" >> /home/mysql/.bash_profile_mysql
    echo -e "\n"  >> /home/mysql/.bash_profile_mysql
    echo -e "alias MYSQL.START='nohup mysqld_safe > /dev/null 2>&1 & '" >> /home/mysql/.bash_profile_mysql
    echo -e "alias MYSQL.STOP='mysqladmin -uroot -p${MYSQL_ROOT_DEFAULT_PASSWD} shutdown'" >> /home/mysql/.bash_profile_mysql
}

echo -e "\033[36m""添加 .bash_profile_mysql""\033[0m"
if [ -f /home/mysql/.bash_profile_mysql ]
then
	rm -f /home/mysql/.bash_profile_mysql
fi
create_bash_profile_mysql


# 修改mysql/.bash_profile
function modify_bash_profile()
{
	echo -e "\n"  >> /home/mysql/.bash_profile
	echo -e "i=1"  >> /home/mysql/.bash_profile
	echo -e "for port in \`ls ${DATA_DIR}/mysql/ |grep '^my*'|awk -F'my' '{print \$2}'\`" >> /home/mysql/.bash_profile
	echo -e "do" >> /home/mysql/.bash_profile
	echo -e "	alias \${i}=\"MYSQL_PORT=\${port};source ~/.bash_profile_mysql;cd ${DATA_DIR}/mysql/my\${port}\"" >> /home/mysql/.bash_profile
	echo -e "	alive=\`${MYSQL_BASE}/bin/mysqladmin ping -s -S ${DATA_DIR}/mysql/my\${port}/run/mysql.\$port.sock -uroot -p${MYSQL_ROOT_DEFAULT_PASSWD} 2>/dev/null\`" >> /home/mysql/.bash_profile
	echo -e "	if [ \$? = 0 ];then" >> /home/mysql/.bash_profile
	echo -e "		alive='is alive'" >> /home/mysql/.bash_profile
	echo -e "		dblist=\`${MYSQL_BASE}/bin/mysql -N -S ${DATA_DIR}/mysql/my\${port}/run/mysql.\$port.sock -uroot -p${MYSQL_ROOT_DEFAULT_PASSWD} -e\"show databases;\" 2>/dev/null | egrep -v 'information_schema|mysql|performance_schema|test'| awk '{printf \"%s \",\$0}'\`" >> /home/mysql/.bash_profile
	echo -e "	else" >> /home/mysql/.bash_profile
	echo -e "		alive='is not alive'" >> /home/mysql/.bash_profile
	echo -e "		dblist=\"\"" >> /home/mysql/.bash_profile
	echo -e "	fi" >> /home/mysql/.bash_profile
	echo -e "	echo \"\${i} - Instance \$port \$alive - Instance DB : \$dblist\"" >> /home/mysql/.bash_profile
	echo -e "	let i=i+1" >> /home/mysql/.bash_profile
	echo -e "done" >> /home/mysql/.bash_profile
	echo -e "\n" >> /home/mysql/.bash_profile
	echo -e "echo -e \"\\\033[36m\"\"Pleas select the number go to mysql instance\"\"\\\033[0m\"" >> /home/mysql/.bash_profile
}

echo -e "\033[36m""修改 .bash_profile""\033[0m"
modify_bash_profile

chown -R mysql:mysql /home/mysql/.bash_profile_mysql


# 选择LOCAL IP地址， 用于生成 server id
# ip以逗号分隔
ip_list_str=`ifconfig -a | grep inet | grep -v 127.0.0.1 | grep -v inet6 | awk '{print $2}'|tr -d "addr:"|awk 'BEGIN{RS="\n";ORS=" ";}{print $0}'`
# 以逗号转成LIST
ip_list=(${ip_list_str//,/ })
first_ip=${ip_list[0]}

# ip to int
function ip2num()
{
    ip=$1
    a=`echo $ip | awk -F'.' '{print $1}'`
    b=`echo $ip | awk -F'.' '{print $2}'`
    c=`echo $ip | awk -F'.' '{print $3}'`
    d=`echo $ip | awk -F'.' '{print $4}'`
 
    echo "$(((d<<24)+(c<<16)+(b<<8)+a))"
}
first_ip_to_server_id=$(ip2num $first_ip)

while true;do
	echo -e "\033[36m""使用下列IP的INT值作为SERVER ID, 或自行输入Server ID [Server ID 必须是数字]; [$first_ip_to_server_id]""\033[0m"
	for(( i=0;i<${#ip_list[@]};i++)) do
		ipnum=$(ip2num ${ip_list[i]})
		echo ${ip_list[i]}" "[$ipnum]
	done;
	read Arg

	if [ ! ${Arg} ]
	then
		SERVER_ID=$first_ip_to_server_id
		break;
	else
		SERVER_ID=${Arg}
		break;
	fi
done


# my.cnf

mysql_5_config="""\n
[client]\n
port            = ${MYSQL_PORT}\n
socket          = ${MYSQL_HOME}/run/mysql.${MYSQL_PORT}.sock\n
loose-default-character-set = utf8mb4\n
\n
[mysqld]\n
skip-grant-tables\n
default-time-zone = '+08:00'\n
\n
sha256_password_private_key_path=${MYSQL_HOME}/mykey.pem\n
sha256_password_public_key_path=${MYSQL_HOME}/mykey.pub\n
\n
##large_pages\n
port            = ${MYSQL_PORT}\n 
socket          = ${MYSQL_HOME}/run/mysql.${MYSQL_PORT}.sock\n
server-id              = ${SERVER_ID}\n
character-set-server   = utf8mb4\n
default-storage-engine = InnoDB\n
lower_case_table_names = 1\n
\n
userstat = 1\n
\n
innodb_old_blocks_time = 1000\n
innodb_stats_on_metadata = off\n
log_slow_verbosity     = microtime,innodb\n

#replicate-do-db         = zabbix\n
federated\n
skip-slave-start\n
skip-name-resolve\n
skip-external-locking\n
log-slave-updates\n
slave-skip-errors       = 1062,1146\n
slave_net_timeout       = 60\n
\n
back_log                = 500\n
max_allowed_packet      = 1073741824\n
#table_cache             = 8192\n
max_connections         = 1000\n
max_connect_errors      = 500\n
\n
key_buffer_size         = 32M\n
sort_buffer_size        = 4M\n
read_buffer_size        = 2M\n
read_rnd_buffer_size    = 8M\n
join_buffer_size        = 2M\n
tmp_table_size          = 256M\n
max_heap_table_size     = 256M\n
binlog_cache_size       = 8M\n
myisam_sort_buffer_size = 64M\n
thread_cache_size       = 64\n
query_cache_type        = 0\n
\n
slow_query_log          = 1\n
slow_query_log_file     = ${MYSQL_HOME}/log/mysql-slow.log\n
long_query_time         = 1\n
log-error               = ${MYSQL_HOME}/log/mysql-error.log\n
log-bin                 = ${MYSQL_HOME}/log/mysql-bin\n
relay_log               = mysql-relay-bin\n
binlog_format           = ROW\n
tmpdir                  = ${MYSQL_HOME}/tmp\n
secure_auth        = 1\n
local-infile       = 0\n
event_scheduler    = OFF\n
\n
innodb_file_per_table    = 1\n
innodb_file_format       = barracuda\n
innodb_file_format_check = barracuda\n
innodb_open_files        = 4096\n

datadir                         = ${MYSQL_HOME}/data/\n
innodb_data_home_dir            = ${MYSQL_HOME}/data/\n
innodb_data_file_path           = ibdata1:1000M;ibdata2:1000M;ibdata3:1000M;ibdata4:100M:autoextend\n
innodb_log_group_home_dir       = ${MYSQL_HOME}/data/\n
innodb_table_locks              = 0\n
innodb_buffer_pool_size         = 1G \n
innodb_log_file_size            = 256M\n
innodb_log_files_in_group       = 2\n
innodb_log_buffer_size          = 32M\n
innodb_flush_method             = O_DIRECT\n
innodb_flush_log_at_trx_commit  = 0\n
innodb_max_dirty_pages_pct      = 60\n
innodb_write_io_threads         = 16\n
innodb_read_io_threads          = 8\n
innodb_adaptive_flushing        = 0\n
innodb_io_capacity              = 200\n
innodb_flush_neighbors          = 0\n
innodb_thread_concurrency       = 0\n  
\n
[mysqldump]\n
quick\n
max_allowed_packet = 16M\n
\n
[mysql]\n
no-auto-rehash\n
\n
[isamchk]\n
key_buffer       = 256M\n
sort_buffer_size = 256M\n
read_buffer      = 2M\n
write_buffer     = 2M\n
\n
[myisamchk]\n
key_buffer       = 256M\n
sort_buffer_size = 256M\n
read_buffer      = 2M\n
write_buffer     = 2M\n
\n
[mysqlhotcopy]\n
interactive-timeout\n
\n
[mysqld_safe]\n
malloc-lib = /usr/lib64/libjemalloc.so\n
"""


mysql_8_config="""\n
[client]\n
port            = ${MYSQL_PORT}\n
socket          = ${MYSQL_HOME}/run/mysql.3306.sock\n
loose-default-character-set = utf8mb4\n
\n
[mysqld]\n
skip-grant-tables\n
default-time-zone = '+08:00'\n
\n
sha256_password_private_key_path=${MYSQL_HOME}/mykey.pem\n
sha256_password_public_key_path=${MYSQL_HOME}/mykey.pub\n
\n
##large_pages\n
port            = ${MYSQL_PORT}\n
socket          = ${MYSQL_HOME}/run/mysql.3306.sock\n
mysqlx_socket   = ${MYSQL_HOME}/run/mysqlx.3306.sock\n
\n
server-id              = ${SERVER_ID}\n
character-set-server   = utf8mb4\n
default-storage-engine = InnoDB\n
lower_case_table_names = 1\n
\n
userstat = 1\n
\n
innodb_old_blocks_time = 1000\n
innodb_stats_on_metadata = off\n
log_slow_verbosity     = microtime,innodb\n
\n
#replicate-do-db         = zabbix \n
federated\n
skip-slave-start\n
skip-name-resolve\n
skip-external-locking\n
log-slave-updates\n
#slave-skip-error        = 1062,1146\n
slave_net_timeout       = 60\n
\n
back_log                = 500\n
max_allowed_packet      = 1073741824\n
#table_cache             = 8192\n
max_connections         = 1000\n
max_connect_errors      = 500\n
\n
#key_buffer              = 32M\n
sort_buffer_size        = 4M\n
read_buffer_size        = 2M\n
read_rnd_buffer_size    = 8M\n
join_buffer_size        = 2M\n
tmp_table_size          = 256M\n
max_heap_table_size     = 256M\n
binlog_cache_size       = 8M\n
myisam_sort_buffer_size = 64M\n
thread_cache_size       = 64\n
\n
slow_query_log          = 1\n
slow_query_log_file     = ${MYSQL_HOME}/log/mysql-slow.log\n
long_query_time         = 1\n
log-error               = ${MYSQL_HOME}/log/mysql-error.log\n
log-bin                 = ${MYSQL_HOME}/log/mysql-bin\n
relay_log               = mysql-relay-bin\n
binlog_format           = ROW\n
tmpdir                  = ${MYSQL_HOME}/tmp\n
#thread_concurrency      = 16\n
\n
local-infile       = 0\n
event_scheduler    = OFF\n
\n
#innodb_use_sys_malloc = 1\n
innodb_file_per_table    = 1\n
innodb_open_files        = 2048\n
\n
datadir                         = ${MYSQL_HOME}/data/\n
innodb_data_home_dir            = ${MYSQL_HOME}/data/\n
innodb_data_file_path           = ibdata1:1000M;ibdata2:1000M;ibdata3:1000M;ibdata4:100M:autoextend\n
innodb_log_group_home_dir       = ${MYSQL_HOME}/data/\n
innodb_table_locks              = 0\n
innodb_buffer_pool_size         = 1G \n
#innodb_additional_mem_pool_size = 16M\n
innodb_log_file_size            = 256M\n
innodb_log_files_in_group       = 2\n
innodb_log_buffer_size          = 32M\n
innodb_flush_method             = O_DIRECT\n
innodb_flush_log_at_trx_commit  = 0\n
\n
innodb_max_dirty_pages_pct      = 60\n
innodb_write_io_threads         = 16\n         
innodb_read_io_threads          = 8\n           
innodb_adaptive_flushing        = 0\n         
innodb_io_capacity              = 200\n           
innodb_flush_neighbors          = 0\n
innodb_thread_concurrency       = 0\n      
\n
[mysqldump]\n
quick\n
max_allowed_packet = 16M\n
\n
[mysql]\n
no-auto-rehash\n
\n
[isamchk]\n
key_buffer       = 256M\n
sort_buffer_size = 256M\n
read_buffer      = 2M\n
write_buffer     = 2M\n
\n
[myisamchk]\n
key_buffer       = 256M\n
sort_buffer_size = 256M\n
read_buffer      = 2M\n
write_buffer     = 2M\n
\n
[mysqlhotcopy]\n
interactive-timeout\n
\n
[mysqld_safe]\n
malloc-lib = /usr/lib64/libjemalloc.so\n

"""


if [ $current_mysql_version == 8 ]
then
	echo -e $mysql_8_config >> ${MYSQL_HOME}/my.cnf
elif [ $current_mysql_version == 5 ]
then
	echo -e $mysql_5_config >> ${MYSQL_HOME}/my.cnf
fi

chown mysql:mysql ${MYSQL_HOME}/my.cnf

# 处理 libjemalloc.so
echo -e "\033[36m""copy libjemalloc.so.1 file ......""\033[0m"
if [ ! -f /usr/lib64/libjemalloc.so ]
then
	cp ${MYSQL_BASE}/lib/mysql/libjemalloc.so.1 /usr/lib64
	cd /usr/lib64
	ln -s libjemalloc.so.1 libjemalloc.so
fi

# 生成安全验证文件
echo -e "\033[36m""create pem & pub file file ......""\033[0m"
openssl genrsa -out ${MYSQL_HOME}/mykey.pem 1024
openssl rsa -in ${MYSQL_HOME}/mykey.pem -pubout -out ${MYSQL_HOME}/mykey.pub
chmod 400 ${MYSQL_HOME}/mykey.pem
chmod 444 ${MYSQL_HOME}/mykey.pub
chown -R mysql:mysql ${MYSQL_HOME}/mykey.pem
chown -R mysql:mysql ${MYSQL_HOME}/mykey.pub


# init data
echo -e "\n"
echo -e "\033[36m""init mysql data file ......""\033[0m"
su - mysql -c "export MYSQL_PORT=${MYSQL_PORT};source ~/.bash_profile_mysql;${MYSQL_BASE}/bin/mysqld --initialize --datadir=${MYSQL_HOME}/data --user=mysql --basedir=${MYSQL_HOME}"

# finished
echo -e "\n"
echo -e "\033[36m""Mysql[Percona] install finished !!!""\033[0m"
echo -e "\n"
echo -e "\033[36m""Please reset root password \n1. flush privileges;\n2. ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '${MYSQL_ROOT_DEFAULT_PASSWD}';""\033[0m"
echo -e "\n"
echo -e "\033[36m""Mysql command:\nstart command: MYSQL.START\nstop command: MYSQL.STOP""\033[0m"

if [ $current_mysql_version == 8 ]
then
	echo -e "\033[36m""Mysql8.x 请删除 skip-grant-tables 参数, 并重启服务 [skip-grant-tables参数影响skip-networking, 禁用TCP/IP监听]""\033[0m"
fi
