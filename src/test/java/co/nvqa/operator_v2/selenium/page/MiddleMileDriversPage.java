package co.nvqa.operator_v2.selenium.page;

import co.nvqa.commons.model.core.Driver;
import co.nvqa.commons.util.NvLogger;
import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.CheckBox;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.TextBox;
import co.nvqa.operator_v2.selenium.elements.ant.AntModal;
import co.nvqa.operator_v2.selenium.elements.ant.AntSelect;
import co.nvqa.operator_v2.selenium.elements.ant.v4.AntCalendarPicker;
import com.google.common.collect.Comparators;
import org.assertj.core.api.Assertions;
import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;

/**
 * @author Tristania Siagian
 */

public class MiddleMileDriversPage extends OperatorV2SimplePage {

  private static final String IFRAME_XPATH = "//iframe[contains(@src,'middle-mile-drivers')]";
  private static final String LOAD_DRIVERS_BUTTON_XPATH = "//div[contains(@class,'col')]/button[contains(@class,'ant-btn-primary')]";
  private static final String DRIVERS_NOT_FOUND_TOAST_XPATH = "//div[contains(@class,'notification-notice-closable')]";
  //private static final String TOTAL_DRIVER_SHOW_XPATH = "//div[contains(@class,'TableWrapper')]/div[contains(@class,'TableStats')]/span[2]"; -
  private static final String TOTAL_DRIVER_SHOW_XPATH = "//span[@class='ant-typography']//strong[normalize-space()]";
  private static final String SELECT_FILTER_VALUE_XPATH = "//div[not(contains(@class,'ant-select-dropdown-hidden'))]//div[contains(@class,'ant-select-item-option')]/div[text()= '%s']";
  private static final String CREATE_DRIVER_BUTTON_XPATH = "//button[contains(@class,'add-driver-btn')]";
  private static final String MODAL_XPATH = "//div[contains(@id,'rcDialogTitle')]";
  private static final String DATE_PICKER_MODAL_XPATH = "//div[not(contains(@class, 'ant-picker-dropdown-hidden'))]/div[@class= 'ant-picker-panel-container']";
  private static final String NEXT_MONTH_XPATH = "//div[contains(@class, 'ant-picker-dropdown')][not(contains(@class,'ant-picker-dropdown-hidden'))]//button[contains(@class,'ant-picker-header-next-btn')]";
  private static final String CALENDAR_DATE_XPATH = "//div[contains(@class, 'ant-picker-dropdown')][not(contains(@class,'ant-picker-dropdown-hidden'))]//td[@title='%s']/div";
  private static final String SAVE_BUTTON_XPATH = "//div[contains(@class,'footer')]/button[contains(@class,'primary')]";
  private static final String TOAST_DRIVER_CREATED_XPATH = "//div[contains(@class,'ant-notification-notice-description') and text()='Username: %s']";
  private static final String NO_RESULT_TABLE_XPATH = "//div[contains(@class,'ant-empty ')]";
  private static final String VIEW_BUTTON_XPATH = "//button[contains(@class,'view-user-btn')]";
  private static final String EDIT_BUTTON_XPATH = "//button[contains(@class,'edit-user-btn')]";
  private static final String NO_COMING_BUTTON_XPATH = "//button[contains(@class, 'availability-btn')][text()='No']";
  private static final String YES_COMING_BUTTON_XPATH = "//button[contains(@class, 'availability-btn')][text()='Yes']";
  private static final String DROP_DOWN_ON_TABLE_XPATH = "//div[contains(@class,'ant-table-selection')]";
  private static final String APPLY_ACTION_DROP_DOWN_XPATH = "//button[contains(@class,'apply-action-btn')]";
  private static final String SET_TO_COMING_DROP_DOWN_XPATH = "//li[contains(@class, 'set-to-coming-btn')]";
  private static final String SET_TO_NOT_COMING_DROP_DOWN_XPATH = "//li[contains(@class, 'set-not-to-coming-btn')]";
  private static final String MODAL_TABLE_HEADER_XPATH ="//div[@class='ant-table-container']//thead";
  private static final String TABLE_COLUMN_VALUES_BY_INDEX_XPATH ="//div[@class='ant-table-container']//tbody//td[%d]";
  private static final String TABLE_FILTER_SORT_XPATH = "//span[@class='ant-table-column-title' and text()='%s']";
  private static final String EMPLOYMENT_STATUS_FILTER_TEXT = "//input[@id='employmentStatus']/ancestor::div[contains(@class, ' ant-select')]//span[@class='ant-select-selection-item']";
  private static final String LICENSE_STATUS_FILTER_TEXT = "//input[@id='licenseStatus']/ancestor::div[contains(@class, ' ant-select')]//span[@class='ant-select-selection-item']";

  private static final String INPUT_CREATE_DRIVER_MODAL_XPATH = "//input[@id='%s']";
  private static final String TABLE_ASSERTION_XPATH = "//div[contains(@class,'ant-table-body')]//tbody/tr[2]/td[%d]";

  private static final String LICENSE_TYPE_INPUT_CREATE_DRIVER_XPATH = "//input[@value='%s']";
  private static final String COMMENTS_INPUT_CREATE_DRIVER_XPATH = "//textarea[@id='comments']";

  private static final String NAME_INPUT_CREATE_DRIVER_ID = "name";
  private static final String HUB_INPUT_CREATE_DRIVER_ID = "hubId";
  private static final String CONTACT_NUMBER_INPUT_CREATE_DRIVER_ID = "contactNumber";
  private static final String LICENSE_NUMBER_INPUT_CREATE_DRIVER_ID = "licenseNumber";
  private static final String EXPIRY_DATE_INPUT_CREATE_DRIVER_ID = "licenseExpiryDate";
  private static final String EMPLOYMENT_TYPE_INPUT_CREATE_DRIVER_ID = "employmentType";
  private static final String EMPLOYMENT_START_DATE_INPUT_CREATE_DRIVER_ID = "employmentStartDate";
  private static final String EMPLOYMENT_END_DATE_INPUT_CREATE_DRIVER_ID = "employmentEndDate";
  private static final String USERNAME_INPUT_CREATE_DRIVER_ID = "username";
  private static final String PASSWORD_INPUT_CREATE_DRIVER_ID = "password";

