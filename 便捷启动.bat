@echo off
cd /d %~dp0

:: ��ȡ����ԱȨ�ޣ�����Ҫ��ɾ����ע�͵���
%1 start "" mshta vbscript:createobject("shell.application").shellexecute("""%~0""","::",,"runas",1)(window.close)&exit

title -- FRPS��������ű� --
MODE con: COLS=60 lines=18
color 0a

:begin  
cls
MODE con: COLS=60 lines=18
echo.
%~dp0\frps\frps.exe -v >%~dp0\frps\version.txt
FOR /F %%i IN (%~dp0\frps\version.txt) DO (
echo    ===FRPS��������ű�^(��ǰfrps.exe�汾:%%i^)===
)
echo.
echo --[1]--���������ش���
echo --[2]--��װ�������������񣨹���ԱȨ�ޣ�
echo --[3]--ж�ؿ������������񣨹���ԱȨ�ޣ�
echo --[4]--�ر�frps����
echo --[5]--��ʱ��������ʾ������Ϣ
echo --[6]--�˳��ű���������ʱ�ļ�
echo.
echo.
echo --ע��--ʹ��ǰӦ���޸�frps.toml�ж�Ӧ��������Ϣ
echo --ע��--��ʱ�����в����������ٰ�װΪ����������
echo --ע��--���������汾����Ҫ�滻frps\frps.exe�ļ�
echo.
choice /c 123456 /n /m "��ѡ��1-6����"
 
echo %errorlevel%
if %errorlevel% == 1 goto set_ip1_ip  
if %errorlevel% == 2 goto set_ip2_ip  
if %errorlevel% == 3 goto set_ip3_ip  
if %errorlevel% == 4 goto set_ip4_ip  
if %errorlevel% == 5 goto set_ip5_ip  
if %errorlevel% == 6 goto end 

:set_ip1_ip  
MODE con: COLS=80 lines=18
taskkill /im frps.exe /f 1>nul 2>nul
ping localhost -n 3 > nul
cls
echo.
echo.
echo ��������������....
echo.
echo --[���ڸ��������ű�]--
echo.set ws=WScript.CreateObject("WScript.Shell")>%~dp0\frps\start2hide.vbs
echo.ws.Run "%~dp0\frps\frps.exe -c %~dp0\frps.toml",^0>>%~dp0\frps\start2hide.vbs
echo.
ping localhost -n 3 > nul
echo --[����������̨����]--
echo.
%~dp0\frps\start2hide.vbs
ping localhost -n 2 > nul
tasklist /fi "imagename eq frps.exe"
echo.
echo �����ɹ�������������ش��ڡ�
pause>nul
exit

:set_ip2_ip  
taskkill /im frps.exe /f 1>nul 2>nul
ping localhost -n 3 > nul
cls
echo.
echo.
echo ���ڻ�ȡ������ԱȨ�ޡ������ڵ����˵��е㡾�ǡ���
ping localhost -n 5 > nul
echo.
echo --[�������������ļ�]--
echo.^<service^>>%~dp0\frps\frps-service.xml
echo.^<id^>frps^</id^>>>%~dp0\frps\frps-service.xml
echo.^<name^>frps Service^</name^>>>%~dp0\frps\frps-service.xml
echo.^<description^>frps Service^</description^>>>%~dp0\frps\frps-service.xml
echo.^<executable^>%~dp0\frps\frps.exe^</executable^>>>%~dp0\frps\frps-service.xml
echo.^<arguments^>-c %~dp0\frps.toml^</arguments^>>>%~dp0\frps\frps-service.xml
echo.^<logmode^>reset^</logmode^>>>%~dp0\frps\frps-service.xml
echo.^</service^>>>%~dp0\frps\frps-service.xml
echo.
ping localhost -n 3 > nul
echo --[���ڰ�װ����]--
echo.
%~dp0\frps\frps-service.exe install 1>nul 2>nul
echo.
echo ����װ�ɹ�������������������������ڵ����˵��е㡾�ǡ���
pause>nul
MODE con: COLS=80 lines=18
%~dp0\frps\frps-service.exe start 1>nul 2>nul
echo.
ping localhost -n 2 > nul
tasklist /fi "imagename eq frps.exe"
echo.
echo ���������ɹ�������������ؿ�ʼ�˵���
pause>nul
goto begin 

:set_ip3_ip 
taskkill /im frps.exe /f 1>nul 2>nul
ping localhost -n 3 > nul
cls
echo.
echo. 
echo ���ڻ�ȡ������ԱȨ�ޡ������ڵ����˵��е㡾�ǡ���
ping localhost -n 5 > nul
echo.
echo --[����ж������������]--
%~dp0\frps\frps-service.exe uninstall 1>nul 2>nul
echo.
echo ж�سɹ�������������ؿ�ʼ�˵���
pause>nul
goto begin 

:set_ip4_ip  
cls
echo.
echo.
echo �ر�frps��̨�����񣩽���....
echo.
echo --[���ڹر�frps����]--
taskkill /im frps.exe /f 1>nul 2>nul
echo.
echo �رճɹ�������������ؿ�ʼ�˵���
pause>nul
goto begin 

:set_ip5_ip  
MODE con: COLS=140 lines=12
taskkill /im frps.exe /f 1>nul 2>nul
ping localhost -n 3 > nul
cls
echo.
echo.
echo - [�رմ���ֹͣ����]����������....��ÿ����success��β˵�������ɹ����������޸�frps.toml�д������
echo - ��ȷ��������ط�������վ���ѿ����������������ʱ��˿ڱ���
echo.
%~dp0\frps\frps.exe -c %~dp0\frps.toml
pause>nul
goto begin 

:end 
cls
echo.
echo.
echo.
echo    ===����������ʱ�ļ�===
del %~dp0\frps\frps-service.err.log 2>nul
del %~dp0\frps\frps-service.out.log 2>nul
del %~dp0\frps\frps-service.wrapper.log 2>nul
del %~dp0\frps\start2hide.vbs 2>nul
del %~dp0\frps\version.txt 2>nul
echo.
echo    ���������,���ڹرսű�....
ping localhost -n 2 > nul
exit  