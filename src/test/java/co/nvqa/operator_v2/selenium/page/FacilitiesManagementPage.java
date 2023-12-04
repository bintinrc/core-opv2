package co.nvqa.operator_v2.selenium.page;

import co.nvqa.commonsort.model.sort.Hub;
import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.ForceClearTextBox;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.ant.AntModal;
import co.nvqa.operator_v2.selenium.elements.ant.AntSelect;
import co.nvqa.operator_v2.selenium.elements.ant.AntSwitch;
import co.nvqa.operator_v2.selenium.elements.ant.AntTable;
import com.google.common.collect.ImmutableMap;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import org.apache.commons.lang3.BooleanUtils;
import org.apache.commons.lang3.StringUtils;
import org.assertj.core.api.Assertions;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;

import static co.nvqa.operator_v2.selenium.page.FacilitiesManagementPage.HubsTable.ACTION_ACTIVATE;
import static co.nvqa.operator_v2.selenium.page.FacilitiesManagementPage.HubsTable.ACTION_DISABLE;
import static co.nvqa.operator_v2.selenium.page.FacilitiesManagementPage.HubsTable.ACTION_EDIT;
import static co.nvqa.operator_v2.selenium.page.FacilitiesManagementPage.HubsTable.COLUMN_NAME;
import static org.apache.commons.lang3.StringUtils.isNotBlank;

/**
 * @author Daniel Joi Partogi Hutapea
 */
public class FacilitiesManagementPage extends SimpleReactPage<FacilitiesManagementPage> {

  private static final String CSV_FILENAME = "hubs.csv";

  @FindBy(xpath = "//div[text()='Loading hubs...']")
  public PageElement loadingHubsLabel;

  @FindBy(css = "[data-testid='reload-hub-cache']")
  public Button refresh;

  @FindBy(css = "[data-testid='add-hub-button']")
  public Button addHub;

  @FindBy(css = "[data-testid='download-button']")
  public Button downloadCsvFile;

  @FindBy(css = "div.ant-modal-content")
  public AddHubDialog addHubDialog;

  @FindBy(css = "div.ant-modal-content")
  public EditHubDialog editHubDialog;

  @FindBy(xpath = "//div[@class='ant-modal-content'][contains(.,'Submit Changes?')]")
  public ConfirmUpdateHubDialog confirmUpdateHubDialog;

  @FindBy(css = "div.ant-modal-content")
  public ConfirmDeactivationDialog confirmDeactivationDialog;