  private static final String NAME_TABLE_FILTER_ID = "name";
  private static final String USERNAME_TABLE_FILTER_ID = "username";
  private static final String HUB_TABLE_FILTER_ID = "hub";
  private static final String COMMENTS_TABLE_FILTER_ID = "comments";

  private static final Integer NEW_NAME_TABLE_FILTER_ID = 2;
  private static final Integer NEW_ID_TABLE_FILTER_ID = 3;
  private static final Integer NEW_USERNAME_TABLE_FILTER_ID = 4;
  private static final Integer NEW_HUB_TABLE_FILTER_ID = 5;
  private static final Integer NEW_EMPLOYMENT_TYPE_FILTER_ID = 6;
  private static final Integer NEW_EMPLOYMENT_STATUS_TABLE_FILTER_ID = 7;
  private static final Integer NEW_LICENSE_TYPE_TABLE_FILTER_ID = 8;
  private static final Integer NEW_LICENSE_STATUS_TABLE_FILTER_ID = 9;
  private static final Integer NEW_COMMENTS_TABLE_FILTER_ID = 10;

  private static final String EMPLOYMENT_TYPE = "employment type";
  private static final String EMPLOYMENT_STATUS = "employment status";
  private static final String LICENSE_TYPE = "license type";
  private static final String LICENSE_STATUS = "license status";
  private static final String ACTIVE_STATUS = "Active";
  private static final String INACTIVE_STATUS = "Inactive";

  private static final String YES = "yes";
  private static final String NO = "no";
  public static List<Driver> LIST_OF_FILTER_DRIVERS = new ArrayList<Driver>();


  @FindBy(tagName = "iframe")
  private PageElement pageFrame;

  @FindBy(xpath = LOAD_DRIVERS_BUTTON_XPATH)
  public Button loadButton;

  @FindBy(xpath = "//span[contains(@class,'ant-spin-dot-spin')]")
  public PageElement antDotSpinner;

  @FindBy(xpath ="//input[@id='hubIds']/ancestor::div[contains(@class, ' ant-select')]")
  public AntSelect hubSearchFilter;

  @FindBy(xpath = "//input[@id='employmentStatus']/ancestor::div[contains(@class, ' ant-select')]")
  public AntSelect employmentStatusSearchFilter;

  @FindBy(xpath = "//input[@id='licenseStatus']/ancestor::div[contains(@class, ' ant-select')]")
  public AntSelect licenseStatusSearchFilter;

  @FindBy(xpath = "//button[.='Load Drivers']")
  public Button loadDrivers;

  @FindBy(xpath = "//input[@aria-label='input-name']")
  public TextBox nameFilter;

  @FindBy(xpath = "//input[@aria-label='input-id']")
  public TextBox idFilter;

  @FindBy(xpath = "//th[div[.='Username']]//input")
  public TextBox usernameFilter;

  @FindBy(xpath = "//th[div[.='Hub']]//input")
  public TextBox hubFilter;

  @FindBy(xpath = "//th[div[.='Comments']]//input")
  public TextBox commentsFilter;

  @FindBy(xpath = "//th[.//span[.='Employment Status']]")
  public StatusFilter employmentStatusFilter;

  @FindBy(xpath = "//th[.//span[.='Employment Type']]")
  public EmploymentTypeFilter employmentTypeFilter;

  @FindBy(xpath = "//th[.//span[.='License Type']]")
  public LicenseTypeFilter licenseTypeFilter;

  @FindBy(xpath = "//th[.//span[.='License Status']]")
  public StatusFilter licenseStatusFilter;

  @FindBy(className = "ant-modal-content")
  public ViewDriverDialog viewDriverDialog;

  @FindBy(className = "ant-modal-content")
  public EditDriverDialog editDriverDialog;

  @FindBy(className = "edit-user-btn")
  public Button editDriver;

  @FindBy(className = "view-user-btn")
  public Button viewDriver;

  @FindBy(xpath = "//button[.='Edit Search Filter']")
  public Button editSearchFilterButton;

  @FindBy(xpath = "//span[contains(@class,'anticon-loading')]")
  public PageElement loadingIcon;


  public MiddleMileDriversPage(WebDriver webDriver) {
    super(webDriver);
  }

  public void switchTo() {
    getWebDriver().switchTo().frame(pageFrame.getWebElement());
  }

  public void clickLoadDriversButton() {
    loadDrivers.click();
    if (isElementExist(DRIVERS_NOT_FOUND_TOAST_XPATH)) {
      waitUntilInvisibilityOfElementLocated(DRIVERS_NOT_FOUND_TOAST_XPATH);
    } else {
      loadDrivers.waitUntilInvisible();
      editSearchFilterButton.waitUntilVisible();
      loadingIcon.waitUntilInvisible(60);
    }
  }

  public void verifiesTotalDriverIsTheSame(int totalDriver) {
    if (totalDriver > 0) {
      assertTrue("Total Driver Shown is the same.",
          getText(TOTAL_DRIVER_SHOW_XPATH).contains(String.valueOf(totalDriver)));
    }
  }

  public void verifiesTextInEmploymentStatusFilter(String ExpectedResult){
    Assertions.assertThat(getText(EMPLOYMENT_STATUS_FILTER_TEXT)).as("Employment Status Filter Text is correct").isEqualToIgnoringCase(ExpectedResult);
  }

  public void verifiesTextInLicenseStatusFilter(String ExpectedResult){
    Assertions.assertThat(getText(LICENSE_STATUS_FILTER_TEXT)).as("License Status Filter Text is correct").isEqualToIgnoringCase(ExpectedResult);
  }

  public void selectHubFilter(String hubName) {
    loadDrivers.waitUntilClickable();
    hubSearchFilter.selectValue(hubName);
  }

  public void selectFilter(String filterName, String value) {
    switch (filterName.toLowerCase()) {
      case "hub":
        hubSearchFilter.selectValue(value);
        break;
      case "employment status":
        employmentStatusSearchFilter.selectValue(value);
        break;
      case "license status":
        licenseStatusSearchFilter.selectValue(value);
        break;
    }
  }

