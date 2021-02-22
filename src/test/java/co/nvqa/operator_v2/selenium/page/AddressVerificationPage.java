package co.nvqa.operator_v2.selenium.page;

import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.CheckBox;
import co.nvqa.operator_v2.selenium.elements.CustomFieldDecorator;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.TextBox;
import co.nvqa.operator_v2.selenium.elements.ant.AntButton;
import co.nvqa.operator_v2.selenium.elements.ant.AntIntervalCalendarPicker;
import co.nvqa.operator_v2.selenium.elements.ant.AntModal;
import co.nvqa.operator_v2.selenium.elements.ant.AntSelect;
import co.nvqa.operator_v2.selenium.page.UpdateDeliveryAddressWithCsvPage.AddressesTable;
import java.util.List;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.PageFactory;

/**
 * @author Sergey Mishanin
 */
public class AddressVerificationPage extends OperatorV2SimplePage {

  @FindBy(tagName = "iframe")
  private PageElement pageFrame;

  @FindBy(css = ".ant-spin-dot")
  public PageElement spinner;

  @FindBy(xpath = "//div[contains(@class,'SectionNavigation')][.='Verify Addresses']")
  public PageElement verifyAddressTab;

  @FindBy(id = "route-group-selector")
  public AntSelect routeGroup;

  @FindBy(xpath = "//div[contains(@class,'AvfetchAddressForm__Grey')][contains(.,'By Route Groups')]//button")
  public AntButton fetchAddressByRouteGroup;

  @FindBy(xpath = "//div[contains(@class,'ant-table')]//tr/td[2]")
  public List<PageElement> fetchedAddresses;

  @FindBy(xpath = "//div[contains(@class,'ant-table')]//tr/td[4]//a[.='Edit']")
  public List<PageElement> editLinks;

  @FindBy(xpath = "//div[contains(@class,'ant-table')]//tr/td[4]//a[.='More']")
  public List<PageElement> moreLinks;

  @FindBy(xpath = "//li[.='Archive Address']")
  public PageElement archiveAddress;

  @FindBy(xpath = "//li[.='Save Address']")
  public PageElement saveAddress;

  @FindBy(className = "ant-modal-content")
  public EditAddressModal editAddressModal;

  @FindBy(css = ".table-holder  div.ant-spin-spinning")
  public PageElement tableSpinner;

  @FindBy(xpath = "//div[@class='filter-container'][.//div[.='Shipper Creation Date']]")
  public AntIntervalCalendarPicker shipperCreationDateFilter;

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

  public AddressesTable addressesTable;

  public AddressVerificationPage(WebDriver webDriver) {
    super(webDriver);
    addressesTable = new AddressesTable(webDriver);
  }

  public void switchTo() {
    getWebDriver().switchTo().frame(pageFrame.getWebElement());
  }

  public void waitUntilLoaded() {
    if (spinner.waitUntilVisible(10)) {
      spinner.waitUntilInvisible();
    }
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
    assertThat("Toast message is the same", notificationElement.getText(),
        equalTo(containsMessage));
    waitUntilInvisibilityOfNotification(notificationXpath, false);
  }

  public static class EditAddressModal extends AntModal {

    public EditAddressModal(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
      PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
    }

    @FindBy(xpath = ".//div[./div/label[.='Latitude']]//input")
    public TextBox latitude;

    @FindBy(xpath = ".//div[./div/label[.='Longitude']]//input")
    public TextBox longitude;

    @FindBy(xpath = ".//button[.='Save']")
    public Button save;

  }
}
