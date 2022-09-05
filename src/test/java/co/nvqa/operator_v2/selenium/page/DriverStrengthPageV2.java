package co.nvqa.operator_v2.selenium.page;

import co.nvqa.operator_v2.model.DriverInfo;
import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.ForceClearTextBox;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.TextBox;
import co.nvqa.operator_v2.selenium.elements.ant.AntModal;
import co.nvqa.operator_v2.selenium.elements.ant.AntSelect;
import co.nvqa.operator_v2.selenium.elements.ant.driver_strength.DriverStrengthAntCalendarPicker;
import co.nvqa.operator_v2.selenium.elements.md.MdAutocomplete;
import co.nvqa.operator_v2.selenium.elements.md.MdDialog;
import co.nvqa.operator_v2.selenium.elements.mm.AntNotice;
import co.nvqa.operator_v2.selenium.elements.nv.NvIconTextButton;
import com.google.common.collect.ImmutableMap;
import java.util.ArrayList;
import java.util.List;
import org.apache.commons.lang3.StringUtils;
import org.openqa.selenium.By;
import org.openqa.selenium.Keys;
import org.openqa.selenium.SearchContext;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;

import static co.nvqa.operator_v2.selenium.page.DriverStrengthPageV2.DriversTable.ACTION_CONTACT_INFO;
import static co.nvqa.operator_v2.selenium.page.DriverStrengthPageV2.DriversTable.ACTION_DELETE;
import static co.nvqa.operator_v2.selenium.page.DriverStrengthPageV2.DriversTable.COLUMN_USERNAME;

/**
 * @author Sergey Mishanin
 */
@SuppressWarnings("WeakerAccess")
public class DriverStrengthPageV2 extends SimpleReactPage {

  private static final String LOCATOR_SPINNER = "//md-progress-circular";
  public static final String LOCATOR_DELETE_BUTTON = "//button/span[.='Delete']";
  private static final String DRIVER_STRENGTH_COLUMN_NAME_XPATH = "//div[contains(@class,'th')]/*[1]";
  private static final String DRIVER_STRENGTH_BUTTONS_XPATH = "//*[@role='button' or @type][starts-with(normalize-space(.),'%s')]";
  private static final String DOWNLOAD_OPTS_HAMBURGER_XPATH = "//div[contains(@class,'ant-dropdown')][not(contains(@class,'ant-dropdown-hidden'))]//li[.='%s']";
  private static final String UPDATE_DRIVER_MODAL_UI_XPATH = "//div[@class='ant-modal-body']//span[normalize-space(.)=\"%s\"]";
  private static final String ALERT_MESSAGE_XPATH = "//*[@class='ant-message-notice' or @class='ant-alert-message'][normalize-space(.)=\"%s\"]";

  @FindBy(xpath = "//div[@role='document' and contains(@class,'ant-modal')]")
  public AddDriverDialog addDriverDialog;

  @FindBy(css = "div.ant-modal")
  public EditDriverDialog editDriverDialog;

  public DriversTable driversTable;

  private ContactDetailsMenu contactDetailsMenu;

  @FindBy(name = "container.driver-strength.edit-search-filter")
  public NvIconTextButton editSearchFilter;

  @FindBy(xpath = "//button[.='Load Selection']")
  public Button loadSelection;

  @FindBy(xpath = "//button[.='Clear Selection']")
  public Button clearSelection;

  @FindBy(xpath = "//button[.='Download All Shown']")
  public Button downloadAllShown;

  @FindBy(xpath = "//button[.='Download CSV Template']")
  public Button downloadCsvTemplate;

  @FindBy(xpath = "//button[.='Download Failure Reasons']")
  public Button downloadFailureReasons;

  @FindBy(id = "bulk-update-driver-csv")
  public PageElement bulkUploadDrivers;

  @FindBy(xpath = "//button[.='Update Driver Details']")
  public Button updateDriverDetails;

  @FindBy(xpath = "//button[.='Download All Shown']/following-sibling::button")
  public Button downloadHamburgerIcon;

  @FindBy(xpath = "//div[contains(@class,'ant-dropdown')][not(contains(@class,'ant-dropdown-hidden'))]//li")
  public List<PageElement> downloadOptions;

  @FindBy(name = "container.driver-strength.load-everything")
  public NvIconTextButton loadEverything;

