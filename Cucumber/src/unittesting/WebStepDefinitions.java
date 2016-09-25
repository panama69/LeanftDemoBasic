package unittesting;

import com.hp.lft.report.ReportException;
import com.hp.lft.report.Reporter;
import com.hp.lft.sdk.GeneralLeanFtException;
import com.hp.lft.sdk.RegExpProperty;
import com.hp.lft.sdk.web.*;
import com.hp.lft.sdk.web.WebElement;
import com.hp.lft.verifications.*;

import cucumber.api.PendingException;
import cucumber.api.java.en.*;

import org.openqa.selenium.*;
import org.openqa.selenium.chrome.*;
import org.openqa.selenium.support.ui.ExpectedCondition;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.openqa.selenium.support.ui.WebDriverWait;

import java.io.File;
import java.util.concurrent.TimeUnit;


@SuppressWarnings("unused")
public class WebStepDefinitions {
	static String HOME_URL = "http://www.advantageonlineshopping.com:8080/#/";
	static String AGENT_PATH = "C:\\Program Files (x86)\\HP\\Unified Functional Testing\\Installations\\Chrome\\Agent.crx";
	private Browser browser;
	private ChromeDriver chromeDriver;
	
	public void launchBrowser () throws GeneralLeanFtException, InterruptedException, ReportException{
/*    	browser = BrowserFactory.launch(BrowserType.CHROME);
        browser.navigate(HOME_URL);
*/        

        ChromeOptions chromeOptions = new ChromeOptions();
        chromeOptions.addExtensions(new File (AGENT_PATH));
        chromeDriver = new ChromeDriver(chromeOptions);
        chromeDriver.get(HOME_URL);
        
        
        Reporter.reportEvent("Selenium Launch Browser", "used Selenium to opne brower to "+HOME_URL); Thread.sleep(3000);
        browser = BrowserFactory.attach(new BrowserDescription.Builder().type(BrowserType.CHROME).build());
        
    }

	@Given("^I am on the site home page$")
	public void i_am_on_the_site_home_page() throws Throwable {
	    // Write code here that turns the phrase above into concrete actions
		launchBrowser();
	}

	@When("^I select \"(.*?)\"$")
	public void i_select(String arg1) throws Throwable {

/*		browser.describe(WebElement.class, new WebElementDescription.Builder()
				.innerText(arg1.toUpperCase()).build());
*/		
		chromeDriver.findElement(By.xpath("//*[.='"+arg1.toUpperCase()+"']/..")).click();

	}

	@Then("^I should see (\\d+) items$")
	public void i_should_see_items(int arg1) throws Throwable {
	    // Write code here that turns the phrase above into concrete actions
	    //throw new PendingException();

		String itemStr = browser.describe(WebElement.class, new WebElementDescription.Builder()
				.tagName("A").innerText(new RegExpProperty(".*ITEMS ")).build()).getInnerText();
		itemStr.substring(0, 2);
		int itemCount = Integer.parseInt(itemStr.substring(0,itemStr.indexOf(" ")));
		Verify.areEqual(arg1, itemCount);
		browser.close();

	}
}
