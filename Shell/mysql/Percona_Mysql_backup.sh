#!/bin/sh

# demo: ./Percona_Mysql_backup.sh --mysqldump_command /data/mybase8/bin/mysqldump --host 192.168.0.9 --port 3306 --username shm --password shm --databases "confluence shm_test" --output /data/mysql/my3306/tmp/
# 多个数据库用双引号包括，且用空格分隔
echo -e "\033[36m""《Percona Mysql 备份脚本》""\033[0m\n\n"

while [[ $# -ge 1 ]]; do
    case $1 in
        --mysqldump_command )
            MYSQLDUMP_PATH=$2
            shift
            ;;
        --host )
            MYSQL_HOST=$2
            shift
            ;;
        --port )
            MYSQL_PORT=$2
            shift
            ;;
        --username )
            MYSQL_USERNAME=$2
            shift
            ;;
        --password )
            MYSQL_PASSWD=$2
            shift
            ;;
        --databases )
            DATABASES=$2
            shift
            ;;
        --output )
            OUTPUT_PATH=$2
            shift
            ;;
        * )
            shift   
            ;;
    esac
done

# 参数验证
if [ ! ${MYSQLDUMP_PATH} ] || [ ! -f ${MYSQLDUMP_PATH} ]
then
    echo -e "\033[31m""mysqldump 命令参数无效 ！！！""\033[0m"
    exit -1
fi

if [ ! ${MYSQL_HOST} ]
then
    echo -e "\033[31m""host 必须指定 ！！！""\033[0m"
    exit -1
fi

if [ ! ${MYSQL_PORT} ]
then
    echo -e "\033[31m""port 没有指定，默认为 3306 ！！！""\033[0m"
    MYSQL_PORT=3306
fi

if [ ! ${MYSQL_USERNAME} ]
then
    echo -e "\033[31m""username 必须指定 ！！！""\033[0m"
    exit -1
fi

if [ ! ${MYSQL_PASSWD} ]
then
    echo -e "\033[31m""password 必须指定 ！！！""\033[0m"
    exit -1
fi

if [ ! ${DATABASES} ]
then
    echo -e "\033[31m""databases 没有指定, 默认全备 ！！！""\033[0m"
    DATABASES=""
fi

if [ ! ${OUTPUT_PATH} ]
then
    echo -e "\033[31m""output 备份路径必须指定 ！！！""\033[0m"
    exit -1
fi

if [ ! ${FILE_PRE_STRING} ]
then
    FILE_PRE_STRING="MYBACK"
fi

echo -e "\n"

current_time=`date +%Y%m%d%H%M%S`

# 检查 /data 目录是否存在；目录需要用户创建
# if [ ! -f ${MYSQLDUMP_PATH} ]
# then
#     echo -e "\033[34m""mysqldump 命令路径:""\033[0m"  
#     ls -l /data/mybase*/bin/mysqldump | awk '{print $9}'

#     echo -e "\n\n"

#     while true;do
# 		echo -e "\033[34m""请输入mysqldump路径:""\033[0m"  
# 		read Arg

# 		if [ ${Arg} ] && [ -f ${Arg} ]
# 		then
# 			MYSQLDUMP_PATH=${Arg}
# 			break;
# 		fi
# 	done
# fi

# mysqldump 版本确认
echo -e "\033[34m""mysqldump 版本:""\033[0m"
${MYSQLDUMP_PATH} --version

echo -e "\n\n"

BACKUP_FILENAME="${FILE_PRE_STRING}_${MYSQL_HOST}_${MYSQL_PORT}_${current_time}.SQL.gz"
BACKUP_PATH="${OUTPUT_PATH}/${BACKUP_FILENAME}"

# --set-gtid-purged=off 不添加此参数，影响恢复slave
if [ ! ${DATABASES} ]
then
    mysql_dump_command="${MYSQLDUMP_PATH} -h ${MYSQL_HOST} -P${MYSQL_PORT} -u${MYSQL_USERNAME} -p${MYSQL_PASSWD} --single-transaction --master-data=2 --all-databases -C | gzip > ${BACKUP_PATH}"
else
    mysql_dump_command="${MYSQLDUMP_PATH} -h ${MYSQL_HOST} -P${MYSQL_PORT} -u${MYSQL_USERNAME} -p${MYSQL_PASSWD} --single-transaction --master-data=2 --databases ${DATABASES} -C | gzip > ${BACKUP_PATH}"
fi
# mysql_dump_command="${MYSQLDUMP_PATH} -h ${MYSQL_HOST} -P${MYSQL_PORT} -u${MYSQL_USERNAME} -p${MYSQL_PASSWD} --single-transaction --master-data=2 --all-databases -C | gzip > ${BACKUP_PATH}"
echo -e "\033[34m""开始备份 ...... [${mysql_dump_command}]""\033[0m"
eval ${mysql_dump_command}

echo -e "\033[34m""备份完成 ！！！""\033[0m"
