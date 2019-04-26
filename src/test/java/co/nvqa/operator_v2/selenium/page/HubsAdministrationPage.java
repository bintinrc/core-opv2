package co.nvqa.operator_v2.selenium.page;

import co.nvqa.commons.model.operator_v2.HubsAdministration;
import org.hamcrest.Matchers;
import org.openqa.selenium.WebDriver;

import java.util.Optional;

/**
 *
 * @author Daniel Joi Partogi Hutapea
 */
@SuppressWarnings("WeakerAccess")
public class HubsAdministrationPage extends OperatorV2SimplePage
{
    private static final String NG_REPEAT = "hub in $data";
    private static final String CSV_FILENAME = "hubs.csv";

    public static final String COLUMN_CLASS_DATA_ID = "id";
    public static final String COLUMN_CLASS_DATA_NAME = "name";
    public static final String COLUMN_CLASS_DATA_DISPLAY_NAME = "short-name";
    public static final String COLUMN_CLASS_DATA_CITY = "city";
    public static final String COLUMN_CLASS_DATA_COUNTRY = "country";
    public static final String COLUMN_CLASS_DATA_LAT_LONG = "latlng";

    private static final String ACTION_BUTTON_EDIT = "Edit";

    public HubsAdministrationPage(WebDriver webDriver)
    {
        super(webDriver);
    }

    public void downloadCsvFile()
    {
        clickNvApiTextButtonByNameAndWaitUntilDone("Download CSV File");
    }

    public void verifyCsvFileDownloadedSuccessfullyAndContainsCorrectInfo(HubsAdministration hubsAdministration)
    {
        String hubName = hubsAdministration.getName();
        verifyFileDownloadedSuccessfully(CSV_FILENAME, hubName);
    }

    public void createNewHub(HubsAdministration hubsAdministration)
    {
        waitUntilInvisibilityOfElementLocated("//div[text()='Loading hubs...']");
        clickNvIconTextButtonByName("Add Hub");
        sendKeysById("container.hub-list.hub-name", hubsAdministration.getName());
        sendKeysById("container.hub-list.display-name", hubsAdministration.getDisplayName());
        sendKeysById("container.hub-list.city", hubsAdministration.getCity());
        sendKeysById("container.hub-list.country", hubsAdministration.getCountry());
        sendKeysById("container.hub-list.latitude", String.valueOf(hubsAdministration.getLatitude()));
        sendKeysById("container.hub-list.longitude", String.valueOf(hubsAdministration.getLongitude()));
        clickNvButtonSaveByNameAndWaitUntilDone("Submit");
    }

    public void updateHub(String searchHubsKeyword, HubsAdministration hubsAdministration)
    {
        searchTable(searchHubsKeyword);
        assertFalse(String.format("Table is empty. Hub with keywords = '%s' not found.", searchHubsKeyword), isTableEmpty());
        clickActionButtonOnTable(1, ACTION_BUTTON_EDIT);

        Optional.ofNullable(hubsAdministration.getName()).ifPresent(value -> sendKeysById("container.hub-list.hub-name", value));
        Optional.ofNullable(hubsAdministration.getDisplayName()).ifPresent(value -> sendKeysById("container.hub-list.display-name", value));
        Optional.ofNullable(hubsAdministration.getCity()).ifPresent(value -> sendKeysById("container.hub-list.city", value));
        Optional.ofNullable(hubsAdministration.getCountry()).ifPresent(value -> sendKeysById("container.hub-list.country", value));
        Optional.ofNullable(hubsAdministration.getLatitude()).ifPresent(value -> sendKeysById("container.hub-list.latitude", String.valueOf(value)));
        Optional.ofNullable(hubsAdministration.getLongitude()).ifPresent(value -> sendKeysById("container.hub-list.longitude", String.valueOf(value)));
        clickNvButtonSaveByNameAndWaitUntilDone("Submit Changes");
    }

    public HubsAdministration searchHub(String searchHubsKeyword)
    {
        searchTable(searchHubsKeyword);
        assertFalse(String.format("Table is empty. Hub with keywords = '%s' not found.", searchHubsKeyword), isTableEmpty());

        String id = getTextOnTable(1, COLUMN_CLASS_DATA_ID);
        String actualName = getTextOnTable(1, COLUMN_CLASS_DATA_NAME);
        String actualDisplayName = getTextOnTable(1, COLUMN_CLASS_DATA_DISPLAY_NAME);
        String actualCity = getTextOnTable(1, COLUMN_CLASS_DATA_CITY);
        String actualCountry = getTextOnTable(1, COLUMN_CLASS_DATA_COUNTRY);
        String actualLatLong = getTextOnTable(1, COLUMN_CLASS_DATA_LAT_LONG);

        Double actualLatitude = null;
        Double actualLongitude = null;

        if(actualLatLong!=null && actualLatLong.contains("("))
        {
            actualLatLong = actualLatLong.replaceAll("[()]", "");

            String[] temp = actualLatLong.split(", ");
            actualLatitude = parseDouble(temp[0].trim());
            actualLongitude = parseDouble(temp[1].trim());
        }

        HubsAdministration hubsAdministration = new HubsAdministration();
        hubsAdministration.setId(Long.parseLong(Optional.ofNullable(id).orElse("-1")));
        hubsAdministration.setName(actualName);
        hubsAdministration.setDisplayName(actualDisplayName);
        hubsAdministration.setCity(actualCity);
        hubsAdministration.setCountry(actualCountry);
        hubsAdministration.setLatitude(actualLatitude);
        hubsAdministration.setLongitude(actualLongitude);

        return hubsAdministration;
    }

    public void verifyHubIsExistAndDataIsCorrect(HubsAdministration hubsAdministration)
    {
        HubsAdministration actualHubsAdministration = searchHub(hubsAdministration.getName());

        hubsAdministration.setId(actualHubsAdministration.getId());
        assertEquals("Hub Name", hubsAdministration.getName(), actualHubsAdministration.getName());
        assertEquals("Display Name", hubsAdministration.getDisplayName(), actualHubsAdministration.getDisplayName());
        assertThat("City", actualHubsAdministration.getCity(), Matchers.equalToIgnoringCase(hubsAdministration.getCity()));
        assertThat("Country", actualHubsAdministration.getCountry(), Matchers.equalToIgnoringCase(hubsAdministration.getCountry()));
        assertEquals("Latitude", hubsAdministration.getLatitude(), actualHubsAdministration.getLatitude());
        assertEquals("Longitude", hubsAdministration.getLongitude(), actualHubsAdministration.getLongitude());
    }

    public void searchTable(String keyword)
    {
        super.searchTable(keyword);
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
