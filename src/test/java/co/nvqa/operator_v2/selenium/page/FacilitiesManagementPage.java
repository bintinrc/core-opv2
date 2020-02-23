package co.nvqa.operator_v2.selenium.page;

import co.nvqa.commons.model.operator_v2.FacilitiesManagement;
import co.nvqa.operator_v2.selenium.elements.TextBox;
import co.nvqa.operator_v2.selenium.elements.md.MdSelect;
import co.nvqa.operator_v2.selenium.elements.nv.NvButtonSave;
import org.junit.platform.commons.util.StringUtils;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.support.FindBy;

import java.util.Optional;

/**
 *
 * @author Daniel Joi Partogi Hutapea
 */
@SuppressWarnings("WeakerAccess")
public class FacilitiesManagementPage extends OperatorV2SimplePage
{
    private static final String MD_VIRTUAL_REPEAT = "hub in getTableData()";
    private static final String CSV_FILENAME = "hubs.csv";

    public static final String COLUMN_CLASS_DATA_ID = "id";
    public static final String COLUMN_CLASS_DATA_NAME = "name";
    public static final String COLUMN_CLASS_DATA_DISPLAY_NAME = "short-name";
    public static final String COLUMN_CLASS_DATA_CITY = "city";
    public static final String COLUMN_CLASS_DATA_COUNTRY = "country";
    public static final String COLUMN_CLASS_DATA_LAT_LONG = "_latlng";

    private static final String ACTION_BUTTON_EDIT = "commons.edit";

    @FindBy(css="[id^='container.hub-list.hub-name']")
    public TextBox hubName;

    @FindBy(css="[id^='container.hub-list.display-name']")
    public TextBox displayName;

    @FindBy(css="[id='container.hub-list.facility-type']")
    public MdSelect facilityType;

    @FindBy(css="[id^='container.hub-list.city']")
    public TextBox city;

    @FindBy(css="[id^='container.hub-list.country']")
    public TextBox country;

    @FindBy(css="[id^='container.hub-list.latitude']")
    public TextBox latitude;

    @FindBy(css="[id^='container.hub-list.longitude']")
    public TextBox longitude;

    @FindBy(name="Submit")
    public NvButtonSave submit;

    public FacilitiesManagementPage(WebDriver webDriver)
    {
        super(webDriver);
    }

    public void downloadCsvFile()
    {
        clickNvApiTextButtonByNameAndWaitUntilDone("Download CSV File");
    }

    public void verifyCsvFileDownloadedSuccessfullyAndContainsCorrectInfo(FacilitiesManagement facilitiesManagement)
    {
        String hubName = facilitiesManagement.getName();
        verifyFileDownloadedSuccessfully(CSV_FILENAME, hubName);
    }

    public void createNewHub(FacilitiesManagement facilitiesManagement)
    {
        waitUntilInvisibilityOfElementLocated("//div[text()='Loading hubs...']");
        clickNvIconTextButtonByName("Add Hub");
        hubName.setValue(facilitiesManagement.getName());
        displayName.setValue(facilitiesManagement.getDisplayName());
        if (StringUtils.isNotBlank(facilitiesManagement.getType())){
            facilityType.selectValue(facilitiesManagement.getType());
        }
        city.setValue(facilitiesManagement.getCity());
        country.setValue(facilitiesManagement.getCountry());
        latitude.setValue(String.valueOf(facilitiesManagement.getLatitude()));
        longitude.setValue(String.valueOf(facilitiesManagement.getLongitude()));
        submit.clickAndWaitUntilDone();
    }

    public void updateHub(String searchHubsKeyword, FacilitiesManagement facilitiesManagement)
    {
        searchTable(searchHubsKeyword);
        assertFalse(String.format("Table is empty. Hub with keywords = '%s' not found.", searchHubsKeyword), isTableEmpty());
        clickActionButtonOnTable(1, ACTION_BUTTON_EDIT);

        Optional.ofNullable(facilitiesManagement.getName()).ifPresent(value -> sendKeysById("container.hub-list.hub-name", value));
        Optional.ofNullable(facilitiesManagement.getDisplayName()).ifPresent(value -> sendKeysById("container.hub-list.display-name", value));
        Optional.ofNullable(facilitiesManagement.getCity()).ifPresent(value -> sendKeysById("container.hub-list.city", value));
        Optional.ofNullable(facilitiesManagement.getCountry()).ifPresent(value -> sendKeysById("container.hub-list.country", value));
        Optional.ofNullable(facilitiesManagement.getLatitude()).ifPresent(value -> sendKeysById("container.hub-list.latitude", String.valueOf(value)));
        Optional.ofNullable(facilitiesManagement.getLongitude()).ifPresent(value -> sendKeysById("container.hub-list.longitude", String.valueOf(value)));
        clickNvButtonSaveByNameAndWaitUntilDone("Submit Changes");
    }

    public FacilitiesManagement searchHub(String searchHubsKeyword)
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

        FacilitiesManagement facilitiesManagement = new FacilitiesManagement();
        facilitiesManagement.setId(Long.parseLong(Optional.ofNullable(id).orElse("-1")));
        facilitiesManagement.setName(actualName);
        facilitiesManagement.setDisplayName(actualDisplayName);
        facilitiesManagement.setCity(actualCity);
        facilitiesManagement.setCountry(actualCountry);
        facilitiesManagement.setLatitude(actualLatitude);
        facilitiesManagement.setLongitude(actualLongitude);

        return facilitiesManagement;
    }

    public void verifyHubIsExistAndDataIsCorrect(FacilitiesManagement facilitiesManagement)
    {
        FacilitiesManagement actualFacilitiesManagement = searchHub(facilitiesManagement.getName());

        facilitiesManagement.setId(actualFacilitiesManagement.getId());
        assertEquals("Hub Name", facilitiesManagement.getName(), actualFacilitiesManagement.getName());
        assertEquals("Display Name", facilitiesManagement.getDisplayName(), actualFacilitiesManagement.getDisplayName());
        assertThat("City", actualFacilitiesManagement.getCity(), equalToIgnoringCase(facilitiesManagement.getCity()));
        assertThat("Country", actualFacilitiesManagement.getCountry(), equalToIgnoringCase(facilitiesManagement.getCountry()));
        assertEquals("Latitude", facilitiesManagement.getLatitude(), actualFacilitiesManagement.getLatitude());
        assertEquals("Longitude", facilitiesManagement.getLongitude(), actualFacilitiesManagement.getLongitude());
    }

    public void searchTable(String hubName)
    {
        searchTableCustom2("name", hubName);
    }

    public String getTextOnTable(int rowNumber, String columnDataClass)
    {
        return getTextOnTableWithMdVirtualRepeat(rowNumber, columnDataClass, MD_VIRTUAL_REPEAT);
    }

    public void clickActionButtonOnTable(int rowNumber, String actionButtonName)
    {
        clickActionButtonOnTableWithMdVirtualRepeat(rowNumber, actionButtonName, MD_VIRTUAL_REPEAT);
    }
}
