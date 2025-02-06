@echo off
cd /d %~dp0

:: 获取管理员权限，不需要可删除或注释掉。
%1 start "" mshta vbscript:createobject("shell.application").shellexecute("""%~0""","::",,"runas",1)(window.close)&exit

title -- FRPS便捷启动脚本 --
MODE con: COLS=60 lines=18
color 0a

:begin  
cls
MODE con: COLS=60 lines=18
echo.
%~dp0\frps\frps.exe -v >%~dp0\frps\version.txt
FOR /F %%i IN (%~dp0\frps\version.txt) DO (
echo    ===FRPS便捷启动脚本^(当前frps.exe版本:%%i^)===
)
echo.
echo --[1]--启动并隐藏窗口
echo --[2]--安装开机自启动服务（管理员权限）
echo --[3]--卸载开机自启动服务（管理员权限）
echo --[4]--关闭frps进程
echo --[5]--临时启动并显示进程信息
echo --[6]--退出脚本并清理临时文件
echo.
echo.
echo --注意--使用前应先修改frps.toml中对应的配置信息
echo --注意--临时启动中测试正常后再安装为自启动服务
echo --注意--如需升级版本仅需要替换frps\frps.exe文件
echo.
choice /c 123456 /n /m "请选择【1-6】："
 
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
echo 程序正在启动中....
echo.
echo --[正在更新启动脚本]--
echo.set ws=WScript.CreateObject("WScript.Shell")>%~dp0\frps\start2hide.vbs
echo.ws.Run "%~dp0\frps\frps.exe -c %~dp0\frps.toml",^0>>%~dp0\frps\start2hide.vbs
echo.
ping localhost -n 3 > nul
echo --[正在启动后台进程]--
echo.
%~dp0\frps\start2hide.vbs
ping localhost -n 2 > nul
tasklist /fi "imagename eq frps.exe"
echo.
echo 启动成功，按任意键隐藏窗口。
pause>nul
exit

:set_ip2_ip  
taskkill /im frps.exe /f 1>nul 2>nul
ping localhost -n 3 > nul
cls
echo.
echo.
echo 正在获取【管理员权限】，请在弹出菜单中点【是】。
ping localhost -n 5 > nul
echo.
echo --[正在生成配置文件]--
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
echo --[正在安装服务]--
echo.
%~dp0\frps\frps-service.exe install 1>nul 2>nul
echo.
echo 服务安装成功。按【任意键】启动服务，请在弹出菜单中点【是】。
pause>nul
MODE con: COLS=80 lines=18
%~dp0\frps\frps-service.exe start 1>nul 2>nul
echo.
ping localhost -n 2 > nul
tasklist /fi "imagename eq frps.exe"
echo.
echo 服务启动成功。按任意键返回开始菜单。
pause>nul
goto begin 

:set_ip3_ip 
taskkill /im frps.exe /f 1>nul 2>nul
ping localhost -n 3 > nul
cls
echo.
echo. 
echo 正在获取【管理员权限】，请在弹出菜单中点【是】。
ping localhost -n 5 > nul
echo.
echo --[正在卸载自启动服务]--
%~dp0\frps\frps-service.exe uninstall 1>nul 2>nul
echo.
echo 卸载成功。按任意键返回开始菜单。
pause>nul
goto begin 

:set_ip4_ip  
cls
echo.
echo.
echo 关闭frps后台（服务）进程....
echo.
echo --[正在关闭frps进程]--
taskkill /im frps.exe /f 1>nul 2>nul
echo.
echo 关闭成功。按任意键返回开始菜单。
pause>nul
goto begin 

:set_ip5_ip  
MODE con: COLS=140 lines=12
taskkill /im frps.exe /f 1>nul 2>nul
ping localhost -n 3 > nul
cls
echo.
echo.
echo - [关闭窗口停止解析]域名解析中....（每行以success结尾说明解析成功，否则请修改frps.toml中错误项。）
echo - 请确保本地相关服务（如网站）已开启，否则访问域名时会端口报错。
echo.
%~dp0\frps\frps.exe -c %~dp0\frps.toml
pause>nul
goto begin 

:end 
cls
echo.
echo.
echo.
echo    ===正在清理临时文件===
del %~dp0\frps\frps-service.err.log 2>nul
del %~dp0\frps\frps-service.out.log 2>nul
del %~dp0\frps\frps-service.wrapper.log 2>nul
del %~dp0\frps\start2hide.vbs 2>nul
del %~dp0\frps\version.txt 2>nul
echo.
echo    清理已完成,正在关闭脚本....
ping localhost -n 2 > nul
exit  