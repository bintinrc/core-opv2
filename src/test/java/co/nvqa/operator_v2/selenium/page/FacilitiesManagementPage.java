package co.nvqa.operator_v2.selenium.page;

import static co.nvqa.operator_v2.selenium.page.FacilitiesManagementPage.HubsTable.ACTION_ACTIVATE;
import static co.nvqa.operator_v2.selenium.page.FacilitiesManagementPage.HubsTable.ACTION_DISABLE;
import static co.nvqa.operator_v2.selenium.page.FacilitiesManagementPage.HubsTable.ACTION_EDIT;
import static co.nvqa.operator_v2.selenium.page.FacilitiesManagementPage.HubsTable.COLUMN_NAME;

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
import java.util.Optional;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import org.apache.commons.lang3.StringUtils;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;

/**
 * @author Daniel Joi Partogi Hutapea
 */
@SuppressWarnings("WeakerAccess")
public class FacilitiesManagementPage extends OperatorV2SimplePage {

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
  public EditHubDialog editHubDialog;

  @FindBy(css = "md-dialog")
  public ConfirmDeactivationDialog confirmDeactivationDialog;

  @FindBy(css = "md-dialog")
  public ConfirmActivationDialog confirmActivationDialog;

  @FindBy(xpath = "//button[@aria-label='Yes']")
  public Button sortHub;

  @FindBy(xpath = "//button[@aria-label='Save']")
  public Button saveChanges;

  public HubsTable hubsTable;

  public FacilitiesManagementPage(WebDriver webDriver) {
    super(webDriver);
    hubsTable = new HubsTable(webDriver);
  }

  public void verifyCsvFileDownloadedSuccessfullyAndContainsCorrectInfo(Hub hub) {
    String hubName = hub.getName();
    verifyFileDownloadedSuccessfully(CSV_FILENAME, hubName);
  }

  public void createNewHub(Hub hub) {
    loadingHubsLabel.waitUntilInvisible();
    addHub.waitUntilClickable();
    addHub.click();
    addHubDialog.waitUntilVisible();
    addHubDialog.hubName.setValue(hub.getName());
    addHubDialog.displayName.setValue(hub.getShortName());
    Optional.ofNullable(hub.getFacilityType())
        .ifPresent(value -> addHubDialog.facilityType.selectByValue(value));
    Optional.ofNullable(hub.getRegion())
        .ifPresent(value -> addHubDialog.region.selectByValue(value));
    addHubDialog.city.setValue(hub.getCity());
    addHubDialog.country.setValue(hub.getCountry());
    addHubDialog.latitude.setValue(String.valueOf(hub.getLatitude()));
    addHubDialog.longitude.setValue(String.valueOf(hub.getLongitude()));
    Optional.ofNullable(hub.getSortHub()).ifPresent(value -> sortHub.click());
    addHubDialog.submit.clickAndWaitUntilDone();
    addHubDialog.waitUntilInvisible();
  }

  public void updateHub(String searchHubsKeyword, Hub hub) {
    retryIfAssertionErrorOccurred(() ->
    {
      refreshPage();
      loadingHubsLabel.waitUntilInvisible();
      hubsTable.filterByColumn(COLUMN_NAME, searchHubsKeyword);
      assertFalse(f("Table is empty. Hub with keywords = '%s' not found.", searchHubsKeyword),
          hubsTable.isEmpty());
    }, "Unable to find the hub, retrying...");

    hubsTable.clickActionButton(1, ACTION_EDIT);
    editHubDialog.waitUntilVisible();

    pause1s();
    Optional.ofNullable(hub.getFacilityType())
        .ifPresent(value -> editHubDialog.facilityType.selectByValue(value));
    Optional.ofNullable(hub.getName()).ifPresent(value -> editHubDialog.hubName.setValue(value));
    Optional.ofNullable(hub.getShortName())
        .ifPresent(value -> editHubDialog.displayName.setValue(value));
    Optional.ofNullable(hub.getCity()).ifPresent(value -> editHubDialog.city.setValue(value));
    Optional.ofNullable(hub.getCountry()).ifPresent(value -> editHubDialog.country.setValue(value));
    Optional.ofNullable(hub.getLatitude())
        .ifPresent(value -> editHubDialog.latitude.setValue(value));
    Optional.ofNullable(hub.getLongitude())
        .ifPresent(value -> editHubDialog.longitude.setValue(value));
    Optional.ofNullable(hub.getSortHub()).ifPresent(value -> sortHub.click());
    editHubDialog.submitChanges.click();

    String facilityType = hub.getFacilityType();
    if (facilityType.equalsIgnoreCase("CROSSDOCK") || facilityType
        .equalsIgnoreCase("CROSSDOCK_STATION") || facilityType.equalsIgnoreCase("STATION")) {
      saveChanges.waitUntilVisible();
      saveChanges.waitUntilClickable();
      saveChanges.click();
    }
    editHubDialog.waitUntilInvisible();
  }

