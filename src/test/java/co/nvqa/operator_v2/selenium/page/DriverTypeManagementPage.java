package co.nvqa.operator_v2.selenium.page;

import co.nvqa.operator_v2.util.SingletonStorage;
import co.nvqa.operator_v2.util.TestConstants;
import co.nvqa.operator_v2.util.TestUtils;
import org.junit.Assert;
import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;

import java.io.File;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

/**
 *
 * @author Soewandi Wirjawan
 */
public class DriverTypeManagementPage extends SimplePage
{
    private static final int MAX_RETRY = 10;
    private static final String DRIVER_TYPES_CSV_FILE_NAME = "driver-types.csv";
    private static final String DRIVER_TYPES_CSV_FILE_LOCATION = TestConstants.SELENIUM_WRITE_PATH + DRIVER_TYPES_CSV_FILE_NAME;

    public DriverTypeManagementPage(WebDriver webDriver)
    {
        super(webDriver);
    }

    public void filteredBy(String filterValue, String filterType) throws InterruptedException
    {
        click("//button[@aria-label='" + filterValue + "']");
        pause1s();

        // get counter
        WebElement el = findElementByXpath("//ng-pluralize[@class='nv-p-med count']");
        String counter = el.getText().split(" ")[0];

        if(Integer.parseInt(counter)==0)
        {
            return;
        }

        String[] tokens = filterType.toLowerCase().split(" ");
        String className = tokens.length == 2 ? tokens[0] + "-" + tokens[1] : tokens[0];

        boolean valid = true;
        List<WebElement> elm = findElementsByXpath("//tr[@md-virtual-repeat='driverTypeProp in ctrl.tableData']");

        for(WebElement e : elm)
        {
            WebElement t = e.findElement(By.className(className));

            if(!t.getText().toLowerCase().contains(filterValue.toLowerCase()) && !t.getText().toLowerCase().contains("all"))
            {
                valid = false;
                break;
            }
        }

        Assert.assertTrue(filterType + " doesn't contains " + filterValue.toLowerCase(), valid);
    }

    public void downloadFile() throws InterruptedException
    {
        TestUtils.deleteFile(DRIVER_TYPES_CSV_FILE_LOCATION);
        click(String.format("//div[@filename='%s']/nv-api-text-button/button", DRIVER_TYPES_CSV_FILE_NAME));
        pause1s();
    }

    public void verifyFile() throws InterruptedException
    {
        File file = new File(DRIVER_TYPES_CSV_FILE_LOCATION);
        int counter = 0;
        boolean isFileExists;

        do
        {
            isFileExists = file.exists();

            if(!isFileExists)
            {
                pause1s();
            }

            counter++;
        }
        while(!isFileExists && counter<MAX_RETRY);

        TestUtils.deleteFile(file);
        Assert.assertTrue(DRIVER_TYPES_CSV_FILE_LOCATION + " not exist", isFileExists);
    }

    public void clickDriverTypeButton() throws InterruptedException
    {
        click("//button[@aria-label='Create Driver Type']");
        pause1s();

        SingletonStorage.getInstance().setTmpId(String.format("QA Testing %s", new SimpleDateFormat("yyyyMMddHH24mmss").format(new Date())));
        sendKeys("//input[@type='text'][@aria-label='Name']", SingletonStorage.getInstance().getTmpId());
        pause1s();

        click("//button[@aria-label='Save Button']");
        waitUntilInvisibilityOfElementLocated("//button[@aria-label='Save Button']//md-progress-circular");
    }

    public void verifyDriverType() throws InterruptedException
    {
        searchingCreatedDriver();
        boolean isFound = false;

        List<WebElement> elm = findElementsByXpath("//tr[@md-virtual-repeat='driverTypeProp in ctrl.tableData']");

        for(WebElement e : elm)
        {
            List<WebElement> tds = e.findElements(By.tagName("td"));

            for(WebElement td : tds)
            {
                if(td.getText().equalsIgnoreCase(SingletonStorage.getInstance().getTmpId()))
                {
                    isFound = true;
                    break;
                }
            }
        }

        Assert.assertTrue(isFound);
    }

    public void searchingCreatedDriver() throws InterruptedException
    {
        sendKeys("//input[@placeholder='Search Driver Types...'][@ng-model='searchText']", SingletonStorage.getInstance().getTmpId());
        pause1s();
    }

    public void searchingCreatedDriverEdit() throws InterruptedException
    {
        searchingCreatedDriver();

        click("//tr[@md-virtual-repeat='driverTypeProp in ctrl.tableData']/td[9]/nv-icon-button[1]");
        pause1s();

        click("//button[@class='button-group-button md-button md-nvBlue-theme md-ink-ripple'][@aria-label='C2C + Return Pick Up']");
        pause1s();

        click("//button[@aria-label='Save Button']");
        waitUntilInvisibilityOfElementLocated("//button[@aria-label='Save Button']//md-progress-circular");
    }

    public void verifyChangesCreatedDriver()
    {
        boolean isFound = false;
        List<WebElement> elm = findElementsByXpath("//tr[@md-virtual-repeat='driverTypeProp in ctrl.tableData']");

        for(WebElement e : elm)
        {
            List<WebElement> tds = e.findElements(By.tagName("td"));

            for(WebElement td : tds)
            {
                if(td.getText().equalsIgnoreCase("Normal Delivery, C2C + Return Pick Up"))
                {
                    isFound = true;
                    break;
                }
            }
        }

        Assert.assertTrue("Driver type is not found.", isFound);
    }

    public void deletedCreatedDriver() throws InterruptedException
    {
        click("//tr[@md-virtual-repeat='driverTypeProp in ctrl.tableData']/td[9]/nv-icon-button[2]");
        pause1s();

        click("//md-dialog[@aria-label='Confirm deleteAre you ...']/md-dialog-actions/button[2]");
        pause1s();
    }

    public void createdDriverShouldNotExist()
    {
        List<WebElement> elm = findElementsByXpath("//tr[@md-virtual-repeat='driverTypeProp in ctrl.tableData']");
        Assert.assertTrue(elm.size() == 0);
    }
}
