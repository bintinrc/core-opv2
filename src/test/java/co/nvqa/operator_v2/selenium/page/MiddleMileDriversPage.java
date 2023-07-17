package co.nvqa.operator_v2.selenium.page;

import co.nvqa.common.mm.model.MiddleMileDriver;
import co.nvqa.common.mm.model.ext.Driver.Contact;
import co.nvqa.commons.model.core.Driver;
import co.nvqa.commons.support.DateUtil;
import co.nvqa.commons.util.NvLogger;
import co.nvqa.operator_v2.cucumber.glue.MiddleMileDriversSteps;
import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.CheckBox;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.TextBox;
import co.nvqa.operator_v2.selenium.elements.ant.AntModal;
import co.nvqa.operator_v2.selenium.elements.ant.AntSelect;
import co.nvqa.operator_v2.selenium.elements.ant.v4.AntCalendarPicker;
import com.google.common.collect.Comparators;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.time.ZonedDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.Date;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Objects;
import java.util.stream.Collectors;
import org.apache.commons.lang3.RandomStringUtils;
import org.assertj.core.api.Assertions;
import org.openqa.selenium.By;
import org.openqa.selenium.JavascriptExecutor;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * @author Tristania Siagian
 */

public class MiddleMileDriversPage extends OperatorV2SimplePage {

    private static final Logger LOGGER = LoggerFactory.getLogger(MiddleMileDriversSteps.class);

    private static final String IFRAME_XPATH = "//iframe[contains(@src,'middle-mile-drivers')]";
    private static final String LOAD_DRIVERS_BUTTON_XPATH = "//button[@data-testid='load-drivers-button']";
    private static final String DRIVERS_NOT_FOUND_TOAST_XPATH = "//div[contains(@class,'notification-notice-closable')]";
    //private static final String TOTAL_DRIVER_SHOW_XPATH = "//div[contains(@class,'TableWrapper')]/div[contains(@class,'TableStats')]/span[2]"; -
    private static final String TOTAL_DRIVER_SHOW_XPATH = "//span[@class='ant-typography']//strong[normalize-space()]";
    private static final String SELECT_FILTER_VALUE_XPATH = "//div[not(contains(@class,'ant-select-dropdown-hidden'))]//div[contains(@class,'ant-select-item-option')]/div[text()= '%s']";
    private static final String CREATE_DRIVER_BUTTON_XPATH = "//button[@data-testid='add-driver-button']";
    private static final String MODAL_XPATH = "//div[contains(@id,'rcDialogTitle')]";
    private static final String DATE_PICKER_MODAL_XPATH = "//div[not(contains(@class, 'ant-picker-dropdown-hidden'))]/div[@class= 'ant-picker-panel-container']";
    private static final String NEXT_MONTH_XPATH = "//div[contains(@class, 'ant-picker-dropdown')][not(contains(@class,'ant-picker-dropdown-hidden'))]//button[contains(@class,'ant-picker-header-next-btn')]";
    private static final String CALENDAR_DATE_XPATH = "//div[contains(@class, 'ant-picker-dropdown')][not(contains(@class,'ant-picker-dropdown-hidden'))]//td[@title='%s']/div";
    private static final String SAVE_BUTTON_XPATH = "//div[contains(@class,'footer')]/button[contains(@class,'primary')]";
    private static final String TOAST_DRIVER_CREATED_XPATH = "//div[contains(@class,'ant-notification-notice-description') and contains(text(),'Username: %s')]";
    private static final String NOTIFICATION_DRIVER_ALREADY_REGISTERED_XPATH = "//div[contains(@class,'ant-notification-notice-description')]//span[contains(normalize-space(),'Username already registered')]";
    private static final String NO_RESULT_TABLE_XPATH = "//div[contains(@class,'ant-empty ')]";
    private static final String VIEW_BUTTON_XPATH = "//button[contains(@data-testid,'driver-detail-button-')]";
    private static final String EDIT_BUTTON_XPATH = "//button[contains(@class,'edit-user-btn')]";
    private static final String NO_COMING_BUTTON_XPATH = "//button[contains(@class, 'availability-btn')][text()='No']";
    private static final String YES_COMING_BUTTON_XPATH = "//button[contains(@class, 'availability-btn')][text()='Yes']";
    private static final String DROP_DOWN_ON_TABLE_XPATH = "//div[contains(@class,'ant-table-selection')]";
    private static final String SELECT_ALL_CHECKBOX_XPATH = "//div[@class='ant-table-selection']//input[@class='ant-checkbox-input']";
    private static final String APPLY_ACTION_DROP_DOWN_XPATH = "//button[contains(@class,'apply-action-btn')]";
    private static final String SET_TO_COMING_DROP_DOWN_XPATH = "//li[contains(@class, 'set-to-coming-btn')]";
    private static final String SET_TO_NOT_COMING_DROP_DOWN_XPATH = "//li[contains(@class, 'set-not-to-coming-btn')]";
    private static final String MODAL_TABLE_HEADER_XPATH = "//div[@class='ant-table-container']//thead//span[contains(@data-testid,'column-title-middle-mile-driver')]";
    private static final String TABLE_COLUMN_VALUES_BY_INDEX_XPATH = "//div[@class='ant-table-container']//tbody//td[%d]";
    private static final String TABLE_FILTER_SORT_XPATH = "//span[@class='ant-table-column-title']//span[text()=\"%s\"]";
    private static final String EMPLOYMENT_STATUS_FILTER_TEXT = "//input[@id='employmentStatus']/ancestor::div[contains(@class, ' ant-select')]//span[@class='ant-select-selection-item']";
    private static final String LICENSE_STATUS_FILTER_TEXT = "//input[@id='licenseStatus']/ancestor::div[contains(@class, ' ant-select')]//span[@class='ant-select-selection-item']";

    private static final String ERROR_MESSAGE_NOTICE_TEXT_XPATH = "//div[contains(@class,'ant-notification-notice ant-notification-notice-error')]//div[contains(text(),'%s')]";
    private static final String ERROR_MESSAGE_NOTICE_CONFLICT_XPATH = "//div[contains(@class,'ant-notification-notice ant-notification-notice-error')]//span[text()='%s']";

    private static final String CHECK_AVAILABILITY_BUTTON_XPATH = "//button[@data-testid='check-availability-button']";
    private static final String INPUT_CREATE_DRIVER_MODAL_XPATH = "//input[@id='%s']";
    private static final String TABLE_ASSERTION_XPATH = "//div[contains(@class,'ant-table-body')]//tbody/tr[2]/td[%d]";

    private static final String LICENSE_TYPE_INPUT_CREATE_DRIVER_XPATH = "//input[@value='%s']";
    private static final String COMMENTS_INPUT_CREATE_DRIVER_XPATH = "//textarea[@id='comments']";

    private static final String LICENSE_TYPE_FILTER_XPATH = "//span[@class='ant-dropdown-menu-title-content']/span[contains(text(),'%s')]";

