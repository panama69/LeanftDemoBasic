@ECHO OFF

cls
echo ##
echo ##
echo ## Checking if cURL is installed
echo #--------------------------------------------------------#
echo #  Searching for cURL installation.  Please be patient.  #
echo #--------------------------------------------------------#
set /a x=1
setlocal ENABLEDELAYEDEXPANSION
for /f "delims=" %%a in ('wmic product where "Name='cURL'" get version') do (
   if !x! EQU 2 (
      set CURL_VER=%%a
   )
   rem echo Iteration !x! %%a
   set /a x=x+1
)
if ["%CURL_VER%"] == [] (
   echo ">>>>>>> cURL was not found so it will be installed"
   echo ##
   echo ## install curl
   echo ##
   msiexec.exe /i utilities\curl-7.46.0-win64-local.msi /passive
   set CURL_BASE="%appdata%\..\Local\Apps\cURL\bin"
) else (
   echo "cURL version %CURL_VER% found"
)

set HOME=%cd%
mkdir c:\tmp
mkdir c:\tmp\LeanftBasicDemoJars
set DEMO_JARS_BASE="c:\tmp\LeanftBasicDemoJars"

echo ##
echo ## Pulling and extracing jars to work with Excel
echo ##
mkdir %DEMO_JARS_BASE%\Apache_POI
cd %DEMO_JARS_BASE%\Apache_POI
curl.exe -O http://www-us.apache.org/dist/poi/release/bin/poi-bin-3.15-20160924.zip
unzip -jo poi-bin-3.15-20160924.zip poi-3.15/poi*3.15.jar
del poi-bin-3.15-20160924.zip

echo ##
echo ## Pulling and extracing jars to work with Cucumber
echo ##
mkdir %DEMO_JARS_BASE%\cucumber_jars
cd %DEMO_JARS_BASE%\cucumber_jars
curl.exe -O http://central.maven.org/maven2/info/cukes/cucumber-core/1.2.2/cucumber-core-1.2.2.jar
curl.exe -O http://central.maven.org/maven2/info/cukes/cucumber-java/1.2.2/cucumber-java-1.2.2.jar
curl.exe -O http://central.maven.org/maven2/info/cukes/gherkin/2.12.2/gherkin-2.12.2.jar
curl.exe -O http://central.maven.org/maven2/info/cukes/cucumber-junit/1.2.2/cucumber-junit-1.2.2.jar
curl.exe -O http://central.maven.org/maven2/info/cukes/cucumber-html/0.2.3/cucumber-html-0.2.3.jar
curl.exe -O http://central.maven.org/maven2/info/cukes/cucumber-jvm-deps/1.0.3/cucumber-jvm-deps-1.0.3.jar

echo ##
echo ## Pulling and extracing jars to work with Selenium
echo ##
cd %DEMO_JARS_BASE%
curl.exe -O http://selenium-release.storage.googleapis.com/2.53/selenium-java-2.53.1.zip
unzip -o selenium-java-2.53.1.zip
del selenium-java-2.53.1.zip

echo ##
echo ## Check TestNG plugin for Eclipse is installed
echo ##
rem set TESTNG="C:\Users\Administrator\.p2\pool\plugins\org.testng.eclipse_6.9.13.201609291640\lib\testng.jar"
rem set JCOMMANDER="C:\Users\Administrator\.p2\pool\plugins\org.testng.eclipse_6.9.13.201609291640\lib\jcommander.jar"
cd "C:\Users\Administrator\.p2\pool\plugins\org.testng.eclipse_*"
set TESTNG="%cd%\lib\testng.jar"
set JCOMMANDER="%cd%\lib\jcommander.jar"
cd %HOME%

set MISSING=0
if not exist %TESTNG% (
   echo NOT FOUND %TESTNG%
   echo Make sure TestNG installed to Eclipse
   set MISSING=1
) else (
   echo FOUND %TESTNG%
)

if not exist %JCOMMANDER% (
   echo NOT FOUND %JCOMMANDER%
   echo Make sure TestNG installed to Eclipse
   set MISSING=1
) else (
   echo FOUND %JCOMMANDER%
)

if %MISSING% EQU 1 (
   echo ##############################################################
   echo ##############################################################
   echo ##                                                          ##
   echo ##                                                          ##
   echo ##               NOTE THE ABOVE MISSING FILES               ##
   echo ##             THIS MUST BE FIXED TO DO THE DEMO            ##
   echo ##                                                          ##
   echo ##                                                          ##
   echo ##############################################################
   echo ##############################################################
   timeout /t 10 /nobreak
) else (
   echo ##
   echo ## Looks like TestNG is installed for Eclipse
   echo ##
)

echo ##
echo ## Copy LeanFT jar files for easier execution from Jenkins
echo ##
mkdir %DEMO_JARS_BASE%\LftSdk
echo #-------------------------------------------------------#
echo #  Searching for UFT installation.  Please be patient.  #
echo #-------------------------------------------------------#
rem notes on variable expantion in a loop http://stackoverflow.com/questions/2913231/how-do-i-increment-a-dos-variable-in-a-for-f-loop
set /a x=1
setlocal ENABLEDELAYEDEXPANSION
for /f "delims=" %%a in ('wmic product where "Name='HPE Unified Functional Testing'" get InstallLocation') do (
   if !x! EQU 2 (
      set LFT=%%a
   )
   rem echo Iteration !x! %%a
   set /a x=x+1
)
echo Copying LFT jars from: "%LFT%"
cd "%LFT%"
copy SDK\Java\com.hp.lft.*.jar %DEMO_JARS_BASE%\LftSdk
cd %DEMO_JARS_BASE%


echo ##
echo ## Copy TestNG.xml to TestExecution for use
echo ##
mkdir %DEMO_JARS_BASE%\TestExecution
copy %HOME%\LeanftDemoJava\TestNG.xml %DEMO_JARS_BASE%\TestExecution
copy %HOME%\TestExecution %DEMO_JARS_BASE%\TestExecution

echo ##
echo ## copy Datasources and UFTAPITests %DEMO_JARS_BASE%
echo ##
mkdir %DEMO_JARS_BASE%\DataSources
copy %HOME%\DataSources\*.* %DEMO_JARS_BASE%\DataSources
xcopy /E /Y %HOME%\UFTAPITests 

echo ##
echo ## setting up Jenkins
echo ##
cd %HOME%
set JENKINS_BASE="C:\Program Files (x86)\Jenkins"
copy utilities\groovy-postbuild.hpi %JENKINS_BASE%\plugins
copy utilities\lft.gif %JENKINS_BASE%\war\images\16x16
copy /Y utilities\jenkins.xml %JENKINS_BASE%\jenkins.xml
curl.exe -v -X POST http://localhost:8080/createItem?name=Buy_Tablet --header "Content-Type: application/xml" -d @utilities\BuyTabletJob.xml
curl.exe -v -X POST -d @utilities\DemoView.xml -H "Content-Type: text/xml" http://localhost:8080/createView?name=DemoView
curl.exe -X POST http://localhost:8080/restart