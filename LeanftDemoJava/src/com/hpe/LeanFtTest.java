package com.hpe;

//TestNG Imports
import org.testng.annotations.*;
import org.testng.annotations.BeforeSuite;

//Java Imports
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.awt.image.*;
import java.util.HashMap;
import java.util.Map;
import javax.imageio.ImageIO;
import javax.xml.soap.*;
import javax.xml.transform.*;
import javax.xml.transform.stream.*;

//LeanFT Imports
import com.hp.lft.sdk.*;
import com.hp.lft.sdk.web.*;
import com.hp.lft.unittesting.*;
import com.hp.lft.verifications.*;
import com.hp.lft.sdk.insight.*;
import com.hp.lft.sdk.apitesting.uft.APITestResult;
import com.hp.lft.sdk.apitesting.uft.APITestRunner;
import unittesting.*;

//Apache POI imports
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;


@SuppressWarnings("unused")
public class LeanFtTest extends UnitTestClassBase {

	String PROJECT_BASE = "C:\\Users\\Administrator\\DemoWorkspace";
    String USER_LIST_EXCEL_PATH = PROJECT_BASE+"\\DataSources\\AOS_Users.xls";
    String CREATE_USER_UFT_API_TEST = PROJECT_BASE+"\\UFTAPITests\\CreateAOSUser";

    static String userName;

    @BeforeSuite
    public void beforeSuite() throws IOException, GeneralLeanFtException {

        userName = getUserNameFromExcel();
        createNewUserInAOS();
    }

    @BeforeClass
    public void beforeClass() {
    }

    @Test
    @Parameters({"browser-name"})
    public void BuyTabletTest(String browserName) throws GeneralLeanFtException, IOException {
    //public void BuyTabletTest() throws GeneralLeanFtException, IOException {	
        //Launch Browser
        //Browser browser = BrowserFactory.launch(BrowserType.valueOf(browserName));
    	Browser browser = BrowserFactory.launch(BrowserType.CHROME);

    	
        //Navigate to Advantage Online Shopping 
    	// should use port 8080 for this test
    	// without 8080, you pick up different version of app which may have diff results
        browser.navigate("http://www.advantageonlineshopping.com:8080/#/");

        
        //Click the "Tablets" category

        
        
        //Click the price of the first tablet

        
        
        //Click the "Add to Cart" button
        browser.describe(Button.class, new ButtonDescription.Builder()
                .className("roboto-medium ng-scope ng-binding").build()).click();
        
        //Click the "Checkout" button
        browser.describe(Button.class, new ButtonDescription.Builder()
                .buttonType("submit").tagName("BUTTON").name("CHECKOUT").build()).click();

        //Get the tablet's price
        String price = browser.describe(WebElement.class, new WebElementDescription.Builder()
                .className("roboto-medium totalValue ng-binding").build()).getInnerText();

        //Validate its value
        Verify.areEqual("$1000", price, "Verify Price");

        //Full user details and complete purchase
        DemoAppModel appModel = new DemoAppModel(browser);

/*      //appModel.AdvantageShoppingPage().UserName().setValue(getUserNameFromExcel());
        appModel.AdvantageShoppingPage().UserName().setValue("demo_user");
        appModel.AdvantageShoppingPage().Password().setValue("Aa1234");
        appModel.AdvantageShoppingPage().Password().click();
        appModel.AdvantageShoppingPage().LoginBtn().click();
 */       
        
        browser.close();
    }


    //Read the first user name from the Excel data source
    private String getUserNameFromExcel() throws IOException {

        FileInputStream file = new FileInputStream(new File(USER_LIST_EXCEL_PATH));

        //Get the workbook instance for XLS file
        HSSFWorkbook workbook = new HSSFWorkbook(file);

        //Get first sheet from the workbook
        HSSFSheet sheet = workbook.getSheetAt(0);

        Row row = sheet.getRow(1);
        Cell cell = row.getCell(0);
        workbook.close();

        return cell.getStringCellValue();
    }

    //
    //Call UFT API test which creates the user in Advantage Online Shopping
    //
    private void createNewUserInAOS() throws GeneralLeanFtException {

        Map<String, Object> inParams = new HashMap<String, Object>();
        inParams.put("UserName", userName);

        APITestResult result = APITestRunner.run(CREATE_USER_UFT_API_TEST, inParams);
    }

    //
    //Call web service via Java code
	//
    public void getCountries() throws GeneralLeanFtException {
		//base on example found http://stackoverflow.com/questions/15940234/how-to-do-a-soap-web-service-call-from-java-class
	    try {
	        // Create SOAP Connection
	        SOAPConnectionFactory soapConnectionFactory = SOAPConnectionFactory.newInstance();
	        SOAPConnection soapConnection = soapConnectionFactory.createConnection();

	        // Send SOAP Message to SOAP Server
	        String url = "http://www.advantageonlineshopping.com/accountservice";
	        SOAPMessage soapResponse = soapConnection.call(createSOAPRequest(), url);

	        // Process the SOAP Response
	        printSOAPResponse(soapResponse);

	        soapConnection.close();
	    } catch (Exception e) {
	        System.err.println("Error occurred while sending SOAP Request to Server");
	        e.printStackTrace();
	    }
	}
    
    private static SOAPMessage createSOAPRequest() throws Exception {
        MessageFactory messageFactory = MessageFactory.newInstance();
        SOAPMessage soapMessage = messageFactory.createMessage();
        SOAPPart soapPart = soapMessage.getSOAPPart();

        String serverURI = "http://www.advantageonlineshopping.com/accountservice";

        // SOAP Envelope
        SOAPEnvelope envelope = soapPart.getEnvelope();

        /*
        Constructed SOAP Request Message:
        <?xml version="1.0" encoding="utf-8"?>
        <Envelope xmlns="http://schemas.xmlsoap.org/soap/envelope/">
             <Body>
                  <GetCountriesRequest xmlns="com.advantage.online.store.accountservice" />
             </Body>
        </Envelope>
        */

        // SOAP Body
        SOAPBody soapBody = envelope.getBody();
        soapBody.addChildElement("GetCountriesRequest xmlns=\"com.advantage.online.store.accountservice\"");

        //SOAPElement soapBodyElem = soapBody.addChildElement("GetCountriesRequest", "");

        MimeHeaders headers = soapMessage.getMimeHeaders();
        headers.addHeader("SOAPAction", serverURI  + "GetCountriesRequest");

        soapMessage.saveChanges();

        /* Print the request message */
        System.out.print("Request SOAP Message = ");
        soapMessage.writeTo(System.out);
        System.out.println();

        return soapMessage;
    }

    /**
     * Method used to print the SOAP Response
     */
    private static void printSOAPResponse(SOAPMessage soapResponse) throws Exception {
        TransformerFactory transformerFactory = TransformerFactory.newInstance();
        Transformer transformer = transformerFactory.newTransformer();
        Source sourceContent = soapResponse.getSOAPPart().getContent();
        System.out.print("\nResponse SOAP Message = ");
        StreamResult result = new StreamResult(System.out);
        transformer.transform(sourceContent, result);
    }
}