  public void clickCreateDriversButton() {
    waitUntilVisibilityOfElementLocated(LOAD_DRIVERS_BUTTON_XPATH);
    click(CREATE_DRIVER_BUTTON_XPATH);
    waitUntilVisibilityOfElementLocated(MODAL_XPATH);
  }

  public void fillName(String name) {
    sendKeys(f(INPUT_CREATE_DRIVER_MODAL_XPATH, NAME_INPUT_CREATE_DRIVER_ID), name);
  }

  public void chooseHub(String hubName) {
    click(f(INPUT_CREATE_DRIVER_MODAL_XPATH, HUB_INPUT_CREATE_DRIVER_ID));
    sendKeys(f(INPUT_CREATE_DRIVER_MODAL_XPATH, HUB_INPUT_CREATE_DRIVER_ID), hubName);
    waitUntilVisibilityOfElementLocated(f(SELECT_FILTER_VALUE_XPATH, hubName));
    click(f(SELECT_FILTER_VALUE_XPATH, hubName));
  }

  public void fillcontactNumber(String contactNumber) {
    sendKeys(f(INPUT_CREATE_DRIVER_MODAL_XPATH, CONTACT_NUMBER_INPUT_CREATE_DRIVER_ID),
        contactNumber);
  }

  public void fillLicenseNumber(String licenseNumber) {
    sendKeys(f(INPUT_CREATE_DRIVER_MODAL_XPATH, LICENSE_NUMBER_INPUT_CREATE_DRIVER_ID),
        licenseNumber);
  }

  public void fillLicenseExpiryDate(String licenseExpiryDate) {
    click(f(INPUT_CREATE_DRIVER_MODAL_XPATH, EXPIRY_DATE_INPUT_CREATE_DRIVER_ID));
    waitUntilVisibilityOfElementLocated(DATE_PICKER_MODAL_XPATH);
    while (!(isElementExistFast(f(CALENDAR_DATE_XPATH, licenseExpiryDate)))) {
      click(NEXT_MONTH_XPATH);
    }
    click(f(CALENDAR_DATE_XPATH, licenseExpiryDate));
  }

  public void chooseLicenseType(String licenseType) {
    click(f(LICENSE_TYPE_INPUT_CREATE_DRIVER_XPATH, licenseType));
  }

  public void chooseEmploymentType(String employmentType) {
    click(f(INPUT_CREATE_DRIVER_MODAL_XPATH, EMPLOYMENT_TYPE_INPUT_CREATE_DRIVER_ID));
    sendKeys(f(INPUT_CREATE_DRIVER_MODAL_XPATH, EMPLOYMENT_TYPE_INPUT_CREATE_DRIVER_ID), employmentType);
    waitUntilVisibilityOfElementLocated(f(SELECT_FILTER_VALUE_XPATH, employmentType));
    click(f(SELECT_FILTER_VALUE_XPATH, employmentType));
  }

  public void fillEmploymentStartDate(String employmentStartDate) {
    click(f(INPUT_CREATE_DRIVER_MODAL_XPATH, EMPLOYMENT_START_DATE_INPUT_CREATE_DRIVER_ID));
    waitUntilVisibilityOfElementLocated(DATE_PICKER_MODAL_XPATH);
    click(f(CALENDAR_DATE_XPATH, employmentStartDate));
  }

  public void fillEmploymentEndDate(String employmentEndDate) {
    click(f(INPUT_CREATE_DRIVER_MODAL_XPATH, EMPLOYMENT_END_DATE_INPUT_CREATE_DRIVER_ID));
    waitUntilVisibilityOfElementLocated(DATE_PICKER_MODAL_XPATH);
    while (!(isElementExistFast(f(CALENDAR_DATE_XPATH, employmentEndDate)))) {
      click(NEXT_MONTH_XPATH);
    }
    click(f(CALENDAR_DATE_XPATH, employmentEndDate));
  }

  public void fillUsername(String username) {
    sendKeys(f(INPUT_CREATE_DRIVER_MODAL_XPATH, USERNAME_INPUT_CREATE_DRIVER_ID), username);
  }

  public void fillPassword(String password) {
    sendKeys(f(INPUT_CREATE_DRIVER_MODAL_XPATH, PASSWORD_INPUT_CREATE_DRIVER_ID), password);
  }

  public void fillComments(String comments) {
    sendKeys(COMMENTS_INPUT_CREATE_DRIVER_XPATH, comments);
  }

  public void clickSaveButton() {
    click(SAVE_BUTTON_XPATH);
  }

  public void driverHasBeenCreatedToast(String username) {
    waitUntilVisibilityOfElementLocated(f(TOAST_DRIVER_CREATED_XPATH, username));
    waitUntilInvisibilityOfElementLocated(f(TOAST_DRIVER_CREATED_XPATH, username));
  }

