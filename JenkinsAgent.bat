echo off
set JENKINS_URL=%ComputerName%
set JENKINS_PORT="8080"

del header.txt
echo Using Jenkins at %JENKINS_URL:"=%:%JENKINS_PORT:"=%

rem check header to see if Jenkins on url http://lornajane.net/posts/2014/view-only-headers-with-curl
rem 2 redirect stderr to file to check
rem 1 redirect the stdout (page body) to nul as it is not needed
curl -v -s http://%JENKINS_URL%:%JENKINS_PORT% 1> NUL 2>header.txt
findstr /c:"X-Jenkins" header.txt 1> NUL

if %ERRORLEVEL% EQU 0 (
   del header.txt
   timeout /t 2 /nobreak > NUL
   rem removed the following as want to place slave.jar in folder other than current
   rem curl -O http://localhost:8080/jnlpJars/slave.jar
   curl -s http://localhost:8080/jnlpJars/slave.jar -o %temp%\slave.jar
   java -jar %temp%\slave.jar -jnlpUrl http://almtraining:8080/computer/Jenkins_UI_Executor/slave-agent.jnlp
) else (
   echo Either %JENKINS_URL:"=%:%JENKINS_PORT:"=% is down or not a valid Jenkins location
   echo Check if Jenkins is up and then try again
   pause
)

