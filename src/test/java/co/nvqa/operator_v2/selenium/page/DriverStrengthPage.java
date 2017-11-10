package co.nvqa.operator_v2.selenium.page;

import co.nvqa.operator_v2.util.SingletonStorage;
import co.nvqa.operator_v2.util.TestConstants;
import com.nv.qa.support.DateUtil;
import org.junit.Assert;
import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;

import java.io.File;
import java.util.List;

/**
 *
 * @author Soewandi Wirjawan
 */
public class DriverStrengthPage extends SimplePage
{
    public static final String COLUMN_CLASS_NAME = "name";
    public static final String COLUMN_CLASS_DRIVER_TYPE = "driver-type";
    public static final String COLUMN_CLASS_ZONE = "zone-preferences-zone-id ";

    private final static String FILENAME = "drivers.csv";
    private String driverType;
    private String zone;

    public DriverStrengthPage(WebDriver webDriver)
    {
        super(webDriver);
    }

    public void downloadFile() throws InterruptedException
    {
        click("//button[@filename='" + FILENAME + "']");
    }

    public void verifyDownloadedFile()
    {
        File f = new File(TestConstants.SELENIUM_WRITE_PATH + FILENAME);
        boolean isFileExisted = f.exists();

        if(isFileExisted)
        {
            f.delete();
        }

        Assert.assertTrue(isFileExisted);
    }

    public void filteredBy(String type) throws InterruptedException
    {
        String filterKey = null;

        if(type.equals("zone"))
        {
            filterKey = zone != null ? zone : "z-out of zone";
            sendKeys("//th[contains(@class, 'zone-preferences-zone-id')]/nv-search-input-filter/md-input-container/div/input", filterKey);
        }
        else if(type.equals("driver-type"))
        {
            filterKey = driverType != null ? driverType : "Ops";
            sendKeys("//th[contains(@class, 'driver-type')]/nv-search-input-filter/md-input-container/div/input", filterKey);
        }

        List<WebElement> listDriver = findElementsByXpath("//tr[@md-virtual-repeat='driver in getTableData()']");
        pause100ms();
        Assert.assertTrue(listDriver.size() > 0);
    }

    public void findZoneAndType()
    {
        try
        {
            pause100ms();
            driverType = getTextOnTable(1, COLUMN_CLASS_DRIVER_TYPE);
            zone = getTextOnTable(1, COLUMN_CLASS_ZONE);
        }
        catch(Exception e)
        {
        }
    }

    public void searchDriver() throws InterruptedException
    {
        String driverUsername = "D"+ SingletonStorage.getInstance().getTmpId();
        click("//button[@aria-label='Load Everything']");
        sendKeys("//th[contains(@class, 'username')]/nv-search-input-filter/md-input-container/div/input", driverUsername);
    }

    public void verifyDriver()
    {
        boolean isFound = false;

        List<WebElement> listDriver = findElementsByXpath("//tr[@md-virtual-repeat='driver in getTableData()']");

        for(WebElement d : listDriver)
        {
            List<WebElement> el = d.findElements(By.tagName("td"));

            for(WebElement e : el)
            {
                if(e.getText().trim().length() > 0)
                {
                    if(e.getText().trim().equalsIgnoreCase("Driver " + SingletonStorage.getInstance().getTmpId()))
                    {
                        isFound = true;
                        break;
                    }
                }
            }
        }

        Assert.assertTrue(isFound);
    }

    public void changeComingStatus() throws InterruptedException
    {
        WebElement firstDriver = findElementsByXpath("//tr[@md-virtual-repeat='driver in getTableData()']").get(0);
        String before = getComingStatusState(firstDriver);
        changeComingStatusState(firstDriver);
        String after = getComingStatusState(firstDriver);
        Assert.assertTrue(!before.equals(after));
    }

    public void clickViewContactButton() throws InterruptedException
    {
        click("//tr[@md-virtual-repeat='driver in getTableData()']/td[contains(@class, 'actions column-locked-right')]/md-menu/button");
        pause1s();

        String expectedLicensoNo = "D" + SingletonStorage.getInstance().getTmpId();
        WebElement licenseNoWe = findElementByXpath("//div[@aria-hidden='false']/md-menu-content/md-menu-item[@class='contact-info-details' and @role='menuitem']/div[2]/div[2]");
        Assert.assertEquals("License No. is not equal.", expectedLicensoNo, licenseNoWe.getText());
        closeModal();
    }

