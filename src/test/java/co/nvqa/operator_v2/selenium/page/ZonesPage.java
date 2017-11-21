package co.nvqa.operator_v2.selenium.page;

import co.nvqa.operator_v2.model.Zone;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;

/**
 *
 * @author Daniel Joi Partogi Hutapea
 */
public class ZonesPage extends SimplePage
{
    private static final String NG_REPEAT = "zone in getTableData()";
    private static final String CSV_FILENAME = "station.csv";

    public static final String COLUMN_CLASS_SHORT_NAME = "short_name";

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
        sendKeysById("commons.name", zone.getName());
        sendKeysById("commons.short-name", zone.getShortName());
        selectValueFromMdSelectMenu("//md-input-container[@label='commons.hub']", String.format("//md-option/div[@class='md-text'][contains(text(), '%s')]", zone.getHubName()));
        sendKeysById("commons.latitude", String.valueOf(zone.getLatitude()));
        sendKeysById("commons.longitude", String.valueOf(zone.getLongitude()));
        sendKeysById("commons.description", zone.getDescription());
        clickNvApiTextButtonByNameAndWaitUntilDone("Submit");
    }

    public void searchTableByName(String name)
    {
        searchTable("name", name);
    }

    public void searchTableByAddress(String address)
    {
        searchTable("_address", address);
    }

    public void searchTableByLatLong(String latLong)
    {
        searchTable("_latlng", latLong);
    }

    private void searchTable(String filterColumnClass, String value)
    {
        sendKeys(String.format("//th[contains(@class, '%s')]/nv-search-input-filter/md-input-container/div/input", filterColumnClass), value);
        pause100ms();
    }

    public boolean isTableEmpty()
    {
        WebElement we = findElementByXpath("//h5[text()='No Results Found']");
        return we!=null;
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
