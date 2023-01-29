REM ###########################################################
REM # Windows  Oracle���ݿ��Զ�����������ű�
REM ###########################################################

REM ȡ��ǰϵͳʱ��,���������ϵͳ��ͬ��ȡֵ��һ��

set CURDATE=%date:~0,4%%date:~5,2%%date:~8,2%
set CURTIME=%time:~0,2%

rem ���ñ���·��
set SrcDir=D:/backup
rem �����ļ���������
set DaysAgo=7
rem /pָ�������ļ���·��  /s ����Ŀ¼������  /m ָ����ʽ��Ĭ��Ϊ*.*   /d  ѡ�����ڣ�+���� - С�ڣ�   /c ָ��ִ�е�����   del /f ǿ��ɾ��  /q ��ѯ���Ƿ�ɾ��   /a ��ָ������ɾ��
forfiles /p %SrcDir% /s /m *.DMP /d -%DaysAgo% /c "cmd /c del /f /q /a @path"
 

REM Сʱ�����С��10������ǰ�油0
if "%CURTIME%"==" 0" set CURTIME=00
if "%CURTIME%"==" 1" set CURTIME=01
if "%CURTIME%"==" 2" set CURTIME=02
if "%CURTIME%"==" 3" set CURTIME=03
if "%CURTIME%"==" 4" set CURTIME=04
if "%CURTIME%"==" 5" set CURTIME=05
if "%CURTIME%"==" 6" set CURTIME=06
if "%CURTIME%"==" 7" set CURTIME=07
if "%CURTIME%"==" 8" set CURTIME=08
if "%CURTIME%"==" 9" set CURTIME=09

set CURTIME=%CURTIME%%time:~3,2%%time:~6,2%

REM ���������ߡ��û���������
set OWNER=ncayu

set USER=ncayu

set PASSWORD=ncayu@123456
set PREFIX=changsha

REM ����������Ŀ¼��Ŀ¼�ṹΪbackup/YYYYMMDD/
if not exist "%CURDATE%"     mkdir %CURDATE%

set CURDIR=%CURDATE%
set FILENAME=%SrcDir%/%PREFIX%_%CURDATE%_%CURTIME%.DMP
set FILENAME=%SrcDir%/%PREFIX%_%CURDATE%.DMP
set EXPLOG=%CURDIR%/%PREFIX%_%CURDATE%_%CURTIME%_log.log
set NLS_LANG=AMERICAN_AMERICA.AL32UTF8

REM ����ORACLE��exp������û�����
#set nls_lang=AMERICAN_AMERICA.ZHS16GBK
exp %USER%/%PASSWORD%@orcl file=%FILENAME% log=%EXPLOG%   compress=yes grants=yes indexes=yes triggers=yes rows=yes constraints=yes tables=(ZT_CLWZ,ZM_DG,ZM_LDSJ,GX_WHYHCD,GX_WHYHCS,HW_HWCL,HW_HWGR,HW_HWGC,HW_LJZYZ,HW_LJCZZD,HW_LJFLSD,HWDT_CLWZ,XZZF_ZFQLSX,XZZF_RYZZJG,XZZF_CLK,XZZF_SYAY,XZZF_FLFG,GGZXC_ZD,GGZXC_JCXX,SR_MQSB,SR_BMD,SZ_DL,SZ_QL,SZCG_GD,DB_EVENT,TCGL_TCD,TCGL_QYBM,XZSP_SPSXSX,XZSP_XZXKSP,ZT_YSQY,ZT_YSCL,ZT_YSSJ,ZT_JZGD,ZT_ZTZSP,ZT_XND,DB_METADATA,DB_SYSADMIN,DB_ROLE,DB_PERMISSION_DATA,DB_PERMISSION_HOUTAI,ZF_LEGISLATIONRULE,ZF_LEGISLATIONITEM,ZF_LEGISLATION,ZF_DOCUMENT,ZF_LEGISLATIONGIST,ZM_LDSC,HWDT_LJDT,HWDT_HWKH,GG_GGSP,GG_DAOLU,JDKH_GQJDKH,JDKH_MONTHKH,JDKH_BMSZCGJXKH,XZZF_AJ,XZZF_WTAJ,XZZF_ZFGC,XZZF_AJBLXX,GGZXC_YK_CZXX,GGZXC_YK_HCJL,GGZXC_YK_JCJL,GGZXC_YK_JHJL,GGZXC_YK_JJK,GGZXC_YK_SSZD,SZ_DLYH,SZ_QLYH,SZ_CQQLYH,SZ_QLJCXX,TCGL_TCDDT,XZSP_SPGC,XZSP_XZXKSPJL,ZT_YSWF,ZT_YSXX,DB_PERSONCAR) full=no record=yes consistent=yes feedback=0

#CD %CURDATE%
#7za a  %PREFIX%_%CURDATE%.zip %FILENAME%
