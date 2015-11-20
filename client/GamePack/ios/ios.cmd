@echo off

rem -----------------------------
rem 打包管理工具
rem -----------------------------

rem SDK目录
set AIRSDK_PATH="%AIR_SDK_HOME%"
rem adt工具目录
set ADT=%AIRSDK_PATH%\bin\adt.bat
rem MSMLC 目录
set MXMLC=%AIRSDK_PATH%\bin\mxmlc.bat
rem 客户端工程主目录
set CLIENT_PATH=%~dp0..\..\GameEntry
set GAME_LIB_PATH=%~dp0..\..\GameLib

set packfiles=entryAssets assets icon Default.png Default-568h@2x.png

:fun_wait
    	set /p gameEntryName="请输入游戏模板代号(例如：CandyLegend):"
	set /p gameName="请输入游戏代号(例如: CandyLegend):"
	set /p gameChannel="请输入游戏渠道(非正式出包，请按回车）:"
	if [%gameEntryName%] == [] (
		set gameEntryName=CandyLegend
	)
	if [%gameName%] == [] (
		set gameName=CandyLegend
	)
	if [%gameChannel%] == [] (
		set gameChannel=
	) else (
		set gameChannel=-%gameChannel%
	)

	set /p isCallSwf=是否重新编译游戏(y表示编译):
	if [%isCallSwf%] == [y] (
		echo =================调用swf.cmd
		cd ..\swf
		call swf.cmd %gameEntryName% %gameName%
		cd %~dp0
		echo =================退出swf.cmd
	)
   	call :fun_pack
    	goto :end

:fun_pack

	set gameClientPath=%~dp0..\..\Games\%gameEntryName%\%gameName%\src
	set gameCompilePath=%~dp0.\games\%gameEntryName%\%gameName%
	md %gameCompilePath%

	if [%gameChannel%] == [] (
		set gameConfigXml=%gameName%-app.xml
	) else (
		set gameConfigXml=mainConfig\%gameName%-app%gameChannel%.xml
	)

	::删除拷贝的资源
	del %gameCompilePath%\%gameName%.swf 
	rd  %gameCompilePath%\assets /S /Q
	rd  %gameCompilePath%\entryAssets /S /Q
	rd  %gameCompilePath%\icon /S /Q
	del %gameCompilePath%\%gameName%-app.xml 
	del %gameCompilePath%\distribution.mobileprovision
	del %gameCompilePath%\Default.png
	del %gameCompilePath%\Default-568h@2x.png

	:: 拷贝需要的资源
	copy  ..\swf\games\%gameEntryName%\%gameName%\%gameName%.swf %gameCompilePath%\ /Y
	xcopy %gameClientPath%\assets %gameCompilePath%\assets\ /E /Y
	xcopy %gameClientPath%\entryAssets  %gameCompilePath%\entryAssets\ /E /Y
	xcopy %gameClientPath%\icon  %gameCompilePath%\icon\ /E /Y
	copy  %gameClientPath%\%gameConfigXml%  %gameCompilePath%\%gameName%-app.xml /Y

	copy  %gameClientPath%\..\cer\ios\distribution.mobileprovision  %gameCompilePath%\ /Y
	copy  %~dp0start_page\Default.png  %gameCompilePath%\ /Y
	copy  %~dp0start_page\Default-568h@2x.png  %gameCompilePath%\ /Y

	:: 删除原来ipa
	del %gameCompilePath%\%gameName%.ipa

	cd %gameCompilePath%

	echo 生成IOS中[%platform%]...
    	call %ADT% -package -target ipa-debug-interpreter -storetype pkcs12 -keystore %~dp0cer\distribution.p12 -storepass bobee83815523 -provisioning-profile distribution.mobileprovision %gameCompilePath%\%gameName%.ipa %gameName%-app.xml %gameName%.swf %packfiles% -extdir %GAME_LIB_PATH%\ane_ios -extdir %GAME_LIB_PATH%\ane_common
	:: ipa-debug-interpreter ipa-app-store

	cd %~dp0
   	goto :eof

goto :end

:end

echo -----------------------
echo 生成成功
echo -----------------------
pause

::-target ipa-test — 选择此选项可快速编译要在开发人员 iPhone 上进行测试的应用程序版本。还可以使用 ipa-test-interpreter 获得更快的编译速度，或使用 ipa-test-interpreter-simulator 在 iOS Simulator 中运行。
::-target ipa-debug — 选择此选项可编译要在开发人员 iPhone 上测试的应用程序调试版本。通过此选项，您可以使用调试会话从 iPhone 应用程序接收 trace() 输出。
::您可以包含以下 -connect 选项 (CONNECT_OPTIONS) 之一，以指定运行该调试器的开发计算机的 IP 地址：
::-connect — 应用程序将尝试通过 wifi 连接到用于编译该应用程序的开发计算机上的调试会话。
::-connect IP_ADDRESS — 应用程序将尝试通过 wifi 连接到具有指定 IP 地址的计算机上的调试会话。例如：
::-target ipa-debug -connect 192.0.32.10
::-connect HOST_NAME — 应用程序将尝试通过 wifi 连接到具有指定主机名称的计算机上的调试会话。例如：
::-target ipa-debug -connect bobroberts-mac.example.com
::-connect 选项是可选项。如果不指定该选项，则生成的调试应用程序不会尝试连接到托管调试器。或者可以指定 ?listen 代替 ?connect 以启用 USB 调试，如通过 USB使用 FDB 进行远程调试所述。
::如果调试连接尝试失败，应用程序会显示一个对话框，要求用户输入调试主机的 IP 地址。如果设备未连接到 wifi，连接尝试可能失败。如果设备已连接，但不在调试主机的防火墙之后，也可能失败。
::还可以使用 ipa-debug-interpreter 获得更快的编译速度，或使用 ipa-debug-interpreter-simulator 在 iOS Simulator 中运行.
::-target ipa-ad-hoc — 选择此选项可创建用于临时部署的应用程序。请参见 Apple iPhone 开发人员中心
::-target ipa-app-store — 选择此选项可创建用于部署到 Apple 应用程序库的 IPA 文件的最终版本。 