package co.nvqa.operator_v2.selenium.page;

import co.nvqa.commons.util.NvLogger;
import co.nvqa.operator_v2.model.MiddleMileDriver;
import org.openqa.selenium.WebDriver;

/**
 *
 * @author Tristania Siagian
 */

public class MiddleMileDriversPage extends OperatorV2SimplePage {

    private static final String IFRAME_XPATH = "//iframe[contains(@src,'middle-mile-drivers')]";
    private static final String LOAD_DRIVERS_BUTTON_XPATH = "//div[contains(@class,'col')]/button[contains(@class,'ant-btn-primary')]";
    private static final String DRIVERS_NOT_FOUND_TOAST_XPATH = "//div[contains(@class,'notification-notice-closable')]";
    private static final String DRIVERS_LIST_CONTAINER_XPATH = "//div[contains(@class,'MiddleMileDriverListContainer')]";
    private static final String TOTAL_DRIVER_SHOW_XPATH = "//div[contains(@class,'TableWrapper')]/div[contains(@class,'TableStats')]/span[2]";
    private static final String FILTER_DROPDOWN_XPATH = "//div[@id='%s']";
    private static final String SELECT_FILTER_VALUE_XPATH = "//div[not(contains(@class,'dropdown-hidden'))]/div/ul/li[text()='%s']";
    private static final String CREATE_DRIVER_BUTTON_XPATH = "//button[contains(@class,'CreateDriverButton')]";
    private static final String CREATE_DRIVER_MODAL_XPATH = "//div[contains(@id,'rcDialogTitle')]";
    private static final String RECENT_MONTH_XPATH = "//a[contains(@class,'month-select')]";
    private static final String NEXT_MONTH_XPATH = "//a[contains(@title,'Next month')]";
    private static final String CALENDAR_DATE_XPATH = "//td[@title='%s']/div";
    private static final String SAVE_BUTTON_XPATH = "//div[contains(@class,'footer')]/button[contains(@class,'primary')]";
    private static final String TOAST_DRIVER_CREATED_XPATH = "//div[contains(@class,'notification-notice-description') and text()='Username: %s']";
    private static final String TABLE_FILTER_BY_NAME_XPATH = "//th[contains(@class,'name') and not (contains(@class,'username'))]//input";
    private static final String NO_RESULT_TABLE_XPATH = "//div[contains(@class,'NoResult')]";

    private static final String INPUT_CREATE_DRIVER_MODAL_XPATH = "//input[@id='%s']";
    private static final String DROPDOWN_CREATE_DRIVER_MODAL_XPATH = "//div[@id='%s']";
    private static final String CALENDAR_CREATE_DRIVER_MODAL_XPATH = "//span[@id='%s']";
    private static final String TABLE_FILTER_XPATH = "//th[contains(@class,'%s')]//input";
    private static final String TABLE_FILTER_SELECTION_XPATH = "//th[contains(@class,'%s')]//button";
    private static final String TABLE_ASSERTION_XPATH = "//td[contains(@class,'%s')]/span/%s";
    private static final String TABLE_ASSERTION_SELECTION_XPATH = "//td[contains(@class,'%s')]";

    private static final String HUB_FILTER_ID = "hubIds";
    private static final String EMPLOYMENT_STATUS_FILTER_ID = "employmentStatus";
    private static final String LICENSE_STATUS_FILTER_ID = "licenseStatus";

    private static final String LICENSE_TYPE_INPUT_CREATE_DRIVER_XPATH = "//input[@value='Class 5']";
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
    private static final String ID_TABLE_FILTER_ID = "id";
    private static final String USERNAME_TABLE_FILTER_ID = "username";
    private static final String HUB_TABLE_FILTER_ID = "hub";
    private static final String COMMENTS_TABLE_FILTER_ID = "comments";

    private static final String EMPLOYMENT_TYPE_TABLE_FILTER_ID = "employmentType";
    private static final String LICENSE_TYPE_TABLE_FILTER_ID = "licenseType";
    private static final String LICENSE_STATUS_TYPE_TABLE_FILTER_ID = "licenseStatus";

