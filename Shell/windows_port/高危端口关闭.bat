%1 mshta vbscript:CreateObject("Shell.Application").ShellExecute("cmd.exe","/c %~s0 ::","","runas",1)(window.close)&&exit
@echo off 
color 1f 
title �ر�135 445 �˿�
echo. 
echo. 
echo. 
echo ���ڹر�135-139�˿� ���Ժ� 
netsh advfirewall firewall add rule name = "Disable port 135 - TCP" dir = in action = block protocol = TCP localport = 135,136,137,138,139
echo. 
netsh advfirewall firewall add rule name = "Disable port 135 - UDP" dir = in action = block protocol = UDP localport = 135,136,137,138,139
echo. 
echo ���ڹر�445�˿� ���Ժ� 
netsh advfirewall firewall add rule name = "Disable port 445 - TCP" dir = in action = block protocol = TCP localport = 445
echo. 
netsh advfirewall firewall add rule name = "Disable port 445 - UDP" dir = in action = block protocol = UDP localport = 445
echo.
echo ��������˳� 
pause>nul
