package co.nvqa.operator_v2.selenium.page;

import co.nvqa.commons.util.NvLogger;
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
import co.nvqa.operator_v2.selenium.elements.nv.NvIconTextButton;
import com.google.common.collect.ImmutableMap;
import java.io.File;
import java.util.ArrayList;
import java.util.List;
import java.util.NoSuchElementException;
import java.util.Objects;
import org.apache.commons.lang3.StringUtils;
import org.assertj.core.api.Assertions;
import org.assertj.core.util.Strings;
import org.openqa.selenium.By;
import org.openqa.selenium.Keys;
import org.openqa.selenium.SearchContext;
import org.openqa.selenium.TimeoutException;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;

import static co.nvqa.operator_v2.selenium.page.DriverStrengthPageV2.DriversTable.ACTION_CONTACT_INFO;
import static co.nvqa.operator_v2.selenium.page.DriverStrengthPageV2.DriversTable.ACTION_DELETE;
import static co.nvqa.operator_v2.selenium.page.DriverStrengthPageV2.DriversTable.COLUMN_ID;
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

  @FindBy(xpath = "//button[contains(@class,'ant-btn') and span[text()='Verify Number']]")
  public Button btnVerifyNumber;

  @FindBy(xpath = "//button[contains(@class,'ant-btn')]/span[contains(text(), 'Yes')]")
  public Button btnConfirmVerify;
  @FindBy(xpath = "//div[@role='document' and contains(@class,'ant-modal')]")
  public AddDriverDialog addDriverDialog;

  @FindBy(css = "div.ant-modal")
  public EditDriverDialog editDriverDialog;

  public DriversTable driversTable;

  private ContactDetailsMenu contactDetailsMenu;

  @FindBy(name = "container.driver-strength.edit-search-filter")
  public NvIconTextButton editSearchFilter;

  @FindBy(xpath = "//button[@type='submit']/span[text()='Load Selection']")
  public Button loadSelection;

  @FindBy(xpath = "//button[.='Clear Selection']")
  public Button clearSelection;

  @FindBy(xpath = "//button[.='Download All Shown']")
  public Button downloadAllShown;

  @FindBy(xpath = "//button[.='Download CSV Template']")
  public Button downloadCsvTemplate;

  @FindBy(xpath = "//button[.='Download Failure Reasons']")
  public Button downloadFailureReasons;

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

  @FindBy(xpath = "//div[contains(@class, 'ant-select') and @name='resigned']")
  public PageElement resignedFilter;

  @FindBy(xpath = "//div[@class='rc-virtual-list-holder-inner']/div[2]")
  public PageElement asda;

  @FindBy(css = "md-autocomplete[placeholder='Select Filter']")
  public MdAutocomplete addFilter;
  @FindBy(xpath = "//div[contains(@class, 'ant-notification')]")
  public PageElement notificationPopup;
  @FindBy(xpath = "//div[contains(@class, 'ant-notification')]/*/*/*[contains(@class,'ant-notification-notice-message')]")
  public PageElement notificationTitle;
  @FindBy(xpath = "//div[contains(@class, 'ant-notification')]/*/*/*[contains(@class,'ant-notification-notice-description')]")
  public PageElement notificationDesc;

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
    pause3s();
    waitUntilVisibilityOfElementLocated(xpathAddButton);
    click(xpathAddButton);
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

  public void verifyContactDetails(String id, DriverInfo expectedContactDetails) {
    pause2s();
    final String licenseNumberXpath = f(
        "//span[contains(@class,'ant-typography') and contains(text(),'%s')]",
        expectedContactDetails.getLicenseNumber());
    final String nameXpath = f(
        "//span[contains(@class,'ant-typography') and contains(text(),'%s')]",
        expectedContactDetails.getFullName());
    final String contactsXpath = f(
        "//div[contains(@class,'ant-col') and contains(text(),'%s')]",
        expectedContactDetails.getContact());

    driversTable.filterByColumn(COLUMN_ID, id);
    driversTable.clickActionButton(1, ACTION_CONTACT_INFO);
    pause2s();
    waitUntilVisibilityOfElementLocated(licenseNumberXpath);
    waitUntilVisibilityOfElementLocated(nameXpath);
    waitUntilVisibilityOfElementLocated(contactsXpath);

    Assertions.assertThat(isElementExist(licenseNumberXpath))
        .as(f("License number should be displayed [Expected: %s]",
            expectedContactDetails.getLicenseNumber()))
        .isTrue();

    Assertions.assertThat(isElementExist(nameXpath))
        .as(f("Full name should be displayed [Expected: %s]",
            expectedContactDetails.getFullName()))
        .isTrue();

    Assertions.assertThat(isElementExist(contactsXpath))
        .as(f("Contact should be displayed [Expected: %s]",
            expectedContactDetails.getContact()))
        .isTrue();
  }

  public void verifyDriverInfo(DriverInfo expectedDriverInfo) {
    filterBy(COLUMN_USERNAME, expectedDriverInfo.getUsername());
    DriverInfo actualDriverInfo = driversTable.readEntity(1);
    if (expectedDriverInfo.getId() != null) {
      Assertions.assertThat(actualDriverInfo.getId()).as("Id")
          .isEqualTo(expectedDriverInfo.getId());
    }
    if (StringUtils.isNotBlank(expectedDriverInfo.getUsername())) {
      Assertions.assertThat(actualDriverInfo.getUsername()).as("Username")
          .isEqualTo(expectedDriverInfo.getUsername());
    }
    if (StringUtils.isNotBlank(expectedDriverInfo.getFirstName())) {
      Assertions.assertThat(actualDriverInfo.getFirstName()).as("First Name")
          .isEqualTo(expectedDriverInfo.getFirstName());
    }
    if (StringUtils.isNotBlank(expectedDriverInfo.getLastName())) {
      Assertions.assertThat(actualDriverInfo.getLastName()).as("Last Name")
          .isEqualTo(expectedDriverInfo.getLastName());
    }
    if (StringUtils.isNotBlank(expectedDriverInfo.getType())) {
      Assertions.assertThat(actualDriverInfo.getType()).as("Type")
          .isEqualTo(expectedDriverInfo.getType());
    }
    if (expectedDriverInfo.getZoneMin() != null) {
      Assertions.assertThat(actualDriverInfo.getZoneMin()).as("Min")
          .isEqualTo(expectedDriverInfo.getZoneMin());
    }
    if (expectedDriverInfo.getZoneMax() != null) {
      Assertions.assertThat(actualDriverInfo.getZoneMax()).as("Max")
          .isEqualTo(expectedDriverInfo.getZoneMax());
    }
    if (StringUtils.isNotBlank(expectedDriverInfo.getComments())) {
      Assertions.assertThat(actualDriverInfo.getComments()).as("Comments")
          .isEqualTo(expectedDriverInfo.getComments());
    }
  }

  public void deleteDriver(String username) {
    waitUntilTableLoaded();
    pause2s();

    String xpath = f(
        "//div[@class='ant-space-item']/input[@dataindex='%s' and contains(@class,'ant-input')]",
        COLUMN_USERNAME);

    if (Strings.isNullOrEmpty(getValue(xpath)) || !getValue(xpath).equalsIgnoreCase(username)) {
      clear(xpath);
      doWithRetry(() -> {
            driversTable.filterByColumn(COLUMN_USERNAME, username);
          }, f("Filter table by %s", COLUMN_USERNAME), DEFAULT_DELAY_ON_RETRY_IN_MILLISECONDS,
          DEFAULT_MAX_RETRY_ON_EXCEPTION);
      waitUntilTableLoaded();
      pause2s();
    }

    driversTable.clickActionButton(1, ACTION_DELETE);
    pause2s();
    click(LOCATOR_DELETE_BUTTON);
    waitUntilInvisibilityOfMdDialogByTitle("Confirm delete");
  }

  public void updloadFile(File absoluteFile) {
    String inputXpath = "//div[@class='ant-space-item']/div[span[text()='Drag and drop CSV file here']]";
    waitUntilVisibilityOfElementLocated(inputXpath);
    dragAndDrop(absoluteFile, findElementBy(By.xpath(inputXpath)));
    pause3s();
  }

  public void clickResignedOption(String resigned) {
    String notResignedXpath = "//div[@label='Not Resigned' and contains(@class,'ant-select-item-option')]";
    String resignedXPath = "//div[@label='Resigned' and contains(@class,'ant-select-item-option')]";
    String allXpath = "//div[@label='All' and contains(@class,'ant-select-item-option')]";

    resignedFilter.waitUntilVisible();
    resignedFilter.click();
    pause5s();
    if (resigned.equalsIgnoreCase("NO") && isElementVisible(notResignedXpath)) {
      click(notResignedXpath);
    }
    if (resigned.equalsIgnoreCase("YES") && isElementVisible(resignedXPath)) {
      click(resignedXPath);
    }
    if (resigned.equalsIgnoreCase("ALL") && isElementVisible(allXpath)) {
      click(allXpath);
    }
    pause5s();
  }

  public void verifyNotificationAppear(String title, String desc) {
    String notificationPopupXpath = "//div[contains(@class, 'ant-notification')]";
    String notificationTitleXpath = "//div[contains(@class, 'ant-notification')]/*/*/*[contains(@class,'ant-notification-notice-message')]";
    String notificationDescXpath = "//div[contains(@class, 'ant-notification')]/*/*/*[contains(@class,'ant-notification-notice-description')]";
    waitUntilVisibilityOfElementLocated(notificationPopupXpath);
    while (isElementVisible(notificationPopupXpath)) {
      boolean isTitleMatch = getText(notificationTitleXpath).equalsIgnoreCase(title);
      boolean isDescMatch = getText(notificationDescXpath).equalsIgnoreCase(desc);
      Assertions.assertThat(isTitleMatch).as("Title is not match")
          .isTrue();
      Assertions.assertThat(isDescMatch).as("Desc is not match")
          .isTrue();
      waitUntilInvisibilityOfElementLocated(notificationPopupXpath);
    }
    pause500ms();
  }

  public void verifyErrorMessageDisplayed(String errorMessage) {
    final String errorMessageXpath = f(
        "//div[@class='ant-space-item']/span[contains(@class,'ant-typography') and contains(text(),'%s')]",
        errorMessage);
    waitUntilVisibilityOfElementLocated(errorMessageXpath);
    Assertions.assertThat(isElementExist(errorMessageXpath))
        .as(f("Error message: [%s] should be exist", errorMessage))
        .isTrue();
  }

  public void openAddNewDriverDialog() {
    final String addDriverDialogXpath = "//div[@class='ant-modal-title' and text()='Add Driver']";
    addNewDriver.waitUntilClickable();
    addNewDriver.click();
    pause5s();
    Assertions.assertThat(isElementExist(addDriverDialogXpath))
        .as("Add driver dialog should be appear")
        .isTrue();
  }

  public void removeVehicleDetails() {
    ForceClearTextBox vehicleLicenseNumber = editDriverDialog.vehicleSettingsForm.vehicleLicenseNumber;
    ForceClearTextBox vehicleCapacity = editDriverDialog.vehicleSettingsForm.vehicleCapacity;
    vehicleLicenseNumber.clearValue();
    vehicleCapacity.clearValue();
    Assertions.assertThat(Strings.isNullOrEmpty(vehicleLicenseNumber.getValue()) &&
            Strings.isNullOrEmpty(vehicleCapacity.getValue()))
        .as("Vehicle detail should be empty")
        .isTrue();
  }

  public void removeZonePreferenceDetails() {
    ForceClearTextBox zoneMin = editDriverDialog.zoneSettingsForms.min;
    ForceClearTextBox zoneMax = editDriverDialog.zoneSettingsForms.max;
    ForceClearTextBox zoneCost = editDriverDialog.zoneSettingsForms.cost;
    ForceClearTextBox seedLat = editDriverDialog.zoneSettingsForms.seedLatitude;
    ForceClearTextBox seedLong = editDriverDialog.zoneSettingsForms.seedLongitude;
    zoneMin.clearValue();
    zoneMax.clearValue();
    zoneCost.clearValue();
    seedLat.clearValue();
    seedLong.clearValue();
    Assertions.assertThat(
            Strings.isNullOrEmpty(zoneMin.getValue()) &&
                Strings.isNullOrEmpty(zoneMax.getValue()) &&
                Strings.isNullOrEmpty(zoneCost.getValue()) &&
                Strings.isNullOrEmpty(seedLat.getValue()) &&
                Strings.isNullOrEmpty(seedLong.getValue()))
        .as("Zone preference detail should be empty")
        .isTrue();
  }

  public void verifyContactDetailsAlreadyVerified(DriverInfo driverInfo) {
    final String contactsXpath = f(
        "//div[contains(@class,'ant-col') and contains(text(),'%s')]", driverInfo.getContact());
    final String verifiedXpath = "//div[contains(@class, 'ant-typography') and text()='Verified']";
    if (!isElementExist(contactsXpath)) {
      refreshPage();
      waitUntilPageLoaded();
      loadSelection();
      waitUntilTableLoaded();
      filterBy(COLUMN_USERNAME, driverInfo.getUsername());
      driversTable.clickActionButton(1, ACTION_CONTACT_INFO);
    }
    waitUntilVisibilityOfElementLocated(verifiedXpath);
    Assertions.assertThat(isElementExist(verifiedXpath))
        .as("Contact details should be verified")
        .isTrue();
  }

  public void verifyButtonVerifiedDisable() {
    pause5s();
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

    @FindBy(id = "displayName")
    public ForceClearTextBox displayName;

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

    @FindBy(xpath = "//span[contains(@class,'ant-input')]/input[@name='password' and @id='password']")
    public ForceClearTextBox password;

    @FindBy(id = "comment")
    public ForceClearTextBox comments;

    @FindBy(xpath = ".//button[.='Add More Vehicle']")
    public Button addMoreVehicles;

    @FindBy(xpath = "//div[contains(@class,'ant-space')][div[@class='ant-space-item'][span[text()='Vehicle']]]")
    public VehicleSettingsForm vehicleSettingsForm;

    @FindBy(xpath = ".//button[.='Add More Contact']")
    public Button addMoreContacts;

    @FindBy(xpath = "//div[contains(@class,'ant-space')][div[@class='ant-space-item'][span[text()='Contact']]]")
    public ContactsSettingsForm contactsSettingsForms;

    @FindBy(xpath = ".//button[.='Add More Zones']")
    public Button addMoreZones;

    @FindBy(xpath = "//div[contains(@class,'ant-space')][div[@class='ant-space-item'][span[text()='Preferred Zone + Capacity']]]")
    public ZoneSettingsForm zoneSettingsForms;

    public static class VehicleSettingsForm extends PageElement {

      public VehicleSettingsForm(WebDriver webDriver, SearchContext searchContext,
          WebElement webElement) {
        super(webDriver, searchContext, webElement);
      }

      @FindBy(name = "vehicles.vehicleType")
      public AntSelect vehicleType;

      @FindBy(name = "vehicles.vehicleNo")
      public ForceClearTextBox vehicleLicenseNumber;

      @FindBy(name = "vehicles.capacity")
      public ForceClearTextBox vehicleCapacity;

      @FindBy(name = "vehicles.ownVehicle")
      public Button vehicleOwn;

    }

    public static class ContactsSettingsForm extends PageElement {

      public ContactsSettingsForm(WebDriver webDriver, SearchContext searchContext,
          WebElement webElement) {
        super(webDriver, searchContext, webElement);
      }

      @FindBy(name = "contacts.details")
      public ForceClearTextBox contact;

    }

    public static class ZoneSettingsForm extends PageElement {

      public ZoneSettingsForm(WebDriver webDriver, SearchContext searchContext,
          WebElement webElement) {
        super(webDriver, searchContext, webElement);
      }

      @FindBy(name = "zonePreferences.zone")
      public AntSelect zoneName;

      @FindBy(name = "zonePreferences.minWaypoints")
      public ForceClearTextBox min;

      @FindBy(name = "zonePreferences.maxWaypoints")
      public ForceClearTextBox max;

      @FindBy(name = "zonePreferences.cost")
      public ForceClearTextBox cost;

      @FindBy(name = "zonePreferences.latitude")
      public ForceClearTextBox seedLatitude;

      @FindBy(name = "zonePreferences.longitude")
      public ForceClearTextBox seedLongitude;

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

    public AddDriverDialog setDisplayNameName(String value) {
      if (value != null) {
        displayName.setValue(value);
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

    public void setDpmsId(String dpmsIdValue) {
      if (dpmsId.isDisplayed()) {
        dpmsId.click();
        for (char key : dpmsIdValue.toCharArray()) {
          dpmsId.sendKeys(Keys.BACK_SPACE);
        }
        dpmsId.sendKeys(dpmsIdValue);
      }
    }

    public void addVehicle(String vehicleType, String licenseNumber, Integer capacity) {
      vehicleSettingsForm.vehicleType.selectValue(vehicleType);
      if (licenseNumber != null) {
        vehicleSettingsForm.vehicleLicenseNumber.setValue(licenseNumber);
      }
      if (capacity != null) {
        vehicleSettingsForm.vehicleCapacity.setValue(capacity);
      }
    }

    public void addContact(String contact) {
      if (contact != null) {
        contactsSettingsForms.contact.setValue(contact);
      }
    }

    public AddDriverDialog addZone(String zoneName, Integer min, Integer max, Integer cost) {
      if (StringUtils.isNotBlank(zoneName)) {
        zoneSettingsForms.zoneName.selectValue(zoneName);
      }
      if (min != null) {
        zoneSettingsForms.min.setValue(min);
      }
      if (max != null) {
        zoneSettingsForms.max.setValue(max);
      }
      if (cost != null) {
        zoneSettingsForms.cost.setValue(cost);
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
      if (value != null && password.isDisplayed()) {
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
      try {
        waitUntilInvisible();
      } catch (TimeoutException ex) {
        NvLogger.info("[ERROR] Something wrong form submitted");
        NvLogger.error(ex.getLocalizedMessage());
      }
    }

    public void fillForm(DriverInfo driverInfo) {
      waitUntilVisible();
      pause3s();
      setDisplayNameName(driverInfo.getDisplayName());
      setFirstName(driverInfo.getFirstName());
      setLastName(driverInfo.getLastName());
      setDriverLicenseNumber(driverInfo.getLicenseNumber());
      setType(driverInfo.getType());
      setMaximumOnDemandWaypoint(10l);
      if (driverInfo.getType().equalsIgnoreCase("Mitra - Fleet") &&
          !Objects.isNull(driverInfo.getDpmsId())) {
        setDpmsId(driverInfo.getDpmsId());
      }
      setCodLimit(driverInfo.getCodLimit());
      setHub(driverInfo.getHub());
      setEmploymentStartDate(driverInfo.getEmploymentStartDate());
      if (driverInfo.hasVehicleInfo()) {
        addVehicle(driverInfo.getVehicleType(), driverInfo.getVehicleLicenseNumber(),
            driverInfo.getVehicleCapacity());
      }
      if (driverInfo.hasContactsInfo()) {
        addContact(driverInfo.getContact());
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

    public static final String LOCATOR_LICENSE = "(//div[contains(@class,'ant-col') and span[text() = 'License No.'] and span[contains(@class,'ant-typography')]])[4]/span[2]";
    public static final String LOCATOR_CONTACT = "((//div[contains(@class,'ant-col') and span[contains(@class,'ant-typography') and text()='Contacts'] ]/div[@class='ant-row'])[4]/div[@class='ant-col'])[1]";
    public static final String LOCATOR_CONTACT_TYPE = "//div[@class='ant-col ant-col-24']/div/div[2]/span[1]";
    public static final String LOCATOR_COMMENTS = "//*[contains(@class,'md-active')]//*[@class='contact-info-comments']/div[contains(.,'Comments')]/div[2]";
    public static final String LOCATOR_NAME = "(//div[contains(@class,'ant-col') and span[text() = 'Name'] and span[contains(@class,'ant-typography')]])[4]/span[2]";

    @FindBy(xpath = "//div[@class = 'ant-popover-title']")
    private PageElement contactDetailsDialog;

    public ContactDetailsMenu(WebDriver webDriver) {
      super(webDriver);
    }

    public String getLicenseNumber() {
      waitUntilVisibilityOfElementLocated(LOCATOR_LICENSE);
      return getText(LOCATOR_LICENSE);
    }

    public String getName() {
      waitUntilVisibilityOfElementLocated(LOCATOR_NAME);
      return getText(LOCATOR_NAME);
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
      driverInfo.setName(getName());
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
      if (licenseNumber != null) {
        vehicleSettingsForm.vehicleLicenseNumber.setValue(licenseNumber);
      }
      if (capacity != null) {
        vehicleSettingsForm.vehicleCapacity.setValue(capacity);
      }
      return this;
    }

    public EditDriverDialog editContact(String contactType, String contact) {
      if (contact != null) {
        contactsSettingsForms.contact.setValue(contact + Keys.TAB);
      }
      return this;
    }

    public EditDriverDialog editZone(String zoneName, Integer min, Integer max, Integer cost) {
      if (StringUtils.isNotBlank(zoneName)) {
        zoneSettingsForms.zoneName.selectValue(zoneName);
      }
      if (min != null) {
        zoneSettingsForms.min.setValue(min);
      }
      if (max != null) {
        zoneSettingsForms.max.setValue(max);
      }
      if (cost != null) {
        zoneSettingsForms.cost.setValue(cost);
      }
      return this;
    }

    public void fillForm(DriverInfo driverInfo, Boolean isVerified) {
      waitUntilVisible();
      pause3s();
      setDisplayNameName(driverInfo.getDisplayName());
      setFirstName(driverInfo.getFirstName());
      setLastName(driverInfo.getLastName());
      setDriverLicenseNumber(driverInfo.getLicenseNumber());
      setCodLimit(driverInfo.getCodLimit());
      if (driverInfo.getType().equalsIgnoreCase("Mitra - Fleet") && !Objects.isNull(
          driverInfo.getDpmsId())) {
        setDpmsId(driverInfo.getDpmsId());
      }
      if (driverInfo.hasVehicleInfo()) {
        addVehicle(driverInfo.getVehicleType(), driverInfo.getVehicleLicenseNumber(),
            driverInfo.getVehicleCapacity());
      }
      if (driverInfo.hasContactsInfo()) {
        final String btnVerifyNumberXpath = "//button[contains(@class,'ant-btn') and span[text()='Verify Number']]";
        final String btnConfirmVerifyXpath = "//button[contains(@class,'ant-btn')]/span[contains(text(), 'Yes')]";
        String[] phoneNumber = driverInfo.getContact().split(" ");
        addContact(phoneNumber[phoneNumber.length - 1]);
        if (isVerified) {
          waitUntilVisibilityOfElementLocated(btnVerifyNumberXpath);
          click(btnVerifyNumberXpath);
          waitUntilVisibilityOfElementLocated(btnConfirmVerifyXpath);
          while (isElementVisible(btnConfirmVerifyXpath)) {
            click(btnConfirmVerifyXpath);
            pause1s();
          }
          waitUntilInvisibilityOfElementLocated(btnConfirmVerifyXpath);
        }
      }
      if (driverInfo.hasZoneInfo()) {
        addZone(driverInfo.getZoneId(), driverInfo.getZoneMin(), driverInfo.getZoneMax(),
            driverInfo.getZoneCost());
      }
      setPassword(driverInfo.getPassword());
      setComments(driverInfo.getComments());
    }
  }

  public static class DriversTable extends AntTableV3<DriverInfo> {

    private static final String LOCATOR_COMING_TOGGLE = "(//tr[contains(@class,'ant-table-row')][%d]//td[contains(@class,'ant-table-cell-fix-right')]//button)[1]";
    private static final String LOCATOR_COMING_VALUE = "//tr[contains(@class,'ant-table-row')][%d]//td[contains(@class,'ant-table-cell-fix-right')]//span[contains(@class,'ant-typography')]";

    public static final String COLUMN_ID = "id";
    public static final String COLUMN_USERNAME = "username";
    public static final String COLUMN_DISPLAY_NAME = "displayName";

    public static final String COLUMN_TYPE = "type";
    public static final String COLUMN_ZONE_ID = "zoneId";
    public static final String COLUMN_EMPLOYMENT_START_DATE = "employmentStartDate";
    public static final String COLUMN_EMPLOYMENT_END_DATE = "employmentEndDate";
    public static final String COLUMN_RESIGNED = "resigned";
    public static final String COLUMN_NAME = "name";
    public static final String COLUMN_DPMS_ID = "dpmsId";
    public static final String COLUMN_HUB = "hub";
    public static final String COLUMN_VEHICLE_TYPE = "vehicleType";
    public static final String COLUMN_VEHICLE_OWN = "vehicleOwn";
    public static final String COLUMN_ZONE_MIN = "zoneMin";
    public static final String COLUMN_ZONE_MAX = "zoneMax";
    public static final String COLUMN_COMMENTS = "comments";
    public static final String COLUMN_CIF_EMAIL = "cifEmail";

    public static final String ACTION_EDIT = "edit";
    public static final String ACTION_DELETE = "delete";
    public static final String ACTION_CONTACT_INFO = "contact_info";

    public DriversTable(WebDriver webDriver) {
      super(webDriver);
      setColumnLocators(ImmutableMap.<String, String>builder()
          .put(COLUMN_ID, "2")
          .put(COLUMN_USERNAME, "3")
          .put(COLUMN_DISPLAY_NAME, "4")
          .put(COLUMN_NAME, "5")
          .put(COLUMN_HUB, "6")
          .put(COLUMN_TYPE, "7")
          .put(COLUMN_CIF_EMAIL, "8")
          .put(COLUMN_DPMS_ID, "9")
          .put(COLUMN_VEHICLE_TYPE, "10")
          .put(COLUMN_VEHICLE_OWN, "11")
          .put(COLUMN_ZONE_ID, "12")
          .put(COLUMN_ZONE_MIN, "13")
          .put(COLUMN_ZONE_MAX, "14")
          .put(COLUMN_COMMENTS, "15")
          .put(COLUMN_EMPLOYMENT_START_DATE, "16")
          .put(COLUMN_EMPLOYMENT_END_DATE, "17")
          .put(COLUMN_RESIGNED, "18")
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
    String tableRowXpath = "//tr[contains(@class,\"ant-table-row ant-table-row-level-0\")][td[@class='ant-table-cell']]";
    Runnable verifyLoadedTable = () -> {
      if (!findElementBy(By.xpath(tableRowXpath)).isDisplayed()) {
        pause500ms();
      }
    };

    try {
      doWithRetry(verifyLoadedTable, "Loaded table method", DEFAULT_DELAY_ON_RETRY_IN_MILLISECONDS,
          DEFAULT_MAX_RETRY_ON_EXCEPTION);
    } catch (NoSuchElementException ignored) {
      NvLogger.error("===== Table isn't loaded =====");
      NvLogger.error(ignored.getMessage());
    }
  }

  public boolean isTableLoaded() {
    return isElementExist("//tr[@class='ant-table-row ant-table-row-level-0'][1]");
  }

  public boolean verifyNoDataOnTable() {
    final WebElement noData = findElementByXpath(
        "//div[@class='ant-empty ant-empty-normal']/p[.='No Data']");
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

  public List<String> getAllDownloadOptions() {
    waitUntilPageLoaded();
    downloadHamburgerIcon.click();
    pause2s();
    List<String> options = new ArrayList<String>();
    for (PageElement option : downloadOptions) {
      options.add(option.getText());
    }
    return options;
  }

  public void verifyFileDownloadForUpdate(String downloadOption) {
    waitUntilPageLoaded();
    downloadHamburgerIcon.click();
    String downloadOptionXpath = f(DOWNLOAD_OPTS_HAMBURGER_XPATH, downloadOption);
    WebElement downloadToUpdate = getWebDriver().findElement(By.xpath(downloadOptionXpath));
    downloadToUpdate.click();
  }

  public boolean verifyNoticeDisplayed(String notice) {
    String noticeXpath = f(ALERT_MESSAGE_XPATH, notice);
    Boolean isExist = isElementExist(noticeXpath);
    Assertions.assertThat(isExist)
        .as(f("Assert that notice : %s  is displayed as expected!", notice))
        .isTrue();
    return isExist;
  }
}