    private static final String NAME_INPUT_CREATE_DRIVER_ID = "name";
    private static final String FIRST_NAME_INPUT_CREATE_DRIVER_ID = "first_name";
    private static final String LAST_NAME_INPUT_CREATE_DRIVER_ID = "last_name";
    private static final String DISPLAY_NAME_INPUT_CREATE_DRIVER_ID = "display_name";
    private static final String HUB_INPUT_CREATE_DRIVER_ID = "hub_id";
    private static final String CONTACT_NUMBER_INPUT_CREATE_DRIVER_ID = "contact_number";
    private static final String LICENSE_NUMBER_INPUT_CREATE_DRIVER_ID = "license_number";
    private static final String EXPIRY_DATE_INPUT_CREATE_DRIVER_ID = "license_expiry_date";
    private static final String LICENSE_TYPE_INPUT_CREATE_DRIVER_ID = "license_type";
    private static final String EMPLOYMENT_TYPE_INPUT_CREATE_DRIVER_ID = "employment_type";
    private static final String VENDOR_NAME_INPUT_CREATE_DRIVER_ID = "vendor_id";
    private static final String EMPLOYMENT_START_DATE_INPUT_CREATE_DRIVER_ID = "employment_start_date";
    private static final String EMPLOYMENT_END_DATE_INPUT_CREATE_DRIVER_ID = "employment_end_date";
    private static final String USERNAME_INPUT_CREATE_DRIVER_ID = "username";
    private static final String PASSWORD_INPUT_CREATE_DRIVER_ID = "password";
    private static final String COMMENTS_INPUT_CREATE_DRIVER_ID = "comments";

    private static final ZonedDateTime TODAY = DateUtil.getDate();
    private static final DateTimeFormatter EXPIRY_DATE_FORMATTER = DateTimeFormatter
            .ofPattern("yyyy-MM-dd", Locale.ENGLISH);

    private static final String NAME_TABLE_FILTER_ID = "name";
    private static final String USERNAME_TABLE_FILTER_ID = "username";
    private static final String HUB_TABLE_FILTER_ID = "hub";
    private static final String COMMENTS_TABLE_FILTER_ID = "comments";
    private static final String VENDOR_TABLE_FILTER_ID = "vendor";

    private static final Integer NEW_NAME_TABLE_FILTER_ID = 1;
    private static final Integer NEW_ID_TABLE_FILTER_ID = 2;
    private static final Integer NEW_USERNAME_TABLE_FILTER_ID = 3;
    private static final Integer NEW_HUB_TABLE_FILTER_ID = 4;
    private static final Integer NEW_EMPLOYMENT_TYPE_FILTER_ID = 5;
    private static final Integer NEW_VENDOR_FILTER_ID = 6;
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

    public static final String XPATH_EMPLOYMENTTYPE = "//div[contains(@class, ' ant-select')][.//input[@id='employmentType']]";

    private static final String YES = "yes";
    private static final String NO = "no";

    private static final String MIDDLE_MILE_DRIVER_FIELD_ERROR_XPATH = "//div[@role='alert' and @class='ant-form-item-explain-error' and contains(text(), \"%s\")]";

    private static final String MIDDLE_MILE_DRIVER_CLEAR_BUTTON_XPATH = "//input[@id='%s']/ancestor::div[@class='ant-select-selector']/following-sibling::span[@class ='ant-select-clear']";

    private static final String TOAST_ERROR_400_MESSAGE_XPATH = "//div[contains(@class,'ant-notification-notice-message')]";

    public static String actualToastMessageContent = "";
    public static List<Driver> LIST_OF_FILTER_DRIVERS = new ArrayList<Driver>();
    @FindBy(xpath = LOAD_DRIVERS_BUTTON_XPATH)
    public Button loadButton;
    @FindBy(xpath = "//span[contains(@class,'ant-spin-dot-spin')]")
    public PageElement antDotSpinner;
    @FindBy(xpath = "//input[@id='hubIds']/ancestor::div[contains(@class, ' ant-select')]")
    public AntSelect hubSearchFilter;
    @FindBy(xpath = "//input[@id='employmentStatus']/ancestor::div[contains(@class, ' ant-select')]")
    public AntSelect employmentStatusSearchFilter;
    @FindBy(xpath = "//input[@id='licenseStatus']/ancestor::div[contains(@class, ' ant-select')]")
    public AntSelect licenseStatusSearchFilter;
    @FindBy(xpath = "//button[@data-testid='load-drivers-button']")
    public Button loadDrivers;
    @FindBy(xpath = "//input[@aria-label='input-name']")
    public TextBox nameFilter;
    @FindBy(xpath = "//input[@aria-label='input-display_name']")
    public TextBox displayNameFilter;
    @FindBy(xpath = "//input[@aria-label='input-driver_id']")
    public TextBox idFilter;
    @FindBy(xpath = "//th[div[.='Username']]//input")
    public TextBox usernameFilter;
    @FindBy(xpath = "//th[div[.='Hub']]//input")
    public TextBox hubFilter;
    @FindBy(xpath = "//th[div[.='Comments']]//input")
    public TextBox commentsFilter;
    @FindBy(xpath = "//input[@aria-label='input-vendor_name']")
    public TextBox vendorFilter;
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
    @FindBy(xpath = "//button[contains(@data-testid,'driver-edit-button-')]")
    public Button editDriver;
    @FindBy(xpath = "//button[contains(@data-testid,'driver-detail-button-')]")
    public Button viewDriver;
    @FindBy(xpath = "//button[.='Edit Search Filter']")
    public Button editSearchFilterButton;
    @FindBy(xpath = "//span[contains(@class,'anticon-loading')]")
    public PageElement loadingIcon;
    @FindBy(tagName = "iframe")
    private PageElement pageFrame;

    @FindBy(xpath = "//div[@class='ant-empty-description']")
    public PageElement listEmptyData;

    @FindBy(xpath = "//div[text()='Add Driver']")
    public PageElement addDriverModalTitle;

    @FindBy(xpath = "//input[@id='first_name']")
    public PageElement createDriverForm_firstName;

    @FindBy(xpath = "//input[@id='last_name']")
    public PageElement createDriverForm_lastName;

    @FindBy(xpath = "//input[@id='display_name']")
    public PageElement createDriverForm_displayName;

    @FindBy(xpath = "//input[@id='hub_id']")
    public PageElement createDriverForm_hub;

    @FindBy(xpath = "//input[@id='contact_number']")
    public PageElement createDriverForm_contactNumber;

    @FindBy(xpath = "//input[@id='license_number']")
    public PageElement createDriverForm_licenseNumber;

    @FindBy(xpath = "//input[@id='license_expiry_date']")
    public PageElement createDriverForm_expiryDate;

    @FindBy(xpath = "//input[@id='license_type']")
    public PageElement createDriverForm_licenseType;

    @FindBy(xpath = "//input[@id='employment_type']")
    public PageElement createDriverForm_employmentType;

    @FindBy(xpath = "//input[@id='employment_start_date']")
    public PageElement createDriverForm_employmentStartDate;

    @FindBy(xpath = "//input[@id='employment_end_date']")
    public PageElement createDriverForm_employmentEndDate;

