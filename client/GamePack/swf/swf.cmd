@echo off & setlocal EnableDelayedExpansion

rem -----------------------------
rem ���������
rem -----------------------------

rem SDKĿ¼
set AIRSDK_PATH="%AIR_SDK_HOME%"
rem adt����Ŀ¼
set ADT=%AIRSDK_PATH%\bin\adt.bat
rem MSMLC Ŀ¼
set MXMLC=%AIRSDK_PATH%\bin\mxmlc.bat
set GAME_LIB_PATH=%~dp0..\..\GameLib
rem Ĭ�ϱ������
set MXMLCConfig=+configname=airmobile


:fun_wait
	set gameEntryName=%1
	set gameName=%2
	if [%gameName%] == [] (
		set /p gameEntryName="��������Ϸģ�����(���磺CandyLegend):"
		set /p gameName="��������Ϸ����(����: CandyLegend):"
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

	:: ����SWF
	cd %gameClientPath%

	:: ɾ��ԭ����swf
	del %gameCompilePath%\%gameName%.swf

	:: ��ʼ����
	echo ����Entry SWF��[��Ϸ: %gameName%]...
	call %MXMLC% %MXMLCConfig% -library-path+=..\..\GameEntry\bin -library-path+=%gameUtilPath%,%gameSWCPath% -output %gameCompilePath%\%gameName%.swf .\%gameName%.as
	cd %~dp0

	:: ɾ����������Դ
	rd %gameCompilePath%\assets /S /Q
	rd %gameCompilePath%\entryAssets /S /Q

	:: ������Ҫ����Դ
	xcopy %gameClientPath%\assets %gameCompilePath%\assets\ /E /Y
	xcopy %gameClientPath%\entryAssets %gameCompilePath%\entryAssets\ /E /Y

   	goto :eof

	


goto :end



:end
