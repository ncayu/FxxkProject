#!/bin/bash
echo '=====开始进行代理人跑手机号实名制校验===='

url="https://mit-gateway-sit.livit.run/app/order/info/mobileAuth"
echo "请求url:"$url""

function get_json(){
  echo "${1//\"/}" | sed "s/.*$2:\([^,}]*\).*/\1/"
}

check(){
	local INIT_BODY=$(cat<< EOF
{ 
"name": "王大锤",
"mobile": "15874689999"
}
EOF
)

echo "$INIT_BODY"
	
value=$(curl ${url} -H "Accept: application/json" -H "Content-Type: application/json" -d "$INIT_BODY")
#value= curl ${url} -H "Accept: application/json" -H "Content-Type: application/json" -d "$INIT_BODY"
echo '+++++++++++++++++++++++++++++++++'
echo $value
echo '+++++++++++++++++++++++++++++++++'
vars=`echo $value | awk -F '"msg":' '{print substr($1,10,3)}'`
echo '+++++++++++++++++++++++++++++++++'
echo 请求的状态码为：$vars
if [ "$vars" == "200" ]; then
	echo "姓名"$1"手机号"$2"校验成功"
else
	echo "姓名"$1"手机号"$2"校验失败"
fi
}

mysql="mysql -h 192.168.114.2 -P 3306 -u mitbroker -pGfKxR55sAXlPsYcV -D mitbroker"
#mysql="mysql -h localhost -P 3306 -u root -pfivefu -D mitbroker"
mobilesql="select b.mobile from app_customer a INNER JOIN agent b on a.agent_code = b.agent_code where a.del_flag = 0 order by a.id;"
namesql="select b.name from app_customer a INNER JOIN agent b on a.agent_code = b.agent_code where a.del_flag = 0 order by a.id;"
mobilearray=($($mysql -e "$mobilesql"))
namearray=($($mysql -e "$namesql"))

mobilelength=${#mobilearray[@]}
echo "手机号数组长度$mobilelength"

for(( i=1;i<2;i++)) do
	check ${mobilearray[i]} ${namearray[i]}
done;

sleep 5