    private static final String MARK_ELEMENT = "mark";
    private static final String SPAN_ELEMENT = "span";

    private static final String NAME = "name";

    public MiddleMileDriversPage(WebDriver webDriver) {
        super(webDriver);
    }

    public void clickLoadDriversButton() {
        getWebDriver().switchTo().frame(findElementByXpath(IFRAME_XPATH));

        waitUntilVisibilityOfElementLocated(LOAD_DRIVERS_BUTTON_XPATH);
        click(LOAD_DRIVERS_BUTTON_XPATH);

        if (isElementExist(DRIVERS_NOT_FOUND_TOAST_XPATH)) {
            waitUntilInvisibilityOfElementLocated(DRIVERS_NOT_FOUND_TOAST_XPATH);
        } else {
            waitUntilVisibilityOfElementLocated(DRIVERS_LIST_CONTAINER_XPATH);
        }

        getWebDriver().switchTo().parentFrame();
    }

    public void verifiesTotalDriverIsTheSame(int totalDriver) {
        getWebDriver().switchTo().frame(findElementByXpath(IFRAME_XPATH));

        if (totalDriver > 0) {
            assertTrue("Total Driver Shown is the same.", getText(TOTAL_DRIVER_SHOW_XPATH).startsWith(String.valueOf(totalDriver)));
        }

        getWebDriver().switchTo().parentFrame();
    }

    public void selectHubFilter(String hubName) {
        getWebDriver().switchTo().frame(findElementByXpath(IFRAME_XPATH));

        waitUntilVisibilityOfElementLocated(LOAD_DRIVERS_BUTTON_XPATH);
        click(f(FILTER_DROPDOWN_XPATH, HUB_FILTER_ID));
        waitUntilVisibilityOfElementLocated(f(SELECT_FILTER_VALUE_XPATH, hubName));
        click(f(SELECT_FILTER_VALUE_XPATH, hubName));

        getWebDriver().switchTo().parentFrame();
    }

    public void selectFilter(String filterName, String value) {
        getWebDriver().switchTo().frame(findElementByXpath(IFRAME_XPATH));

        if ("Employment Status".equalsIgnoreCase(filterName)) {
            click(f(FILTER_DROPDOWN_XPATH, EMPLOYMENT_STATUS_FILTER_ID));
        } else if ("License Status".equalsIgnoreCase(filterName)) {
            click(f(FILTER_DROPDOWN_XPATH, LICENSE_STATUS_FILTER_ID));
        }

        waitUntilVisibilityOfElementLocated(f(SELECT_FILTER_VALUE_XPATH, value));
        click(f(SELECT_FILTER_VALUE_XPATH, value));

        getWebDriver().switchTo().parentFrame();
    }

    public void clickCreateDriversButton() {
        getWebDriver().switchTo().frame(findElementByXpath(IFRAME_XPATH));

        waitUntilVisibilityOfElementLocated(LOAD_DRIVERS_BUTTON_XPATH);
        click(CREATE_DRIVER_BUTTON_XPATH);
        waitUntilVisibilityOfElementLocated(CREATE_DRIVER_MODAL_XPATH);

        getWebDriver().switchTo().parentFrame();
    }

    public void fillName(String name) {
        getWebDriver().switchTo().frame(findElementByXpath(IFRAME_XPATH));
        sendKeys(f(INPUT_CREATE_DRIVER_MODAL_XPATH, NAME_INPUT_CREATE_DRIVER_ID), name);
        getWebDriver().switchTo().parentFrame();
    }

    public void chooseHub(String hubName) {
        getWebDriver().switchTo().frame(findElementByXpath(IFRAME_XPATH));
        click(f(DROPDOWN_CREATE_DRIVER_MODAL_XPATH, HUB_INPUT_CREATE_DRIVER_ID));
        waitUntilVisibilityOfElementLocated(f(SELECT_FILTER_VALUE_XPATH, hubName));
        click(f(SELECT_FILTER_VALUE_XPATH, hubName));
        getWebDriver().switchTo().parentFrame();
    }

