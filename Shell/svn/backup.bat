echo off
rem ���а汾��ĸ�Ŀ¼
set SVN_ROOT=D:\svn_repositories
rem ���ݵ�Ŀ¼
set BACKUP_SVN_ROOT=D:\SVNbackup
set BACKUP_DIRECTORY=%BACKUP_SVN_ROOT%/%date:~0,10%
if exist %BACKUP_DIRECTORY% goto checkBack
echo ��������Ŀ¼%BACKUP_DIRECTORY%>>%SVN_ROOT%/backup.log
mkdir %BACKUP_DIRECTORY%
rem ��֤Ŀ¼�Ƿ�Ϊ�汾�⣬�������ȡ�����Ʊ���
for /r %SVN_ROOT% %%I in (.) do @if exist "%%I/conf/svnserve.conf" %SVN_ROOT%/simplebackup.bat "%%~fI" %%~nI
goto end
:checkBack
echo ����Ŀ¼%BACKUP_DIRECTORY%�Ѿ����ڣ�����ա�
goto end
:end