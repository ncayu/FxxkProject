w32tm /config /manualpeerlist:3.cn.pool.ntp.org,0x8 /syncfromflags:MANUAL
net stop w32time
net start w32time
w32tm /resync