    public void fillcontactNumber(String contactNumber) {
        getWebDriver().switchTo().frame(findElementByXpath(IFRAME_XPATH));
        sendKeys(f(INPUT_CREATE_DRIVER_MODAL_XPATH, CONTACT_NUMBER_INPUT_CREATE_DRIVER_ID), contactNumber);
        getWebDriver().switchTo().parentFrame();
    }

    public void fillLicenseNumber(String licenseNumber) {
        getWebDriver().switchTo().frame(findElementByXpath(IFRAME_XPATH));
        sendKeys(f(INPUT_CREATE_DRIVER_MODAL_XPATH, LICENSE_NUMBER_INPUT_CREATE_DRIVER_ID), licenseNumber);
        getWebDriver().switchTo().parentFrame();
    }

    public void fillLicenseExpiryDate(String licenseExpiryDate) {
        getWebDriver().switchTo().frame(findElementByXpath(IFRAME_XPATH));
        click(f(CALENDAR_CREATE_DRIVER_MODAL_XPATH, EXPIRY_DATE_INPUT_CREATE_DRIVER_ID));
        waitUntilVisibilityOfElementLocated(RECENT_MONTH_XPATH);
        while (!(isElementExistFast(f(CALENDAR_DATE_XPATH, licenseExpiryDate)))) {
            click(NEXT_MONTH_XPATH);
        }
        click(f(CALENDAR_DATE_XPATH, licenseExpiryDate));
        getWebDriver().switchTo().parentFrame();
    }

    public void chooseLicenseType() {
        getWebDriver().switchTo().frame(findElementByXpath(IFRAME_XPATH));
        click(LICENSE_TYPE_INPUT_CREATE_DRIVER_XPATH);
        getWebDriver().switchTo().parentFrame();
    }

    public void chooseEmploymentType(String employmentType) {
        getWebDriver().switchTo().frame(findElementByXpath(IFRAME_XPATH));
        click(f(DROPDOWN_CREATE_DRIVER_MODAL_XPATH, EMPLOYMENT_TYPE_INPUT_CREATE_DRIVER_ID));
        waitUntilVisibilityOfElementLocated(f(SELECT_FILTER_VALUE_XPATH, employmentType));
        click(f(SELECT_FILTER_VALUE_XPATH, employmentType));
        getWebDriver().switchTo().parentFrame();
    }

    public void fillEmploymentStartDate(String employmentStartDate) {
        getWebDriver().switchTo().frame(findElementByXpath(IFRAME_XPATH));
        click(f(CALENDAR_CREATE_DRIVER_MODAL_XPATH, EMPLOYMENT_START_DATE_INPUT_CREATE_DRIVER_ID));
        waitUntilVisibilityOfElementLocated(RECENT_MONTH_XPATH);
        click(f(CALENDAR_DATE_XPATH, employmentStartDate));
        getWebDriver().switchTo().parentFrame();
    }

    public void fillEmploymentEndDate(String employmentEndDate) {
        getWebDriver().switchTo().frame(findElementByXpath(IFRAME_XPATH));
        click(f(CALENDAR_CREATE_DRIVER_MODAL_XPATH, EMPLOYMENT_END_DATE_INPUT_CREATE_DRIVER_ID));
        waitUntilVisibilityOfElementLocated(RECENT_MONTH_XPATH);
        while (!(isElementExistFast(f(CALENDAR_DATE_XPATH, employmentEndDate)))) {
            click(NEXT_MONTH_XPATH);
        }
        click(f(CALENDAR_DATE_XPATH, employmentEndDate));
        getWebDriver().switchTo().parentFrame();
    }

    public void fillUsername(String username) {
        getWebDriver().switchTo().frame(findElementByXpath(IFRAME_XPATH));
        sendKeys(f(INPUT_CREATE_DRIVER_MODAL_XPATH, USERNAME_INPUT_CREATE_DRIVER_ID), username);
        getWebDriver().switchTo().parentFrame();
    }

