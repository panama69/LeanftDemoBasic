# LeanftDemoBasic
All the components to perform a basic LFT demo along with making call to Excel file and UFT service script

# Getting the demo
Assumptions
  1. You have some form of Git on your machine
  2. You are using demo image ADM_1253 v5
  3. The instructions assume you are performing a clone and not a zip download

Installation Steps
  1. git clone -v http://github.com/panama69/LeanftDemoBasic.git
    * the above will clone all the latest files in the project.  Using this may not work as some non-working changes may have been committed.
    * If you want to see the releases/tags for the project from your favorite git commandline tool us git ls-remote --tags https://github.com/panama69/LeanftDemoBasic.git
    * The other way to get a specific release is to click the release link and then download the source from the release of your choice.
    * To check out a specific release use git clone -v --branch v1.0.0-beta https://github.com/panama69/LeanftDemoBasic.git
    * To clone a s
  2. Open Eclipse and install TestNG
    * Eclipse->Help->Eclipse Marketplace.
    * Search for 'TestNG'.
    * Install 'TestNG for Eclipse'.
    * Follow the rest of the instructions on the install and restart Eclipse.
    * Minimize for later.
  3. Using Windows explorer go to the clone location
    * run the pullJars.bat.
    * run JenkinsAgent.bat.
  4. Maximize/Open Eclipse
    * File->Open Projects From File System
    * Select the 'Directory' button and select the folder where your Git download is and select the folder.
    * Select only the.
      * LeanftDemoJava.
      * Cucumber.

Removal Steps
  1. Go to the folder where you cloned the project
  2. Run the cleanJars.bat
    - this will remove the jars used by the demo and remove the job and view that was created in Jenkins
  3. Delete the folder where you placed the clone.

**LeanftDemoJava**
  * You will need to build this script like in the video before you can executed it.
  * To execute it from Eclipse, you need to right click on TestNG.xml and select TestNG Suite.
  * There is no need to execute from Eclipse as you will see in the video (located on iRock https://irock.jiveon.com/docs/DOC-137642) that it is only executed from Jenkins.

**Cucumber**
  * You will need to right click on LeanFtTest and select run as Junit.

Make sure to use: http://www.advantageonlineshopping.com:8080/#/
  **Take note of the port 8080**

Video of the demo flow can be found on https://irock.jiveon.com/docs/DOC-137642

If you wish to turn off the annoying message in Chrome saying there is debugging happening, open the page "chrome://flags" and find "silent debugging" and select enable
