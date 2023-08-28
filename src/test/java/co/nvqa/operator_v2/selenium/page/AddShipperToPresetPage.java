package co.nvqa.operator_v2.selenium.page;

import co.nvqa.operator_v2.model.ShipperInfo;
import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.CheckBox;
import co.nvqa.operator_v2.selenium.elements.CustomFieldDecorator;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.TextBox;
import co.nvqa.operator_v2.selenium.elements.ant.AntButton;
import co.nvqa.operator_v2.selenium.elements.ant.AntCalendarRange;
import co.nvqa.operator_v2.selenium.elements.ant.AntModal;
import co.nvqa.operator_v2.selenium.elements.ant.AntSelect;
import com.google.common.collect.ImmutableMap;
import java.util.Map;
import org.apache.commons.lang3.StringUtils;
import org.assertj.core.api.Assertions;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.PageFactory;

/**
 * @author Sergey Mishanin
 */
public class AddShipperToPresetPage extends OperatorV2SimplePage {

  @FindBy(tagName = "iframe")
  private PageElement pageFrame;

  @FindBy(css = ".ant-spin-dot")
  public PageElement spinner;

  @FindBy(css = ".table-holder  div.ant-spin-spinning")
  public PageElement tableSpinner;

  @FindBy(xpath = "//div[@class='filter-container'][.//div[.='Shipper Creation Date']]")
  public AntCalendarRange shipperCreationDateFilter;

  @FindBy(css = "[data-testid='load-button']")
  public AntButton loadSelection;

  @FindBy(xpath = "//button[.='Add to Preset']")
  public Button addToPreset;

  @FindBy(css = "button.ant-dropdown-trigger")
  public Button dropdownTrigger;

  @FindBy(xpath = "//li[@role='menuitem'][.='Select All Shown']")
  public Button selectAllShown;

  @FindBy(xpath = "//li[@role='menuitem'][.='Deselect All Shown']")
  public Button deselectAllShown;

  @FindBy(xpath = "//li[@role='menuitem'][.='Clear Current Selection']")
  public Button clearCurrentSelection;

  @FindBy(xpath = "//li[@role='menuitem'][.='Show Only Selected']//input")
  public CheckBox showOnlySelected;

  @FindBy(css = ".ant-select-search__field")
  public TextBox presetSelector;

  @FindBy(id = "originHubId")
  public AntSelect originCrossdockHub;

  @FindBy(id = "orig_station_hub")
  public AntSelect originStationHub;

  @FindBy(id = "crossdock_hub")
  public AntSelect crossdockHub;

  @FindBy(id = "destinationHubId")
  public AntSelect destinationCrossdockHub;

  @FindBy(id = "dest_station_hub")
  public AntSelect destinationStationHub;

  @FindBy(xpath = "//button[.='Edit Filters']")
  public Button editFilters;

  @FindBy(xpath = "(//th//input)[1]")
  public TextBox originCrossdockHubFilter;

  @FindBy(xpath = "(//th//input)[2]")
  public TextBox destinationCrossdockHubFilter;

  @FindBy(xpath = "//div[@class='ant-popover-buttons']//button[.='Delete']")
  public Button popoverDeleteButton;

  @FindBy(xpath = "//label[.='Crossdock']")
  public PageElement crossdockHubsTab;

  @FindBy(xpath = "//label[.='Relations']")
  public PageElement relationsTab;

  @FindBy(xpath = "//label[starts-with(.,'All')]")
  public PageElement allTab;

  @FindBy(xpath = "//label[starts-with(.,'Completed')]")
  public PageElement completedTab;

  @FindBy(xpath = "//label[starts-with(.,'Pending')]")
  public PageElement pendingTab;

  @FindBy(xpath = "//th[contains(.,'Station')]//input")
  public TextBox stationFilter;

  //region Stations tab
  @FindBy(xpath = "//label[starts-with(.,'Station')]")
  public PageElement stationsTab;

  @FindBy(xpath = "//button[.='Add Schedule']")
  public Button addSchedule;

  @FindBy(xpath = "//button[.='Delete']")
  public Button delete;

  @FindBy(xpath = "//button[.='Modify']")
  public Button modify;

  @FindBy(xpath = "//button[.='Save']")
  public Button save;

  @FindBy(xpath = "//tr[1]//td[contains(@class,'action')]/i[1]")
  public PageElement assignDriverButton;

