package co.nvqa.operator_v2.selenium.page;

import co.nvqa.commons.model.core.hub.Hub;
import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.TextBox;
import co.nvqa.operator_v2.selenium.elements.md.MdDialog;
import co.nvqa.operator_v2.selenium.elements.md.MdSelect;
import co.nvqa.operator_v2.selenium.elements.nv.NvApiTextButton;
import co.nvqa.operator_v2.selenium.elements.nv.NvButtonSave;
import co.nvqa.operator_v2.selenium.elements.nv.NvIconButton;
import co.nvqa.operator_v2.selenium.elements.nv.NvIconTextButton;
import com.google.common.collect.ImmutableMap;
import org.apache.commons.lang3.StringUtils;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;

import java.util.Optional;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import static co.nvqa.operator_v2.selenium.page.FacilitiesManagementPage.HubsTable.*;

/**
 * @author Daniel Joi Partogi Hutapea
 */
@SuppressWarnings("WeakerAccess")
public class FacilitiesManagementPage extends OperatorV2SimplePage
{
    private static final String CSV_FILENAME = "hubs.csv";

    @FindBy(xpath = "//div[text()='Loading hubs...']")
    public PageElement loadingHubsLabel;

    @FindBy(name = "commons.refresh")
    public NvIconButton refresh;

    @FindBy(name = "Add Hub")
    public NvIconTextButton addHub;

    @FindBy(name = "Download CSV File")
    public NvApiTextButton downloadCsvFile;

    @FindBy(css = "md-dialog")
    public AddHubDialog addHubDialog;

    @FindBy(css = "md-dialog")
    public ConfirmDeactivationDialog confirmDeactivationDialog;

    @FindBy(css = "md-dialog")
    public ConfirmActivationDialog confirmActivationDialog;

    public HubsTable hubsTable;

    public FacilitiesManagementPage(WebDriver webDriver)
    {
        super(webDriver);
        hubsTable = new HubsTable(webDriver);
    }

    public void verifyCsvFileDownloadedSuccessfullyAndContainsCorrectInfo(Hub hub)
    {
        String hubName = hub.getName();
        verifyFileDownloadedSuccessfully(CSV_FILENAME, hubName);
    }

    public void createNewHub(Hub hub)
    {
        loadingHubsLabel.waitUntilInvisible();
        addHub.click();
        addHubDialog.hubName.setValue(hub.getName());
        addHubDialog.displayName.setValue(hub.getShortName());
        if (StringUtils.isNotBlank(hub.getFacilityType()))
        {
            addHubDialog.facilityType.selectValue(hub.getFacilityType());
        }
        addHubDialog.city.setValue(hub.getCity());
        addHubDialog.country.setValue(hub.getCountry());
        addHubDialog.latitude.setValue(String.valueOf(hub.getLatitude()));
        addHubDialog.longitude.setValue(String.valueOf(hub.getLongitude()));
        addHubDialog.submit.clickAndWaitUntilDone();
        addHubDialog.waitUntilInvisible();
    }

    public void updateHub(String searchHubsKeyword, Hub hub)
    {
        loadingHubsLabel.waitUntilInvisible();
        hubsTable.filterByColumn(COLUMN_NAME, searchHubsKeyword);
        assertFalse(f("Table is empty. Hub with keywords = '%s' not found.", searchHubsKeyword), hubsTable.isEmpty());
        hubsTable.clickActionButton(1, ACTION_EDIT);

        Optional.ofNullable(hub.getName()).ifPresent(value -> sendKeysById("container.hub-list.hub-name", value));
        Optional.ofNullable(hub.getShortName()).ifPresent(value -> sendKeysById("container.hub-list.display-name", value));
        Optional.ofNullable(hub.getCity()).ifPresent(value -> sendKeysById("container.hub-list.city", value));
        Optional.ofNullable(hub.getCountry()).ifPresent(value -> sendKeysById("container.hub-list.country", value));
        Optional.ofNullable(hub.getLatitude()).ifPresent(value -> sendKeysById("container.hub-list.latitude", String.valueOf(value)));
        Optional.ofNullable(hub.getLongitude()).ifPresent(value -> sendKeysById("container.hub-list.longitude", String.valueOf(value)));
        clickNvButtonSaveByNameAndWaitUntilDone("Submit Changes");
    }

    public void disableHub(String searchHubsKeyword)
    {
        hubsTable.filterByColumn(COLUMN_NAME, searchHubsKeyword);
        hubsTable.clickActionButton(1, ACTION_DISABLE);
        confirmDeactivationDialog.waitUntilVisible();
        confirmDeactivationDialog.disable.click();
        confirmDeactivationDialog.waitUntilInvisible();
    }