  public void disableHub(String searchHubsKeyword) {
    hubsTable.filterByColumn(COLUMN_NAME, searchHubsKeyword);
    hubsTable.clickActionButton(1, ACTION_DISABLE);
    confirmDeactivationDialog.waitUntilVisible();
    pause1s();
    confirmDeactivationDialog.disable.click();
    confirmDeactivationDialog.waitUntilInvisible();
  }

  public void activateHub(String searchHubsKeyword) {
    hubsTable.filterByColumn(COLUMN_NAME, searchHubsKeyword);
    hubsTable.clickActionButton(1, ACTION_ACTIVATE);
    confirmActivationDialog.waitUntilVisible();
    pause1s();
    confirmActivationDialog.activate.click();
    confirmActivationDialog.waitUntilInvisible();
  }

  public Hub searchHub(String searchHubsKeyword) {
    hubsTable.filterByColumn(COLUMN_NAME, searchHubsKeyword);
    assertFalse(
        String.format("Table is empty. Hub with keywords = '%s' not found.", searchHubsKeyword),
        hubsTable.isEmpty());
    return hubsTable.readEntity(1);
  }

  public void verifyHubIsExistAndDataIsCorrect(Hub expectedHub) {
    Hub actualHub = searchHub(expectedHub.getName());
    expectedHub.setId(actualHub.getId());
    if (expectedHub.getFacilityType().equalsIgnoreCase("CROSSDOCK")) {
      expectedHub.setFacilityType("Hub - Crossdock");
    } else if (expectedHub.getFacilityType().equalsIgnoreCase("CROSSDOCK_STATION")) {
      expectedHub.setFacilityType("Station - Crossdock");
    }
    expectedHub.compareWithActual(actualHub, "createdAt", "updatedAt", "deletedAt", "sortHub");
  }

  public static class HubsTable extends MdVirtualRepeatTable<Hub> {

    private static final Pattern LATLONG_PATTERN = Pattern
        .compile(".*?([\\d\\.]+).*?([\\d\\.]+).*");
    public static final String COLUMN_NAME = "name";
    public static final String COLUMN_SHORT_NAME = "shortName";
    public static final String COLUMN_LATITUDE = "latitude";
    public static final String COLUMN_LONGITUDE = "longitude";
    public static final String COLUMN_ACTIVE = "active";
    public static final String ACTION_EDIT = "Edit";
    public static final String ACTION_ACTIVATE = "Activate";
    public static final String ACTION_DISABLE = "Disable";

    public HubsTable(WebDriver webDriver) {
      super(webDriver);
      setMdVirtualRepeat("hub in getTableData()");
      setColumnLocators(ImmutableMap.<String, String>builder()
          .put("id", "id")
          .put(COLUMN_NAME, "name")
          .put(COLUMN_SHORT_NAME, "short_name")
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
      setActionButtonsLocators(ImmutableMap.of(ACTION_EDIT, "commons.edit", ACTION_ACTIVATE,
          "//nv-icon-text-button[@name='commons.activate']", ACTION_DISABLE,
          "//nv-icon-text-button[@name='commons.disable']"));
      setEntityClass(Hub.class);
    }
  }

  public static class AddHubDialog extends MdDialog {

    public AddHubDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }

    @FindBy(css = "[id^='container.hub-list.hub-name']")
    public TextBox hubName;

    @FindBy(css = "[id^='container.hub-list.display-name']")
    public TextBox displayName;

    @FindBy(css = "[id='container.hub-list.facility-type']")
    public MdSelect facilityType;

    @FindBy(css = "[id='container.hub-list.region']")
    public MdSelect region;

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

  public static class EditHubDialog extends MdDialog {

    public EditHubDialog(WebDriver webDriver, WebElement webElement) {
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

    @FindBy(name = "Submit Changes")
    public NvButtonSave submitChanges;
  }

  public static class ConfirmDeactivationDialog extends MdDialog {

    public ConfirmDeactivationDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }

    @FindBy(css = "button[aria-label='Disable']")
    public Button disable;
  }

  public static class ConfirmActivationDialog extends MdDialog {

    public ConfirmActivationDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }

    @FindBy(css = "button[aria-label='Activate']")
    public Button activate;
  }
}