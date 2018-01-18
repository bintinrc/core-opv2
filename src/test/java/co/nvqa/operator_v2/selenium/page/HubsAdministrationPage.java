package co.nvqa.operator_v2.selenium.page;

import co.nvqa.operator_v2.model.HubsAdministration;
import org.junit.Assert;
import org.openqa.selenium.WebDriver;

/**
 *
 * @author Daniel Joi Partogi Hutapea
 */
public class HubsAdministrationPage extends SimplePage
{
    private static final String NG_REPEAT = "hub in $data";
    private static final String CSV_FILENAME = "hubs.csv";

    public static final String COLUMN_CLASS_NAME = "name";
    public static final String COLUMN_CLASS_LAT_LONG = "latlng";

    private static final String ACTION_BUTTON_EDIT = "Edit";

    public HubsAdministrationPage(WebDriver webDriver)
    {
        super(webDriver);
    }

    public void downloadCsvFile()
    {
        clickNvApiTextButtonByName("Download CSV File");
    }

    public void verifyCsvFileDownloadedSuccessfully()
    {
        verifyFileDownloadedSuccessfully(CSV_FILENAME);
    }

    public void clickButtonAddHub()
    {
        clickNvIconTextButtonByName("Add Hub");
    }

    public void editHub(HubsAdministration hubsAdministration, HubsAdministration hubsAdministrationEdited)
    {
        searchTableByName(hubsAdministration);
        clickActionButtonOnTable(1, ACTION_BUTTON_EDIT);

        sendKeysById("hub-name", hubsAdministrationEdited.getName());
        sendKeysById("latitude", String.valueOf(hubsAdministrationEdited.getLatitude()));
        sendKeysById("longitude", String.valueOf(hubsAdministrationEdited.getLongitude()));
        clickNvButtonSaveByNameAndWaitUntilDone("Submit Changes");
    }

    public void fillTheForm(HubsAdministration hubsAdministration)
    {
        sendKeysById("hub-name", hubsAdministration.getName());
        sendKeysById("latitude", String.valueOf(hubsAdministration.getLatitude()));
        sendKeysById("longitude", String.valueOf(hubsAdministration.getLongitude()));
        clickNvButtonSaveByNameAndWaitUntilDone("Submit");
    }

    public void verifyHubIsExistAndDataIsCorrect(HubsAdministration hubsAdministration)
    {
        searchTableByName(hubsAdministration);

        String actualName = getTextOnTable(1, COLUMN_CLASS_NAME);
        Assert.assertEquals("Hub Name", hubsAdministration.getName(), actualName);

        String expectedLatLong = "("+hubsAdministration.getLatitude()+", "+hubsAdministration.getLongitude()+")";
        String actualLatLong = getTextOnTable(1, COLUMN_CLASS_LAT_LONG);
        Assert.assertEquals("Hub Lat/Long", expectedLatLong, actualLatLong);
    }

    public void searchTableByName(HubsAdministration hubsAdministration)
    {
        searchTable(hubsAdministration.getName());
        pause1s();
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
