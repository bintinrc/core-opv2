package co.nvqa.operator_v2.selenium.page;

import co.nvqa.operator_v2.model.DriverInfo;
import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.TextBox;
import co.nvqa.operator_v2.selenium.elements.md.MdAutocomplete;
import co.nvqa.operator_v2.selenium.elements.md.MdDatepicker;
import co.nvqa.operator_v2.selenium.elements.md.MdDialog;
import co.nvqa.operator_v2.selenium.elements.md.MdSelect;
import co.nvqa.operator_v2.selenium.elements.nv.NvAutocomplete;
import co.nvqa.operator_v2.selenium.elements.nv.NvButtonSave;
import co.nvqa.operator_v2.selenium.elements.nv.NvFilterBooleanBox;
import co.nvqa.operator_v2.selenium.elements.nv.NvFilterBox;
import co.nvqa.operator_v2.selenium.elements.nv.NvIconTextButton;
import com.google.common.collect.ImmutableMap;
import java.util.List;
import org.apache.commons.lang3.StringUtils;
import org.openqa.selenium.SearchContext;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;

import static co.nvqa.operator_v2.selenium.page.DriverStrengthPageV2.DriversTable.ACTION_CONTACT_INFO;
import static co.nvqa.operator_v2.selenium.page.DriverStrengthPageV2.DriversTable.ACTION_DELETE;
import static co.nvqa.operator_v2.selenium.page.DriverStrengthPageV2.DriversTable.ACTION_EDIT;
import static co.nvqa.operator_v2.selenium.page.DriverStrengthPageV2.DriversTable.COLUMN_USERNAME;

/**
 * @author Sergey Mishanin
 */
@SuppressWarnings("WeakerAccess")
public class DriverStrengthPageV2 extends OperatorV2SimplePage {

  private static final String LOCATOR_SPINNER = "//md-progress-circular";
  public static final String LOCATOR_DELETE_BUTTON = "//md-dialog//button[@aria-label='Delete']";

  @FindBy(css = "md-dialog")
  public AddDriverDialog addDriverDialog;

  @FindBy(css = "md-dialog")
  public EditDriverDialog editDriverDialog;

  public DriversTable driversTable;
  private ContactDetailsMenu contactDetailsMenu;

  @FindBy(name = "container.driver-strength.edit-search-filter")
  public NvIconTextButton editSearchFilter;

  @FindBy(name = "container.driver-strength.load-selection")
  public NvIconTextButton loadSelection;

  @FindBy(name = "container.driver-strength.load-everything")
  public NvIconTextButton loadEverything;

  @FindBy(name = "Add New Driver")
  public NvIconTextButton addNewDriver;

  @FindBy(xpath = "//nv-filter-box[@item-types='Zones']")
  public NvFilterBox zonesFilter;

  @FindBy(xpath = "//nv-filter-box[@item-types='Driver Types']")
  public NvFilterBox driverTypesFilter;