  @FindBy(css = "table input[type='checkbox']")
  public PageElement recordCheckbox;

  @FindBy(xpath = "//button[.='Add New Driver']")
  public Button addNewDriver;

  @FindBy(name = "zones")
  public AntSelect zonesFilter;

  @FindBy(name = "hubs")
  public AntSelect hubsFilter;

  @FindBy(name = "driverTypes")
  public AntSelect driverTypesFilter;

//  @FindBy(className = "//span[.='All']")
  @FindBy(xpath = "//div[contains(@class, 'ant-select') and @name='resigned']")
  public PageElement resignedFilter;

  @FindBy(xpath = "//div[@class='rc-virtual-list-holder-inner']/div[2]")
  public PageElement asda;

  @FindBy(css = "md-autocomplete[placeholder='Select Filter']")
  public MdAutocomplete addFilter;

  public DriverStrengthPageV2(WebDriver webDriver) {
    super(webDriver);
    driversTable = new DriversTable(webDriver);
    contactDetailsMenu = new ContactDetailsMenu(webDriver);
  }

  public void addFilter(String value) {
    addFilter.selectValue(value);
    addFilter.closeSuggestions();
  }

  public void loadEverything() {
    loadEverything.click();
    if (halfCircleSpinner.waitUntilVisible(2)) {
      halfCircleSpinner.waitUntilInvisible();
    }
  }

  public void loadSelection() {
    loadSelection.click();
    if (halfCircleSpinner.waitUntilVisible(2)) {
      halfCircleSpinner.waitUntilInvisible();
    }
  }

  public DriversTable driversTable() {
    return driversTable;
  }

  public void clickAddNewDriver() {
    final String xpathAddButton = "//button[.='Add New Driver']";
    waitUntilVisibilityOfElementLocated(xpathAddButton);
    click(xpathAddButton);
    pause3s();
  }

  public void addNewDriver(DriverInfo driverInfo) {
    waitUntilInvisibilityOfElementLocated(LOCATOR_SPINNER);
    clickAddNewDriver();
    pause3s();
    addDriverDialog.fillForm(driverInfo);
    addDriverDialog.submitForm();
  }

  public void filterBy(String columnName, String value) {
    driversTable.filterByColumn(columnName, value);
  }

  public void verifyContactDetails(String username, DriverInfo expectedContactDetails) {
    waitUntilVisibilityOfElementLocated("//tr[@class='ant-table-row ant-table-row-level-0'][1]");
    filterBy(COLUMN_USERNAME, username);
    driversTable.clickActionButton(1, ACTION_CONTACT_INFO);
    DriverInfo actualContactDetails = contactDetailsMenu.readData();
    if (StringUtils.isNotBlank(expectedContactDetails.getLicenseNumber())) {
      assertThat("License Number", actualContactDetails.getLicenseNumber(),
          equalTo(expectedContactDetails.getLicenseNumber()));
    }
    if (StringUtils.isNotBlank(expectedContactDetails.getContact())) {
      assertThat("Contact", actualContactDetails.getContact().replaceAll("\\s", ""),
          equalTo(expectedContactDetails.getContact()));
    }
    if (StringUtils.isNotBlank(expectedContactDetails.getContactType())) {
      assertThat("Contact Type", actualContactDetails.getContactType(),
          containsString(expectedContactDetails.getContactType()));
    }
  }

  public void verifyDriverInfo(DriverInfo expectedDriverInfo) {
    filterBy(COLUMN_USERNAME, expectedDriverInfo.getUsername());
    DriverInfo actualDriverInfo = driversTable.readEntity(1);
    if (expectedDriverInfo.getId() != null) {
      assertThat("Id", actualDriverInfo.getId(), equalTo(expectedDriverInfo.getId()));
    }
    if (StringUtils.isNotBlank(expectedDriverInfo.getUsername())) {
      assertThat("Username", actualDriverInfo.getUsername(),
          equalTo(expectedDriverInfo.getUsername()));
    }
    if (StringUtils.isNotBlank(expectedDriverInfo.getFirstName())) {
      assertThat("First Name", actualDriverInfo.getFirstName(),
          equalTo(expectedDriverInfo.getFirstName()));
    }
    if (StringUtils.isNotBlank(expectedDriverInfo.getLastName())) {
      assertThat("Last Name", actualDriverInfo.getLastName(),
          equalTo(expectedDriverInfo.getLastName()));
    }
    if (StringUtils.isNotBlank(expectedDriverInfo.getType())) {
      assertThat("Type", actualDriverInfo.getType(), equalTo(expectedDriverInfo.getType()));
    }
    if (expectedDriverInfo.getZoneMin() != null) {
      assertThat("Min", actualDriverInfo.getZoneMin(), equalTo(expectedDriverInfo.getZoneMin()));
    }
    if (expectedDriverInfo.getZoneMax() != null) {
      assertThat("Max", actualDriverInfo.getZoneMax(), equalTo(expectedDriverInfo.getZoneMax()));
    }
    if (StringUtils.isNotBlank(expectedDriverInfo.getComments())) {
      assertThat("Comments", actualDriverInfo.getComments(),
          equalTo(expectedDriverInfo.getComments()));
    }
  }