  public void tableFilter(Driver middleMileDriver, String filterBy) {
    String actualName = null;
    String actualUsername = null;
    String actualHub = null;
    String actualEmploymentType = null;
    String actualLicenseType = null;
    String actualComments = null;

    switch (filterBy.toLowerCase()) {
      case NAME_TABLE_FILTER_ID:
        nameFilter.setValue(middleMileDriver.getFirstName());
        waitUntilVisibilityOfElementLocated(
            f(TABLE_ASSERTION_XPATH, NEW_NAME_TABLE_FILTER_ID));
        actualName = getText(f(TABLE_ASSERTION_XPATH, NEW_NAME_TABLE_FILTER_ID));
        actualUsername = getText(f(TABLE_ASSERTION_XPATH, NEW_USERNAME_TABLE_FILTER_ID));
        actualHub = getText(f(TABLE_ASSERTION_XPATH, NEW_HUB_TABLE_FILTER_ID));
        actualEmploymentType = getText(
            f(TABLE_ASSERTION_XPATH, NEW_EMPLOYMENT_TYPE_FILTER_ID));
        actualLicenseType = getText(
            f(TABLE_ASSERTION_XPATH, NEW_LICENSE_TYPE_TABLE_FILTER_ID));
        actualComments = getText(f(TABLE_ASSERTION_XPATH, NEW_COMMENTS_TABLE_FILTER_ID));
        break;

      case USERNAME_TABLE_FILTER_ID:
        usernameFilter.setValue(middleMileDriver.getUsername());
        waitUntilVisibilityOfElementLocated(
            f(TABLE_ASSERTION_XPATH, NEW_USERNAME_TABLE_FILTER_ID));
        actualName = getText(f(TABLE_ASSERTION_XPATH, NEW_NAME_TABLE_FILTER_ID));
        actualUsername = getText(f(TABLE_ASSERTION_XPATH, NEW_USERNAME_TABLE_FILTER_ID));
        actualHub = getText(f(TABLE_ASSERTION_XPATH, NEW_HUB_TABLE_FILTER_ID));
        actualEmploymentType = getText(
            f(TABLE_ASSERTION_XPATH, NEW_EMPLOYMENT_TYPE_FILTER_ID));
        actualLicenseType = getText(
            f(TABLE_ASSERTION_XPATH, NEW_LICENSE_TYPE_TABLE_FILTER_ID));
        actualComments = getText(f(TABLE_ASSERTION_XPATH, NEW_COMMENTS_TABLE_FILTER_ID));
        break;

      case HUB_TABLE_FILTER_ID:
        nameFilter.setValue(middleMileDriver.getFirstName());
        hubFilter.setValue(middleMileDriver.getHub());
        waitUntilVisibilityOfElementLocated(
            f(TABLE_ASSERTION_XPATH, NEW_HUB_TABLE_FILTER_ID));
        actualName = getText(f(TABLE_ASSERTION_XPATH, NEW_NAME_TABLE_FILTER_ID));
        actualUsername = getText(f(TABLE_ASSERTION_XPATH, NEW_USERNAME_TABLE_FILTER_ID));
        actualHub = getText(f(TABLE_ASSERTION_XPATH, NEW_HUB_TABLE_FILTER_ID));
        actualEmploymentType = getText(
            f(TABLE_ASSERTION_XPATH, NEW_EMPLOYMENT_TYPE_FILTER_ID));
        actualLicenseType = getText(
            f(TABLE_ASSERTION_XPATH, NEW_LICENSE_TYPE_TABLE_FILTER_ID));
        actualComments = getText(f(TABLE_ASSERTION_XPATH, NEW_COMMENTS_TABLE_FILTER_ID));
        break;

      case COMMENTS_TABLE_FILTER_ID:
        commentsFilter.scrollIntoView();
        commentsFilter.setValue(middleMileDriver.getComments());
        waitUntilVisibilityOfElementLocated(
            f(TABLE_ASSERTION_XPATH, NEW_NAME_TABLE_FILTER_ID));
        waitUntilVisibilityOfElementLocated(
            f(TABLE_ASSERTION_XPATH, NEW_HUB_TABLE_FILTER_ID));
        actualName = getText(f(TABLE_ASSERTION_XPATH, NEW_NAME_TABLE_FILTER_ID));
        actualUsername = getText(f(TABLE_ASSERTION_XPATH, NEW_USERNAME_TABLE_FILTER_ID));
        actualHub = getText(f(TABLE_ASSERTION_XPATH, NEW_HUB_TABLE_FILTER_ID));
        actualEmploymentType = getText(
            f(TABLE_ASSERTION_XPATH, NEW_EMPLOYMENT_TYPE_FILTER_ID));
        actualLicenseType = getText(
            f(TABLE_ASSERTION_XPATH, NEW_LICENSE_TYPE_TABLE_FILTER_ID));
        actualComments = getText(f(TABLE_ASSERTION_XPATH, NEW_COMMENTS_TABLE_FILTER_ID));
        break;

      default:
        NvLogger.warn("Filter is not found");
    }

    assertEquals("Name is not the same : ", middleMileDriver.getFirstName(), actualName);
    assertEquals("Username is not the same : ", middleMileDriver.getUsername(), actualUsername);
    assertEquals("Hub is not the same : ", middleMileDriver.getHub(), actualHub);
    assertEquals("Employment Type is not the same : ", middleMileDriver.getEmploymentType(),
        actualEmploymentType);
    assertEquals("License Type is not the same : ", middleMileDriver.getLicenseType(),
        actualLicenseType);
    assertEquals("Comment is not the same : ", middleMileDriver.getComments(), actualComments);
  }

  public void tableFilterById(Driver middleMileDriver, Long driverId) {
    idFilter.setValue(driverId);
    waitUntilVisibilityOfElementLocated(f(TABLE_ASSERTION_XPATH, NEW_ID_TABLE_FILTER_ID));

    String actualName = getText(f(TABLE_ASSERTION_XPATH, NEW_NAME_TABLE_FILTER_ID));
    String actualId = getText(f(TABLE_ASSERTION_XPATH, NEW_ID_TABLE_FILTER_ID));
    String actualUsername = getText(
        f(TABLE_ASSERTION_XPATH, NEW_USERNAME_TABLE_FILTER_ID));
    String actualHub = getText(f(TABLE_ASSERTION_XPATH, NEW_HUB_TABLE_FILTER_ID));
    String actualEmploymentType = getText(
        f(TABLE_ASSERTION_XPATH, NEW_EMPLOYMENT_TYPE_FILTER_ID));
    String actualLicenseType = getText(
        f(TABLE_ASSERTION_XPATH, NEW_LICENSE_TYPE_TABLE_FILTER_ID));
    String actualComments = getText(
        f(TABLE_ASSERTION_XPATH, NEW_COMMENTS_TABLE_FILTER_ID));

    assertEquals("Name is not the same : ", middleMileDriver.getFirstName(), actualName);
    assertEquals("ID is not the same : ", driverId.toString(), actualId);
    assertEquals("Username is not the same : ", middleMileDriver.getUsername(), actualUsername);
    assertEquals("Hub is not the same : ", middleMileDriver.getHub(), actualHub);
    assertEquals("Employment Type is not the same : ", middleMileDriver.getEmploymentType(),
        actualEmploymentType);
    assertEquals("License Type is not the same : ", middleMileDriver.getLicenseType(),
        actualLicenseType);
    assertEquals("Comment is not the same : ", middleMileDriver.getComments(), actualComments);
  }

