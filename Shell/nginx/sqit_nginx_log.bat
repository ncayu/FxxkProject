@echo off
rem @echo off 
rem ȡ1��֮ǰ������
echo wscript.echo dateadd("d",-1,date) >%tmp%\tmp.vbs 
for /f "tokens=1,2,3* delims=/" %%i in ('cscript /nologo %tmp%\tmp.vbs') do set y=%%i
for /f "tokens=1,2,3* delims=/" %%i in ('cscript /nologo %tmp%\tmp.vbs') do set m=%%j
for /f "tokens=1,2,3* delims=/" %%i in ('cscript /nologo %tmp%\tmp.vbs') do set d=%%k
if %m% LSS 9 set m=0%m%
if %d% LSS 9 set d=0%d%
echo %y%-%m%-%d%
 
rem ���� Nginx λ�ڵ��̷�
set NGINX_DRIVER=D:
rem ���� Nginx ����Ŀ¼
set NGINX_PATH=%NGINX_DRIVER%\nginx_1.13.5
rem ���� Nginx ����־Ŀ¼
set LOG_PATH=%NGINX_PATH%\logs
rem �ƶ��ļ�
move %LOG_PATH%\access.log %LOG_PATH%\access_%y%-%m%-%d%.log
move %LOG_PATH%\error.log %LOG_PATH%\error_%y%-%m%-%d%.log
rem �л��� Nginx ���ڵ��̷�
%NGINX_DRIVER%
rem ���� Nginx ����Ŀ¼
cd %NGINX_PATH%
rem �� nginx ���� reopen �ź������´���־�ļ��������� Linux ƽ̨�е� kill -USR1 һ��
nginx -s reopen
