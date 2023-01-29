#!/bin/sh

# 参数
# --mysql_command		MYSQL客户端路径
# --primary_host		主库IP
# --primary_port		主库PORT
# --primary_username	主库用户
# --primary_password	主库密码
# --slave_host			备库IP
# --slave_port			备库PORT
# --slave_username		备库用户
# --slave_password		备库密码

# demo: ./Percona_Mysql_Master_Slave.sh --mysql_command /data/mysql/my3306/bin/mysql --primary_host 192.168.0.9 --primary_port 3306 --primary_username shm 
# 										--primary_password shm --slave_host 192.168.0.10 --slave_port 3306 --slave_username shm --slave_password shm


echo -e "\033[36m""《Percona Mysql Master Salve GTID 部署脚本》 [Mysql 部署环境参考 Percona_Mysql_install.sh]""\033[0m\n\n"
echo -e "\033[36m""Mysql 必须开启GTID参数""\033[0m\n\n"

while [[ $# -ge 1 ]]; do
	case $1 in
		--mysql_command )
			mysql_command=$2
			shift
			;;
		--primary_host )
			primary_host=$2
			shift
			;;
		--primary_port )
			primary_port=$2
			shift
			;;
		--primary_username )
			primary_username=$2
			shift
			;;
		--primary_password )
			primary_password=$2
			shift
			;;
		--slave_host )
			slave_host=$2
			shift
			;;
		--slave_port )
			slave_port=$2
			shift
			;;
		--slave_username )
			slave_username=$2
			shift
			;;
		--slave_password )
			slave_password=$2
			shift
			;;
		* )
			shift	
			;;
	esac
done

# 参数验证
if [ ! ${mysql_command} ] || [ ! -f ${mysql_command} ]
then
    echo -e "\033[31m""mysql 客户端路径无效 ！！！""\033[0m"
    exit -1
fi

if [ ! ${primary_host} ]
then
    echo -e "\033[31m""master ip 必须指定 ！！！""\033[0m"
    exit -1
fi

if [ ! ${primary_port} ]
then
    echo -e "\033[31m""master port 必须指定 ！！！""\033[0m"
    exit -1
fi

if [ ! ${primary_username} ]
then
    echo -e "\033[31m""master username 必须指定 ！！！""\033[0m"
    exit -1
fi

if [ ! ${primary_password} ]
then
    echo -e "\033[31m""master password 必须指定 ！！！""\033[0m"
    exit -1
fi

if [ ! ${slave_host} ]
then
    echo -e "\033[31m""slave ip 必须指定 ！！！""\033[0m"
    exit -1
fi

if [ ! ${slave_port} ]
then
    echo -e "\033[31m""slave port 必须指定 ！！！""\033[0m"
    exit -1
fi

if [ ! ${slave_username} ]
then
    echo -e "\033[31m""slave username 必须指定 ！！！""\033[0m"
    exit -1
fi

if [ ! ${slave_password} ]
then
    echo -e "\033[31m""slave password 必须指定 ！！！""\033[0m"
    exit -1
fi

# 环境参数
REPLICATION_USERNAME="repl"
REPLICATION_PASSWORD="repl@fivefu.com"

# 检验MYSQL版本，为避免兼容等相关问题，主从版本要求一致

# master version
master_version=`${mysql_command} -h${primary_host} -P${primary_port} -u${primary_username} -p${primary_password} --skip-column-names -s -e "select version()" 2>/dev/null`
echo -e "\033[34m""Master Mysql version:\t${master_version}""\033[0m"

# slave version
slave_version=`${mysql_command} -h${slave_host} -P${slave_port} -u${slave_username} -p${slave_password} --skip-column-names -s -e "select version()" 2>/dev/null`
echo -e "\033[34m""Slave Mysql version:\t${slave_version}""\033[0m"

# 人为介入确认继续建设
# while true;do
# 	echo -e "\033[34m""请确认 Master and Slave 版本 ! (yes or no)?""\033[0m"
# 	read Arg
# 	case $Arg in
# 		Y|y|YES|yes)
# 	  		break;;
# 		N|n|NO|no)
# 			echo -e "\033[31m用户中止部署 !!! \033[0m"
# 	  		exit;;
# 		"")  #Autocontinue
# 			echo -e "\033[31m用户没有确认,中止部署 !!! \033[0m"
# 	  		exit;;
# 	esac
# done

if [ ${master_version} != ${slave_version} ]
then
	echo -e "\033[31m""Master Slave 版本不同, 中止部署 ！！！""\033[0m"
	exit -1
fi

echo -e "\n"

# 确认主从的配置环境
# server_id, log-bin, binlog-format
master_serverid=`${mysql_command} -h${primary_host} -P${primary_port} -u${primary_username} -p${primary_password} --skip-column-names -s -e "show variables like 'server_id'" 2>/dev/null | awk '{print $2}'`
echo -e "\033[34m""Master Mysql server_id [${master_serverid}]""\033[0m"

