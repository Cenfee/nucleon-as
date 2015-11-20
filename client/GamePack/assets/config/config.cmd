@echo off

rem -----------------------------
rem Excel处理工具
rem -----------------------------


rd .\xlsx2json\excel /S /Q
rd .\xlsx2json\json /S /Q

xcopy .\excel .\xlsx2json\excel\ /E /Y

cd .\xlsx2json

call export.bat
cd ..\

xcopy .\xlsx2json\json .\json\ /E /Y

rd .\xlsx2json\excel /S /Q
rd .\xlsx2json\json /S /Q

echo -----------------------
echo 生成成功
echo -----------------------
pause