  public void deleteDriver(String username) {
    driversTable.filterByColumn(COLUMN_USERNAME, username);
    waitUntilTableLoaded();

    driversTable.clickActionButton(1, ACTION_DELETE);
    pause1s();
    click(LOCATOR_DELETE_BUTTON);
    waitUntilInvisibilityOfMdDialogByTitle("Confirm delete");
  }

  public void clickResignedOption(String resigned){
    pause2s();
    resignedFilter.click();
    pause2s();
    if(resigned.equalsIgnoreCase("no")){
        click("//div[@label='Not Resigned']");
    } else {
      click("//div[@label='Resigned']");
    }
  }

  /**
   * Accessor for Add Driver dialog
   */
  @SuppressWarnings("UnusedReturnValue")
  public static class AddDriverDialog extends AntModal {

    @FindBy(xpath = ".//button[.='Submit']")
    public Button submit;

    @FindBy(xpath = "//span[.='At least one contacts required.']")
    public PageElement contactHints;

    @FindBy(xpath = "//span[.='At least one vehicle required.']")
    public PageElement vehicleHints;

    @FindBy(xpath = "//span[.='At least one zone preference required.']")
    public PageElement zoneHints;

    @FindBy(xpath = "//span[.='Please input a valid mobile phone number (e.g. 8123 4567)']")
    public PageElement validContactNumber;

    @FindBy(id = "firstName")
    public ForceClearTextBox firstName;

    @FindBy(id = "lastName")
    public ForceClearTextBox lastName;

    @FindBy(id = "licenseNumber")
    public ForceClearTextBox driverLicenseNumber;

    @FindBy(name = "type")
    public AntSelect type;

    @FindBy(id = "maxOnDemandWaypoints")
    public PageElement maximumOnDemandWaypoints;

    @FindBy(id = "dpmsId")
    public PageElement dpmsId;

    @FindBy(id = "codLimit")
    public TextBox codLimit;

    @FindBy(name = "hub")
    public AntSelect hub;

    @FindBy(css = ".ant-picker-input")
    public DriverStrengthAntCalendarPicker employmentStartDate;

    @FindBy(id = "username")
    public ForceClearTextBox username;

    @FindBy(id = "password")
    public ForceClearTextBox password;

    @FindBy(id = "comment")
    public ForceClearTextBox comments;

    @FindBy(xpath = ".//button[.='Add More Vehicle']")
    public Button addMoreVehicles;

    @FindBy(xpath = ".//div[@class='ant-space-item'][contains(.,'Vehicles')]//div[@class='ant-row']")
    public List<VehicleSettingsForm> vehicleSettingsForm;

    @FindBy(xpath = ".//button[.='Add More Contact']")
    public Button addMoreContacts;

    @FindBy(xpath = ".//div[@class='ant-space-item'][contains(.,'Contacts')]//div[@class='ant-row']")
    public List<ContactsSettingsForm> contactsSettingsForms;

    @FindBy(xpath = ".//button[.='Add More Zones']")
    public Button addMoreZones;

    @FindBy(xpath = ".//div[@class='ant-space-item'][contains(.,'Preferred Zones')]//div[@class='ant-row']")
    public List<ZoneSettingsForm> zoneSettingsForms;

    public static class VehicleSettingsForm extends PageElement {

      public VehicleSettingsForm(WebDriver webDriver, SearchContext searchContext,
          WebElement webElement) {
        super(webDriver, searchContext, webElement);
      }