  public void tableFilterByname(Driver middleMileDriver) {
    nameFilter.setValue(middleMileDriver.getFirstName());
    waitUntilVisibilityOfElementLocated(
            f(TABLE_ASSERTION_XPATH, NEW_NAME_TABLE_FILTER_ID));

    String actualName = getText(f(TABLE_ASSERTION_XPATH, NEW_NAME_TABLE_FILTER_ID));
    String actualId = getText(f(TABLE_ASSERTION_XPATH, NEW_ID_TABLE_FILTER_ID));
    String actualUsername = getText(
            f(TABLE_ASSERTION_XPATH, NEW_USERNAME_TABLE_FILTER_ID));
    String actualHub = getText(f(TABLE_ASSERTION_XPATH, NEW_HUB_TABLE_FILTER_ID));
    String actualEmploymentType = getText(
            f(TABLE_ASSERTION_XPATH, NEW_EMPLOYMENT_TYPE_FILTER_ID));
    String actualEmpStatus = getText(f(TABLE_ASSERTION_XPATH,NEW_EMPLOYMENT_STATUS_TABLE_FILTER_ID));
    String actualLicenseType = getText(
            f(TABLE_ASSERTION_XPATH, NEW_LICENSE_TYPE_TABLE_FILTER_ID));
    String actualLicenseStatus = getText(f(TABLE_ASSERTION_XPATH,NEW_LICENSE_STATUS_TABLE_FILTER_ID));
    String actualComments = getText(
            f(TABLE_ASSERTION_XPATH, NEW_COMMENTS_TABLE_FILTER_ID));
    //System.out.println("Return employment status:   "+getEmploymentStatus(middleMileDriver));

    Assertions.assertThat(actualName).as("The Name is the same").isEqualTo(middleMileDriver.getFirstName());
    Assertions.assertThat(actualUsername).as("The Username is the same").isEqualTo(middleMileDriver.getUsername());
    Assertions.assertThat(actualHub).as("The Hub is the same").isEqualTo(middleMileDriver.getHub());
    Assertions.assertThat(actualEmploymentType).as("The Employment Type is the same").isEqualTo(middleMileDriver.getEmploymentType());
    Assertions.assertThat(actualEmpStatus).as("The Employment Status is the same").isEqualTo(getEmploymentStatus(middleMileDriver));
    Assertions.assertThat(actualLicenseType).as("The License Type is the same").isEqualTo(middleMileDriver.getLicenseType());
    Assertions.assertThat(actualLicenseStatus).as("The License Status is the same").isEqualTo(getLicenseStatus(middleMileDriver));
    Assertions.assertThat(actualComments).as("The Comment is the same").isEqualTo(middleMileDriver.getComments());
    Assertions.assertThat(editDriver.isDisplayed()).as("The Edit driver is shown").isTrue();
    Assertions.assertThat(viewDriver.isDisplayed()).as("The View driver is shown").isTrue();
//    assertEquals("Name is not the same : ", middleMileDriver.getFirstName(), actualName);
//    assertEquals("Username is not the same : ", middleMileDriver.getUsername(), actualUsername);
//    assertEquals("Hub is not the same : ", middleMileDriver.getHub(), actualHub);
//    assertEquals("Employment Type is not the same : ", middleMileDriver.getEmploymentType(),
//            actualEmploymentType);
//    assertEquals("License Type is not the same : ", middleMileDriver.getLicenseType(),
//            actualLicenseType);
//    assertEquals("Comment is not the same : ", middleMileDriver.getComments(), actualComments);
  }

  public void tableFilterByIdWithValue(Long driverId) {
    idFilter.setValue(driverId);
    waitUntilVisibilityOfElementLocated(f(TABLE_ASSERTION_XPATH, NEW_ID_TABLE_FILTER_ID));
  }

  public void tableFilterCombobox(Driver middleMileDriver, String filterBy) {
    String actualName = null;
    String actualUsername = null;
    String actualHub = null;
    String actualEmploymentType = null;
    String actualLicenseType = null;
    String actualComments = null;
    pause3s();
    nameFilter.setValue(middleMileDriver.getFirstName());
    waitUntilVisibilityOfElementLocated(
        f(TABLE_ASSERTION_XPATH, NEW_NAME_TABLE_FILTER_ID));

    switch (filterBy.toLowerCase()) {
      case EMPLOYMENT_TYPE:
        employmentTypeFilter.scrollIntoView();
        employmentTypeFilter.openButton.click();
        employmentTypeFilter.selectType(middleMileDriver.getEmploymentType());
        employmentTypeFilter.ok.click();

        actualName = getText(f(TABLE_ASSERTION_XPATH, NEW_NAME_TABLE_FILTER_ID));
        actualUsername = getText(f(TABLE_ASSERTION_XPATH, NEW_USERNAME_TABLE_FILTER_ID));
        actualHub = getText(f(TABLE_ASSERTION_XPATH, NEW_HUB_TABLE_FILTER_ID));
        actualEmploymentType = getText(
            f(TABLE_ASSERTION_XPATH, NEW_EMPLOYMENT_TYPE_FILTER_ID));
        actualLicenseType = getText(
            f(TABLE_ASSERTION_XPATH, NEW_LICENSE_TYPE_TABLE_FILTER_ID));
        actualComments = getText(f(TABLE_ASSERTION_XPATH, NEW_COMMENTS_TABLE_FILTER_ID));
        break;

      case EMPLOYMENT_STATUS:
        employmentStatusFilter.scrollIntoView();
        employmentStatusFilter.openButton.click();
        employmentStatusFilter.active.check();
        employmentStatusFilter.ok.click();

        actualName = getText(f(TABLE_ASSERTION_XPATH, NEW_NAME_TABLE_FILTER_ID));
        actualUsername = getText(f(TABLE_ASSERTION_XPATH, NEW_USERNAME_TABLE_FILTER_ID));
        actualHub = getText(f(TABLE_ASSERTION_XPATH, NEW_HUB_TABLE_FILTER_ID));
        actualEmploymentType = getText(
            f(TABLE_ASSERTION_XPATH, NEW_EMPLOYMENT_TYPE_FILTER_ID));
        actualLicenseType = getText(
            f(TABLE_ASSERTION_XPATH, NEW_LICENSE_TYPE_TABLE_FILTER_ID));
        actualComments = getText(f(TABLE_ASSERTION_XPATH, NEW_COMMENTS_TABLE_FILTER_ID));
        break;

      case LICENSE_TYPE:
        licenseTypeFilter.scrollIntoView();
        licenseTypeFilter.openButton.click();
        licenseTypeFilter.selectType(middleMileDriver.getLicenseType());
        licenseTypeFilter.ok.click();

        actualName = getText(f(TABLE_ASSERTION_XPATH, NEW_NAME_TABLE_FILTER_ID));
        actualUsername = getText(f(TABLE_ASSERTION_XPATH, NEW_USERNAME_TABLE_FILTER_ID));
        actualHub = getText(f(TABLE_ASSERTION_XPATH, NEW_HUB_TABLE_FILTER_ID));
        actualEmploymentType = getText(
            f(TABLE_ASSERTION_XPATH, NEW_EMPLOYMENT_TYPE_FILTER_ID));
        actualLicenseType = getText(
            f(TABLE_ASSERTION_XPATH, NEW_LICENSE_TYPE_TABLE_FILTER_ID));
        actualComments = getText(f(TABLE_ASSERTION_XPATH, NEW_COMMENTS_TABLE_FILTER_ID));
        break;

      case LICENSE_STATUS:
        licenseStatusFilter.scrollIntoView();
        licenseStatusFilter.openButton.click();
        licenseStatusFilter.active.check();
        licenseStatusFilter.ok.click();

        actualName = getText(f(TABLE_ASSERTION_XPATH, NEW_NAME_TABLE_FILTER_ID));
        actualUsername = getText(f(TABLE_ASSERTION_XPATH, NEW_USERNAME_TABLE_FILTER_ID));
        actualHub = getText(f(TABLE_ASSERTION_XPATH, NEW_HUB_TABLE_FILTER_ID));
        actualEmploymentType = getText(
            f(TABLE_ASSERTION_XPATH, NEW_EMPLOYMENT_TYPE_FILTER_ID));
        actualLicenseType = getText(
            f(TABLE_ASSERTION_XPATH, NEW_LICENSE_TYPE_TABLE_FILTER_ID));
        actualComments = getText(f(TABLE_ASSERTION_XPATH, NEW_COMMENTS_TABLE_FILTER_ID));
        break;
    }

    assertEquals("Name is not the same : ", middleMileDriver.getFirstName(), actualName);
    assertEquals("Username is not the same : ", middleMileDriver.getUsername(), actualUsername);
    assertEquals("Hub is not the same : ", middleMileDriver.getHub(), actualHub);
    assertEquals("Employment Type is not the same : ", middleMileDriver.getEmploymentType(),
        actualEmploymentType);
    assertEquals("License Type is not the same : ", middleMileDriver.getLicenseType(),
        actualLicenseType);
    assertEquals("Comment is not the same : ", middleMileDriver.getComments(), actualComments);
  }

