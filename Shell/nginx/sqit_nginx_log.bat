@echo off
rem @echo off 
rem 取1天之前的日期
echo wscript.echo dateadd("d",-1,date) >%tmp%\tmp.vbs 
for /f "tokens=1,2,3* delims=/" %%i in ('cscript /nologo %tmp%\tmp.vbs') do set y=%%i
for /f "tokens=1,2,3* delims=/" %%i in ('cscript /nologo %tmp%\tmp.vbs') do set m=%%j
for /f "tokens=1,2,3* delims=/" %%i in ('cscript /nologo %tmp%\tmp.vbs') do set d=%%k
if %m% LSS 9 set m=0%m%
if %d% LSS 9 set d=0%d%
echo %y%-%m%-%d%
 
rem 设置 Nginx 位于的盘符
set NGINX_DRIVER=D:
rem 设置 Nginx 的主目录
set NGINX_PATH=%NGINX_DRIVER%\nginx_1.13.5
rem 设置 Nginx 的日志目录
set LOG_PATH=%NGINX_PATH%\logs
rem 移动文件
move %LOG_PATH%\access.log %LOG_PATH%\access_%y%-%m%-%d%.log
move %LOG_PATH%\error.log %LOG_PATH%\error_%y%-%m%-%d%.log
rem 切换到 Nginx 所在的盘符
%NGINX_DRIVER%
rem 进入 Nginx 的主目录
cd %NGINX_PATH%
rem 向 nginx 发送 reopen 信号以重新打开日志文件，功能与 Linux 平台中的 kill -USR1 一致
nginx -s reopen