    public void clickAddNewDriver()
    {
        click("//button[@aria-label='Add New Driver']");
        pause1s();
    }

    public void enterDefaultValue()
    {
        String tmpId = DateUtil.getTimestamp();
        SingletonStorage.getInstance().setTmpId(tmpId);

        sendKeys("//input[@type='text'][@aria-label='First Name']", "Driver");
        sendKeys("//input[@type='text'][@aria-label='Last Name']", tmpId);
        sendKeys("//input[@type='text'][@aria-label='Driver License Number']", "D"+tmpId);
        sendKeys("//input[@type='number'][@aria-label='COD Limit']", "100");

        /**
         * Add vehicle.
         */
        click("//button[@aria-label='Add More Vehicles']");
        sendKeys("//input[@type='text'][@aria-label='License Number']", "D"+tmpId);
        sendKeys("//input[@type='number'][@aria-label='Vehicle Capacity']", "100");

        /**
         * Add contact.
         */
        click("//button[@aria-label='Add More Contacts']");
        sendKeys("//input[@type='text'][@aria-label='Contact']", "D"+tmpId+"@NV.CO");

        /**
         * Add zone.
         */
        click("//button[@aria-label='Add More Zones']");
        sendKeys("//input[@type='number'][@aria-label='Min']", "1");
        sendKeys("//input[@type='number'][@aria-label='Max']", "1");
        sendKeys("//input[@type='number'][@aria-label='Cost']", "1");

        /**
         * Username + password.
         */
        sendKeys("//input[@type='text'][@aria-label='Username']", "D"+tmpId);
        sendKeys("//input[@type='text'][@aria-label='Password']", "D00"+tmpId);

        /**
         * Comments.
         */
        sendKeys("//textarea[@aria-label='Comments']", "This driver is created by \"Automation Test\" for testing purpose.");

        /**
         * Save.
         */
        click("//button[@aria-label='Save Button']");
        pause5s();
    }

    public void verifyNewDriver()
    {
        String expectedUsername = "D"+ SingletonStorage.getInstance().getTmpId();

        click("//button[@aria-label='Load Everything']");
        sendKeys("//th[contains(@class, 'username')]/nv-search-input-filter/md-input-container/div/input", expectedUsername);

        String actualName = getTextOnTable(1, COLUMN_CLASS_NAME);
        Assert.assertEquals(expectedUsername, actualName);
    }

    public void searchingNewDriver()
    {
        String driverUsername = "D"+ SingletonStorage.getInstance().getTmpId();
        click("//button[@aria-label='Load Everything']");
        sendKeys("//th[contains(@class, 'username')]/nv-search-input-filter/md-input-container/div/input", driverUsername);
    }

    public void editNewDriver()
    {
        click("//tr[@md-virtual-repeat='driver in getTableData()']/td[contains(@class, 'actions column-locked-right')]/nv-icon-button[1]/button");
        pause1s();
        sendKeys("//textarea[@aria-label='Comments']", "This driver is created by \"Automation Test\" for testing purpose. [EDITED]");
        sendKeys("//input[@type='number'][@aria-label='Vehicle Capacity']", "1000");
        click("//button[@aria-label='Save Button']");
        pause1s();
        closeModal();
    }

    public void deleteNewDriver()
    {
        click("//tr[@md-virtual-repeat='driver in getTableData()']/td[contains(@class, 'actions column-locked-right')]/nv-icon-button[2]/button");
        pause1s();

        click("//md-dialog/md-dialog-actions/button[@aria-label='Delete']");
        pause1s();
    }

    public void createdDriverShouldNotExist()
    {
        /**
         * Check first row does not contain deleted driver.
         */

        String expectedDriverName = "Driver "+ SingletonStorage.getInstance().getTmpId();
        String actualDriverName = getTextOnTable(1, COLUMN_CLASS_NAME);
        Assert.assertNotEquals(expectedDriverName, actualDriverName);
    }

    private void changeComingStatusState(WebElement el) throws InterruptedException
    {
        pause1s();
        el.findElement(By.xpath("//td[contains(@class, 'availability')]/nv-toggle-button/button")).click();
        pause1s();
    }

    private String getComingStatusState(WebElement el)
    {
        return el.findElement(By.xpath("//td[contains(@class, 'availability')]/nv-toggle-button")).getAttribute("md-theme");
    }

    public String getTextOnTable(int rowNumber, String columnDataClass)
    {
        return getTextOnTable(rowNumber, columnDataClass, "driver in getTableData()");
    }
}