      @FindBy(css = "div[name*='vehicleType']")
      public AntSelect vehicleType;

      @FindBy(css = "input[name*='vehicleNo']")
      public ForceClearTextBox vehicleLicenseNumber;

      @FindBy(css = "input[name*='capacity']")
      public ForceClearTextBox vehicleCapacity;

      @FindBy(xpath = ".//button[.='Remove']")
      public Button remove;

    }

    public static class ContactsSettingsForm extends PageElement {

      public ContactsSettingsForm(WebDriver webDriver, SearchContext searchContext,
          WebElement webElement) {
        super(webDriver, searchContext, webElement);
      }

      @FindBy(css = "div[name*='type']")
      public AntSelect contactType;

      @FindBy(css = "input[name*='details']")
      public ForceClearTextBox contact;

      @FindBy(xpath = ".//button[.='Remove']")
      public Button remove;

    }

    public static class ZoneSettingsForm extends PageElement {

      public ZoneSettingsForm(WebDriver webDriver, SearchContext searchContext,
          WebElement webElement) {
        super(webDriver, searchContext, webElement);
      }

      @FindBy(css = "div[name*='zone']")
      public AntSelect zoneName;

      @FindBy(css = "input[name*='minWaypoints']")
      public ForceClearTextBox min;

      @FindBy(css = "input[name*='maxWaypoints']")
      public ForceClearTextBox max;

      @FindBy(css = "input[name*='cost']")
      public ForceClearTextBox cost;

      @FindBy(css = "input[name*='latitude']")
      public ForceClearTextBox seedLatitude;

      @FindBy(css = "input[name*='latitude']")
      public ForceClearTextBox seedLongitude;

      @FindBy(xpath = ".//button[.='Remove']")
      public Button remove;

    }

    public AddDriverDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }

    public AddDriverDialog setHub(String value) {
      hub.selectValue(value);
      return this;
    }

    public AddDriverDialog setFirstName(String value) {
      if (value != null) {
        firstName.setValue(value);
      }
      return this;
    }

    public AddDriverDialog setLastName(String value) {
      if (value != null) {
        lastName.setValue(value);
      }
      return this;
    }

    public AddDriverDialog setEmploymentStartDate(String value) {
      if (value != null) {
        employmentStartDate.setValue(value);
      }
      return this;
    }

    public AddDriverDialog setDriverLicenseNumber(String value) {
      if (value != null) {
        driverLicenseNumber.setValue(value);
      }
      return this;
    }

    public AddDriverDialog setCodLimit(Integer value) {
      if (value != null) {
        codLimit.setValue(value);
      }
      return this;
    }

    public void setType(String driverType) {
      type.selectValue(driverType);
      waitUntilVisibilityOfElementLocated(f("//*[@*='%s']", driverType));
    }

    public void setMaximumOnDemandWaypoint(long param) {
      maximumOnDemandWaypoints.sendKeys(param);
    }

    public void setDpmsId(String dpmsIdValue){
      if(dpmsId.isDisplayed()){
        dpmsId.click();
        for(char key : dpmsIdValue.toCharArray()){
          dpmsId.sendKeys(Keys.BACK_SPACE);
        }
        dpmsId.sendKeys(dpmsIdValue);
      }
    }

    public AddDriverDialog addVehicle(String vehicleType, String licenseNumber, Integer capacity) {
      addMoreVehicles.click();
      VehicleSettingsForm form = vehicleSettingsForm.get(vehicleSettingsForm.size() - 1);
      form.vehicleType.selectValue(vehicleType);
      if (licenseNumber != null) {
        form.vehicleLicenseNumber.setValue(licenseNumber);
      }
      if (capacity != null) {
        form.vehicleCapacity.setValue(capacity);
      }
      return this;
    }

    public AddDriverDialog addContact(String contactType, String contact) {
      addMoreContacts.click();
      ContactsSettingsForm form = contactsSettingsForms.get(contactsSettingsForms.size() - 1);
      if(contact != null) {
        form.contact.setValue(contact + Keys.TAB);
      }
      return this;
    }

