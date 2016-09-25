@ECHO OFF

cls

curl -v -X POST -H "Content-Type: text/xml" http://localhost:8080/job/Buy_Tablet/doDelete
curl -v -X POST -H "Content-Type: text/xml" http://localhost:8080/view/DemoView/doDelete

del slave.jar
rmdir /s /q Apache_POI
rmdir /s /q cucumber_jars
rmdir /s /q selenium-2.53.1
rmdir /s /q LeanftDemoJava\bin
rmdir /s /q LeanftDemoJava\RunResults
rmdir /s /q LeanftDemoJava\test-output
rmdir /s /q Cucumber\bin
rmdir /s /q Cucumber\RunResults
del TestExecution\com.hp.lft.*.jar
del TestExecution\poi-*.jar
rmdir /s /q TestExecution\RunResults
rmdir /s /q TestExecution\test-output

del "C:\Program Files (x86)\Jenkins\war\images\16x16\lft.gif"