  @FindBy(css = "nv-filter-boolean-box[main-title='Resigned']")
  public NvFilterBooleanBox resignedFilter;

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
    waitUntilVisibilityOfElementLocated("//nv-icon-text-button[@name='Add New Driver']//button");
    click("//nv-icon-text-button[@name='Add New Driver']//button");
  }

  public void addNewDriver(DriverInfo driverInfo) {
    waitUntilInvisibilityOfElementLocated(LOCATOR_SPINNER);
    clickAddNewDriver();
    addDriverDialog.fillForm(driverInfo);
    addDriverDialog.submitForm();
  }

  public void editDriver(String username, DriverInfo newDriverInfo) {
    filterBy(COLUMN_USERNAME, username);
    driversTable.clickActionButton(1, ACTION_EDIT);
    editDriverDialog.fillForm(newDriverInfo);
    editDriverDialog.submitForm();
  }

  public void filterBy(String columnName, String value) {
    if (loadEverything.isDisplayed()) {
      loadEverything.click();
      if (halfCircleSpinner.waitUntilVisible(2)) {
        halfCircleSpinner.waitUntilInvisible();
      }
    }
    driversTable.filterByColumn(columnName, value);
  }

  public void verifyContactDetails(String username, DriverInfo expectedContactDetails) {
    filterBy(COLUMN_USERNAME, username);
    driversTable.clickActionButton(1, ACTION_CONTACT_INFO);
    DriverInfo actualContactDetails = contactDetailsMenu.readData();
    if (StringUtils.isNotBlank(expectedContactDetails.getLicenseNumber())) {
      assertThat("License Number", actualContactDetails.getLicenseNumber(),
          equalTo(expectedContactDetails.getLicenseNumber()));
    }
    if (StringUtils.isNotBlank(expectedContactDetails.getContact())) {
      assertThat("Contact", actualContactDetails.getContact(),
          equalTo(expectedContactDetails.getContact()));
    }
    if (StringUtils.isNotBlank(expectedContactDetails.getContactType())) {
      assertThat("Contact Type", actualContactDetails.getContactType(),
          containsString(expectedContactDetails.getContactType()));
    }
    if (StringUtils.isNotBlank(expectedContactDetails.getComments())) {
      assertThat("Comments", actualContactDetails.getComments(),
          equalTo(expectedContactDetails.getComments()));
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
    filterBy(COLUMN_USERNAME, username);
    driversTable.clickActionButton(1, ACTION_DELETE);
    waitUntilVisibilityOfMdDialogByTitle("Confirm delete");
    waitUntilVisibilityOfElementLocated(LOCATOR_DELETE_BUTTON);
    waitUntilElementIsClickable(LOCATOR_DELETE_BUTTON);
    pause1s();
    click(LOCATOR_DELETE_BUTTON);
    waitUntilInvisibilityOfMdDialogByTitle("Confirm delete");
  }

  /**
   * Accessor for Add Driver dialog
   */
  @SuppressWarnings("UnusedReturnValue")
  public static class AddDriverDialog extends MdDialog {

    @FindBy(name = "Submit")
    public NvButtonSave submit;

    @FindBy(css = "div.hints")
    public PageElement hints;

    @FindBy(css = "nv-autocomplete[placeholder='Hub']")
    public NvAutocomplete hub;

    @FindBy(id = "employment-start-date")
    public MdDatepicker employmentStartDate;

    @FindBy(css = "input[aria-label='First Name']")
    public TextBox firstName;

    @FindBy(css = "input[aria-label='Last Name']")
    public TextBox lastName;

    @FindBy(css = "input[aria-label='COD Limit']")
    public TextBox codLimit;

    @FindBy(css = "input[aria-label='Driver License Number']")
    public TextBox driverLicenseNumber;

    @FindBy(css = "input[aria-label='Username']")
    public TextBox username;

    @FindBy(css = "input[aria-label='Password']")
    public TextBox password;

    @FindBy(name = "commons.comments")
    public TextBox comments;

    @FindBy(css = "button[aria-label='Check Availability']")
    public Button checkAvailability;

    @FindBy(name = "Add More Vehicles")
    public NvIconTextButton addMoreVehicles;

    @FindBy(css = "div[ng-repeat='vehicle in fields.vehicles._values track by $index']")
    public List<VehicleSettingsForm> vehicleSettingsForm;

    @FindBy(name = "Add More Contacts")
    public NvIconTextButton addMoreContacts;

    @FindBy(css = "div[ng-repeat='contact in fields.contacts._values track by $index']")
    public List<ContactsSettingsForm> contactsSettingsForms;

    @FindBy(name = "Add More Zones")
    public NvIconTextButton addMoreZones;

    @FindBy(css = "div[ng-repeat='zonePreference in fields.zonePreferences._values track by $index']")
    public List<ZoneSettingsForm> zoneSettingsForms;

    public static class VehicleSettingsForm extends PageElement {

      public VehicleSettingsForm(WebDriver webDriver, SearchContext searchContext,
          WebElement webElement) {
        super(webDriver, searchContext, webElement);
      }

      @FindBy(css = "input[aria-label='License Number']")
      public TextBox vehicleLicenseNumber;

      @FindBy(css = "input[aria-label='Vehicle Capacity']")
      public TextBox vehicleCapacity;

      @FindBy(css = "button[aria-label='Remove']")
      public Button remove;

    }

    public static class ContactsSettingsForm extends PageElement {

      public ContactsSettingsForm(WebDriver webDriver, SearchContext searchContext,
          WebElement webElement) {
        super(webDriver, searchContext, webElement);
      }

      @FindBy(css = "md-select[id^='contact-type']")
      public MdSelect contactType;

      @FindBy(css = "input[aria-label='Contact']")
      public TextBox contact;

      @FindBy(css = "button[aria-label='Remove']")
      public Button remove;

    }

    public static class ZoneSettingsForm extends PageElement {

      public ZoneSettingsForm(WebDriver webDriver, SearchContext searchContext,
          WebElement webElement) {
        super(webDriver, searchContext, webElement);
      }

      @FindBy(css = "md-select[id^='zone']")
      public MdSelect zoneName;

      @FindBy(css = "input[aria-label='Min']")
      public TextBox min;

      @FindBy(css = "input[aria-label='Max']")
      public TextBox max;

      @FindBy(css = "input[aria-label='Cost']")
      public TextBox cost;

      @FindBy(css = "input[aria-label='Seed Latitude']")
      public TextBox seedLatitude;

      @FindBy(css = "input[aria-label='Seed Longitude']")
      public TextBox seedLongitude;

      @FindBy(css = "button[aria-label='Remove']")
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
        employmentStartDate.simpleSetValue(value);
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

    public AddDriverDialog addVehicle(String licenseNumber, Integer capacity) {
      addMoreVehicles.click();
      VehicleSettingsForm form = vehicleSettingsForm.get(vehicleSettingsForm.size() - 1);
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
      if (StringUtils.isNotBlank(contactType)) {
        form.contactType.searchAndSelectValue(contactType);
      }
      if (contact != null) {
        form.contact.setValue(contact);
      }
      return this;
    }

    public AddDriverDialog addZone(String zoneName, Integer min, Integer max, Integer cost) {
      addMoreZones.click();
      ZoneSettingsForm form = zoneSettingsForms.get(zoneSettingsForms.size() - 1);
      if (StringUtils.isNotBlank(zoneName)) {
        form.zoneName.searchAndSelectValue(zoneName);
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
      submit.clickAndWaitUntilDone();
      waitUntilInvisible();
    }

    public void fillForm(DriverInfo driverInfo) {
      waitUntilVisible();
      setFirstName(driverInfo.getFirstName());
      setLastName(driverInfo.getLastName());
      setDriverLicenseNumber(driverInfo.getLicenseNumber());
      setCodLimit(driverInfo.getCodLimit());
      setHub(driverInfo.getHub());
      setEmploymentStartDate(driverInfo.getEmploymentStartDate());
      if (driverInfo.hasVehicleInfo()) {
        addVehicle(driverInfo.getVehicleLicenseNumber(), driverInfo.getVehicleCapacity());
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

    public static final String LOCATOR_CONTACT = "//*[contains(@class,'md-active')]//*[@class='contact-info-contacts']/div[1]";
    public static final String LOCATOR_CONTACT_TYPE = "//*[contains(@class,'md-active')]//*[@class='contact-info-contacts']/div[2]";
    public static final String LOCATOR_COMMENTS = "//*[contains(@class,'md-active')]//*[@class='contact-info-comments']/div[contains(.,'Comments')]/div[2]";

    @FindBy(xpath = "//*[contains(@class,'md-active')]")
    private ContactDetailsDialog contactDetailsDialog;

    public ContactDetailsMenu(WebDriver webDriver) {
      super(webDriver);
    }

    public String getLicenseNumber() {
      contactDetailsDialog.waitUntilVisible();
      return contactDetailsDialog.driverLicenseNumber.getText();
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

      @FindBy(xpath = "//*[contains(@class,'md-active')]//*[@class='contact-info-details']/div[contains(.,'License No.')]/div[2]")
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
        form.contactType.searchAndSelectValue(contactType);
      }
      if (contact != null) {
        form.contact.setValue(contact);
      }
      return this;
    }

    public EditDriverDialog editZone(String zoneName, Integer min, Integer max, Integer cost) {
      ZoneSettingsForm form = zoneSettingsForms.get(zoneSettingsForms.size() - 1);
      if (StringUtils.isNotBlank(zoneName)) {
        form.zoneName.searchAndSelectValue(zoneName);
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
      setCodLimit(driverInfo.getCodLimit());
      if (driverInfo.hasVehicleInfo()) {
        if (vehicleSettingsForm.size() > 0) {
          editVehicle(driverInfo.getVehicleLicenseNumber(), driverInfo.getVehicleCapacity());
        } else {
          addVehicle(driverInfo.getVehicleLicenseNumber(), driverInfo.getVehicleCapacity());
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

  /**
   * Accessor for DP table
   */
  public static class DriversTable extends MdVirtualRepeatTable<DriverInfo> {

    private static final String LOCATOR_COMING_TOGGLE = "//tr[@md-virtual-repeat='%s'][%d]/td[contains(@class, 'availability')]/nv-toggle-button/button";

    public static final String COLUMN_ID = "id";
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
          .put(COLUMN_ID, "id")
          .put(COLUMN_USERNAME, "username")
          .put("name", "name")
          .put("hub", "hub")
          .put(COLUMN_TYPE, "driver-type")
          .put("vehicleType", "vehicles-vehicle-type")
          .put("vehicleOwn", "vehicles-own-vehicle")
          .put(COLUMN_ZONE, "zone-preferences-zone-id")
          .put("zoneMin", "zone-preferences-min-waypoints")
          .put("zoneMax", "zone-preferences-max-waypoints")
          .put("comments", "comments")
          .put(COLUMN_EMPLOYMENT_START_DATE, "_employment-start-date")
          .put(COLUMN_EMPLOYMENT_END_DATE, "_employment-end-date")
          .put(COLUMN_RESIGNED, "resign")
          .build()
      );
      setActionButtonsLocators(ImmutableMap
          .of(ACTION_CONTACT_INFO, "//button[@aria-label='Contact Info']", ACTION_EDIT, "Edit",
              ACTION_DELETE, "Delete"));
      setEntityClass(DriverInfo.class);
      setMdVirtualRepeat("driver in getTableData()");
    }

    public String getComingStatus(int rowNumber) {
      String xpath = String
          .format(LOCATOR_COMING_TOGGLE + "/span", getMdVirtualRepeat(), rowNumber);
      return getText(xpath);
    }

    public void toggleComingStatus(int rowNumber) {
      String xpath = String.format(LOCATOR_COMING_TOGGLE, getMdVirtualRepeat(), rowNumber);
      waitUntilElementIsClickable(xpath);
      click(xpath);
    }
  }
}