    public AddDriverDialog addZone(String zoneName, Integer min, Integer max, Integer cost) {
      addMoreZones.click();
      ZoneSettingsForm form = zoneSettingsForms.get(zoneSettingsForms.size() - 1);
      if (StringUtils.isNotBlank(zoneName)) {
        form.zoneName.selectValue(zoneName);
      }
      if (min != null) {
        form.min.setValue(min);
      }
      if (max != null) {
        form.max.setValue(max);
      }
      if (cost != null) {
        form.cost.setValue(cost);
      }
      return this;
    }

    public AddDriverDialog setUsername(String value) {
      if (value != null) {
        username.setValue(value);
      }
      return this;
    }

    public AddDriverDialog setPassword(String value) {
      if (value != null) {
        password.setValue(value);
      }
      return this;
    }

    public AddDriverDialog setComments(String value) {
      if (value != null) {
        comments.setValue(value);
      }
      return this;
    }

    public void submitForm() {
      submit.click();
      waitUntilInvisible();
    }

    public void fillForm(DriverInfo driverInfo) {
      waitUntilVisible();
      pause3s();
      setFirstName(driverInfo.getFirstName());
      setLastName(driverInfo.getLastName());
      setDriverLicenseNumber(driverInfo.getLicenseNumber());
      setType(driverInfo.getType());
      setMaximumOnDemandWaypoint(10l);
      setDpmsId(driverInfo.getDpmsId());
      setCodLimit(driverInfo.getCodLimit());
      setHub(driverInfo.getHub());
      setEmploymentStartDate(driverInfo.getEmploymentStartDate());
      if (driverInfo.hasVehicleInfo()) {
        addVehicle(driverInfo.getVehicleType(), driverInfo.getVehicleLicenseNumber(), driverInfo.getVehicleCapacity());
      }
      if (driverInfo.hasContactsInfo()) {
        addContact(driverInfo.getContactType(), driverInfo.getContact());
      }
      if (driverInfo.hasZoneInfo()) {
        addZone(driverInfo.getZoneId(), driverInfo.getZoneMin(), driverInfo.getZoneMax(),
            driverInfo.getZoneCost());
      }
      setUsername(driverInfo.getUsername());
      setPassword(driverInfo.getPassword());
      setComments(driverInfo.getComments());
    }
  }

  /**
   * Accessor for Contact Details menu
   */
  public static class ContactDetailsMenu extends OperatorV2SimplePage {

    public static final String LOCATOR_LICENSE = "//div[@class='ant-popover-inner-content']/div/div[2]/span[2]";
    public static final String LOCATOR_CONTACT = "//div[contains(@class, 'ant-col ant-col-24')]/div/div[1]/span[1]";
    public static final String LOCATOR_CONTACT_TYPE = "//div[@class='ant-col ant-col-24']/div/div[2]/span[1]";
    public static final String LOCATOR_COMMENTS = "//*[contains(@class,'md-active')]//*[@class='contact-info-comments']/div[contains(.,'Comments')]/div[2]";

    @FindBy(xpath = "//div[@class = 'ant-popover-title']")
    private PageElement contactDetailsDialog;

    public ContactDetailsMenu(WebDriver webDriver) {
      super(webDriver);
    }

    public String getLicenseNumber() {
      waitUntilVisibilityOfElementLocated(LOCATOR_LICENSE);
      return getText(LOCATOR_LICENSE);
    }

    public String getContact() {
      return getText(LOCATOR_CONTACT);
    }

    public String getContactType() {
      return getText(LOCATOR_CONTACT_TYPE);
    }

    public String getComments() {
      if (isElementExistFast(LOCATOR_COMMENTS)) {
        return getText(LOCATOR_COMMENTS);
      } else {
        return null;
      }
    }

    public DriverInfo readData() {
      DriverInfo driverInfo = new DriverInfo();
      driverInfo.setLicenseNumber(getLicenseNumber());
      driverInfo.setContact(getContact());
      driverInfo.setContactType(getContactType());
      driverInfo.setComments(getComments());
      return driverInfo;
    }

    public static class ContactDetailsDialog extends MdDialog {

      public ContactDetailsDialog(WebDriver webDriver, WebElement webElement) {
        super(webDriver, webElement);
      }

      public ContactDetailsDialog(WebDriver webDriver, SearchContext searchContext,
          WebElement webElement) {
        super(webDriver, searchContext, webElement);
      }

      @FindBy(xpath = "//div[@class='ant-popover-inner-content']/div/div[2]/span[2]")
      public PageElement driverLicenseNumber;
    }
  }

  /**
   * Accessor for Edit Driver dialog
   */
  public static class EditDriverDialog extends AddDriverDialog {

    public EditDriverDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }

    public EditDriverDialog editVehicle(String licenseNumber, Integer capacity) {
      VehicleSettingsForm form = vehicleSettingsForm.get(vehicleSettingsForm.size() - 1);
      if (licenseNumber != null) {
        form.vehicleLicenseNumber.setValue(licenseNumber);
      }
      if (capacity != null) {
        form.vehicleCapacity.setValue(capacity);
      }
      return this;
    }

    public EditDriverDialog editContact(String contactType, String contact) {
      ContactsSettingsForm form = contactsSettingsForms.get(contactsSettingsForms.size() - 1);
      if (StringUtils.isNotBlank(contactType)) {
        form.contactType.selectValue(contactType);
      }
      if (contact != null) {
        form.contact.setValue(contact + Keys.TAB);
      }
      return this;
    }

    public EditDriverDialog editZone(String zoneName, Integer min, Integer max, Integer cost) {
      ZoneSettingsForm form = zoneSettingsForms.get(zoneSettingsForms.size() - 1);
      if (StringUtils.isNotBlank(zoneName)) {
        form.zoneName.selectValue(zoneName);
      }
      if (min != null) {
        form.min.setValue(min);
      }
      if (max != null) {
        form.max.setValue(max);
      }
      if (cost != null) {
        form.cost.setValue(cost);
      }
      return this;
    }

    public void fillForm(DriverInfo driverInfo) {
      waitUntilVisible();
      setFirstName(driverInfo.getFirstName());
      setLastName(driverInfo.getLastName());
      setDriverLicenseNumber(driverInfo.getLicenseNumber());
      setDpmsId(driverInfo.getDpmsId());
      setCodLimit(driverInfo.getCodLimit());
      if (driverInfo.hasVehicleInfo()) {
        if (vehicleSettingsForm.size() > 0) {
          editVehicle(driverInfo.getVehicleLicenseNumber(), driverInfo.getVehicleCapacity());
        } else {
          addVehicle(driverInfo.getVehicleType(),driverInfo.getVehicleLicenseNumber(), driverInfo.getVehicleCapacity());
        }
      }
      if (driverInfo.hasContactsInfo()) {
        if (contactsSettingsForms.size() > 0) {
          editContact(driverInfo.getContactType(), driverInfo.getContact());
        } else {
          addContact(driverInfo.getContactType(), driverInfo.getContact());
        }
      }
      if (driverInfo.hasZoneInfo()) {
        if (zoneSettingsForms.size() > 0) {
          editZone(driverInfo.getZoneId(), driverInfo.getZoneMin(), driverInfo.getZoneMax(),
              driverInfo.getZoneCost());
        } else {
          addZone(driverInfo.getZoneId(), driverInfo.getZoneMin(), driverInfo.getZoneMax(),
              driverInfo.getZoneCost());
        }
      }
      setPassword(driverInfo.getPassword());
      setComments(driverInfo.getComments());
    }
  }

  public static class DriversTable extends AntTableV3<DriverInfo> {

    private static final String LOCATOR_COMING_TOGGLE = "(//tr[contains(@class,'ant-table-row')][%d]//td[contains(@class,'ant-table-cell-fix-right')]//button)[1]";
    private static final String LOCATOR_COMING_VALUE = "//tr[contains(@class,'ant-table-row')][%d]//td[contains(@class,'ant-table-cell-fix-right')]//span[contains(@class,'ant-typography')]";

    public static final String COLUMN_ID = "id";
    //    public static final String COLUMN_ID = "//span[@class='ant-table-filter-column-title']/div/div/span[.='Id']";
    public static final String COLUMN_USERNAME = "username";
    public static final String COLUMN_TYPE = "type";
    public static final String COLUMN_ZONE = "zoneId";
    public static final String COLUMN_EMPLOYMENT_START_DATE = "employmentStartName";
    public static final String COLUMN_EMPLOYMENT_END_DATE = "employmentEndName";
    public static final String COLUMN_RESIGNED = "resign";

    public static final String ACTION_EDIT = "edit";
    public static final String ACTION_DELETE = "delete";
    public static final String ACTION_CONTACT_INFO = "contact_info";

    public DriversTable(WebDriver webDriver) {
      super(webDriver);
      setColumnLocators(ImmutableMap.<String, String>builder()
          .put(COLUMN_ID, "2")
          .put(COLUMN_USERNAME, "3")
          .put("name", "4")
          .put("hub", "5")
          .put(COLUMN_TYPE, "6")
          .put("dpmsId", "7")
          .put("vehicleType", "8")
          .put("vehicleOwn", "9")
          .put(COLUMN_ZONE, "10")
          .put("zoneMin", "11")
          .put("zoneMax", "12")
          .put("comments", "13")
          .put(COLUMN_EMPLOYMENT_START_DATE, "14")
          .put(COLUMN_EMPLOYMENT_END_DATE, "15")
          .put(COLUMN_RESIGNED, "16")
          .build()
      );
      setActionButtonsLocators(ImmutableMap
          .of(ACTION_CONTACT_INFO, "2", ACTION_EDIT, "3",
              ACTION_DELETE, "4"));
      setEntityClass(DriverInfo.class);
    }

    public String getComingStatus(int rowNumber) {
      String xpath = String.format(LOCATOR_COMING_VALUE, rowNumber);
      return getText(xpath);
    }

    public void toggleComingStatus(int rowNumber) {
      String xpath = String.format(LOCATOR_COMING_TOGGLE, rowNumber);
      waitUntilElementIsClickable(xpath);
      click(xpath);
    }
  }

  public void waitUntilTableLoaded() {
    waitUntilVisibilityOfElementLocated("//tr[@class='ant-table-row ant-table-row-level-0'][1]");
  }

  public boolean isTableLoaded(){
    return isElementExist("//tr[@class='ant-table-row ant-table-row-level-0'][1]");
  }

  public boolean verifyNoDataOnTable(){
    final WebElement noData = findElementByXpath("//div[@class='ant-empty ant-empty-normal']/p[.='No Data']");
    return noData.getText().equals("No Data");
  }

  public List<String> getAllColumnsInResultGrid(String userName) {
    filterBy(COLUMN_USERNAME, userName);
    waitUntilTableLoaded();
    List<String> actualColumns = new ArrayList<String>();
    List<WebElement> tableColumns = getWebDriver().findElements(
        By.xpath(DRIVER_STRENGTH_COLUMN_NAME_XPATH));
    tableColumns.forEach((tableColumn) -> {
      scrollIntoView(tableColumn);
      actualColumns.add(tableColumn.getText().trim());
    });
    return actualColumns;
  }

  public boolean verifyButtonsDisplayed(String buttonName) {
    String buttonXpath = f(DRIVER_STRENGTH_BUTTONS_XPATH, buttonName);
    List<WebElement> labels = getWebDriver().findElements(By.xpath(buttonXpath));
    boolean isDisplayed = labels.size() > 0;
    return isDisplayed;
  }

  public boolean verifyUpdateDriverModalUiDisplayed(String element) {
    String buttonXpath = f(UPDATE_DRIVER_MODAL_UI_XPATH, element);
    waitUntilPageLoaded();
    List<WebElement> labels = getWebDriver().findElements(By.xpath(buttonXpath));
    boolean isDisplayed = labels.size() > 0;
    return isDisplayed;
  }

  public List<String> getAllDownloadOptions(){
    waitUntilPageLoaded();
    downloadHamburgerIcon.click();
    pause2s();
    List<String> options = new ArrayList<String>();
    for(PageElement option : downloadOptions){
      options.add(option.getText());
    }
    return options;
  }

  public void verifyFileDownloadForUpdate(String downloadOption){
    waitUntilPageLoaded();
    downloadHamburgerIcon.click();
    String downloadOptionXpath = f(DOWNLOAD_OPTS_HAMBURGER_XPATH, downloadOption);
    WebElement downloadToUpdate = getWebDriver().findElement(By.xpath(downloadOptionXpath));
    downloadToUpdate.click();
  }

  public boolean verifyNoticeDisplayed(String notice){
    String noticeXpath = f(ALERT_MESSAGE_XPATH, notice);
    waitUntilVisibilityOfElementLocated(noticeXpath);
    List<WebElement> message = getWebDriver().findElements(By.xpath(noticeXpath));
    boolean isDisplayed = message.size() > 0;
    return isDisplayed;
  }

}
