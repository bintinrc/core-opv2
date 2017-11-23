package co.nvqa.operator_v2.selenium.page;

import co.nvqa.operator_v2.model.Zone;
import co.nvqa.operator_v2.util.TestUtils;
import com.nv.qa.commons.utils.NvLogger;
import org.junit.Assert;
import org.openqa.selenium.TimeoutException;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;

/**
 *
 * @author Daniel Joi Partogi Hutapea
 */
public class ZonesPage extends SimplePage
{
    private static final String NG_REPEAT = "zone in getTableData()";
    private static final String CSV_FILENAME = "zones.csv";
    private static final String XPATH_OF_TOAST_ERROR_MESSAGE = "//div[@id='toast-container']//div[@class='toast-message']/div[@class='toast-right']/div[@class='toast-bottom']/strong[4]";

    public static final String COLUMN_CLASS_SHORT_NAME = "short_name";
    public static final String COLUMN_CLASS_NAME = "name";
    public static final String COLUMN_CLASS_HUB_NAME = "hub-name";
    public static final String COLUMN_CLASS_LAT_LONG = "lat-lng";
    public static final String COLUMN_CLASS_DESCRIPTION = "description";

    public static final String ACTION_BUTTON_EDIT = "commons.edit";
    public static final String ACTION_BUTTON_DELETE = "commons.delete";

    public ZonesPage(WebDriver webDriver)
    {
        super(webDriver);
    }

    public void addZone(Zone zone)
    {
        clickNvIconTextButtonByName("Add Zone");
        waitUntilVisibilityOfElementLocated("//md-dialog[contains(@class, 'zone-form')]");
        fillTheForm(zone);
        clickNvApiTextButtonByNameAndWaitUntilDone("Submit");
    }

    public void editZone(Zone zoneOld, Zone zoneEdited)
    {
        searchTableByNameAndRetryIfTableIsEmpty(zoneOld.getName());

        clickActionButtonOnTable(1, ACTION_BUTTON_EDIT);
        waitUntilVisibilityOfElementLocated("//md-dialog[contains(@class, 'zone-form')]");
        fillTheForm(zoneEdited);

        TestUtils.retryIfRuntimeExceptionOccurred(()->
        {
            clickNvApiTextButtonByNameAndWaitUntilDone("Update");

            try
            {
                WebElement toastErrorMessageWe = waitUntilVisibilityOfElementLocated(XPATH_OF_TOAST_ERROR_MESSAGE, FAST_WAIT_IN_SECONDS);
                String toastErrorMessage = toastErrorMessageWe.getText();
                NvLogger.warnf("Error when updating Zone. Cause: %s", toastErrorMessage);
                waitUntilInvisibilityOfElementLocated(XPATH_OF_TOAST_ERROR_MESSAGE);

                /**
                 * If toast error message found, that's means updated the zone is failed.
                 * Throw runtime exception so the code will retry again until success or max retry is reached.
                 */
                throw new RuntimeException(toastErrorMessage);
            }
            catch(TimeoutException ex)
            {
                /**
                 * If TimeoutException occurred that means the toast error message is not found
                 * and that means zone is updated successfully.
                 */
                NvLogger.infof("Expected exception occurred. Cause: %s", ex.getMessage());
            }
        });
    }

    public void fillTheForm(Zone zone)
    {
        sendKeysById("commons.name", zone.getName());
        sendKeysById("commons.short-name", zone.getShortName());
        selectValueFromMdSelectMenu("//md-input-container[@label='commons.hub']", String.format("//md-option/div[@class='md-text'][contains(text(), '%s')]", zone.getHubName()));
        sendKeysById("commons.latitude", String.valueOf(zone.getLatitude()));
        sendKeysById("commons.longitude", String.valueOf(zone.getLongitude()));
        sendKeysById("commons.description", zone.getDescription());
    }

    public void verifyNewZoneIsCreatedSuccessfully(Zone zone)
    {
        searchTableByNameAndRetryIfTableIsEmpty(zone.getName());
        verifyZoneInfoIsCorrect(zone);
    }

    public void verifyZoneIsUpdatedSuccessfully(Zone zone)
    {
        searchTableByNameAndRetryIfTableIsEmpty(zone.getName());
        verifyZoneInfoIsCorrect(zone);
    }

