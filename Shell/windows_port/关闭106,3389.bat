%1 mshta vbscript:CreateObject("Shell.Application").ShellExecute("cmd.exe","/c %~s0 ::","","runas",1)(window.close)&&exit
@echo off 
color 1f 
title �ر�106 3389 �˿�
echo. 
echo. 
echo. 
echo ���ڹر�106�˿� ���Ժ� 
netsh advfirewall firewall add rule name = "Disable port 106 - TCP" dir = in action = block protocol = TCP localport = 106
echo. 
netsh advfirewall firewall add rule name = "Disable port 106 - UDP" dir = in action = block protocol = UDP localport = 106
echo. 
echo ���ڹر�3389�˿� ���Ժ� 
netsh advfirewall firewall add rule name = "Disable port 3389 - TCP" dir = in action = block protocol = TCP localport = 3389
echo. 
netsh advfirewall firewall add rule name = "Disable port 3389 - UDP" dir = in action = block protocol = UDP localport = 3389
echo.
echo ��������˳� 
pause>nul