master_log_bin=`${mysql_command} -h${primary_host} -P${primary_port} -u${primary_username} -p${primary_password} --skip-column-names -s -e "show variables like 'log_bin'" 2>/dev/null | awk '{print $2}'`
echo -e "\033[34m""Master Mysql log_bin [${master_log_bin}]""\033[0m"

master_binlog_format=`${mysql_command} -h${primary_host} -P${primary_port} -u${primary_username} -p${primary_password} --skip-column-names -s -e "show variables like 'binlog_format'" 2>/dev/null | awk '{print $2}'`
echo -e "\033[34m""Master Mysql log_bin [${master_binlog_format}]""\033[0m"

master_gtid_mode=`${mysql_command} -h${primary_host} -P${primary_port} -u${primary_username} -p${primary_password} --skip-column-names -s -e "show variables like 'gtid_mode'" 2>/dev/null | awk '{print $2}'`
echo -e "\033[34m""Master Mysql gtid_mode [${master_gtid_mode}]""\033[0m"

master_enforce_gtid_consistency=`${mysql_command} -h${primary_host} -P${primary_port} -u${primary_username} -p${primary_password} --skip-column-names -s -e "show variables like 'enforce_gtid_consistency'" 2>/dev/null | awk '{print $2}'`
echo -e "\033[34m""Master Mysql enforce_gtid_consistency [${master_enforce_gtid_consistency}]""\033[0m"

master_log_slave_updates=`${mysql_command} -h${primary_host} -P${primary_port} -u${primary_username} -p${primary_password} --skip-column-names -s -e "show variables like 'log_slave_updates'" 2>/dev/null | awk '{print $2}'`
echo -e "\033[34m""Master Mysql log_slave_updates [${master_log_slave_updates}]""\033[0m"

echo -e "\n"

slave_serverid=`${mysql_command} -h${slave_host} -P${slave_port} -u${slave_username} -p${slave_password} --skip-column-names -s -e "show variables like 'server_id'" 2>/dev/null | awk '{print $2}'`
echo -e "\033[34m""Slave Mysql server_id [${slave_serverid}]""\033[0m"

slave_log_bin=`${mysql_command} -h${slave_host} -P${slave_port} -u${slave_username} -p${slave_password} --skip-column-names -s -e "show variables like 'log_bin'" 2>/dev/null | awk '{print $2}'`
echo -e "\033[34m""Slave Mysql server_id [${slave_log_bin}]""\033[0m"

slave_binlog_format=`${mysql_command} -h${slave_host} -P${slave_port} -u${slave_username} -p${slave_password} --skip-column-names -s -e "show variables like 'binlog_format'" 2>/dev/null | awk '{print $2}'`
echo -e "\033[34m""Slave Mysql server_id [${slave_binlog_format}]""\033[0m"

slave_gtid_mode=`${mysql_command} -h${slave_host} -P${slave_port} -u${slave_username} -p${slave_password} --skip-column-names -s -e "show variables like 'gtid_mode'" 2>/dev/null | awk '{print $2}'`
echo -e "\033[34m""Slave Mysql gtid_mode [${slave_gtid_mode}]""\033[0m"

slave_enforce_gtid_consistency=`${mysql_command} -h${slave_host} -P${slave_port} -u${slave_username} -p${slave_password} --skip-column-names -s -e "show variables like 'enforce_gtid_consistency'" 2>/dev/null | awk '{print $2}'`
echo -e "\033[34m""Slave Mysql enforce_gtid_consistency [${slave_enforce_gtid_consistency}]""\033[0m"

slave_log_slave_updates=`${mysql_command} -h${slave_host} -P${slave_port} -u${slave_username} -p${slave_password} --skip-column-names -s -e "show variables like 'log_slave_updates'" 2>/dev/null | awk '{print $2}'`
echo -e "\033[34m""Slave Mysql log_slave_updates [${slave_log_slave_updates}]""\033[0m"

echo -e "\n"

if [ ${master_serverid} == ${slave_serverid} ]
then
	echo -e "\033[31m""Master Slave 版本不同, 中止部署 ！！！""\033[0m"
	exit -1
fi

if [ ${master_log_bin} != "ON" ]
then
	echo -e "\033[31m""Master binlog 需要开启, 中止部署 ！！！""\033[0m"
	exit -1
fi

if [ ${slave_log_bin} != "ON" ]
then
	echo -e "\033[31m""Slave binlog 需要开启, 中止部署 ！！！""\033[0m"
	exit -1
fi

if [ ${master_binlog_format} != "ROW" ]
then
	echo -e "\033[31m""Master binlog format 配置为ROW, 中止部署 ！！！""\033[0m"
	exit -1
fi

if [ ${slave_binlog_format} != "ROW" ]
then
	echo -e "\033[31m""Slave binlog format 配置为ROW, 中止部署 ！！！""\033[0m"
	exit -1
fi

if [ ${master_gtid_mode} != "ON" ]
then
	echo -e "\033[31m""Master gtid_mode 必须开启, 中止部署 ！！！""\033[0m"
	exit -1
fi

if [ ${slave_gtid_mode} != "ON" ]
then
	echo -e "\033[31m""Slave gtid_mode 必须开启, 中止部署 ！！！""\033[0m"
	exit -1