    @FindBy(xpath = "//input[@id='username']")
    public PageElement createDriverForm_username;

    @FindBy(xpath = "//input[@id='password']")
    public PageElement createDriverForm_password;

    @FindBy(xpath = "//textarea[@id='comments']")
    public PageElement createDriverForm_comments;

    @FindBy(xpath = "//button[@data-testid='driver-dialog-save-button']/span")
    public Button saveCreateDriver;

    @FindBy(xpath = "//button[@data-testid='column-filter-icon-middle-mile-driver-license-type']")
    public Button clickLicenseTypeFilterInColumn;

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
        LOGGER.info("Total driver from API: {}", totalDriver);
        LOGGER.info("Total driver on FE: {}", getText(TOTAL_DRIVER_SHOW_XPATH));
        Assertions.assertThat(getText(TOTAL_DRIVER_SHOW_XPATH))
            .as(f("Total Driver Shown is the same: %d", totalDriver))
            .contains(String.valueOf(totalDriver));
    }

    public void verifiesTextInEmploymentStatusFilter(String ExpectedResult) {
        Assertions.assertThat(getText(EMPLOYMENT_STATUS_FILTER_TEXT)).as("Employment Status Filter Text is correct").isEqualToIgnoringCase(ExpectedResult);
    }

    public void verifiesTextInLicenseStatusFilter(String ExpectedResult) {
        Assertions.assertThat(getText(LICENSE_STATUS_FILTER_TEXT)).as("License Status Filter Text is correct").isEqualToIgnoringCase(ExpectedResult);
    }

    public void selectHubFilter(String hubName) {
        loadDrivers.waitUntilClickable();
        listEmptyData.waitUntilInvisible();
        hubSearchFilter.waitUntilClickable();
        hubSearchFilter.click();
        hubSearchFilter.selectValue(hubName);
    }

    public void selectFilter(String filterName, String value) {
        switch (filterName.toLowerCase()) {
            case "hub":
                doWithRetry(() -> {
                    try {
                        if (!hubSearchFilter.isEnabled()) throw new AssertionError("Dropdown is loading.");
                        hubSearchFilter.selectValue(value);
                    } catch (AssertionError e) {
                        LOGGER.info(e.getMessage());
                        refreshPage_v1();
                    }
                }, "Retrying to select hub filter", 1000, 10);
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

    public void fillNames(String firstName, String lastName) {
        addDriverModalTitle.waitUntilVisible();
        sendKeys(f(INPUT_CREATE_DRIVER_MODAL_XPATH, FIRST_NAME_INPUT_CREATE_DRIVER_ID), firstName);
        sendKeys(f(INPUT_CREATE_DRIVER_MODAL_XPATH, LAST_NAME_INPUT_CREATE_DRIVER_ID), lastName);
        sendKeys(f(INPUT_CREATE_DRIVER_MODAL_XPATH, DISPLAY_NAME_INPUT_CREATE_DRIVER_ID),
            firstName + " " + lastName);
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

    public void chooseVendorName(String vendorName) {
        click(f(INPUT_CREATE_DRIVER_MODAL_XPATH, VENDOR_NAME_INPUT_CREATE_DRIVER_ID));
        sendKeys(f(INPUT_CREATE_DRIVER_MODAL_XPATH, VENDOR_NAME_INPUT_CREATE_DRIVER_ID), vendorName);
        waitUntilVisibilityOfElementLocated(f(SELECT_FILTER_VALUE_XPATH, vendorName));
        click(f(SELECT_FILTER_VALUE_XPATH, vendorName));
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

    public void tableFilter(MiddleMileDriver driver, String filterBy) {
        switch (filterBy.toLowerCase()) {
            case NAME_TABLE_FILTER_ID:
                displayNameFilter.setValue(driver.getDisplayName().trim());
                break;

            case USERNAME_TABLE_FILTER_ID:
                usernameFilter.setValue(driver.getUsername());
                break;

            case HUB_TABLE_FILTER_ID:
                displayNameFilter.setValue(driver.getDisplayName());
                hubFilter.setValue(driver.getHubName());
                break;

            case COMMENTS_TABLE_FILTER_ID:
                displayNameFilter.setValue(driver.getDisplayName());
                commentsFilter.scrollIntoView();
                commentsFilter.setValue(driver.getComments());
                break;

            case VENDOR_TABLE_FILTER_ID:
                displayNameFilter.setValue(driver.getDisplayName());
                vendorFilter.scrollIntoView();
                vendorFilter.setValue(Objects.nonNull(driver.getVendorId()) ? driver.getVendorName() : "-");
                break;

            default:
                throw new IllegalArgumentException("Unknown filter given.");
        }

        waitUntilVisibilityOfElementLocated(
            f(TABLE_ASSERTION_XPATH, NEW_NAME_TABLE_FILTER_ID));
        String actualDisplayName = getText(f(TABLE_ASSERTION_XPATH, NEW_NAME_TABLE_FILTER_ID));
        String actualUsername = getText(f(TABLE_ASSERTION_XPATH, NEW_USERNAME_TABLE_FILTER_ID));
        String actualHub = getText(f(TABLE_ASSERTION_XPATH, NEW_HUB_TABLE_FILTER_ID));
        String actualEmploymentType = getText(
            f(TABLE_ASSERTION_XPATH, NEW_EMPLOYMENT_TYPE_FILTER_ID));
        String actualLicenseType = getText(
            f(TABLE_ASSERTION_XPATH, NEW_LICENSE_TYPE_TABLE_FILTER_ID));
        String actualComments = getText(f(TABLE_ASSERTION_XPATH, NEW_COMMENTS_TABLE_FILTER_ID));

        Assertions.assertThat(actualDisplayName).as("Display Name is correct: %s", actualDisplayName).isEqualTo(driver.getDisplayName());
        Assertions.assertThat(actualUsername).as("Username is correct: %s", actualUsername).isEqualTo(driver.getUsername());
        Assertions.assertThat(actualHub).as("Hub is correct: %s", actualHub).isEqualTo(driver.getHubName());
        Assertions.assertThat(actualEmploymentType).as("Employment Type is correct: %s", actualEmploymentType).isEqualTo(driver.getEmploymentType());
        Assertions.assertThat(actualLicenseType).as("License Type is correct: %s", actualLicenseType).isEqualTo(driver.getLicenseType());
        Assertions.assertThat(actualComments).as("Comment is correct: %s", actualComments).isEqualTo(driver.getComments());
    }

    public void tableFilter(Driver middleMileDriver, String filterBy) {
        String actualDisplayName = null;
        String actualUsername = null;
        String actualHub = null;
        String actualEmploymentType = null;
        String actualLicenseType = null;
        String actualComments = null;

        switch (filterBy.toLowerCase()) {
            case NAME_TABLE_FILTER_ID:
                displayNameFilter.setValue(middleMileDriver.getDisplayName().trim());
                waitUntilVisibilityOfElementLocated(
                    f(TABLE_ASSERTION_XPATH, NEW_NAME_TABLE_FILTER_ID));
                actualDisplayName = getText(f(TABLE_ASSERTION_XPATH, NEW_NAME_TABLE_FILTER_ID));
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
                actualDisplayName = getText(f(TABLE_ASSERTION_XPATH, NEW_NAME_TABLE_FILTER_ID));
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
                actualDisplayName = getText(f(TABLE_ASSERTION_XPATH, NEW_NAME_TABLE_FILTER_ID));
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
                actualDisplayName = getText(f(TABLE_ASSERTION_XPATH, NEW_NAME_TABLE_FILTER_ID));
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

       Assertions.assertThat(actualDisplayName).as("Display Name is not the same : ").isEqualTo(middleMileDriver.getDisplayName());
       Assertions.assertThat(actualUsername).as("Username is not the same : ").isEqualTo(middleMileDriver.getUsername());
       Assertions.assertThat(actualHub).as("Hub is not the same : ").isEqualTo(middleMileDriver.getHub());
       Assertions.assertThat(actualEmploymentType).as("Employment Type is not the same : ").isEqualTo(middleMileDriver.getEmploymentType());
       Assertions.assertThat(actualLicenseType).as("License Type is not the same : ").isEqualTo(middleMileDriver.getLicenseType());
       Assertions.assertThat(actualComments).as("Comment is not the same : ").isEqualTo(middleMileDriver.getComments());
    }

    public void tableFilterById(MiddleMileDriver driver, Long driverId) {
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

        Assertions.assertThat(actualName).as("Name is not the same : ")
            .isEqualTo(driver.getDisplayName());
        Assertions.assertThat(actualId).as("ID is not the same : ").isEqualTo(driverId.toString());
        Assertions.assertThat(actualUsername).as("Username is not the same : ")
            .isEqualTo(driver.getUsername());
        Assertions.assertThat(actualHub).as("Hub is not the same : ")
            .isEqualTo(driver.getHubName());
        Assertions.assertThat(actualEmploymentType).as("Employment Type is not the same : ")
            .isEqualTo(driver.getEmploymentType());
        Assertions.assertThat(actualLicenseType).as("License Type is not the same : ")
            .isEqualTo(driver.getLicenseType());
        Assertions.assertThat(actualComments).as("Comment is not the same : ")
            .isEqualTo(driver.getComments());
    }

    public void tableFilterByname(MiddleMileDriver middleMileDriver) {
        LOGGER.info("Display name: {}", middleMileDriver.getDisplayName());
        displayNameFilter.click();
        displayNameFilter.setValue(middleMileDriver.getDisplayName());
        waitUntilVisibilityOfElementLocated(
            f(TABLE_ASSERTION_XPATH, NEW_NAME_TABLE_FILTER_ID));

        String actualName = getText(f(TABLE_ASSERTION_XPATH, NEW_NAME_TABLE_FILTER_ID));
        String actualId = getText(f(TABLE_ASSERTION_XPATH, NEW_ID_TABLE_FILTER_ID));
        String actualUsername = getText(
            f(TABLE_ASSERTION_XPATH, NEW_USERNAME_TABLE_FILTER_ID));
        String actualHub = getText(f(TABLE_ASSERTION_XPATH, NEW_HUB_TABLE_FILTER_ID));
        String actualEmploymentType = getText(
            f(TABLE_ASSERTION_XPATH, NEW_EMPLOYMENT_TYPE_FILTER_ID));
        String actualVendor = getText(
            f(TABLE_ASSERTION_XPATH, NEW_VENDOR_FILTER_ID));
        String actualEmpStatus = getText(f(TABLE_ASSERTION_XPATH, NEW_EMPLOYMENT_STATUS_TABLE_FILTER_ID));
        String actualLicenseType = getText(
                f(TABLE_ASSERTION_XPATH, NEW_LICENSE_TYPE_TABLE_FILTER_ID));
        String actualLicenseStatus = getText(f(TABLE_ASSERTION_XPATH, NEW_LICENSE_STATUS_TABLE_FILTER_ID));
        String actualComments = getText(
                f(TABLE_ASSERTION_XPATH, NEW_COMMENTS_TABLE_FILTER_ID));

        Assertions.assertThat(actualName).as("The Name is the same")
            .isEqualTo(middleMileDriver.getDisplayName());
        Assertions.assertThat(actualUsername).as("The Username is the same")
            .isEqualTo(middleMileDriver.getUsername());
        Assertions.assertThat(actualHub).as("The Hub is the same")
            .isEqualTo(middleMileDriver.getHubName());
        Assertions.assertThat(actualEmploymentType).as("The Employment Type is the same")
            .isEqualTo(middleMileDriver.getEmploymentType());
        Assertions.assertThat(actualVendor).as("The Vendor Name is the same")
            .isEqualTo(Objects.nonNull(middleMileDriver.getVendorId()) ? middleMileDriver.getVendorName() : "-");
        Assertions.assertThat(actualEmpStatus).as("The Employment Status is the same")
            .isEqualTo(middleMileDriver.getIsEmploymentActive() ? "Active" : "Inactive");
        Assertions.assertThat(actualLicenseType).as("The License Type is the same")
            .isEqualTo(middleMileDriver.getLicenseType());
        Assertions.assertThat(actualLicenseStatus).as("The License Status is the same")
            .isEqualTo(middleMileDriver.getIsLicenseActive() ? "Active" : "Inactive");
        Assertions.assertThat(actualComments).as("The Comment is the same")
            .isEqualTo(middleMileDriver.getComments());
        Assertions.assertThat(editDriver.isDisplayed()).as("The Edit driver is shown").isTrue();
        Assertions.assertThat(viewDriver.isDisplayed()).as("The View driver is shown").isTrue();
    }

    public void tableFilterByIdWithValue(Long driverId) {
        idFilter.setValue(driverId);
        waitUntilVisibilityOfElementLocated(f(TABLE_ASSERTION_XPATH, NEW_ID_TABLE_FILTER_ID));
    }

    public void tableFilterCombobox(MiddleMileDriver driver, String filterBy) {
        pause3s();
        displayNameFilter.setValue(driver.getDisplayName());
        waitUntilVisibilityOfElementLocated(
            f(TABLE_ASSERTION_XPATH, NEW_NAME_TABLE_FILTER_ID));

        switch (filterBy.toLowerCase()) {
            case EMPLOYMENT_TYPE:
                employmentTypeFilter.scrollIntoView();
                employmentTypeFilter.openButton.click();
                employmentTypeFilter.selectType(driver.getEmploymentType());
                employmentTypeFilter.ok.click();
                break;

            case EMPLOYMENT_STATUS:
                employmentStatusFilter.scrollIntoView();
                employmentStatusFilter.openButton.click();
                employmentStatusFilter.active.check();
                employmentStatusFilter.ok.click();
                break;

            case LICENSE_TYPE:
                licenseTypeFilter.scrollIntoView();
                licenseTypeFilter.openButton.click();
                licenseTypeFilter.selectType(driver.getLicenseType());
                licenseTypeFilter.ok.click();
                break;

            case LICENSE_STATUS:
                licenseStatusFilter.scrollIntoView();
                licenseStatusFilter.openButton.click();
                licenseStatusFilter.active.check();
                licenseStatusFilter.ok.click();
                break;
        }

        String actualName = getText(f(TABLE_ASSERTION_XPATH, NEW_NAME_TABLE_FILTER_ID));
        String actualUsername = getText(f(TABLE_ASSERTION_XPATH, NEW_USERNAME_TABLE_FILTER_ID));
        String actualHub = getText(f(TABLE_ASSERTION_XPATH, NEW_HUB_TABLE_FILTER_ID));
        String actualEmploymentType = getText(
                f(TABLE_ASSERTION_XPATH, NEW_EMPLOYMENT_TYPE_FILTER_ID));
        String actualLicenseType = getText(
                f(TABLE_ASSERTION_XPATH, NEW_LICENSE_TYPE_TABLE_FILTER_ID));
        String actualComments = getText(f(TABLE_ASSERTION_XPATH, NEW_COMMENTS_TABLE_FILTER_ID));

       Assertions.assertThat(actualName).as("Name is not the same : ").isEqualTo(driver.getDisplayName());
       Assertions.assertThat(actualUsername).as("Username is not the same : ").isEqualTo(driver.getUsername());
       Assertions.assertThat(actualHub).as("Hub is not the same : ").isEqualTo(driver.getHubName());
       Assertions.assertThat(actualEmploymentType).as("Employment Type is not the same : ").isEqualTo(
           driver.getEmploymentType());
       Assertions.assertThat(actualLicenseType).as("License Type is not the same : ").isEqualTo(
           driver.getLicenseType());
       Assertions.assertThat(actualComments).as("Comment is not the same : ").isEqualTo(driver.getComments());
    }

    public void verifiesDataIsNotExisted(String driverName) {
        displayNameFilter.setValue(driverName);
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

    public void editDriverByWithValue(String column, String value, boolean withSave) {
        switch (column) {
            case "firstName":
                editDriverDialog.name.forceClear();
                editDriverDialog.name.sendKeys(value);
                break;
            case "lastName":
                editDriverDialog.lastName.forceClear();
                editDriverDialog.lastName.sendKeys(value);
                break;
            case "displayName":
                editDriverDialog.displayName.forceClear();
                editDriverDialog.displayName.sendKeys(value);
                break;
            case "contactDetails":
                editDriverDialog.contactNumber.forceClear();
                editDriverDialog.contactNumber.sendKeys(value);
                break;
            case "hubName":
                editDriverDialog.hub.selectValue(value);
                break;
            case "licenseNumber":
                editDriverDialog.licenseNumber.forceClear();
                editDriverDialog.licenseNumber.sendKeys(value);
                break;
            case "licenseExpiryDate":
                editDriverDialog.licenseExpiryDate.setDate(value);
                break;
            case "licenseType":
                editDriverDialog.selectLicenseType(value);
                break;
            case "employmentType":
                editDriverDialog.employmentType.click();
                scrollIntoView(f(SELECT_FILTER_VALUE_XPATH, value));
                click(f(SELECT_FILTER_VALUE_XPATH, value));
                break;
            case "employmentStartDate":
                editDriverDialog.employmentStartDate.setDate(value);
                break;
            case "employmentEndDate":
                editDriverDialog.employmentEndDate.setDate(value);
                break;
        }

        if (withSave) {
            editDriverDialog.save.click();
            editDriverDialog.waitUntilInvisible();
        }
    }

    public void editDriverByWithValue(String column, String value) {
        editDriverByWithValue(column, value, true);
    }

    public void verifiesDriverIsUpdatedByWithValue(String column, String value) {
        String tableColumnValue = "//tr[1]//td[contains(@class,'%s')]/span";
        switch (column) {
            case "name":
                String actualName = getText(f(tableColumnValue, column));
               Assertions.assertThat(actualName).as("Updated name is the same").isEqualTo(value);
                break;
            case "contact_number":
                break;
        }
    }

    public void verifiesDataInViewModalIsTheSame(MiddleMileDriver middleMileDriver) {
        Assertions.assertThat(middleMileDriver.getDisplayName()).
            as("Name is as expected").isEqualTo(viewDriverDialog.name.getValue());
        Assertions.assertThat(middleMileDriver.getHubName()).
            as("Hub is as expected").isEqualTo(viewDriverDialog.hub.getText());
        Assertions.assertThat(middleMileDriver.getContact().getDetails()).
            as("Contact number is as expected").endsWith(viewDriverDialog.contactNumber.getValue());
        Assertions.assertThat(middleMileDriver.getLicenseNumber()).
            as("License number is as expected").isEqualTo(viewDriverDialog.licenseNumber.getValue());
        Assertions.assertThat(middleMileDriver.getLicenseExpiryDate()).
            as("Expiry Date is as expected").isEqualTo(viewDriverDialog.licenseExpiryDate.getValue());
        Assertions.assertThat(middleMileDriver.getUsername()).
            as("Username is as expected").isEqualTo(viewDriverDialog.username.getValue());
        Assertions.assertThat(middleMileDriver.getComments()).
            as("Comments is as expected").isEqualTo(viewDriverDialog.comments.getValue());
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
        if(!findElementByXpath(SELECT_ALL_CHECKBOX_XPATH).isSelected()){
            click(DROP_DOWN_ON_TABLE_XPATH);
        }
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
           Assertions.assertThat(driverAvailability).as("Driver Availability is True : ").isTrue();
        } else if (isElementExistFast(NO_COMING_BUTTON_XPATH)) {
           Assertions.assertThat(driverAvailability).as("Driver Availability is false : ").isFalse();
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

    private void scrollHorizontal(WebElement webElement, int amount) {
        ((JavascriptExecutor) getWebDriver()).executeScript(f("arguments[0].scrollLeft = %d;", amount), webElement);
    }

    public void sortColumn(String columnName, String sortingOrder) {
        waitWhilePageIsLoading();
        String sortColumnXpath = f(TABLE_FILTER_SORT_XPATH, columnName);
        String tableBodyXpath = "//div[@data-testid='middle-mile-driver-table']//div[contains(@class, 'ant-table-body')]";
        scrollHorizontal(findElementByXpath(tableBodyXpath), 2000);
        String body_class_name = "name";
        switch (columnName){
            case "ID":
                body_class_name ="driver-id";
                break;
            case "Username":
                body_class_name ="username";
                break;
            case "Hub":
                body_class_name ="hub-name";
                break;
            case "Employment Type":
                body_class_name ="employment-type";
                break;
            case "Employment Status":
                body_class_name = "employment-status-string";
                break;
            case "License Type":
                body_class_name ="license-type";
                break;
            case "License Status":
                body_class_name = "license-status-string";
                break;
            case "Comments":
                body_class_name ="comments";
                break;
            case "Vendor's Name":
                body_class_name ="vendor-name";
                break;
        }

        WebElement TableBody = findElementByXpath(f("(//div[contains(@class,'ant-table-container')]//div[contains(@class,'ant-table-body')]//td[contains(@class,'%s')])[1]",body_class_name));
        executeScript("arguments[0].scrollIntoView({block: \"center\",inline: \"center\"});", TableBody);
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
        List<String> headerFields = getWebDriver().findElements(By.xpath(headerXpath))
            .stream()
            .map(webElement -> webElement.getText().trim().toLowerCase())
            .collect(Collectors.toList());
        if (headerFields.size() == 0) {
            Assertions.assertThat(headerFields.size())
                .as(f("Assert that the column %s to be sorted is displayed on the screen",
                    columnName)).isGreaterThan(0);
        }
        for (String header : headerFields) {
            columnIndex++;
            if (header.contains(columnName.toLowerCase())) {
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
        List<String> colData = getColumnValuesByColumnName(columnName).stream()
            .filter(c -> !c.isEmpty())
            .map(u -> u.trim().toLowerCase())
            .collect(
                Collectors.toList());
        LOGGER.info("Values: {}", colData);
        if (sortingOrder.equalsIgnoreCase("Ascending")) {
            Assertions.assertThat(Comparators.isInOrder(colData, Comparator.naturalOrder()))
                .as("The column values %s are sorted in %s order: %s", columnName, sortingOrder, String.join(", ", colData)).isTrue();
            return;
        }
        if (sortingOrder.equalsIgnoreCase("Descending")) {
            Assertions.assertThat(Comparators.isInOrder(colData, Comparator.reverseOrder()))
                .as("The column values %s are sorted in %s order: %s", columnName, sortingOrder, String.join(", ", colData)).isTrue();
            return;
        }

        Assertions.assertThat(Comparators.isInOrder(colData, Comparator.naturalOrder()))
            .as("The column values %s are sorted in %s order: %s", columnName, sortingOrder, String.join(", ", colData)).isTrue();
    }

    public void ClickToBrowserBackButton() {
        getWebDriver().navigate().back();
        switchTo();
        loadDrivers.waitUntilClickable();
    }

    public void ClickToBrowserForwardButton() {
        getWebDriver().navigate().forward();
        switchTo();
        loadDrivers.waitUntilInvisible();
        loadingIcon.waitUntilInvisible(60);

    }

    public void verifyURLofPage(String ExpectedURL) {
        String ActualURL = getWebDriver().getCurrentUrl();
        Assertions.assertThat(ActualURL).as("The URL is the same:").isEqualTo(ExpectedURL);
    }

    public String getEmploymentStatus(Driver mmDriver) {
        SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
        Date currentdate = new Date();
        String status = mmDriver.getEmploymentEndDate();
        if (status == null) return ACTIVE_STATUS;
        try {
            Date employmentEndDate = new Date(Long.parseLong(status, 10));
            if (employmentEndDate.after(currentdate)) {
                return ACTIVE_STATUS;
            }
        } catch (Exception e) {
            NvLogger.error(e.getMessage());
        }
        return INACTIVE_STATUS;

    }

    public String getLicenseStatus(Driver mmDriver) {
        SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
        Date currentdate = new Date();
        String status = mmDriver.getLicenseExpiryDate();
        try {
            Date LicenseEndDate = new Date(Long.parseLong(status, 10));
            if (LicenseEndDate.after(currentdate)) {
                return ACTIVE_STATUS;
            }
        } catch (Exception e) {
            NvLogger.error(e.getMessage());
        }
        return INACTIVE_STATUS;

    }

    public List<Driver> filterDriver(List<Driver> middleMileDrivers, String statusName, String filter) {
        List<Driver> temp = new ArrayList<Driver>();
        switch (statusName) {
            case "Employment Status":
                middleMileDrivers.forEach(driver -> {
                    if (getEmploymentStatus(driver).equals(filter)) temp.add(driver);
                });
                break;
            case "License Status":
                middleMileDrivers.forEach(driver -> {
                    if (getLicenseStatus(driver).equals(filter)) temp.add(driver);
                });
                break;
        }

        return temp;
    }

    public List<Driver> filterDriver(List<Driver> middleMileDrivers, String statusName1, String filter1, String statusName2, String filter2) {
        List<Driver> temp = new ArrayList<Driver>();
        temp = filterDriver(middleMileDrivers, statusName1, filter1);
        return filterDriver(temp, statusName2, filter2);
    }

    /*
    Employment End date and License End Date of created driver are Date format, not Unix timestamp format
    Convert them to Unix timestamp and set them
     */
    public void convertDateToUnixTimestamp(Driver driver) {
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

    public static class TableFilterPopup extends PageElement {

        @FindBy(xpath = ".//button")
        public Button openButton;
        @FindBy(xpath = "//div[contains(@class,'ant-dropdown ')][not(contains(@class, 'ant-dropdown-hidden'))]//button[.='OK']")
        public Button ok;
        @FindBy(xpath = "//div[contains(@class,'ant-dropdown ')][not(contains(@class, 'ant-dropdown-hidden'))]//button[.='Reset']")
        public Button reset;

        public TableFilterPopup(WebDriver webDriver, WebElement webElement) {
            super(webDriver, webElement);
        }
    }

    public static class StatusFilter extends TableFilterPopup {

        @FindBy(xpath = "//div[contains(@class,'ant-dropdown ')][not(contains(@class,'ant-dropdown-hidden'))]//li[.='Active']//input")
        public CheckBox active;
        @FindBy(xpath = "//div[contains(@class,'ant-dropdown ')][not(contains(@class,'ant-dropdown-hidden'))]//li[.='Inactive']//input")
        public CheckBox inactive;

        public StatusFilter(WebDriver webDriver, WebElement webElement) {
            super(webDriver, webElement);
        }
    }

    public static class EmploymentTypeFilter extends TableFilterPopup {

        @FindBy(xpath = "//div[contains(@class,'ant-dropdown ')][not(contains(@class,'ant-dropdown-hidden'))]//li[.='Full-time / Contract']//input")
        public CheckBox contract;
        @FindBy(xpath = "//div[contains(@class,'ant-dropdown ')][not(contains(@class,'ant-dropdown-hidden'))]//li[.='Part-time / Freelance']//input")
        public CheckBox freelance;
        @FindBy(xpath = "//div[contains(@class,'ant-dropdown ')][not(contains(@class,'ant-dropdown-hidden'))]//li[.='Vendor']//input")
        public CheckBox vendor;

        public EmploymentTypeFilter(WebDriver webDriver, WebElement webElement) {
            super(webDriver, webElement);
        }

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

        @FindBy(id = "display_name")
        public TextBox name;
        @FindBy(xpath = "//div[@data-testid='form-hub-select']//span[contains(@class,'ant-select-selection-item')]")
        public co.nvqa.operator_v2.selenium.elements.ant.v4.AntSelect hub;
        @FindBy(id = "contact_number")
        public TextBox contactNumber;
        @FindBy(id = "license_number")
        public TextBox licenseNumber;
        @FindBy(id = "license_expiry_date")
        public PageElement licenseExpiryDate;
        @FindBy(id = "username")
        public TextBox username;
        @FindBy(id = "comments")
        public TextBox comments;

        public ViewDriverDialog(WebDriver webDriver, WebElement webElement) {
            super(webDriver, webElement);
        }
    }

    public static class EditDriverDialog extends AntModal {

        @FindBy(xpath = "//div[@class='ant-modal-title']")
        public TextBox dialogTitle;
        @FindBy(id = "first_name")
        public TextBox name;
        @FindBy(id = "last_name")
        public TextBox lastName;
        @FindBy(id = "display_name")
        public TextBox displayName;
        @FindBy(id = "contact_number")
        public TextBox contactNumber;
        @FindBy(xpath = "//div[contains(@class, ' ant-select')][.//input[@id='hub_id']]")
        public co.nvqa.operator_v2.selenium.elements.ant.v4.AntSelect hub;
        @FindBy(id = "license_number")
        public TextBox licenseNumber;
        @FindBy(xpath = "//div[@class= 'ant-picker'][.//input[@id='license_expiry_date']]")
        public AntCalendarPicker licenseExpiryDate;
        @FindBy(xpath = "//div[contains(@class, ' ant-select')][.//input[@id='employment_type']]")
        public co.nvqa.operator_v2.selenium.elements.ant.v4.AntSelect employmentType;
        @FindBy(xpath = "//div[@class= 'ant-picker'][.//input[@id='employment_start_date']]")
        public AntCalendarPicker employmentStartDate;
        @FindBy(xpath = "//div[@class= 'ant-picker'][.//input[@id='employment_end_date']]")
        public AntCalendarPicker employmentEndDate;
        @FindBy(className = "ant-btn")
        public Button cancel;
        @FindBy(className = "ant-btn-primary")
        public Button save;

        public EditDriverDialog(WebDriver webDriver, WebElement webElement) {
            super(webDriver, webElement);
        }

        public void selectLicenseType(String value) {
            String licenseTypeXpath = "//div[contains(.//label,'License Type')]//input[@value='%s']";
            WebElement licenseTypeInput = findElementByXpath(f(licenseTypeXpath, value));
            licenseTypeInput.click();
        }
    }

    public void clickCheckAvailabilityButton(){
        waitUntilVisibilityOfElementLocated(CHECK_AVAILABILITY_BUTTON_XPATH);
        click(CHECK_AVAILABILITY_BUTTON_XPATH);
    }

    public void verifyErrorMessage(String message){
        if (isElementExist(f(ERROR_MESSAGE_NOTICE_TEXT_XPATH,message),2L)) {
            Assertions.assertThat(true).as(message).isTrue();
        } else if (isElementExist(f(ERROR_MESSAGE_NOTICE_CONFLICT_XPATH,message),2L)){
            Assertions.assertThat(true).as(message).isTrue();
        }
    }

    @Deprecated
    public Driver createNewMiddleMileDrivers(Map<String, String> data) {
            Driver middleMileDriver = new Driver();

            if (data.get("firstName") != null) {
                String firstName = data.get("firstName");
                if (firstName.equalsIgnoreCase("random")) {
                    firstName = "FIRSTNAME" + RandomStringUtils.randomAlphabetic(5);
                }
                createDriverForm_firstName.sendKeys(firstName);
                middleMileDriver.setFirstName(firstName);
            }

            if (data.get("lastName") != null) {
                String lastName = data.get("lastName");
                if (lastName.equalsIgnoreCase("random")) {
                    lastName = "LASTNAME" + RandomStringUtils.randomAlphabetic(5);
                }
                createDriverForm_lastName.sendKeys(lastName);
                middleMileDriver.setLastName(lastName);
            }

            if (data.get("displayName") != null) {
                String displayName = data.get("displayName");
                if (displayName.equalsIgnoreCase("random")) {
                    displayName = "DISPLAY-NAME_" + RandomStringUtils.randomAlphabetic(5);
                } else if (displayName.equalsIgnoreCase("random-custom")) {
                    displayName = "DISPLAY-NAME_[" + RandomStringUtils.randomAlphabetic(5)
                            + "] (" + RandomStringUtils.randomNumeric(5) + ")";
                }
                createDriverForm_displayName.sendKeys(displayName);
                middleMileDriver.setDisplayName(displayName);
            }

            if (data.get("hub") != null) {
                middleMileDriver.setHub(data.get("hub"));
                chooseHub(middleMileDriver.getHub());
            }

            if (data.get("contactNumber") != null) {
                middleMileDriver.setMobilePhone(data.get("contactNumber"));
                fillcontactNumber(middleMileDriver.getMobilePhone());
            }

            if (data.get("licenseNumber") != null) {
                middleMileDriver.setLicenseNumber(data.get("licenseNumber"));
                createDriverForm_licenseNumber.sendKeys(data.get("licenseNumber"));
            }

            //Expiry date in days
            middleMileDriver.setLicenseExpiryDate(EXPIRY_DATE_FORMATTER.format(TODAY.plusMonths(2)));
            fillLicenseExpiryDate(EXPIRY_DATE_FORMATTER.format(TODAY.plusDays(5)));

            if (data.get("licenseType") != null) {
                String licenseType = data.get("licenseType");
                middleMileDriver.setLicenseType(licenseType);
                if (licenseType.equalsIgnoreCase("all types")) {
                    chooseLicenseType("B");
                    chooseLicenseType("B1");
                    chooseLicenseType("B2");
                    chooseLicenseType("C");
                    chooseLicenseType("Restriction 1");
                    chooseLicenseType("Restriction 2");
                    chooseLicenseType("Restriction 3");
                } else {
                    chooseLicenseType(data.get("licenseType"));
                }
            }

            if (data.get("employmentType") != null) {
                String employmentType = data.get("employmentType");
                middleMileDriver.setEmploymentType(employmentType);
                String vendorName = data.get("vendorName");
                if (data.get("vendorName") != null) {
                    if (employmentType.equalsIgnoreCase("Outsourced - Vendors")) {
                        chooseEmploymentType(employmentType);
                        chooseVendorName(vendorName);
                    } else if (employmentType.equalsIgnoreCase("Outsourced - Manpower Agency")) {
                        chooseEmploymentType(employmentType);
                        chooseVendorName(vendorName);
                    }
                } else {
                    chooseEmploymentType(employmentType);
                }
            }

            //Employment Start Date in today's date
            fillEmploymentStartDate(EXPIRY_DATE_FORMATTER.format(TODAY));

            //Employment End Date in days
            fillEmploymentEndDate(EXPIRY_DATE_FORMATTER.format(TODAY.plusDays(5)));

            if (data.get("username") != null) {
                String username = data.get("username");
                middleMileDriver.setUsername(username);
                if (username.equalsIgnoreCase("random")) {
                    middleMileDriver.setUsername(middleMileDriver.getFirstName() + middleMileDriver.getLastName());
                }
                fillUsername(middleMileDriver.getUsername());
            }

            if (data.get("password") != null) {
                fillPassword(data.get("password"));
            }

            if (data.get("comments") != null) {
                middleMileDriver.setComments(data.get("comments"));
                fillComments(middleMileDriver.getComments());
            }
            return middleMileDriver;
    }

    public MiddleMileDriver createMiddleMileDrivers(Map<String, String> data) {
        MiddleMileDriver middleMileDriver = new MiddleMileDriver();

        if (data.get("firstName") != null) {
            String firstName = data.get("firstName");
            if (firstName.equalsIgnoreCase("random")) {
            }
                firstName = "F" + RandomStringUtils.randomAlphabetic(5);
            createDriverForm_firstName.sendKeys(firstName);
            middleMileDriver.setFirstName(firstName);
        }

        if (data.get("lastName") != null) {
            String lastName = data.get("lastName");
            if (lastName.equalsIgnoreCase("random")) {
            }
                lastName = "L" + RandomStringUtils.randomAlphabetic(5);
            createDriverForm_lastName.sendKeys(lastName);
            middleMileDriver.setLastName(lastName);
        }

        if (data.get("displayName") != null) {
            String displayName = data.get("displayName");
            if (displayName.equalsIgnoreCase("random")) {
                displayName = "DISPLAY-NAME_" + RandomStringUtils.randomAlphabetic(5);
            } else if (displayName.equalsIgnoreCase("random-custom")) {
                displayName = "DISPLAY-NAME_[" + RandomStringUtils.randomAlphabetic(5)
                    + "] (" + RandomStringUtils.randomNumeric(5) + ")";
            }
            createDriverForm_displayName.sendKeys(displayName);
            middleMileDriver.setDisplayName(displayName);
        }

        if (data.get("hub") != null) {
            middleMileDriver.setHubName(data.get("hub"));
            chooseHub(middleMileDriver.getHubName());
        }

        if (data.get("contactNumber") != null) {
            middleMileDriver.setContact(Contact.builder().active(true).type("Mobile Phone").details(data.get("contactNumber")).build());
            fillcontactNumber(middleMileDriver.getContact().getDetails());
        }

        if (data.get("licenseNumber") != null) {
            middleMileDriver.setLicenseNumber(data.get("licenseNumber"));
            createDriverForm_licenseNumber.sendKeys(data.get("licenseNumber"));
        }

        //Expiry date in days
        middleMileDriver.setLicenseExpiryDate(EXPIRY_DATE_FORMATTER.format(TODAY.plusMonths(2)));
        fillLicenseExpiryDate(EXPIRY_DATE_FORMATTER.format(TODAY.plusDays(5)));

        if (data.get("licenseType") != null) {
            String licenseType = data.get("licenseType");
            middleMileDriver.setLicenseType(licenseType);
            if (licenseType.equalsIgnoreCase("all types")) {
                chooseLicenseType("B");
                chooseLicenseType("B1");
                chooseLicenseType("B2");
                chooseLicenseType("C");
                chooseLicenseType("Restriction 1");
                chooseLicenseType("Restriction 2");
                chooseLicenseType("Restriction 3");
            } else {
                chooseLicenseType(data.get("licenseType"));
            }
        }

        if (data.get("employmentType") != null) {
            String employmentType = data.get("employmentType");
            middleMileDriver.setEmploymentType(employmentType);
            String vendorName = data.get("vendorName");
            if (data.get("vendorName") != null) {
                if (employmentType.equalsIgnoreCase("Outsourced - Vendors")) {
                    chooseEmploymentType(employmentType);
                    chooseVendorName(vendorName);
                } else if (employmentType.equalsIgnoreCase("Outsourced - Manpower Agency")) {
                    chooseEmploymentType(employmentType);
                    chooseVendorName(vendorName);
                }
            } else {
                chooseEmploymentType(employmentType);
            }
        }

        //Employment Start Date in today's date
        fillEmploymentStartDate(EXPIRY_DATE_FORMATTER.format(TODAY));

        //Employment End Date in days
        fillEmploymentEndDate(EXPIRY_DATE_FORMATTER.format(TODAY.plusDays(5)));

        if (data.get("username") != null) {
            String username = data.get("username");
            middleMileDriver.setUsername(username);
            if (username.equalsIgnoreCase("random")) {
                middleMileDriver.setUsername(middleMileDriver.getFirstName() + middleMileDriver.getLastName());
            }
            fillUsername(middleMileDriver.getUsername());
        }

        if (data.get("password") != null) {
            fillPassword(data.get("password"));
        }

        if (data.get("comments") != null) {
            middleMileDriver.setComments(data.get("comments"));
            fillComments(middleMileDriver.getComments());
        }
        return middleMileDriver;
    }

    public void verifyMandatoryFieldErrorMessageMiddlemileDriverPage(String fieldName) {
        String actualMessage = findElementByXpath(f(MIDDLE_MILE_DRIVER_FIELD_ERROR_XPATH, fieldName)).getText();
        String expectedMessage = "Please enter " + fieldName;
        Assertions.assertThat(actualMessage).as("Mandatory field error message is same")
                .isEqualTo(expectedMessage);
    }

    public void clearTextonField(String fieldName) {
        if (fieldName.equals("Employment Type")) {
            findElementByXpath(f(MIDDLE_MILE_DRIVER_CLEAR_BUTTON_XPATH, "employment_type")).click();
        }
    }

    public void verifyErrorNotificationDriverAlreadyRegistered() {
        Assertions.assertThat(isElementExist(NOTIFICATION_DRIVER_ALREADY_REGISTERED_XPATH))
            .as("Error notification is Username already registered")
            .isTrue();
    }

    public void editDriverByWithVendorValue(String employmentType, String vendorName) {
        editDriverByWithVendorValue(employmentType, vendorName, true);
    }

    public void editDriverByWithVendorValue(String employmentType, String vendorName, boolean withSave) {
        chooseEmploymentType(employmentType);
        if (vendorName.equals("-")) return;
        chooseVendorName(vendorName);

        if (withSave) {
            editDriverDialog.save.click();
            editDriverDialog.waitUntilInvisible();
        }
    }

    public void verifiesToastWithMessage(String errorMessage) {
        if (errorMessage.equals("Request failed with status code 400")) {
            Assertions.assertThat(isElementExistFast(TOAST_ERROR_400_MESSAGE_XPATH))
                    .as("Toast Error Request 400")
                    .isTrue();
        }
    }

    public void editDriverByWithInvalidValue(String fieldName, String value) {
        switch (fieldName) {
            case "firstName":
                editDriverDialog.name.forceClear();
                editDriverDialog.name.sendKeys(value);
                break;
            case "lastName":
                editDriverDialog.lastName.forceClear();
                editDriverDialog.lastName.sendKeys(value);
                break;
            case "displayName":
                editDriverDialog.displayName.forceClear();
                editDriverDialog.displayName.sendKeys(value);
                break;
        }
        editDriverDialog.save.click();
    }

    public void chooseLicenseTypeFilter(String licenseType) {
        click(f(LICENSE_TYPE_FILTER_XPATH, licenseType));
    }
}
