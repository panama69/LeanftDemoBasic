@ECHO OFF

cls

echo ##
echo ## Removing Buy_Tablet job from Jenkins
echo ##
curl -v -X POST -H "Content-Type: text/xml" http://localhost:8080/job/Buy_Tablet/doDelete

echo ##
echo ## Removing DemoView view from Jenkins
echo ##
curl -v -X POST -H "Content-Type: text/xml" http://localhost:8080/view/DemoView/doDelete

echo ##
echo ## Removing demo jar folder %userprofile%\LeanftBasicJars
echo ##
rmdir /s /q c:\tmp\LeanftBasicDemoJars

echo ##
echo ## Removing slave.jar for Jenkins agent
echo ##
rem should check if agent running and stop/kill first
del %temp%\slave.jar

echo ##
echo ## Removing lft.gif used for reports
echo ##
del "C:\Program Files (x86)\Jenkins\war\images\16x16\lft.gif"