  public void verifiesDataIsNotExisted(String driverName) {
    nameFilter.setValue(driverName);
    waitUntilVisibilityOfElementLocated(NO_RESULT_TABLE_XPATH);
  }

  public void clickViewButton() {
    click(VIEW_BUTTON_XPATH);
    viewDriverDialog.waitUntilVisible();
    antDotSpinner.waitUntilInvisible();
  }

  public void clickEditButton() {
    editDriver.click();
    editDriverDialog.waitUntilVisible();
    antDotSpinner.waitUntilInvisible();
  }

  public void editDriverByWithValue(String column, String value) {
    switch (column) {
      case "name":
        editDriverDialog.name.forceClear();
        editDriverDialog.name.sendKeys(value);
        break;
      case "contactNumber":
        editDriverDialog.contactNumber.forceClear();
        editDriverDialog.contactNumber.sendKeys(value);
        break;
      case "hub":
        editDriverDialog.hub.selectValue(value);
        break;
      case "licenseNumber":
        editDriverDialog.licenseNumber.forceClear();
        editDriverDialog.licenseNumber.sendKeys(value);
        break;
      case "licenseExpiryDate":
        editDriverDialog.licenseExpiryDate.sendDate(value);
        break;
      case "licenseType":
        editDriverDialog.selectLicenseType(value);
        break;
      case "employmentType":
        editDriverDialog.employmentType.selectValue(value);
        break;
      case "employmentStartDate":
        editDriverDialog.employmentStartDate.sendDate(value);
        break;
      case "employmentEndDate":
        editDriverDialog.employmentEndDate.sendDate(value);
        break;
    }
    editDriverDialog.save.click();
    editDriverDialog.waitUntilInvisible();
  }

  public void verifiesDriverIsUpdatedByWithValue(String column, String value) {
    String tableColumnValue = "//tr[1]//td[contains(@class,'%s')]/span";
    switch (column) {
      case "name":
        String actualName = getText(f(tableColumnValue, column));
        assertThat("Updated name is the same", actualName, equalTo(value));
        break;
      case "contact_number":
        break;
    }
  }

  public void verifiesDataInViewModalIsTheSame(Driver middleMileDriver) {
    assertEquals("Name is not the same : ", middleMileDriver.getFirstName(),
        viewDriverDialog.name.getValue());
    assertEquals("Hub is not the same : ", middleMileDriver.getHub(),
        viewDriverDialog.hub.getValue());
    assertEquals("Contact number is not the same : ", middleMileDriver.getMobilePhone(),
        viewDriverDialog.contactNumber.getValue());
    assertEquals("License Number is not the same : ", middleMileDriver.getLicenseNumber(),
        viewDriverDialog.licenseNumber.getValue());
    assertEquals("Expiry Date is not the same : ", middleMileDriver.getLicenseExpiryDate(),
        viewDriverDialog.licenseExpiryDate.getValue());
    assertEquals("Username is not the same : ", middleMileDriver.getUsername(),
        viewDriverDialog.username.getValue());
    assertEquals("Comments is not the same : ", middleMileDriver.getComments(),
        viewDriverDialog.comments.getValue());
  }

  public void clickAvailabilityMode(String mode) {
    if (NO.equalsIgnoreCase(mode)) {
      click(NO_COMING_BUTTON_XPATH);
      waitUntilVisibilityOfElementLocated(YES_COMING_BUTTON_XPATH);
    } else if (YES.equalsIgnoreCase(mode)) {
      click(YES_COMING_BUTTON_XPATH);
      waitUntilVisibilityOfElementLocated(NO_COMING_BUTTON_XPATH);
    }
  }

