@echo off

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

set packfiles=entryAssets assets icon

:fun_wait
    	set /p gameEntryName="��������Ϸģ�����(���磺CandyLegend):"
	set /p gameName="��������Ϸ����(����: CandyLegend):"
	set /p gameChannel="��������Ϸ����(����ʽ�������밴�س���:"
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
	

	set /p isCallSwf=�Ƿ����±�����Ϸ(y��ʾ����):
	if [%isCallSwf%] == [y] (
		echo =================����swf.cmd
		cd ..\swf
		call swf.cmd %gameEntryName% %gameName%
		cd %~dp0
		echo =================�˳�swf.cmd
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

	::ɾ����������Դ
	del %gameCompilePath%\%gameName%.swf 
	rd  %gameCompilePath%\assets /S /Q
	rd  %gameCompilePath%\entryAssets /S /Q
	rd  %gameCompilePath%\icon /S /Q
	del %gameCompilePath%\%gameName%-app.xml 

	:: ������Ҫ����Դ
	copy  ..\swf\games\%gameEntryName%\%gameName%\%gameName%.swf %gameCompilePath%\ /Y
	xcopy %gameClientPath%\assets %gameCompilePath%\assets\ /E /Y
	xcopy %gameClientPath%\entryAssets  %gameCompilePath%\entryAssets\ /E /Y
	xcopy %gameClientPath%\icon  %gameCompilePath%\icon\ /E /Y
	copy  %gameClientPath%\%gameConfigXml%  %gameCompilePath%\%gameName%-app.xml /Y

	:: ɾ��ԭ��apk
	del %gameCompilePath%\%gameName%.apk

	cd %gameCompilePath%

	echo ����APK��[%platform%]...
    	call %ADT% -package -target apk-captive-runtime -storetype pkcs12 -keystore %~dp0yes3d.p12 -storepass yes3d %gameCompilePath%\%gameName%.apk %gameName%-app.xml %gameName%.swf %packfiles% -extdir %GAME_LIB_PATH%\ane_android -extdir %GAME_LIB_PATH%\ane_common

	cd %~dp0
   	goto :eof

goto :end

:end

echo -----------------------
echo ���ɳɹ�
echo -----------------------
pause