fi

if [ ${master_enforce_gtid_consistency} != "ON" ]
then
	echo -e "\033[31m""Master master_enforce_gtid_consistency 必须开启, 中止部署 ！！！""\033[0m"
	exit -1
fi

if [ ${slave_enforce_gtid_consistency} != "ON" ]
then
	echo -e "\033[31m""Slave master_enforce_gtid_consistency 必须开启, 中止部署 ！！！""\033[0m"
	exit -1
fi

if [ ${master_log_slave_updates} != "ON" ]
then
	echo -e "\033[31m""Master log_slave_updates 必须开启, 中止部署 ！！！""\033[0m"
	exit -1
fi

if [ ${slave_log_slave_updates} != "ON" ]
then
	echo -e "\033[31m""Slave log_slave_updates 必须开启, 中止部署 ！！！""\033[0m"
	exit -1
fi

echo -e "\n"

# MASTER上确认复制帐号是否存在
echo -e "\033[34m""确认复制帐号是否存在 ...... [${REPLICATION_USERNAME}] ！！！""\033[0m"
repl_user=`${mysql_command} -h${primary_host} -P${primary_port} -u${primary_username} -p${primary_password} --skip-column-names -s -e "select count(*) from mysql.user where host='%' and user='${REPLICATION_USERNAME}'" 2>/dev/null`

if [ ${repl_user} -gt 0 ]
then
	echo -e "\033[34m""复制帐号已存在 [${REPLICATION_USERNAME}] ！！！""\033[0m"
else
	create_user="${mysql_command} -h${primary_host} -P${primary_port} -u${primary_username} -p${primary_password} --skip-column-names -s -e \"create user '${REPLICATION_USERNAME}'@'%' identified with mysql_native_password by '${REPLICATION_PASSWORD}'\""
	echo -e "\033[34m""创建复制帐号命令 [${create_user}] ！！！""\033[0m"
	eval ${create_user}
	`${mysql_command} -h${primary_host} -P${primary_port} -u${primary_username} -p${primary_password} --skip-column-names -s -e "flush privileges" 2>/dev/null`
	echo -e "\033[34m""创建复制帐号 [${REPLICATION_USERNAME}] ！！！""\033[0m"
fi 

echo -e "\n"

# 确认复制帐号权限
echo -e "\033[34m""确认复制帐号权限 ...... [REPLICATION SLAVE] ！！！""\033[0m"
repl_user_priv=`${mysql_command} -h${primary_host} -P${primary_port} -u${primary_username} -p${primary_password} --skip-column-names -s -e "select count(*) from information_schema.USER_PRIVILEGES where grantee='\'${REPLICATION_USERNAME}\'@\'%\'' and privilege_type='REPLICATION SLAVE'" 2>/dev/null`

if [ ${repl_user_priv} -gt 0 ]
then
	echo -e "\033[34m""复制帐号权限已存在 [REPLICATION SLAVE] ！！！""\033[0m"
else
	create_priv="${mysql_command} -h${primary_host} -P${primary_port} -u${primary_username} -p${primary_password} --skip-column-names -s -e \"GRANT replication slave ON *.* TO '${REPLICATION_USERNAME}'@'%'\""
	echo -e "\033[34m""创建复制帐号权限 [${create_priv}] ！！！""\033[0m"
	# eval ${create_priv}
	`${mysql_command} -h${primary_host} -P${primary_port} -u${primary_username} -p${primary_password} --skip-column-names -s -e "GRANT replication slave ON *.* TO '${REPLICATION_USERNAME}'@'%'"`
	`${mysql_command} -h${primary_host} -P${primary_port} -u${primary_username} -p${primary_password} --skip-column-names -s -e "flush privileges" 2>/dev/null`
	echo -e "\033[34m""复制帐号权限创建完成 [REPLICATION SLAVE] ！！！""\033[0m"
fi 

echo -e "\n"

# 配置主从链接 

change_config="${mysql_command} -h${slave_host} -P${slave_port} -u${slave_username} -p${slave_password} --skip-column-names -s -e \"change master to master_host='${primary_host}', master_user='${REPLICATION_USERNAME}', master_password='${REPLICATION_PASSWORD}', master_port=${primary_port}, master_auto_position = 1;\""
echo -e "\033[34m""配置主从链接 ...... [${change_config}]""\033[0m"
eval ${change_config}

echo -e "\n"

# 启动SLAVE
echo -e "\033[34m""启动SLAVE ......""\033[0m"
`${mysql_command} -h${slave_host} -P${slave_port} -u${slave_username} -p${slave_password} --skip-column-names -s -e "start slave"`

echo -e "\n"

# 显示 SLAVE 状态
echo -e "\033[34m""SLAVE STATUS ......""\033[0m"
slave_status="${mysql_command} -h${slave_host} -P${slave_port} -u${slave_username} -p${slave_password} -e \"show slave status \\G\""
eval ${slave_status}

echo -e "\033[34m""完成 ！！！""\033[0m"