  public void clickBulkAvailabilityMode(String mode) {
    click(DROP_DOWN_ON_TABLE_XPATH);
    click(APPLY_ACTION_DROP_DOWN_XPATH);

    if (YES.equalsIgnoreCase(mode)) {
      click(SET_TO_COMING_DROP_DOWN_XPATH);
      waitUntilVisibilityOfElementLocated(YES_COMING_BUTTON_XPATH);
    } else if (NO.equalsIgnoreCase(mode)) {
      click(SET_TO_NOT_COMING_DROP_DOWN_XPATH);
      waitUntilVisibilityOfElementLocated(NO_COMING_BUTTON_XPATH);
    }
  }

  public void verifiesDriverAvailability(boolean driverAvailability) {
    if (isElementExistFast(YES_COMING_BUTTON_XPATH)) {
      assertTrue("Driver Availability is True : ", driverAvailability);
    } else if (isElementExistFast(NO_COMING_BUTTON_XPATH)) {
      assertFalse("Driver Availability is false : ", driverAvailability);
    }
  }

  public void refreshAndWaitUntilLoadingDone() {
    refreshPage();
    if (antDotSpinner.isDisplayedFast()) {
      antDotSpinner.waitUntilInvisible();
    }
    // temporary close /aaa error alert if shown
    if (isElementExist("//button[.='close']")) {
      click("//button[.='close']");
      pause1s();
    }
  }

  public void sortColumn(String columnName, String sortingOrder) {
    waitWhilePageIsLoading();
    String sortColumnXpath = f(TABLE_FILTER_SORT_XPATH, columnName);
    //scrollIntoView(sortColumnXpath);
    List<WebElement> sortFields = getWebDriver().findElements(By.xpath(sortColumnXpath));
    if (sortFields.size() == 0) {
      Assertions.assertThat(sortFields.size()).as(f("Assert that the column %s to be sorted is displayed on the screen", columnName)).isGreaterThan(0);
    }
    sortFields.get(0).click();
    waitWhilePageIsLoading();
    if (sortingOrder.equalsIgnoreCase("Descending")) {
      sortFields.get(0).click();
      waitWhilePageIsLoading();
    }
  }

  public List<String> getColumnValuesByColumnName(String columnName) {
    int columnIndex = 0;
    List<String> colData = new ArrayList<String>();
    waitWhilePageIsLoading();
    String headerXpath = f(MODAL_TABLE_HEADER_XPATH);
    List<WebElement> headerFields = getWebDriver().findElements(By.xpath(headerXpath));
    if (headerFields.size() == 0) {
      Assertions.assertThat(headerFields.size()).as(f("Assert that the column %s to be sorted is displayed on the screen", columnName)).isGreaterThan(0);
    }
    for (WebElement header : headerFields) {
      String headerName = header.getText().trim().toLowerCase();
      columnIndex++;
      if (headerName.contains(columnName.toLowerCase())) {
        break;
      }
    }

    List<WebElement> colElements = getWebDriver().findElements(
            By.xpath(f(TABLE_COLUMN_VALUES_BY_INDEX_XPATH, columnIndex)));
    colElements.forEach(element -> {
      colData.add(element.getText().trim());
    });
    return colData;
  }

  public void getRecordsAndValidateSorting(String columnName, String sortingOrder) {
    List<String> colData = getColumnValuesByColumnName(columnName);
    if (sortingOrder.equalsIgnoreCase("Ascending")) {
      Assertions.assertThat(Comparators.isInOrder(colData, Comparator.naturalOrder())).as(f("The column values %s are sorted as expected", columnName)).isTrue();
      return;
    }
    if (sortingOrder.equalsIgnoreCase("Descending")) {
      Assertions.assertThat(Comparators.isInOrder(colData, Comparator.reverseOrder())).as(f("The column values %s are sorted as expected", columnName)).isTrue();
      return;
    }

    Assertions.assertThat(Comparators.isInOrder(colData, Comparator.naturalOrder())).as(f("The column values %s are sorted as expected", columnName)).isTrue();
  }

  public void ClickToBrowserBackButton(){
    getWebDriver().navigate().back();
    switchTo();
    loadDrivers.waitUntilClickable();
  }

  public void ClickToBrowserForwardButton(){
    getWebDriver().navigate().forward();
    switchTo();
    loadDrivers.waitUntilInvisible();
    loadingIcon.waitUntilInvisible(60);

  }

  public void verifyURLofPage(String ExpectedURL){
    String ActualURL = getWebDriver().getCurrentUrl();
    //assertEquals("The URL is the same:",ExpectedURL, ActualURL);
    Assertions.assertThat(ActualURL).as("The URL is the same:").isEqualTo(ExpectedURL);
  }

  public static class TableFilterPopup extends PageElement {

    public TableFilterPopup(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }

    @FindBy(xpath = ".//button")
    public Button openButton;

    @FindBy(xpath = "//div[contains(@class,'ant-dropdown ')][not(contains(@class, 'ant-dropdown-hidden'))]//button[.='OK']")
    public Button ok;

    @FindBy(xpath = "//div[contains(@class,'ant-dropdown ')][not(contains(@class, 'ant-dropdown-hidden'))]//button[.='Reset']")
    public Button reset;
  }

  public static class StatusFilter extends TableFilterPopup {

    public StatusFilter(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }

    @FindBy(xpath = "//div[contains(@class,'ant-dropdown ')][not(contains(@class,'ant-dropdown-hidden'))]//li[.='Active']//input")
    public CheckBox active;

    @FindBy(xpath = "//div[contains(@class,'ant-dropdown ')][not(contains(@class,'ant-dropdown-hidden'))]//li[.='Inactive']//input")
    public CheckBox inactive;
  }

  public static class EmploymentTypeFilter extends TableFilterPopup {

    public EmploymentTypeFilter(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }

    @FindBy(xpath = "//div[contains(@class,'ant-dropdown ')][not(contains(@class,'ant-dropdown-hidden'))]//li[.='Full-time / Contract']//input")
    public CheckBox contract;

    @FindBy(xpath = "//div[contains(@class,'ant-dropdown ')][not(contains(@class,'ant-dropdown-hidden'))]//li[.='Part-time / Freelance']//input")
    public CheckBox freelance;

