#!/bin/sh

# 参数
# --mysql_command		MYSQL客户端路径
# --host				IP
# --port				PORT
# --username			用户
# --password			密码
# --retain_number		保留binlog文件的数量 int

# demo: ./Percona_Mysql_Purge_Binlog.sh --mysql_command /data/mysql/my3306/bin/mysql --host 192.168.0.9 --port 3306 --username shm 
# 										--password shm --retain_number 10

echo -e "\033[36m""《Percona Mysql 清除 Binlog 维护脚本》 [Mysql 部署环境参考 Percona_Mysql_install.sh]""\033[0m\n\n"

while [[ $# -ge 1 ]]; do
	case $1 in
		--mysql_command )
			mysql_command=$2
			shift
			;;
		--host )
			host=$2
			shift
			;;
		--port )
			port=$2
			shift
			;;
		--username )
			username=$2
			shift
			;;
		--password )
			password=$2
			shift
			;;
		--retain_number )
			retain_number=$2
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

if [ ! ${host} ]
then
    echo -e "\033[31m""host 必须指定 ！！！""\033[0m"
    exit -1
fi

if [ ! ${port} ]
then
    echo -e "\033[31m""port 没有指定，默认为 3306 ！！！""\033[0m"
    port=3306
fi

if [ ! ${username} ]
then
    echo -e "\033[31m""username 必须指定 ！！！""\033[0m"
    exit -1
fi

if [ ! ${password} ]
then
    echo -e "\033[31m""password 必须指定 ！！！""\033[0m"
    exit -1
fi

if [ ! ${retain_number} ]
then
    echo -e "\033[31m""retain_number 没有指定, 默认为 10 ！！！""\033[0m"
    retain_number=10
fi

echo -e "\n"

# binlog 列表
echo -e "\033[34m""Binlog 数据列表: ""\033[0m"
${mysql_command} -h${host} -P${port} -u${username} -p${password} -e "show binary logs"

binlog_list_str=`${mysql_command} -h${host} -P${port} -u${username} -p${password} --skip-column-names -s -e "show binary logs" 2>&1 | grep -v "Warning" | awk '{print $1}'`

binlog_list=(${binlog_list_str// / })

binlog_exist_num=${#binlog_list[@]}

if [ ${binlog_exist_num} -gt ${retain_number} ]
then
	# 存在的binlog数量 > 需要保留的数量; 才需要清理
	# for i in ${binlog_list[*]}; do
	# 	echo $i
	# done

	binlog_point=`expr ${binlog_exist_num} - ${retain_number}`		# 定位到purge的索引位置
	echo -e "\n"
	echo -e "\033[34m""mysql purge binlog index file ......""\033[0m"
	echo ${binlog_list[${binlog_point}]}

	purge_command="${mysql_command} -h${host} -P${port} -u${username} -p${password} -e 'purge binary logs to \"${binlog_list[${binlog_point}]}\"'"
	echo -e "\033[34m""清除Binlog记录 ...... [${purge_command}]""\033[0m"
	eval ${purge_command}

else
	echo -e "\033[34m""存在的binlog数量未达到保留数量 ！！！""\033[0m"
fi

echo -e "\033[34m""完成 ！！！""\033[0m"