    public void activateHub(String searchHubsKeyword)
    {
        hubsTable.filterByColumn(COLUMN_NAME, searchHubsKeyword);
        hubsTable.clickActionButton(1, ACTION_ACTIVATE);
        confirmActivationDialog.waitUntilVisible();
        confirmActivationDialog.activate.click();
        confirmActivationDialog.waitUntilInvisible();
    }

    public Hub searchHub(String searchHubsKeyword)
    {
        hubsTable.filterByColumn(COLUMN_NAME, searchHubsKeyword);
        assertFalse(String.format("Table is empty. Hub with keywords = '%s' not found.", searchHubsKeyword), hubsTable.isEmpty());
        return hubsTable.readEntity(1);
    }

    public void verifyHubIsExistAndDataIsCorrect(Hub expectedHub)
    {
        Hub actualHub = searchHub(expectedHub.getName());
        expectedHub.setId(actualHub.getId());
        expectedHub.compareWithActual(actualHub, "createdAt", "updatedAt", "deletedAt");
    }

    public static class HubsTable extends MdVirtualRepeatTable<Hub>
    {
        private static final Pattern LATLONG_PATTERN = Pattern.compile(".*?([\\d\\.]+).*?([\\d\\.]+).*");
        public static final String COLUMN_NAME = "name";
        public static final String COLUMN_LATITUDE = "latitude";
        public static final String COLUMN_LONGITUDE = "longitude";
        public static final String COLUMN_ACTIVE = "active";
        public static final String ACTION_EDIT = "Edit";
        public static final String ACTION_ACTIVATE = "Activate";
        public static final String ACTION_DISABLE = "Disable";

        public HubsTable(WebDriver webDriver)
        {
            super(webDriver);
            setMdVirtualRepeat("hub in getTableData()");
            setColumnLocators(ImmutableMap.<String, String>builder()
                    .put("id", "id")
                    .put(COLUMN_NAME, "name")
                    .put("shortName", "short-name")
                    .put("city", "city")
                    .put("region", "region")
                    .put("area", "area")
                    .put("country", "country")
                    .put(COLUMN_LATITUDE, "_latlng")
                    .put(COLUMN_LONGITUDE, "_latlng")
                    .put("facilityType", "_facility-type")
                    .put(COLUMN_ACTIVE, "_active")
                    .build()
            );
            setColumnValueProcessors(ImmutableMap.of(
                    COLUMN_LATITUDE, value ->
                    {
                        Matcher m = LATLONG_PATTERN.matcher(value);
                        return m.matches() ? m.group(1) : null;
                    },
                    COLUMN_LONGITUDE, value ->
                    {
                        Matcher m = LATLONG_PATTERN.matcher(value);
                        return m.matches() ? m.group(2) : null;
                    },
                    COLUMN_ACTIVE, value -> String.valueOf(StringUtils.equalsIgnoreCase("active", value))
            ));
            setActionButtonsLocators(ImmutableMap.of(ACTION_EDIT, "commons.edit", ACTION_ACTIVATE, "//nv-icon-text-button[@name='commons.activate']", ACTION_DISABLE, "//nv-icon-text-button[@name='commons.disable']"));
            setEntityClass(Hub.class);
        }
    }

    public static class AddHubDialog extends MdDialog
    {
        public AddHubDialog(WebDriver webDriver, WebElement webElement)
        {
            super(webDriver, webElement);
        }

        @FindBy(css = "[id^='container.hub-list.hub-name']")
        public TextBox hubName;

        @FindBy(css = "[id^='container.hub-list.display-name']")
        public TextBox displayName;

        @FindBy(css = "[id='container.hub-list.facility-type']")
        public MdSelect facilityType;

        @FindBy(css = "[id^='container.hub-list.city']")
        public TextBox city;

        @FindBy(css = "[id^='container.hub-list.country']")
        public TextBox country;

        @FindBy(css = "[id^='container.hub-list.latitude']")
        public TextBox latitude;

        @FindBy(css = "[id^='container.hub-list.longitude']")
        public TextBox longitude;

        @FindBy(name = "Submit")
        public NvButtonSave submit;
    }

    public static class ConfirmDeactivationDialog extends MdDialog
    {
        public ConfirmDeactivationDialog(WebDriver webDriver, WebElement webElement)
        {
            super(webDriver, webElement);
        }

        @FindBy(css = "button[aria-label='Disable']")
        public Button disable;
    }

    public static class ConfirmActivationDialog extends MdDialog
    {
        public ConfirmActivationDialog(WebDriver webDriver, WebElement webElement)
        {
            super(webDriver, webElement);
        }

        @FindBy(css = "button[aria-label='Activate']")
        public Button activate;
    }
}