  @FindBy(css = "div.ant-modal-content")
  public ConfirmActivationDialog confirmActivationDialog;

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
    addHub.click();
    addHubDialog.waitUntilVisible();
    addHubDialog.hubName.setValue(hub.getName());
    addHubDialog.displayName.setValue(hub.getShortName());
    if (isNotBlank(hub.getFacilityType())) {
      addHubDialog.facilityType.selectValue(hub.getFacilityType());
    }
    if (BooleanUtils.isTrue(hub.getSortHub())) {
      addHubDialog.sortHub.check();
    }
    if (isNotBlank(hub.getRegion())) {
      addHubDialog.region.selectValue(hub.getRegion());
    }
    addHubDialog.city.setValue(hub.getCity());
    addHubDialog.country.setValue(hub.getCountry());
    addHubDialog.latitude.setValue(hub.getLatitude());
    addHubDialog.longitude.setValue(hub.getLongitude());
    if (BooleanUtils.isTrue(hub.getVirtualHub())) {
      addHubDialog.virtualHub.check();
    }
    addHubDialog.submit.click();
  }

  public void updateHub(String searchHubsKeyword, Hub hub) {
    loadingHubsLabel.waitUntilInvisible();
    hubsTable.filterByColumn(COLUMN_NAME, searchHubsKeyword);
    Assertions.assertThat(hubsTable.isEmpty())
        .as(f("Table is empty. Hub with keywords = '%s' not found.", searchHubsKeyword)).isFalse();
    hubsTable.clickActionButton(1, ACTION_EDIT);
    editHubDialog.waitUntilVisible();
    pause1s();

    editHubDialog.hubName.setValue(hub.getName());
    editHubDialog.displayName.setValue(hub.getShortName());
    if (isNotBlank(hub.getFacilityType())) {
      editHubDialog.facilityType.selectValue(hub.getFacilityType());
    }
    if (BooleanUtils.isTrue(hub.getSortHub())) {
      editHubDialog.sortHub.check();
    } else if (editHubDialog.sortHub.isDisplayedFast()) {
      editHubDialog.sortHub.uncheck();
    }
    if (isNotBlank(hub.getRegion())) {
      editHubDialog.region.selectValue(hub.getRegion());
    }
    editHubDialog.city.setValue(hub.getCity());
    editHubDialog.country.setValue(hub.getCountry());
    editHubDialog.latitude.setValue(hub.getLatitude());
    editHubDialog.longitude.setValue(hub.getLongitude());
    if (BooleanUtils.isTrue(hub.getVirtualHub())) {
      editHubDialog.virtualHub.check();
    }
    editHubDialog.submit.click();
    if (confirmUpdateHubDialog.waitUntilVisible(1)) {
      confirmUpdateHubDialog.saveButton.click();
    }
  }

  public void updateHubByColumn(Hub hub, String column, String typeBefore) {
    loadingHubsLabel.waitUntilInvisible();
    hubsTable.filterByColumn(COLUMN_NAME, hub.getName());
    hubsTable.clickActionButton(1, ACTION_EDIT);
    editHubDialog.waitUntilVisible();
    if ("facility type".equals(column)) {
      editHubDialog.facilityType.selectValue(hub.getFacilityType());
    }
    if ("lat/long".equals(column)) {
      editHubDialog.latitude.setValue(hub.getLatitude());
      editHubDialog.longitude.setValue(hub.getLongitude());
    }
    if ("facility type and lat/long".equals(column)) {
      editHubDialog.facilityType.selectValue(hub.getFacilityType());
      editHubDialog.latitude.setValue(hub.getLatitude());
      editHubDialog.longitude.setValue(hub.getLongitude());
    }
    editHubDialog.submit.click();
    if (typeBefore.equalsIgnoreCase("CROSSDOCK") || typeBefore
        .equalsIgnoreCase("CROSSDOCK_STATION") || typeBefore.equalsIgnoreCase("STATION")) {
      confirmUpdateHubDialog.saveButton.waitUntilVisible();
      confirmUpdateHubDialog.saveButton.waitUntilClickable();
      confirmUpdateHubDialog.saveButton.click();
    }
    editHubDialog.waitUntilInvisible();
  }

  public void disableHub(String searchHubsKeyword) {
    hubsTable.filterByColumn(COLUMN_NAME, searchHubsKeyword);
    hubsTable.clickActionButton(1, ACTION_DISABLE);
    confirmDeactivationDialog.waitUntilVisible();
    confirmDeactivationDialog.disable.click();
  }

  public void activateHub(String searchHubsKeyword) {
    hubsTable.filterByColumn(COLUMN_NAME, searchHubsKeyword);
    hubsTable.clickActionButton(1, ACTION_ACTIVATE);
    confirmActivationDialog.waitUntilVisible();
    confirmActivationDialog.activate.click();
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

  public static class HubsTable extends AntTable<Hub> {

    private static final Pattern LATLONG_PATTERN = Pattern
        .compile(".*?([\\d.]+).*?([\\d.]+).*");
    public static final String COLUMN_NAME = "name";
    public static final String COLUMN_SHORT_NAME = "shortName";
    public static final String COLUMN_LATITUDE = "latitude";
    public static final String COLUMN_LONGITUDE = "longitude";
    public static final String COLUMN_SORT_HUB = "sortHub";
    public static final String COLUMN_VIRTUAL_HUB = "virtualHub";
    public static final String ACTION_EDIT = "Edit";
    public static final String ACTION_ACTIVATE = "Activate";
    public static final String ACTION_DISABLE = "Disable";

    public HubsTable(WebDriver webDriver) {
      super(webDriver);
      setColumnLocators(ImmutableMap.<String, String>builder()
          .put("id", "id")
          .put(COLUMN_NAME, "name")
          .put(COLUMN_SHORT_NAME, "short_name")
          .put("city", "city")
          .put("region", "region")
          .put("area", "areaString")
          .put("country", "country")
          .put(COLUMN_LATITUDE, "latAndLong")
          .put(COLUMN_LONGITUDE, "latAndLong")
          .put("facilityType", "facilityTypeString")
          .put("status", "status")
          .put(COLUMN_SORT_HUB, "sortHubString")
          .put(COLUMN_VIRTUAL_HUB, "virtualHubString")
          .put("parentHub", "parent_hub")
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
          COLUMN_SORT_HUB, value -> String.valueOf(StringUtils.equalsIgnoreCase("yes", value)),
          COLUMN_VIRTUAL_HUB, value -> String.valueOf(StringUtils.equalsIgnoreCase("yes", value))
      ));
      setActionButtonsLocators(ImmutableMap.of(
          ACTION_EDIT, "//tr[%d]//*[contains(@data-testid,'edit-hub-button')]",
          ACTION_ACTIVATE, "//tr[%d]//*[contains(@data-testid,'activate-hub-button')]",
          ACTION_DISABLE, "//tr[%d]//*[contains(@data-testid,'disable-hub-button')]"));
      setEntityClass(Hub.class);
    }
  }

  public static class AddHubDialog extends AntModal {

    public AddHubDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }

    @FindBy(css = "[data-testid='hub-name-input']")
    public ForceClearTextBox hubName;

    @FindBy(css = "[data-testid='short-name-input']")
    public ForceClearTextBox displayName;

    @FindBy(xpath = ".//div[contains(@class,'ant-select')][.//*[@id='facility-type']]")
    public AntSelect facilityType;

    @FindBy(xpath = ".//div[contains(@class,'ant-select')][.//*[@id='region']]")
    public AntSelect region;

    @FindBy(css = "[data-testid='city-input']")
    public ForceClearTextBox city;

    @FindBy(css = "[data-testid='country-input']")
    public ForceClearTextBox country;

    @FindBy(css = "[data-testid='latitude-input']")
    public ForceClearTextBox latitude;

    @FindBy(css = "[data-testid='longitude-input']")
    public ForceClearTextBox longitude;

    @FindBy(css = "[data-testid='virtual-hub-switch']")
    public AntSwitch virtualHub;

    @FindBy(css = "[data-testid='sort-hub-switch']")
    public AntSwitch sortHub;

    @FindBy(xpath = ".//div[contains(@class,'ant-select')][.//*[@id='parent-hub']]")
    public AntSelect parentHub;

    @FindBy(css = "[data-testid='confirm-button']")
    public Button submit;
  }

  public static class EditHubDialog extends AddHubDialog {

    public EditHubDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }

    @FindBy(id = "id")
    public PageElement id;

  }

  public static class ConfirmDeactivationDialog extends AntModal {

    public ConfirmDeactivationDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }

    @FindBy(css = "[data-testid='disable-button']")
    public Button disable;
  }

  public static class ConfirmActivationDialog extends AntModal {

    public ConfirmActivationDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }

    @FindBy(css = "[data-testid='leave-text']")
    public Button activate;
  }

  public static class ConfirmUpdateHubDialog extends AntModal {

    public ConfirmUpdateHubDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }

    @FindBy(xpath = "//button[.='Save']")
    public Button saveButton;

    @FindBy(xpath = "//button[.='Cancel']")
    public Button cancelButton;
  }
}