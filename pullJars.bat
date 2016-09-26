@ECHO OFF

cls
echo ##
echo ## install curl
echo ##
msiexec.exe /i utilities\curl-7.46.0-win64-local.msi /passive

set CURL_BASE="%appdata%\..\Local\Apps\cURL\bin"
set HOME=%cd%
mkdir %userprofile%\LeanftBasicDemoJars
set DEMO_JARS_BASE="%userprofile%\LeanftBasicDemoJars"

echo ##
echo ## Pulling and extracing jars to work with Excel
echo ##
mkdir %DEMO_JARS_BASE%\Apache_POI
cd %DEMO_JARS_BASE%\Apache_POI
%CURL_BASE%\curl.exe -O http://www-us.apache.org/dist/poi/release/bin/poi-bin-3.15-20160924.zip
unzip -jo poi-bin-3.15-20160924.zip poi-3.15/poi*3.15.jar
del poi-bin-3.15-20160924.zip

echo ##
echo ## Pulling and extracing jars to work with Cucumber
echo ##
mkdir %DEMO_JARS_BASE%\cucumber_jars
cd %DEMO_JARS_BASE%\cucumber_jars
%CURL_BASE%\curl.exe -O http://central.maven.org/maven2/info/cukes/cucumber-core/1.2.2/cucumber-core-1.2.2.jar
%CURL_BASE%\curl.exe -O http://central.maven.org/maven2/info/cukes/cucumber-java/1.2.2/cucumber-java-1.2.2.jar
%CURL_BASE%\curl.exe -O http://central.maven.org/maven2/info/cukes/gherkin/2.12.2/gherkin-2.12.2.jar
%CURL_BASE%\curl.exe -O http://central.maven.org/maven2/info/cukes/cucumber-junit/1.2.2/cucumber-junit-1.2.2.jar
%CURL_BASE%\curl.exe -O http://central.maven.org/maven2/info/cukes/cucumber-html/0.2.3/cucumber-html-0.2.3.jar
%CURL_BASE%\curl.exe -O http://central.maven.org/maven2/info/cukes/cucumber-jvm-deps/1.0.3/cucumber-jvm-deps-1.0.3.jar

echo ##
echo ## Pulling and extracing jars to work with Selenium
echo ##
cd %DEMO_JARS_BASE%
%CURL_BASE%\curl.exe -O http://selenium-release.storage.googleapis.com/2.53/selenium-java-2.53.1.zip
unzip -o selenium-java-2.53.1.zip
unzip -o testng-6.9.9.jar
del selenium-java-2.53.1.zip

echo ##
echo ## Check TestNG plugin for Eclipse is installed
echo ##
set TESTNG="C:\Users\Administrator\.p2\pool\plugins\org.testng.eclipse_6.9.12.201607091356\lib\testng.jar"
set JCOMMANDER="C:\Users\Administrator\.p2\pool\plugins\org.testng.eclipse_6.9.12.201607091356\lib\jcommander.jar"

set MISSING=0
if not exist %TESTNG% (
   echo NOT FOUND %TESTNG%
   echo Make sure TestNG installed to Eclipse
   set MISSING=1
)

if not exist %JCOMMANDER% (
   echo NOT FOUND %JCOMMANDER%
   echo Make sure TestNG installed to Eclipse
   set MISSING=1
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
for /f "delims=" %%a in ('wmic product where "Name='HP Unified Functional Testing'" get InstallLocation') do (
set LFT=%%a )
copy "%LFT%\SDK\Java\com.hp.lft.*.jar" %DEMO_JARS_BASE%\LftSdk


echo ##
echo ## Copy TestNG.xml to TestExecution for use
echo ##
mkdir %DEMO_JARS_BASE%\TestExecution
copy %HOME%\LeanftDemoJava\TestNG.xml %DEMO_JARS_BASE%\TestExecution
copy %HOME%\TestExecution %DEMO_JARS_BASE%\TestExecution

echo ##
echo ## setting up Jenkins
echo ##
cd %HOME%
set JENKINS_BASE="C:\Program Files (x86)\Jenkins"
copy utilities\groovy-postbuild.hpi %JENKINS_BASE%\plugins
copy utilities\lft.gif %JENKINS_BASE%\war\images\16x16
copy /Y utilities\jenkins.xml %JENKINS_BASE%\jenkins.xml
%CURL_BASE%\curl.exe -v -X POST http://localhost:8080/createItem?name=Buy_Tablet --header "Content-Type: application/xml" -d @utilities\BuyTabletJob.xml
%CURL_BASE%\curl.exe -v -X POST -d @utilities\DemoView.xml -H "Content-Type: text/xml" http://localhost:8080/createView?name=DemoView
%CURL_BASE%\curl.exe -X POST http://localhost:8080/restart