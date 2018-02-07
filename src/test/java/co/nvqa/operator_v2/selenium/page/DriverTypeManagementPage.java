package co.nvqa.operator_v2.selenium.page;

import org.junit.Assert;
import org.openqa.selenium.By;
import org.openqa.selenium.TimeoutException;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;

import java.util.List;

/**
 *
 * @author Soewandi Wirjawan
 */
public class DriverTypeManagementPage extends OperatorV2SimplePage
{
    private static final String MD_VIRTUAL_REPEAT = "driverTypeProp in ctrl.tableData";
    private static final String XPATH_OF_TR_MD_VIRTUAL_REPEAT = String.format("//tr[@md-virtual-repeat='%s']", MD_VIRTUAL_REPEAT);
    private static final String CSV_FILENAME_PATTERN = "driver-types";
    private static final String COLUMN_CLASS_NAME = "name";

    private static final String ACTION_BUTTON_EDIT = "Edit";
    private static final String ACTION_BUTTON_DELETE = "Delete";

    public DriverTypeManagementPage(WebDriver webDriver)
    {
        super(webDriver);
    }

    public void filteredBy(String filterValue, String filterType)
    {
        clickButtonByAriaLabel(filterValue);
        pause1s();

        // Get counter.
        String counter = getText("//ng-pluralize[@class='nv-p-med count']").split(" ")[0];

        if(Integer.parseInt(counter)==0)
        {
            return;
        }

        String[] tokens = filterType.toLowerCase().split(" ");
        String className = tokens.length==2 ? tokens[0]+"-"+tokens[1] : tokens[0];

        boolean valid = true;
        List<WebElement> elm = findElementsByXpath(XPATH_OF_TR_MD_VIRTUAL_REPEAT);

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

    public void downloadFile()
    {
        clickNvApiTextButtonByName("Download CSV File");
    }

    public void verifyFile()
    {
        verifyFileDownloadedSuccessfully(getLatestDownloadedFilename(CSV_FILENAME_PATTERN));
    }

    public void createDriverType(String driverTypeName)
    {
        clickButtonByAriaLabel("Create Driver Type");
        pause1s();

        sendKeysByAriaLabel("Name", driverTypeName);
        pause1s();

        clickNvButtonSaveByName("Submit");
    }

    public void verifyDriverType(String expectedDriverTypeName)
    {
        searchingCreatedDriver(expectedDriverTypeName);
        String actualDriverTypeName = getTextOnTable(1, COLUMN_CLASS_NAME);
        Assert.assertEquals("Driver Type Name", expectedDriverTypeName, actualDriverTypeName);
    }

    public void searchingCreatedDriver(String driverTypeName)
    {
        searchTable(driverTypeName);
        pause1s();
    }

    public void searchingCreatedDriverEdit(String driverTypeName)
    {
        searchingCreatedDriver(driverTypeName);

        clickActionButtonOnTable(1, ACTION_BUTTON_EDIT);
        pause1s();

        clickButtonOnMdDialogByAriaLabel("C2C + Return Pick Up");
        pause1s();

        clickNvButtonSaveByNameAndWaitUntilDone("Submit Changes");
    }

    public void verifyChangesCreatedDriver()
    {
        boolean isFound = false;
        List<WebElement> elm = findElementsByXpath(XPATH_OF_TR_MD_VIRTUAL_REPEAT);

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

    public void deletedCreatedDriver()
    {
        clickActionButtonOnTable(1, ACTION_BUTTON_DELETE);
        pause1s();

        clickButtonOnMdDialogByAriaLabel("Delete");
        pause1s();
    }

    public void createdDriverShouldNotExist()
    {
        try
        {
            findElementsByXpathFast(XPATH_OF_TR_MD_VIRTUAL_REPEAT);
            Assert.fail("Driver still exists on table.");
        }
        catch(TimeoutException ex)
        {
        }
    }

    public String getTextOnTable(int rowNumber, String columnDataClass)
    {
        return getTextOnTable(rowNumber, columnDataClass, MD_VIRTUAL_REPEAT);
    }

    public void clickActionButtonOnTable(int rowNumber, String actionButtonName)
    {
        clickActionButtonOnTableWithMdVirtualRepeat(rowNumber, actionButtonName, MD_VIRTUAL_REPEAT);
    }
}