    public void fillPassword(String password) {
        getWebDriver().switchTo().frame(findElementByXpath(IFRAME_XPATH));
        sendKeys(f(INPUT_CREATE_DRIVER_MODAL_XPATH, PASSWORD_INPUT_CREATE_DRIVER_ID), password);
        getWebDriver().switchTo().parentFrame();
    }

    public void fillComments(String comments) {
        getWebDriver().switchTo().frame(findElementByXpath(IFRAME_XPATH));
        sendKeys(COMMENTS_INPUT_CREATE_DRIVER_XPATH, comments);
        getWebDriver().switchTo().parentFrame();
    }

    public void clickSaveButton() {
        getWebDriver().switchTo().frame(findElementByXpath(IFRAME_XPATH));
        click(SAVE_BUTTON_XPATH);
        getWebDriver().switchTo().parentFrame();
    }

    public void driverHasBeenCreatedToast(String username) {
        getWebDriver().switchTo().frame(findElementByXpath(IFRAME_XPATH));
        waitUntilVisibilityOfElementLocated(f(TOAST_DRIVER_CREATED_XPATH, username));
        waitUntilInvisibilityOfElementLocated(f(TOAST_DRIVER_CREATED_XPATH, username));
        getWebDriver().switchTo().parentFrame();
    }

    public void filterByTableAndVerifiesData(MiddleMileDriver middleMileDriver, String filterBy) {
        getWebDriver().switchTo().frame(findElementByXpath(IFRAME_XPATH));
        switch (filterBy.toLowerCase()) {
            case NAME :
                sendKeys(TABLE_FILTER_BY_NAME_XPATH, middleMileDriver.getName());
                break;

                //tbc. will be filled with about 5 filter more
            default :
                NvLogger.warn("Filter is not found");
        }

        waitUntilVisibilityOfElementLocated(f(TABLE_ASSERTION_XPATH, NAME_TABLE_FILTER_ID, MARK_ELEMENT));

        //Data Assertion
        String actualName = getText(f(TABLE_ASSERTION_XPATH, NAME_TABLE_FILTER_ID, MARK_ELEMENT));
        String actualUsername = getText(f(TABLE_ASSERTION_XPATH, USERNAME_TABLE_FILTER_ID, SPAN_ELEMENT));
        String actualHub = getText(f(TABLE_ASSERTION_XPATH, HUB_TABLE_FILTER_ID, SPAN_ELEMENT));
        String actualEmploymentType = getText(f(TABLE_ASSERTION_SELECTION_XPATH, EMPLOYMENT_TYPE_TABLE_FILTER_ID));
        String actualLicenseType = getText(f(TABLE_ASSERTION_SELECTION_XPATH, LICENSE_TYPE_TABLE_FILTER_ID));
        String actualComments = getText(f(TABLE_ASSERTION_XPATH, COMMENTS_TABLE_FILTER_ID, SPAN_ELEMENT));

        assertEquals("Name is not the same : ", middleMileDriver.getName(), actualName);
        assertEquals("Username is not the same : ", middleMileDriver.getUsername(), actualUsername);
        assertEquals("Hub is not the same : ", middleMileDriver.getHub(), actualHub);
        assertEquals("Employment Type is not the same : ", middleMileDriver.getEmploymentType(), actualEmploymentType);
        assertEquals("License Type is not the same : ", middleMileDriver.getLicenseType(), actualLicenseType);
        assertEquals("Comment is not the same : ", middleMileDriver.getComments(), actualComments);
        getWebDriver().switchTo().parentFrame();
    }

    public void verifiesDataIsNotExisted(String driverName) {
        getWebDriver().switchTo().frame(findElementByXpath(IFRAME_XPATH));
        sendKeys(TABLE_FILTER_BY_NAME_XPATH, driverName);
        waitUntilVisibilityOfElementLocated(NO_RESULT_TABLE_XPATH);
        getWebDriver().switchTo().parentFrame();
    }
}
