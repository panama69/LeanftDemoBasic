echo off
set HOME=%cd%
echo Home %HOME%
set DEMO_JARS_BASE="C:\tmp\LeanftBasicDemoJars"

echo ##
echo ## Copy DataSources and UFTAPITests
echo ##   From %HOME% to %DEMO_JARS_BASE%
xcopy /Y /S %HOME%\DataSources %DEMO_JARS_BASE%\DataSources
xcopy /E %HOME%\UFTAPITests %DEMO_JARS_BASE%