@ECHO OFF

cls
echo ##
echo ## install curl
echo ##
msiexec.exe /i utilities\curl-7.46.0-win64-local.msi /passive

echo ##
echo ## Pulling and extracing jars to work with Excel
echo ##
mkdir %userprofile%\LeanftBasicDemoJars
mkdir %userprofile%\LeanftBasicDemoJars\Apache_POI
cd %userprofile%\LeanftBasicDemoJars\Apache_POI

%appdata%\..\Local\Apps\cURL\bin\curl.exe -O http://www-us.apache.org/dist/poi/release/bin/poi-bin-3.15-20160924.zip

unzip -jo poi-bin-3.15-20160924.zip poi-3.15/poi*3.15.jar
del poi-bin-3.15-20160924.zip
rem copy *.jar ..\TestExecution
rem cd ..


echo ##
echo ## Pulling and extracing jars to work with Cucumber
echo ##
mkdir %userprofile%\LeanftBasicDemoJars\cucumber_jars
cd %userprofile%\LeanftBasicDemoJars\cucumber_jars
%appdata%\..\Local\Apps\cURL\bin\curl.exe -O http://central.maven.org/maven2/info/cukes/cucumber-core/1.2.2/cucumber-core-1.2.2.jar
%appdata%\..\Local\Apps\cURL\bin\curl.exe -O http://central.maven.org/maven2/info/cukes/cucumber-java/1.2.2/cucumber-java-1.2.2.jar
%appdata%\..\Local\Apps\cURL\bin\curl.exe -O http://central.maven.org/maven2/info/cukes/gherkin/2.12.2/gherkin-2.12.2.jar
%appdata%\..\Local\Apps\cURL\bin\curl.exe -O http://central.maven.org/maven2/info/cukes/cucumber-junit/1.2.2/cucumber-junit-1.2.2.jar
%appdata%\..\Local\Apps\cURL\bin\curl.exe -O http://central.maven.org/maven2/info/cukes/cucumber-html/0.2.3/cucumber-html-0.2.3.jar
%appdata%\..\Local\Apps\cURL\bin\curl.exe -O http://central.maven.org/maven2/info/cukes/cucumber-jvm-deps/1.0.3/cucumber-jvm-deps-1.0.3.jar

echo ##
echo ## Pulling and extracing jars to work with Selenium
echo ##
cd %userprofile%\LeanftBasicDemoJars
%appdata%\..\Local\Apps\cURL\bin\curl.exe -O http://selenium-release.storage.googleapis.com/2.53/selenium-java-2.53.1.zip
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
)

echo ##
echo ## Copy LeanFT jar files for easier execution from Jenkins
echo ##
mkdir %userprofile%\LeanftBasicDemoJars\LftSdk
copy "C:\Program Files (x86)\HP\Unified Functional Testing\SDK\Java\com.hp.lft.*.jar" %userprofile%\LeanftBasicDemoJars\LftSdk


echo ##
echo ##
echo ##
copy LeanftDemoJava\TestNG.xml TestExecution\

echo ##
echo ## setting up Jenkins
echo ##

copy utilities\groovy-postbuild.hpi "C:\Program Files (x86)\Jenkins\plugins"
copy utilities\lft.gif "C:\Program Files (x86)\Jenkins\war\images\16x16"
copy utilities\jenkins.xml "C:\Program Files (x86)\Jenkins\jenkins.xml"
%appdata%\..\Local\Apps\cURL\bin\curl.exe -v -X POST http://localhost:8080/createItem?name=Buy_Tablet --header "Content-Type: application/xml" -d @utilities\BuyTabletJob.xml
%appdata%\..\Local\Apps\cURL\bin\curl.exe -v -X POST -d @utilities\DemoView.xml -H "Content-Type: text/xml" http://localhost:8080/createView?name=DemoView
%appdata%\..\Local\Apps\cURL\bin\curl.exe -X POST http://localhost:8080/restart