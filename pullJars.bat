@ECHO OFF

cls
echo ##
echo ## install curl
echo ##
msiexec.exe /i utilities\curl-7.46.0-win64-local.msi /passive

echo ##
echo ## Pulling and extracing jars to work with Excel
echo ##
mkdir Apache_POI
cd Apache_POI

%appdata%\..\Local\Apps\cURL\bin\curl.exe -O http://www-us.apache.org/dist/poi/release/bin/poi-bin-3.15-20160924.zip

unzip -jo poi-bin-3.15-20160924.zip poi-3.15/poi*3.15.jar
del poi-bin-3.15-20160924.zip
copy *.jar ..\TestExecution
cd ..


echo ##
echo ## Pulling and extracing jars to work with Cucumber
echo ##
mkdir cucumber_jars
cd cucumber_jars
%appdata%\..\Local\Apps\cURL\bin\curl.exe -O http://central.maven.org/maven2/info/cukes/cucumber-core/1.2.2/cucumber-core-1.2.2.jar
%appdata%\..\Local\Apps\cURL\bin\curl.exe -O http://central.maven.org/maven2/info/cukes/cucumber-java/1.2.2/cucumber-java-1.2.2.jar
%appdata%\..\Local\Apps\cURL\bin\curl.exe -O http://central.maven.org/maven2/info/cukes/gherkin/2.12.2/gherkin-2.12.2.jar
%appdata%\..\Local\Apps\cURL\bin\curl.exe -O http://central.maven.org/maven2/info/cukes/cucumber-junit/1.2.2/cucumber-junit-1.2.2.jar
%appdata%\..\Local\Apps\cURL\bin\curl.exe -O http://central.maven.org/maven2/info/cukes/cucumber-html/0.2.3/cucumber-html-0.2.3.jar
%appdata%\..\Local\Apps\cURL\bin\curl.exe -O http://central.maven.org/maven2/info/cukes/cucumber-jvm-deps/1.0.3/cucumber-jvm-deps-1.0.3.jar
cd ..

echo ##
echo ## Pulling and extracing jars to work with Selenium
echo ##
%appdata%\..\Local\Apps\cURL\bin\curl.exe -O http://selenium-release.storage.googleapis.com/2.53/selenium-java-2.53.1.zip
unzip -o selenium-java-2.53.1.zip
del selenium-java-2.53.1.zip

copy "C:\Program Files (x86)\HP\Unified Functional Testing\SDK\Java\com.hp.lft.*.jar" TestExecution

echo ##
echo ## setting up Jenkins
echo ##

copy utilities\groovy-postbuild.hpi "C:\Program Files (x86)\Jenkins\plugins"
copy utilities\lft.gif "C:\Program Files (x86)\Jenkins\war\images\16x16"
copy utilities\jenkins.xml "C:\Program Files (x86)\Jenkins\jenkins.xml"
%appdata%\..\Local\Apps\cURL\bin\curl.exe -v -X POST http://localhost:8080/createItem?name=Buy_Tablet --header "Content-Type: application/xml" -d @utilities\BuyTabletJob.xml
%appdata%\..\Local\Apps\cURL\bin\curl.exe -v -X POST -d @utilities\DemoView.xml -H "Content-Type: text/xml" http://localhost:8080/createView?name=DemoView
%appdata%\..\Local\Apps\cURL\bin\curl.exe -X POST http://localhost:8080/restart