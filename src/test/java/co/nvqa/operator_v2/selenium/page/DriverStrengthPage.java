package co.nvqa.operator_v2.selenium.page;

import co.nvqa.commons.support.DateUtil;
import co.nvqa.commons.utils.NvLogger;
import co.nvqa.operator_v2.util.SingletonStorage;
import co.nvqa.operator_v2.util.TestConstants;
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
    public static final String COLUMN_CLASS_USERNAME = "username";
    public static final String COLUMN_CLASS_DRIVER_TYPE = "driver-type";
    public static final String COLUMN_CLASS_ZONE = "zone-preferences-zone-id";

    private final static String FILENAME = "drivers.csv";
    private String driverType;
    private String zone;

    public DriverStrengthPage(WebDriver webDriver)
    {
        super(webDriver);
    }

    public void downloadFile()
    {
        click("//button[@filename='" + FILENAME + "']");
    }

    public void verifyDownloadedFile()
    {
        File f = new File(TestConstants.TEMP_DIR + FILENAME);
        boolean isFileExisted = f.exists();

        if(isFileExisted)
        {
            f.delete();
        }

        Assert.assertTrue(isFileExisted);
    }

    public void filteredBy(String type)
    {
        String filterKey;

        if("zone".equals(type))
        {
            filterKey = zone!=null ? zone : "z-out of zone";
            sendKeys("//th[contains(@class, 'zone-preferences-zone-id')]/nv-search-input-filter/md-input-container/div/input", filterKey);
        }
        else if("driver-type".equals(type))
        {
            filterKey = driverType!=null ? driverType : "Ops";
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
        catch(Exception ex)
        {
            NvLogger.warn("An error occurred when getting 'Driver Type' and 'Zone' from table.");
        }
    }

    public void searchDriver()
    {
        String driverUsername = "D"+ SingletonStorage.getInstance().getTmpId();
        clickNvIconTextButtonByNameAndWaitUntilDone("container.driver-strength.load-everything");
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

    public void changeComingStatus()
    {
        WebElement firstDriver = findElementsByXpath("//tr[@md-virtual-repeat='driver in getTableData()']").get(0);
        String before = getComingStatusState(firstDriver);
        changeComingStatusState(firstDriver);
        String after = getComingStatusState(firstDriver);
        Assert.assertTrue(!before.equals(after));
    }

    public void clickViewContactButton()
    {
        click("//tr[@md-virtual-repeat='driver in getTableData()']/td[contains(@class, 'actions column-locked-right')]/md-menu/button");
        pause1s();

        String expectedLicensoNo = "D" + SingletonStorage.getInstance().getTmpId();
        String actualLicenseNo = getText("//div[@aria-hidden='false']/md-menu-content/md-menu-item[@class='contact-info-details' and @role='menuitem']/div[2]/div[2]");
        Assert.assertEquals("License No. is not equal.", expectedLicensoNo, actualLicenseNo);
        closeModal();
    }

    public void clickAddNewDriver()
    {
        clickNvIconTextButtonByName("Add New Driver");
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
        clickButtonByAriaLabel("Add More Vehicles");
        sendKeys("//input[@type='text'][@aria-label='License Number']", "D"+tmpId);
        sendKeys("//input[@type='number'][@aria-label='Vehicle Capacity']", "100");

        /**
         * Add contact.
         */
        clickButtonByAriaLabel("Add More Contacts");
        sendKeys("//input[@type='text'][@aria-label='Contact']", "D"+tmpId+"@NV.CO");

        /**
         * Add zone.
         */
        clickButtonByAriaLabel("Add More Zones");
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
        clickNvButtonSaveByNameAndWaitUntilDone("Submit");
    }

    public void verifyNewDriver()
    {
        String expectedUsername = "D"+ SingletonStorage.getInstance().getTmpId();

        clickNvIconTextButtonByNameAndWaitUntilDone("container.driver-strength.load-everything");
        sendKeys("//th[contains(@class, 'username')]/nv-search-input-filter/md-input-container/div/input", expectedUsername);

        String actualUsername = getTextOnTable(1, COLUMN_CLASS_USERNAME);
        Assert.assertEquals(expectedUsername, actualUsername);
    }

    public void searchingNewDriver()
    {
        String driverUsername = "D"+ SingletonStorage.getInstance().getTmpId();
        clickNvIconTextButtonByNameAndWaitUntilDone("container.driver-strength.load-everything");
        sendKeys("//th[contains(@class, 'username')]/nv-search-input-filter/md-input-container/div/input", driverUsername);
    }

    public void editNewDriver()
    {
        click("//tr[@md-virtual-repeat='driver in getTableData()']/td[contains(@class, 'actions column-locked-right')]/nv-icon-button[1]/button");
        pause1s();
        sendKeys("//textarea[@aria-label='Comments']", "This driver is created by \"Automation Test\" for testing purpose. [EDITED]");
        sendKeys("//input[@type='number'][@aria-label='Vehicle Capacity']", "1000");
        clickNvButtonSaveByNameAndWaitUntilDone("Submit");
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

        String expectedDriverUsername = "D"+ SingletonStorage.getInstance().getTmpId();
        String actualDriverUsername = getTextOnTable(1, COLUMN_CLASS_USERNAME);
        Assert.assertNotEquals(expectedDriverUsername, actualDriverUsername);
    }

    private void changeComingStatusState(WebElement el)
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
