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
set GAME_LIB_PATH=%~dp0..\..\GameLib

set packfiles=entryAssets assets icon

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

	:: 拷贝需要的资源
	copy  ..\swf\games\%gameEntryName%\%gameName%\%gameName%.swf %gameCompilePath%\ /Y
	xcopy %gameClientPath%\assets %gameCompilePath%\assets\ /E /Y
	xcopy %gameClientPath%\entryAssets  %gameCompilePath%\entryAssets\ /E /Y
	xcopy %gameClientPath%\icon  %gameCompilePath%\icon\ /E /Y
	copy  %gameClientPath%\%gameConfigXml%  %gameCompilePath%\%gameName%-app.xml /Y

	:: 删除原来apk
	del %gameCompilePath%\%gameName%.apk

	cd %gameCompilePath%

	echo 生成APK中[%platform%]...
    	call %ADT% -package -target apk-captive-runtime -storetype pkcs12 -keystore %~dp0yes3d.p12 -storepass yes3d %gameCompilePath%\%gameName%.apk %gameName%-app.xml %gameName%.swf %packfiles% -extdir %GAME_LIB_PATH%\ane_android -extdir %GAME_LIB_PATH%\ane_common

	cd %~dp0
   	goto :eof

goto :end

:end

echo -----------------------
echo 生成成功
echo -----------------------
pause