    private void verifyZoneInfoIsCorrect(Zone zone)
    {
        String actualShortName = getTextOnTable(1, COLUMN_CLASS_SHORT_NAME);
        Assert.assertEquals("Zone Short Name", zone.getShortName(), actualShortName);

        String actualName = getTextOnTable(1, COLUMN_CLASS_NAME);
        Assert.assertEquals("Zone Name", zone.getName(), actualName);

        String actualHubName = getTextOnTable(1, COLUMN_CLASS_HUB_NAME);
        Assert.assertEquals("Zone Hub Name", zone.getHubName(), actualHubName);

        String expectedLatLong = zone.getLatitude()+", "+zone.getLongitude();
        String actualLatLong = getTextOnTable(1, COLUMN_CLASS_LAT_LONG);
        Assert.assertEquals("Zone Lat/Long", expectedLatLong, actualLatLong);

        String actualDescription = getTextOnTable(1, COLUMN_CLASS_DESCRIPTION);
        Assert.assertEquals("Zone Description", zone.getDescription(), actualDescription);
    }

    public void deleteZone(Zone zone)
    {
        TestUtils.retryIfRuntimeExceptionOccurred(()->
        {
            searchTableByNameAndRetryIfTableIsEmpty(zone.getName());

            clickActionButtonOnTable(1, ACTION_BUTTON_DELETE);
            pause100ms();
            click("//md-dialog/md-dialog-actions/button[@aria-label='Delete']");

            try
            {
                WebElement toastErrorMessageWe = waitUntilVisibilityOfElementLocated(XPATH_OF_TOAST_ERROR_MESSAGE, FAST_WAIT_IN_SECONDS);
                String toastErrorMessage = toastErrorMessageWe.getText();
                NvLogger.warnf("Error when deleting Zone. Cause: %s", toastErrorMessage);
                waitUntilInvisibilityOfElementLocated(XPATH_OF_TOAST_ERROR_MESSAGE);

                /**
                 * If toast error message found, that's means deleted the zone is failed.
                 * Throw runtime exception so the code will retry again until success or max retry is reached.
                 */
                throw new RuntimeException(toastErrorMessage);
            }
            catch(TimeoutException ex)
            {
                /**
                 * If TimeoutException occurred that means the toast error message is not found
                 * and that means zone is deleted successfully.
                 */
                NvLogger.infof("Expected exception occurred. Cause: %s", ex.getMessage());
            }
        });
    }

    public void verifyZoneIsDeletedSuccessfully(Zone zone)
    {
        clickRefreshCache();
        searchTableByName(zone.getName());
        boolean isTableEmpty = isTableEmpty();
        Assert.assertTrue("Zone still exist in table. Fail to delete DP Vault.", isTableEmpty);
    }

    public void verifyAllFiltersWorkFine(Zone zone)
    {
        searchTableByName(zone.getName());
        verifyZoneInfoIsCorrect(zone);

        searchTableByShortName(zone.getShortName());
        verifyZoneInfoIsCorrect(zone);

        searchTableByHubName(zone.getHubName());
        verifyZoneInfoIsCorrect(zone);
    }

    public void downloadCsvFile(Zone zone)
    {
        searchTableByNameAndRetryIfTableIsEmpty(zone.getName());
        clickNvApiTextButtonByName("Download CSV File");
    }

    public void verifyCsvFileDownloadedSuccessfully(Zone zone)
    {
        String name = zone.getName();
        String shortName = zone.getShortName();
        String hubName = zone.getHubName();
        String expectedText = String.format("\"%s\",\"%s\",\"%s\"", shortName, name, hubName);
        verifyFileDownloadedSuccessfully(CSV_FILENAME, expectedText);
    }

    public void searchTableByName(String name)
    {
        searchTableCustom2("name", name);
    }

    public void searchTableByShortName(String shortName)
    {
        searchTableCustom2("short_name", shortName);
    }

    public void searchTableByHubName(String hubName)
    {
        searchTableCustom2("hub-name", hubName);
    }

    private void clickRefreshCache()
    {
        clickNvIconButtonByNameAndWaitUntilEnabled("commons.refresh");
    }

    public void searchTableByNameAndRetryIfTableIsEmpty(String name)
    {
        TestUtils.retryIfRuntimeExceptionOccurred(()->
        {
            clickRefreshCache();
            searchTableByName(name);

            if(isTableEmpty())
            {
                throw new RuntimeException(String.format("Zone with name = '%s' not found. Zones table is empty.", name));
            }
        });
    }

    public String getTextOnTable(int rowNumber, String columnDataClass)
    {
        return getTextOnTableWithNgRepeat(rowNumber, columnDataClass, NG_REPEAT);
    }

    public void clickActionButtonOnTable(int rowNumber, String actionButtonName)
    {
        clickActionButtonOnTableWithNgRepeat(rowNumber, actionButtonName, NG_REPEAT);
    }
}
