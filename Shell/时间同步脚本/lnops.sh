#!/bin/bash -x

cd /root/ln

##值班人员，每周一8：30 变更值班人员.
##如果有人员变动，修改下面的信息就可以了
LUSER1=13817414626  #王春
LUSER2=13916482337  #孙天伟
LUSER3=18916337316  #邵春生
LUSER4=13428879753  #李辉
LUSER5=13052283372  #张磊
LUSER6=17766442326  #刘成龙
# LUSER7=15900652268  #黄李涛
LUSER7=13321949911  #姜磊
LUSER8=15026671706  #杨章铭



##时间
TIME=`date +"%Y-%m-%d %H:%M:%S"`
WEEKDAY=`date +"%u"`




#发送人员缓存
if [ ! -e SMSUSER ];then
	echo 1>SMSUSER
fi

SMSNU=`cat SMSUSER`

if [ "$WEEKDAY" -eq 1 ];then
	SMSNU=$[SMSNU+1]
	if [ $SMSNU -gt 8 ];then
		SMSNU=1
        fi

	echo $SMSNU>SMSUSER
fi
LUSER=`eval echo '$'"LUSER$SMSNU"`

#PING 检查
function PING(){
	if ! ping -c 3 $1>/dev/null;then
		echo "fail"
	else
	        echo "ok"
	fi
}

#服务检查

function TELNET(){
	telnet $1 $2 <<EOF
	 quit
EOF
}

#发送短信
function SMS(){
	xml='<?xml version="1.0" encoding="utf-8"?><soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"><soap:Body><SendMessage xmlns="http://tempuri.org/"><phoneNo>13816936959,'$LUSER'</phoneNo><companyCode>string</companyCode><userName>IT_WARN</userName><password>123456</password><timeMsg>string</timeMsg><message>'$1'</message></SendMessage></soap:Body></soap:Envelope>'
	echo $xml |curl --header "Content-Type: text/xml;charset=UTF-8" --header 'SOAPAction:' --data @- http://BEEP.NIPPONPAINT.COM.CN/MsgService/MsgService1069.asmx?op=SendMessage
}

#监控网络连通性
if PING 172.31.11.35 |grep fail>/dev/null;then
	SMS "172.31.11.35 必梵监控服务器PING 不通"
        exit
fi
		
if PING 172.31.11.36 |grep fail>/dev/null;then
	SMS "172.31.11.36 必梵监控服务器PING 不通"
        exit
fi

if PING 172.31.11.37 |grep fail>/dev/null;then
	SMS "172.31.11.37 必梵监控服务器PING 不通"
        exit
fi

#检查服务状态
if ! TELNET 172.31.11.35 80 |grep Connected >/dev/null;then
	SMS "172.31.11.35 必梵服务异常，请及时修复"
	exit
fi


if ! TELNET 172.31.11.37 9200 |grep Connected >/dev/null;then
	SMS "172.31.11.37 必梵监控服务异常，请及时修复"
	exit
fi


if ! TELNET 172.31.11.37 3306 |grep Connected >/dev/null;then
	SMS "172.31.11.37 必梵监控服务异常，请及时修复"
	exit
fi

SMS "$TIME 必梵监控服务检查正常。"

