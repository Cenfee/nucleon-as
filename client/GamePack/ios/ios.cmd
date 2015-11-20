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
rem �ͻ��˹�����Ŀ¼
set CLIENT_PATH=%~dp0..\..\GameEntry
set GAME_LIB_PATH=%~dp0..\..\GameLib

set packfiles=entryAssets assets icon Default.png Default-568h@2x.png

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
	del %gameCompilePath%\distribution.mobileprovision
	del %gameCompilePath%\Default.png
	del %gameCompilePath%\Default-568h@2x.png

	:: ������Ҫ����Դ
	copy  ..\swf\games\%gameEntryName%\%gameName%\%gameName%.swf %gameCompilePath%\ /Y
	xcopy %gameClientPath%\assets %gameCompilePath%\assets\ /E /Y
	xcopy %gameClientPath%\entryAssets  %gameCompilePath%\entryAssets\ /E /Y
	xcopy %gameClientPath%\icon  %gameCompilePath%\icon\ /E /Y
	copy  %gameClientPath%\%gameConfigXml%  %gameCompilePath%\%gameName%-app.xml /Y

	copy  %gameClientPath%\..\cer\ios\distribution.mobileprovision  %gameCompilePath%\ /Y
	copy  %~dp0start_page\Default.png  %gameCompilePath%\ /Y
	copy  %~dp0start_page\Default-568h@2x.png  %gameCompilePath%\ /Y

	:: ɾ��ԭ��ipa
	del %gameCompilePath%\%gameName%.ipa

	cd %gameCompilePath%

	echo ����IOS��[%platform%]...
    	call %ADT% -package -target ipa-debug-interpreter -storetype pkcs12 -keystore %~dp0cer\distribution.p12 -storepass bobee83815523 -provisioning-profile distribution.mobileprovision %gameCompilePath%\%gameName%.ipa %gameName%-app.xml %gameName%.swf %packfiles% -extdir %GAME_LIB_PATH%\ane_ios -extdir %GAME_LIB_PATH%\ane_common
	:: ipa-debug-interpreter ipa-app-store

	cd %~dp0
   	goto :eof

goto :end

:end

echo -----------------------
echo ���ɳɹ�
echo -----------------------
pause

::-target ipa-test �� ѡ���ѡ��ɿ��ٱ���Ҫ�ڿ�����Ա iPhone �Ͻ��в��Ե�Ӧ�ó���汾��������ʹ�� ipa-test-interpreter ��ø���ı����ٶȣ���ʹ�� ipa-test-interpreter-simulator �� iOS Simulator �����С�
::-target ipa-debug �� ѡ���ѡ��ɱ���Ҫ�ڿ�����Ա iPhone �ϲ��Ե�Ӧ�ó�����԰汾��ͨ����ѡ�������ʹ�õ��ԻỰ�� iPhone Ӧ�ó������ trace() �����
::�����԰������� -connect ѡ�� (CONNECT_OPTIONS) ֮һ����ָ�����иõ������Ŀ���������� IP ��ַ��
::-connect �� Ӧ�ó��򽫳���ͨ�� wifi ���ӵ����ڱ����Ӧ�ó���Ŀ���������ϵĵ��ԻỰ��
::-connect IP_ADDRESS �� Ӧ�ó��򽫳���ͨ�� wifi ���ӵ�����ָ�� IP ��ַ�ļ�����ϵĵ��ԻỰ�����磺
::-target ipa-debug -connect 192.0.32.10
::-connect HOST_NAME �� Ӧ�ó��򽫳���ͨ�� wifi ���ӵ�����ָ���������Ƶļ�����ϵĵ��ԻỰ�����磺
::-target ipa-debug -connect bobroberts-mac.example.com
::-connect ѡ���ǿ�ѡ������ָ����ѡ������ɵĵ���Ӧ�ó��򲻻᳢�����ӵ��йܵ����������߿���ָ�� ?listen ���� ?connect ������ USB ���ԣ���ͨ�� USBʹ�� FDB ����Զ�̵���������
::����������ӳ���ʧ�ܣ�Ӧ�ó������ʾһ���Ի���Ҫ���û�������������� IP ��ַ������豸δ���ӵ� wifi�����ӳ��Կ���ʧ�ܡ�����豸�����ӣ������ڵ��������ķ���ǽ֮��Ҳ����ʧ�ܡ�
::������ʹ�� ipa-debug-interpreter ��ø���ı����ٶȣ���ʹ�� ipa-debug-interpreter-simulator �� iOS Simulator ������.
::-target ipa-ad-hoc �� ѡ���ѡ��ɴ���������ʱ�����Ӧ�ó�����μ� Apple iPhone ������Ա����
::-target ipa-app-store �� ѡ���ѡ��ɴ������ڲ��� Apple Ӧ�ó����� IPA �ļ������հ汾�� 