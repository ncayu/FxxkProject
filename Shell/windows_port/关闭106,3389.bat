%1 mshta vbscript:CreateObject("Shell.Application").ShellExecute("cmd.exe","/c %~s0 ::","","runas",1)(window.close)&&exit
@echo off 
color 1f 
title 关闭106 3389 端口
echo. 
echo. 
echo. 
echo 正在关闭106端口 请稍候… 
netsh advfirewall firewall add rule name = "Disable port 106 - TCP" dir = in action = block protocol = TCP localport = 106
echo. 
netsh advfirewall firewall add rule name = "Disable port 106 - UDP" dir = in action = block protocol = UDP localport = 106
echo. 
echo 正在关闭3389端口 请稍候… 
netsh advfirewall firewall add rule name = "Disable port 3389 - TCP" dir = in action = block protocol = TCP localport = 3389
echo. 
netsh advfirewall firewall add rule name = "Disable port 3389 - UDP" dir = in action = block protocol = UDP localport = 3389
echo.
echo 按任意键退出 
pause>nul