  @FindBy(className = "ant-modal-wrap")
  public TripManagementPage.AssignTripModal assignDriverModal;

  @FindBy(xpath = "//div[@class='ant-notification-notice-message' and .='Relation created']")
  public PageElement successCreateRelation;

  @FindBy(xpath = "//tr[1]//td[1]//input")
  public CheckBox rowCheckBox;

  @FindBy(xpath = "//button[.='Delete' and contains(@class, 'ant-btn-primary')]")
  public Button modalDeleteButton;

  @FindBy(xpath = ".//button[.//span[contains(., 'Download CSV')]]")
  public AntButton downloadCsv;

  //endregion

  public ShippersTable shippersTable;

  public AddShipperToPresetPage(WebDriver webDriver) {
    super(webDriver);
    shippersTable = new ShippersTable(webDriver);
  }

  public void switchTo() {
    getWebDriver().switchTo().frame(pageFrame.getWebElement());
  }

  public void waitUntilLoaded() {
    if (spinner.waitUntilVisible(10)) {
      spinner.waitUntilInvisible();
    }
    loadSelection.waitUntilClickable(60);
  }

  public void waitUntilUpdated() {
    if (tableSpinner.waitUntilVisible(10)) {
      tableSpinner.waitUntilInvisible();
    }
  }

  public void verifyNotificationWithMessage(String containsMessage) {
    String notificationXpath = "//div[contains(@class,'ant-notification')]//div[@class='ant-notification-notice-message']";
    waitUntilVisibilityOfElementLocated(notificationXpath);
    WebElement notificationElement = findElementByXpath(notificationXpath);
    Assertions.assertThat(notificationElement.getText()).as("Toast message is the same")
        .isEqualTo(containsMessage);
    waitUntilInvisibilityOfNotification(containsMessage, false);
  }

  public static class AssignDriverModal extends AntModal {

    public AssignDriverModal(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
      PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
    }

    @FindBy(xpath = ".//div[contains(@class,'ant-select')]")
    public AntSelect driverSelect;

    @FindBy(xpath = "//button[.='Save Driver']")
    public Button save;

    @FindBy(xpath = "//button[.='Cancel']")
    public Button cancel;
  }

  public static class ShippersTable extends AntTableV2<ShipperInfo> {

    public static final String COLUMN_CREATION_DATE = "createdAt";
    public static final String COLUMN_SHIPPER_ADDRESS = "address";
    public static final String COLUMN_SHIPPER_NAME = "name";
    public static final String COLUMN_SHIPPER_ID = "legacyId";
    public static final String COLUMN_IS_ACTIVE = "isActive";

    public static final Map<String, String> COLUMN_IDS_BY_NAME = ImmutableMap.of(
        "creation date", COLUMN_CREATION_DATE,
        "shipper address", COLUMN_SHIPPER_ADDRESS,
        "shipper name", COLUMN_SHIPPER_NAME,
        "shipper id", COLUMN_SHIPPER_ID,
        "is active", COLUMN_IS_ACTIVE
    );

    private static final Map<String, String> DIRECTIONS = ImmutableMap.of(
        "up", "sort-up",
        "down", "sort-down",
        "none", "sort"
    );

    public ShippersTable(WebDriver webDriver) {
      super(webDriver);
      setColumnLocators(ImmutableMap.<String, String>builder()
          .put(COLUMN_CREATION_DATE, "createdAt")
          .put(COLUMN_SHIPPER_ADDRESS, "address")
          .put(COLUMN_SHIPPER_NAME, "name")
          .put(COLUMN_SHIPPER_ID, "legacyId")
          .put(COLUMN_IS_ACTIVE, "isActive")
          .build()
      );
      setEntityClass(ShipperInfo.class);
    }

    public void sortColumn(String columnName, String direction) {
      String columnId = COLUMN_IDS_BY_NAME.get(columnName.trim().toLowerCase());
      String expectedDirection = DIRECTIONS.get(direction.trim().toLowerCase());
      String xpath = f("//div[@data-headerkey='%s']//*[@data-icon]", columnId);
      String sortType = getAttribute(xpath, "data-icon");
      while (!StringUtils.equalsIgnoreCase(sortType, expectedDirection)) {
        click(xpath);
        pause1s();
        sortType = getAttribute(xpath, "data-icon");
      }
    }
  }
}
