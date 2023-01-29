echo off
rem Subversion的安装目录  
set SVN_HOME="C:\Program Files\VisualSVN Server"

rem 所有版本库的父目录  
set SVN_ROOT=D:\svn_repositories
rem 备份的目录  
set BACKUP_SVN_ROOT=D:\svnbak

rem 创建存放版本库的临时目录  
set BACKUP_DIRECTORY=%BACKUP_SVN_ROOT%\%date:~0,10%
if exist %BACKUP_DIRECTORY% goto checkBack  
echo %date:~0,10% %time:~0,-3% : 建立备份目录%BACKUP_DIRECTORY%>>%SVN_ROOT%/backup.log

rem 创建备份目录  
md %BACKUP_DIRECTORY%

rem 验证目录是否为版本库，如果是则取出名称备份  
for /r %SVN_ROOT% %%I in (.) do @if exist "%%I\conf\svnserve.conf" call %SVN_ROOT%\win_svn_Backup.bat "%%~fI" %%~nI  
echo 开始压缩版本库，请不要中止....  

%SVN_ROOT%\7z.exe a -tzip %BACKUP_SVN_ROOT%\%date:~0,10%.zip %BACKUP_DIRECTORY%\* -r >nul 
echo 版本库压缩完成!  