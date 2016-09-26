@ECHO OFF

cls

curl -v -X POST -H "Content-Type: text/xml" http://localhost:8080/job/Buy_Tablet/doDelete
curl -v -X POST -H "Content-Type: text/xml" http://localhost:8080/view/DemoView/doDelete

rmdir /s /q %userprofile%\LeanftBasicDemoJars

rem should check if agent running and stop/kill first
del %temp%\slave.jar

del "C:\Program Files (x86)\Jenkins\war\images\16x16\lft.gif"