    @FindBy(xpath = "//div[contains(@class,'ant-dropdown ')][not(contains(@class,'ant-dropdown-hidden'))]//li[.='Vendor']//input")
    public CheckBox vendor;

    public void selectType(String type) {
      switch (type.toLowerCase()) {
        case "full-time / contract":
          contract.check();
          break;
        case "Part-time / Freelance":
          freelance.check();
          break;
        case "vendor":
          vendor.check();
          break;
      }
    }
  }

  public static class LicenseTypeFilter extends TableFilterPopup {

    private static final String TYPE_CHECKBOX_LOCATOR = "//div[contains(@class,'ant-dropdown ')][not(contains(@class,'ant-dropdown-hidden'))]//li[.='%s']//input";

    public LicenseTypeFilter(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }

    public void selectType(String type) {
      new CheckBox(webDriver, findElementByXpath(f(TYPE_CHECKBOX_LOCATOR, type))).check();
    }
  }

  public static class ViewDriverDialog extends AntModal {

    public ViewDriverDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }

    @FindBy(id = "name")
    public TextBox name;

    @FindBy(xpath = "//div[contains(@class,' ant-select')][.//input[@id='hubId']]")
    public co.nvqa.operator_v2.selenium.elements.ant.v4.AntSelect hub;

    @FindBy(id = "contactNumber")
    public TextBox contactNumber;

    @FindBy(id = "licenseNumber")
    public TextBox licenseNumber;

    @FindBy(xpath = "//div[contains(@class,'ant-picker')][not(contains(@class,'ant-picker-input'))][.//input[@id='licenseExpiryDate']]")
    public PageElement licenseExpiryDate;

    @FindBy(id = "username")
    public TextBox username;

    @FindBy(id = "comments")
    public TextBox comments;
  }

  public static class EditDriverDialog extends AntModal {

    public EditDriverDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }

    @FindBy(xpath = "//div[@class='ant-modal-title']")
    public TextBox dialogTitle;

    @FindBy(id = "name")
    public TextBox name;

    @FindBy(id = "contactNumber")
    public TextBox contactNumber;

    @FindBy(xpath = "//div[contains(@class, ' ant-select')][.//input[@id='hubId']]")
    public co.nvqa.operator_v2.selenium.elements.ant.v4.AntSelect hub;

    @FindBy(id = "licenseNumber")
    public TextBox licenseNumber;

    @FindBy(xpath = "//div[@class= 'ant-picker'][.//input[@id='licenseExpiryDate']]")
    public AntCalendarPicker licenseExpiryDate;

    @FindBy(xpath = "//div[contains(@class, ' ant-select')][.//input[@id='employmentType']]")
    public co.nvqa.operator_v2.selenium.elements.ant.v4.AntSelect employmentType;

    @FindBy(xpath = "//div[@class= 'ant-picker'][.//input[@id='employmentStartDate']]")
    public AntCalendarPicker employmentStartDate;

    @FindBy(xpath = "//div[@class= 'ant-picker'][.//input[@id='employmentEndDate']]")
    public AntCalendarPicker employmentEndDate;

    @FindBy(className = "ant-btn")
    public Button cancel;

    @FindBy(className = "ant-btn-primary")
    public Button save;

    public void selectLicenseType(String value) {
      String licenseTypeXpath = "//div[contains(.//label,'License Type')]//input[@value='%s']";
      WebElement licenseTypeInput = findElementByXpath(f(licenseTypeXpath, value));
      licenseTypeInput.click();
    }
  }

  public String getEmploymentStatus(Driver mmDriver){
    SimpleDateFormat formatter = new SimpleDateFormat ("yyyy-MM-dd");
    Date currentdate= new Date();
    String status = mmDriver.getEmploymentEndDate();
    if (status == null) return ACTIVE_STATUS;
    try {
      Date employmentEndDate = new Date(Long.parseLong(status,10));
      if (employmentEndDate.after(currentdate)){
        return ACTIVE_STATUS;
      }
    } catch (Exception e) {
      NvLogger.error(e.getMessage());
    }
    return INACTIVE_STATUS;

  }

  public String getLicenseStatus(Driver mmDriver){
    SimpleDateFormat formatter = new SimpleDateFormat ("yyyy-MM-dd");
    Date currentdate= new Date();
    String status = mmDriver.getLicenseExpiryDate();
    //if (status == null) return ACTIVE_STATUS;
    try {
      Date LicenseEndDate = new Date(Long.parseLong(status,10));
      if (LicenseEndDate.after(currentdate)){
        return ACTIVE_STATUS;
      }
    } catch (Exception e) {
      NvLogger.error(e.getMessage());
    }
    return INACTIVE_STATUS;

  }

  public List<Driver> filterDriver(List<Driver> middleMileDrivers, String statusName, String filter){
    List<Driver> temp = new ArrayList<Driver>();
    switch (statusName){
      case "Employment Status":
        middleMileDrivers.forEach(driver ->{
          if(getEmploymentStatus(driver).equals(filter)) temp.add(driver);
        });
        break;
      case "License Status":
        middleMileDrivers.forEach(driver ->{
          if(getLicenseStatus(driver).equals(filter)) temp.add(driver);
        });
        break;
    }

    return temp;
  }

  public List<Driver> filterDriver(List<Driver> middleMileDrivers, String statusName1, String filter1,String statusName2, String filter2 ){
    List<Driver> temp = new ArrayList<Driver>();
    temp= filterDriver(middleMileDrivers,statusName1,filter1);
    return filterDriver(temp,statusName2,filter2);
  }
  /*
  Employment End date and License End Date of created driver are Date format, not Unix timestamp format
  Convert them to Unix timestamp and set them
   */
  public void convertDateToUnixTimestamp(Driver driver){
    try {
      SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
      Date date = format.parse(driver.getEmploymentEndDate());
      long timestamp = date.getTime();
      driver.setEmploymentEndDate(Long.toString(timestamp));
      date = format.parse(driver.getLicenseExpiryDate());
      timestamp = date.getTime();
      driver.setLicenseExpiryDate(Long.toString(timestamp));
    } catch (ParseException e) {
      NvLogger.error(e.getMessage());
    }

  }

}
