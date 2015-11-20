@echo off & setlocal EnableDelayedExpansion

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
rem 默认编译参数
set MXMLCConfig=+configname=airmobile


:fun_wait
	set gameEntryName=%1
	set gameName=%2
	if [%gameName%] == [] (
		set /p gameEntryName="请输入游戏模板代号(例如：CandyLegend):"
		set /p gameName="请输入游戏代号(例如: CandyLegend):"
		if [%gameEntryName%] == [] (
			set gameEntryName=CandyLegend
		)
		if [%gameName%] == [] (
			set gameName=CandyLegend
		)
	) 

    	call :fun_pack
    	goto :end

:fun_pack

	set gameClientPath=%~dp0..\..\Games\%gameEntryName%\%gameName%\src
	set gameCompilePath=%~dp0.\games\%gameEntryName%\%gameName%
	set gameUtilPath=%~dp0..\..\GameLib\GameUtil\bin
	set gameSWCPath=%~dp0..\..\GameLib\swc

	:: 生成SWF
	cd %gameClientPath%

	:: 删除原来的swf
	del %gameCompilePath%\%gameName%.swf

	:: 开始编译
	echo 生成Entry SWF中[游戏: %gameName%]...
	call %MXMLC% %MXMLCConfig% -library-path+=..\..\GameEntry\bin -library-path+=%gameUtilPath%,%gameSWCPath% -output %gameCompilePath%\%gameName%.swf .\%gameName%.as
	cd %~dp0

	:: 删除拷贝的资源
	rd %gameCompilePath%\assets /S /Q
	rd %gameCompilePath%\entryAssets /S /Q

	:: 拷贝需要的资源
	xcopy %gameClientPath%\assets %gameCompilePath%\assets\ /E /Y
	xcopy %gameClientPath%\entryAssets %gameCompilePath%\entryAssets\ /E /Y

   	goto :eof

	


goto :end



:end
