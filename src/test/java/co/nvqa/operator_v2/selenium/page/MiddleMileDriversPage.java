package co.nvqa.operator_v2.selenium.page;

import co.nvqa.commons.util.NvLogger;
import co.nvqa.operator_v2.model.MiddleMileDriver;
import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.CheckBox;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.TextBox;
import co.nvqa.operator_v2.selenium.elements.ant.AntModal;
import co.nvqa.operator_v2.selenium.elements.ant.AntSelect;
import org.openqa.selenium.JavascriptExecutor;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;

/**
 * @author Tristania Siagian
 */

public class MiddleMileDriversPage extends OperatorV2SimplePage
{
    private static final String IFRAME_XPATH = "//iframe[contains(@src,'middle-mile-drivers')]";
    private static final String LOAD_DRIVERS_BUTTON_XPATH = "//div[contains(@class,'col')]/button[contains(@class,'ant-btn-primary')]";
    private static final String DRIVERS_NOT_FOUND_TOAST_XPATH = "//div[contains(@class,'notification-notice-closable')]";
    private static final String DRIVERS_LIST_CONTAINER_XPATH = "//div[contains(@class,'MiddleMileDriverListContainer')]";
    private static final String TOTAL_DRIVER_SHOW_XPATH = "//div[contains(@class,'TableWrapper')]/div[contains(@class,'TableStats')]/span[2]";
    private static final String FILTER_DROPDOWN_XPATH = "//div[@id='%s']";
    private static final String SELECT_FILTER_VALUE_XPATH = "//div[not(contains(@class,'dropdown-hidden'))]/div/ul/li[text()='%s']";
    private static final String CREATE_DRIVER_BUTTON_XPATH = "//button[contains(@class,'CreateDriverButton')]";
    private static final String MODAL_XPATH = "//div[contains(@id,'rcDialogTitle')]";
    private static final String RECENT_MONTH_XPATH = "//a[contains(@class,'month-select')]";
    private static final String NEXT_MONTH_XPATH = "//a[contains(@title,'Next month')]";
    private static final String CALENDAR_DATE_XPATH = "//td[@title='%s']/div";
    private static final String SAVE_BUTTON_XPATH = "//div[contains(@class,'footer')]/button[contains(@class,'primary')]";
    private static final String TOAST_DRIVER_CREATED_XPATH = "//div[contains(@class,'notification-notice-description') and text()='Username: %s']";
    private static final String NO_RESULT_TABLE_XPATH = "//div[contains(@class,'NoResult')]";
    private static final String VIEW_BUTTON_XPATH = "//td[contains(@class,'action')]/button[contains(@class,'view')]";
    private static final String NO_COMING_BUTTON_XPATH = "//button[contains(@class,'_NotComing')]";
    private static final String YES_COMING_BUTTON_XPATH = "//button[contains(@class,'_Coming')]";
    private static final String DROP_DOWN_ON_TABLE_XPATH = "//div[contains(@class,'dropdown-trigger')]";
    private static final String SELECT_ALL_DROP_DOWN_SELECTION_XPATH = "//li[contains(@class,'dropdown')]//span[text()='Select All Shown']";
    private static final String APPLY_ACTION_DROP_DOWN_XPATH = "//button[contains(@class,'GenericDropdownButton')]";
    private static final String SET_TO_COMING_DROP_DOWN_XPATH = "//span[text()='Set To Coming']/preceding-sibling::div";
    private static final String SET_TO_NOT_COMING_DROP_DOWN_XPATH = "//span[text()='Set Not To Coming']/preceding-sibling::div";

    private static final String INPUT_CREATE_DRIVER_MODAL_XPATH = "//input[@id='%s']";
    private static final String DROPDOWN_CREATE_DRIVER_MODAL_XPATH = "//div[@id='%s']";
    private static final String CALENDAR_CREATE_DRIVER_MODAL_XPATH = "//span[@id='%s']";
    private static final String TABLE_ASSERTION_XPATH = "//tr[1]//td[contains(@class,'%s')]/span/%s";
    private static final String TABLE_ASSERTION_SELECTION_XPATH = "//td[contains(@class,'%s')]";

    private static final String HUB_FILTER_ID = "hubIds";
    private static final String EMPLOYMENT_STATUS_FILTER_ID = "employmentStatus";
    private static final String LICENSE_STATUS_FILTER_ID = "licenseStatus";

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
    private static final String ID_TABLE_FILTER_ID = "id";
    private static final String USERNAME_TABLE_FILTER_ID = "username";
    private static final String HUB_TABLE_FILTER_ID = "hub";
    private static final String COMMENTS_TABLE_FILTER_ID = "comments";

    private static final String EMPLOYMENT_TYPE_TABLE_FILTER_ID = "employmentType";
    private static final String LICENSE_TYPE_TABLE_FILTER_ID = "licenseType";

    private static final String EMPLOYMENT_TYPE = "employment type";
    private static final String EMPLOYMENT_STATUS = "employment status";
    private static final String LICENSE_TYPE = "license type";
    private static final String LICENSE_STATUS = "license status";

    private static final String MARK_ELEMENT = "mark";
    private static final String SPAN_ELEMENT = "span";
    private static final String YES = "yes";
    private static final String NO = "no";

    @FindBy(xpath = "//span[contains(@class,'ant-spin-dot-spin')]")
    public PageElement antDotSpinner;

    @FindBy(xpath = "//th[div[.='Name']]//input")
    public TextBox nameFilter;

    @FindBy(xpath = "//th[div[.='Id']]//input")
    public TextBox idFilter;

    @FindBy(xpath = "//th[div[.='Username']]//input")
    public TextBox usernameFilter;

    @FindBy(xpath = "//th[div[.='Hub']]//input")
    public TextBox hubFilter;

    @FindBy(xpath = "//th[div[.='Comments']]//input")
    public TextBox commentsFilter;

    @FindBy(xpath = "//th[div[.='Employment Status']]")
    public StatusFilter employmentStatusFilter;

    @FindBy(xpath = "//th[div[.='Employment Type']]")
    public EmploymentTypeFilter employmentTypeFilter;

    @FindBy(xpath = "//th[div[.='License Type']]")
    public LicenseTypeFilter licenseTypeFilter;

    @FindBy(xpath = "//th[div[.='License Status']]")
    public StatusFilter licenseStatusFilter;

    @FindBy(className = "ant-modal-content")
    public ViewDriverDialog viewDriverDialog;

    public MiddleMileDriversPage(WebDriver webDriver)
    {
        super(webDriver);
    }

    public void clickLoadDriversButton()
    {
        getWebDriver().switchTo().frame(findElementByXpath(IFRAME_XPATH));

        waitUntilVisibilityOfElementLocated(LOAD_DRIVERS_BUTTON_XPATH);
        click(LOAD_DRIVERS_BUTTON_XPATH);

        if (isElementExist(DRIVERS_NOT_FOUND_TOAST_XPATH))
        {
            waitUntilInvisibilityOfElementLocated(DRIVERS_NOT_FOUND_TOAST_XPATH);
        } else
        {
            waitUntilVisibilityOfElementLocated(DRIVERS_LIST_CONTAINER_XPATH);
        }

        getWebDriver().switchTo().parentFrame();
    }

    public void verifiesTotalDriverIsTheSame(int totalDriver)
    {
        getWebDriver().switchTo().frame(findElementByXpath(IFRAME_XPATH));

        if (totalDriver > 0)
        {
            assertTrue("Total Driver Shown is the same.", getText(TOTAL_DRIVER_SHOW_XPATH).contains(String.valueOf(totalDriver)));
        }

        getWebDriver().switchTo().parentFrame();
    }

    public void selectHubFilter(String hubName)
    {
        getWebDriver().switchTo().frame(findElementByXpath(IFRAME_XPATH));

        waitUntilVisibilityOfElementLocated(LOAD_DRIVERS_BUTTON_XPATH);
        click(f(FILTER_DROPDOWN_XPATH, HUB_FILTER_ID));
        waitUntilVisibilityOfElementLocated(f(SELECT_FILTER_VALUE_XPATH, hubName));
        click(f(SELECT_FILTER_VALUE_XPATH, hubName));

        getWebDriver().switchTo().parentFrame();
    }

    public void selectFilter(String filterName, String value)
    {
        getWebDriver().switchTo().frame(findElementByXpath(IFRAME_XPATH));

        if ("Employment Status".equalsIgnoreCase(filterName))
        {
            click(f(FILTER_DROPDOWN_XPATH, EMPLOYMENT_STATUS_FILTER_ID));
        } else if ("License Status".equalsIgnoreCase(filterName))
        {
            click(f(FILTER_DROPDOWN_XPATH, LICENSE_STATUS_FILTER_ID));
        }

        waitUntilVisibilityOfElementLocated(f(SELECT_FILTER_VALUE_XPATH, value));
        click(f(SELECT_FILTER_VALUE_XPATH, value));

        getWebDriver().switchTo().parentFrame();
    }

    public void clickCreateDriversButton()
    {
        getWebDriver().switchTo().frame(findElementByXpath(IFRAME_XPATH));

        waitUntilVisibilityOfElementLocated(LOAD_DRIVERS_BUTTON_XPATH);
        click(CREATE_DRIVER_BUTTON_XPATH);
        waitUntilVisibilityOfElementLocated(MODAL_XPATH);

        getWebDriver().switchTo().parentFrame();
    }

    public void fillName(String name)
    {
        getWebDriver().switchTo().frame(findElementByXpath(IFRAME_XPATH));
        sendKeys(f(INPUT_CREATE_DRIVER_MODAL_XPATH, NAME_INPUT_CREATE_DRIVER_ID), name);
        getWebDriver().switchTo().parentFrame();
    }

    public void chooseHub(String hubName)
    {
        getWebDriver().switchTo().frame(findElementByXpath(IFRAME_XPATH));
        click(f(DROPDOWN_CREATE_DRIVER_MODAL_XPATH, HUB_INPUT_CREATE_DRIVER_ID));
        waitUntilVisibilityOfElementLocated(f(SELECT_FILTER_VALUE_XPATH, hubName));
        click(f(SELECT_FILTER_VALUE_XPATH, hubName));
        getWebDriver().switchTo().parentFrame();
    }

    public void fillcontactNumber(String contactNumber)
    {
        getWebDriver().switchTo().frame(findElementByXpath(IFRAME_XPATH));
        sendKeys(f(INPUT_CREATE_DRIVER_MODAL_XPATH, CONTACT_NUMBER_INPUT_CREATE_DRIVER_ID), contactNumber);
        getWebDriver().switchTo().parentFrame();
    }

    public void fillLicenseNumber(String licenseNumber)
    {
        getWebDriver().switchTo().frame(findElementByXpath(IFRAME_XPATH));
        sendKeys(f(INPUT_CREATE_DRIVER_MODAL_XPATH, LICENSE_NUMBER_INPUT_CREATE_DRIVER_ID), licenseNumber);
        getWebDriver().switchTo().parentFrame();
    }

    public void fillLicenseExpiryDate(String licenseExpiryDate)
    {
        getWebDriver().switchTo().frame(findElementByXpath(IFRAME_XPATH));
        click(f(CALENDAR_CREATE_DRIVER_MODAL_XPATH, EXPIRY_DATE_INPUT_CREATE_DRIVER_ID));
        waitUntilVisibilityOfElementLocated(RECENT_MONTH_XPATH);
        while (!(isElementExistFast(f(CALENDAR_DATE_XPATH, licenseExpiryDate))))
        {
            click(NEXT_MONTH_XPATH);
        }
        click(f(CALENDAR_DATE_XPATH, licenseExpiryDate));
        getWebDriver().switchTo().parentFrame();
    }

    public void chooseLicenseType(String licenseType)
    {
        getWebDriver().switchTo().frame(findElementByXpath(IFRAME_XPATH));
        click(f(LICENSE_TYPE_INPUT_CREATE_DRIVER_XPATH, licenseType));
        getWebDriver().switchTo().parentFrame();
    }

    public void chooseEmploymentType(String employmentType)
    {
        getWebDriver().switchTo().frame(findElementByXpath(IFRAME_XPATH));
        click(f(DROPDOWN_CREATE_DRIVER_MODAL_XPATH, EMPLOYMENT_TYPE_INPUT_CREATE_DRIVER_ID));
        waitUntilVisibilityOfElementLocated(f(SELECT_FILTER_VALUE_XPATH, employmentType));
        click(f(SELECT_FILTER_VALUE_XPATH, employmentType));
        getWebDriver().switchTo().parentFrame();
    }

    public void fillEmploymentStartDate(String employmentStartDate)
    {
        getWebDriver().switchTo().frame(findElementByXpath(IFRAME_XPATH));
        click(f(CALENDAR_CREATE_DRIVER_MODAL_XPATH, EMPLOYMENT_START_DATE_INPUT_CREATE_DRIVER_ID));
        waitUntilVisibilityOfElementLocated(RECENT_MONTH_XPATH);
        click(f(CALENDAR_DATE_XPATH, employmentStartDate));
        getWebDriver().switchTo().parentFrame();
    }

    public void fillEmploymentEndDate(String employmentEndDate)
    {
        getWebDriver().switchTo().frame(findElementByXpath(IFRAME_XPATH));
        click(f(CALENDAR_CREATE_DRIVER_MODAL_XPATH, EMPLOYMENT_END_DATE_INPUT_CREATE_DRIVER_ID));
        waitUntilVisibilityOfElementLocated(RECENT_MONTH_XPATH);
        while (!(isElementExistFast(f(CALENDAR_DATE_XPATH, employmentEndDate))))
        {
            click(NEXT_MONTH_XPATH);
        }
        click(f(CALENDAR_DATE_XPATH, employmentEndDate));
        getWebDriver().switchTo().parentFrame();
    }

    public void fillUsername(String username)
    {
        getWebDriver().switchTo().frame(findElementByXpath(IFRAME_XPATH));
        sendKeys(f(INPUT_CREATE_DRIVER_MODAL_XPATH, USERNAME_INPUT_CREATE_DRIVER_ID), username);
        getWebDriver().switchTo().parentFrame();
    }

    public void fillPassword(String password)
    {
        getWebDriver().switchTo().frame(findElementByXpath(IFRAME_XPATH));
        sendKeys(f(INPUT_CREATE_DRIVER_MODAL_XPATH, PASSWORD_INPUT_CREATE_DRIVER_ID), password);
        getWebDriver().switchTo().parentFrame();
    }

    public void fillComments(String comments)
    {
        getWebDriver().switchTo().frame(findElementByXpath(IFRAME_XPATH));
        sendKeys(COMMENTS_INPUT_CREATE_DRIVER_XPATH, comments);
        getWebDriver().switchTo().parentFrame();
    }

    public void clickSaveButton()
    {
        getWebDriver().switchTo().frame(findElementByXpath(IFRAME_XPATH));
        click(SAVE_BUTTON_XPATH);
        getWebDriver().switchTo().parentFrame();
    }

    public void driverHasBeenCreatedToast(String username)
    {
        getWebDriver().switchTo().frame(findElementByXpath(IFRAME_XPATH));
        waitUntilVisibilityOfElementLocated(f(TOAST_DRIVER_CREATED_XPATH, username));
        waitUntilInvisibilityOfElementLocated(f(TOAST_DRIVER_CREATED_XPATH, username));
        getWebDriver().switchTo().parentFrame();
    }

    public void tableFilter(MiddleMileDriver middleMileDriver, String filterBy)
    {
        getWebDriver().switchTo().frame(findElementByXpath(IFRAME_XPATH));
        String actualName = null;
        String actualUsername = null;
        String actualHub = null;
        String actualEmploymentType = null;
        String actualLicenseType = null;
        String actualComments = null;

        switch (filterBy.toLowerCase())
        {
            case NAME_TABLE_FILTER_ID:
                nameFilter.setValue(middleMileDriver.getName());
                waitUntilVisibilityOfElementLocated(f(TABLE_ASSERTION_XPATH, NAME_TABLE_FILTER_ID, MARK_ELEMENT));
                actualName = getText(f(TABLE_ASSERTION_XPATH, NAME_TABLE_FILTER_ID, MARK_ELEMENT));
                actualUsername = getText(f(TABLE_ASSERTION_XPATH, USERNAME_TABLE_FILTER_ID, SPAN_ELEMENT));
                actualHub = getText(f(TABLE_ASSERTION_XPATH, HUB_TABLE_FILTER_ID, SPAN_ELEMENT));
                actualEmploymentType = getText(f(TABLE_ASSERTION_SELECTION_XPATH, EMPLOYMENT_TYPE_TABLE_FILTER_ID));
                actualLicenseType = getText(f(TABLE_ASSERTION_SELECTION_XPATH, LICENSE_TYPE_TABLE_FILTER_ID));
                actualComments = getText(f(TABLE_ASSERTION_XPATH, COMMENTS_TABLE_FILTER_ID, SPAN_ELEMENT));
                break;

            case USERNAME_TABLE_FILTER_ID:
                usernameFilter.setValue(middleMileDriver.getUsername());
                waitUntilVisibilityOfElementLocated(f(TABLE_ASSERTION_XPATH, USERNAME_TABLE_FILTER_ID, MARK_ELEMENT));
                actualName = getText(f(TABLE_ASSERTION_XPATH, NAME_TABLE_FILTER_ID, SPAN_ELEMENT));
                actualUsername = getText(f(TABLE_ASSERTION_XPATH, USERNAME_TABLE_FILTER_ID, MARK_ELEMENT));
                actualHub = getText(f(TABLE_ASSERTION_XPATH, HUB_TABLE_FILTER_ID, SPAN_ELEMENT));
                actualEmploymentType = getText(f(TABLE_ASSERTION_SELECTION_XPATH, EMPLOYMENT_TYPE_TABLE_FILTER_ID));
                actualLicenseType = getText(f(TABLE_ASSERTION_SELECTION_XPATH, LICENSE_TYPE_TABLE_FILTER_ID));
                actualComments = getText(f(TABLE_ASSERTION_XPATH, COMMENTS_TABLE_FILTER_ID, SPAN_ELEMENT));
                break;

            case HUB_TABLE_FILTER_ID:
                nameFilter.setValue(middleMileDriver.getName());
                hubFilter.setValue(middleMileDriver.getHub());
                waitUntilVisibilityOfElementLocated(f(TABLE_ASSERTION_XPATH, HUB_TABLE_FILTER_ID, MARK_ELEMENT));
                actualName = getText(f(TABLE_ASSERTION_XPATH, NAME_TABLE_FILTER_ID, MARK_ELEMENT));
                actualUsername = getText(f(TABLE_ASSERTION_XPATH, USERNAME_TABLE_FILTER_ID, SPAN_ELEMENT));
                actualHub = getText(f(TABLE_ASSERTION_XPATH, HUB_TABLE_FILTER_ID, MARK_ELEMENT));
                actualEmploymentType = getText(f(TABLE_ASSERTION_SELECTION_XPATH, EMPLOYMENT_TYPE_TABLE_FILTER_ID));
                actualLicenseType = getText(f(TABLE_ASSERTION_SELECTION_XPATH, LICENSE_TYPE_TABLE_FILTER_ID));
                actualComments = getText(f(TABLE_ASSERTION_XPATH, COMMENTS_TABLE_FILTER_ID, SPAN_ELEMENT));
                break;

            case COMMENTS_TABLE_FILTER_ID:
                commentsFilter.setValue(middleMileDriver.getComments());
                waitUntilVisibilityOfElementLocated(f(TABLE_ASSERTION_XPATH, COMMENTS_TABLE_FILTER_ID, MARK_ELEMENT));
                actualName = getText(f(TABLE_ASSERTION_XPATH, NAME_TABLE_FILTER_ID, SPAN_ELEMENT));
                actualUsername = getText(f(TABLE_ASSERTION_XPATH, USERNAME_TABLE_FILTER_ID, SPAN_ELEMENT));
                actualHub = getText(f(TABLE_ASSERTION_XPATH, HUB_TABLE_FILTER_ID, SPAN_ELEMENT));
                actualEmploymentType = getText(f(TABLE_ASSERTION_SELECTION_XPATH, EMPLOYMENT_TYPE_TABLE_FILTER_ID));
                actualLicenseType = getText(f(TABLE_ASSERTION_SELECTION_XPATH, LICENSE_TYPE_TABLE_FILTER_ID));
                actualComments = getText(f(TABLE_ASSERTION_XPATH, COMMENTS_TABLE_FILTER_ID, MARK_ELEMENT));
                break;

            default:
                NvLogger.warn("Filter is not found");
        }

        assertEquals("Name is not the same : ", middleMileDriver.getName(), actualName);
        assertEquals("Username is not the same : ", middleMileDriver.getUsername(), actualUsername);
        assertEquals("Hub is not the same : ", middleMileDriver.getHub(), actualHub);
        assertEquals("Employment Type is not the same : ", middleMileDriver.getEmploymentType(), actualEmploymentType);
        assertEquals("License Type is not the same : ", middleMileDriver.getLicenseType(), actualLicenseType);
        assertEquals("Comment is not the same : ", middleMileDriver.getComments(), actualComments);
        getWebDriver().switchTo().parentFrame();
    }

    public void tableFilterById(MiddleMileDriver middleMileDriver, Long driverId)
    {
        getWebDriver().switchTo().frame(findElementByXpath(IFRAME_XPATH));
        idFilter.setValue(driverId);
        waitUntilVisibilityOfElementLocated(f(TABLE_ASSERTION_XPATH, ID_TABLE_FILTER_ID, MARK_ELEMENT));

        String actualName = getText(f(TABLE_ASSERTION_XPATH, NAME_TABLE_FILTER_ID, SPAN_ELEMENT));
        String actualId = getText(f(TABLE_ASSERTION_XPATH, ID_TABLE_FILTER_ID, MARK_ELEMENT));
        String actualUsername = getText(f(TABLE_ASSERTION_XPATH, USERNAME_TABLE_FILTER_ID, SPAN_ELEMENT));
        String actualHub = getText(f(TABLE_ASSERTION_XPATH, HUB_TABLE_FILTER_ID, SPAN_ELEMENT));
        String actualEmploymentType = getText(f(TABLE_ASSERTION_SELECTION_XPATH, EMPLOYMENT_TYPE_TABLE_FILTER_ID));
        String actualLicenseType = getText(f(TABLE_ASSERTION_SELECTION_XPATH, LICENSE_TYPE_TABLE_FILTER_ID));
        String actualComments = getText(f(TABLE_ASSERTION_XPATH, COMMENTS_TABLE_FILTER_ID, SPAN_ELEMENT));

        assertEquals("Name is not the same : ", middleMileDriver.getName(), actualName);
        assertEquals("ID is not the same : ", driverId.toString(), actualId);
        assertEquals("Username is not the same : ", middleMileDriver.getUsername(), actualUsername);
        assertEquals("Hub is not the same : ", middleMileDriver.getHub(), actualHub);
        assertEquals("Employment Type is not the same : ", middleMileDriver.getEmploymentType(), actualEmploymentType);
        assertEquals("License Type is not the same : ", middleMileDriver.getLicenseType(), actualLicenseType);
        assertEquals("Comment is not the same : ", middleMileDriver.getComments(), actualComments);
        getWebDriver().switchTo().parentFrame();
    }

    public void tableFilterCombobox(MiddleMileDriver middleMileDriver, String filterBy)
    {
        try
        {
            String actualName = null;
            String actualUsername = null;
            String actualHub = null;
            String actualEmploymentType = null;
            String actualLicenseType = null;
            String actualComments = null;

            getWebDriver().switchTo().frame(findElementByXpath(IFRAME_XPATH));
            ((JavascriptExecutor) webDriver).executeScript("document.body.style.zoom='70%'");
            pause3s();
            nameFilter.setValue(middleMileDriver.getName());
            waitUntilVisibilityOfElementLocated(f(TABLE_ASSERTION_XPATH, NAME_TABLE_FILTER_ID, MARK_ELEMENT));

            switch (filterBy.toLowerCase())
            {
                case EMPLOYMENT_TYPE:
                    employmentTypeFilter.openButton.click();
                    employmentTypeFilter.selectType(middleMileDriver.getEmploymentType());
                    employmentTypeFilter.ok.click();

                    actualName = getText(f(TABLE_ASSERTION_XPATH, NAME_TABLE_FILTER_ID, MARK_ELEMENT));
                    actualUsername = getText(f(TABLE_ASSERTION_XPATH, USERNAME_TABLE_FILTER_ID, SPAN_ELEMENT));
                    actualHub = getText(f(TABLE_ASSERTION_XPATH, HUB_TABLE_FILTER_ID, SPAN_ELEMENT));
                    actualEmploymentType = getText(f(TABLE_ASSERTION_SELECTION_XPATH, EMPLOYMENT_TYPE_TABLE_FILTER_ID));
                    actualLicenseType = getText(f(TABLE_ASSERTION_SELECTION_XPATH, LICENSE_TYPE_TABLE_FILTER_ID));
                    actualComments = getText(f(TABLE_ASSERTION_XPATH, COMMENTS_TABLE_FILTER_ID, SPAN_ELEMENT));
                    break;

                case EMPLOYMENT_STATUS:
                    employmentStatusFilter.openButton.click();
                    employmentStatusFilter.active.check();
                    employmentStatusFilter.ok.click();

                    actualName = getText(f(TABLE_ASSERTION_XPATH, NAME_TABLE_FILTER_ID, MARK_ELEMENT));
                    actualUsername = getText(f(TABLE_ASSERTION_XPATH, USERNAME_TABLE_FILTER_ID, SPAN_ELEMENT));
                    actualHub = getText(f(TABLE_ASSERTION_XPATH, HUB_TABLE_FILTER_ID, SPAN_ELEMENT));
                    actualEmploymentType = getText(f(TABLE_ASSERTION_SELECTION_XPATH, EMPLOYMENT_TYPE_TABLE_FILTER_ID));
                    actualLicenseType = getText(f(TABLE_ASSERTION_SELECTION_XPATH, LICENSE_TYPE_TABLE_FILTER_ID));
                    actualComments = getText(f(TABLE_ASSERTION_XPATH, COMMENTS_TABLE_FILTER_ID, SPAN_ELEMENT));
                    break;

                case LICENSE_TYPE:
                    licenseTypeFilter.openButton.click();
                    licenseTypeFilter.selectType(middleMileDriver.getLicenseType());
                    licenseTypeFilter.ok.click();

                    actualName = getText(f(TABLE_ASSERTION_XPATH, NAME_TABLE_FILTER_ID, MARK_ELEMENT));
                    actualUsername = getText(f(TABLE_ASSERTION_XPATH, USERNAME_TABLE_FILTER_ID, SPAN_ELEMENT));
                    actualHub = getText(f(TABLE_ASSERTION_XPATH, HUB_TABLE_FILTER_ID, SPAN_ELEMENT));
                    actualEmploymentType = getText(f(TABLE_ASSERTION_SELECTION_XPATH, EMPLOYMENT_TYPE_TABLE_FILTER_ID));
                    actualLicenseType = getText(f(TABLE_ASSERTION_SELECTION_XPATH, LICENSE_TYPE_TABLE_FILTER_ID));
                    actualComments = getText(f(TABLE_ASSERTION_XPATH, COMMENTS_TABLE_FILTER_ID, SPAN_ELEMENT));
                    break;

                case LICENSE_STATUS:
                    licenseStatusFilter.openButton.click();
                    licenseStatusFilter.active.check();
                    licenseStatusFilter.ok.click();

                    actualName = getText(f(TABLE_ASSERTION_XPATH, NAME_TABLE_FILTER_ID, MARK_ELEMENT));
                    actualUsername = getText(f(TABLE_ASSERTION_XPATH, USERNAME_TABLE_FILTER_ID, SPAN_ELEMENT));
                    actualHub = getText(f(TABLE_ASSERTION_XPATH, HUB_TABLE_FILTER_ID, SPAN_ELEMENT));
                    actualEmploymentType = getText(f(TABLE_ASSERTION_SELECTION_XPATH, EMPLOYMENT_TYPE_TABLE_FILTER_ID));
                    actualLicenseType = getText(f(TABLE_ASSERTION_SELECTION_XPATH, LICENSE_TYPE_TABLE_FILTER_ID));
                    actualComments = getText(f(TABLE_ASSERTION_XPATH, COMMENTS_TABLE_FILTER_ID, SPAN_ELEMENT));
                    break;
            }

            assertEquals("Name is not the same : ", middleMileDriver.getName(), actualName);
            assertEquals("Username is not the same : ", middleMileDriver.getUsername(), actualUsername);
            assertEquals("Hub is not the same : ", middleMileDriver.getHub(), actualHub);
            assertEquals("Employment Type is not the same : ", middleMileDriver.getEmploymentType(), actualEmploymentType);
            assertEquals("License Type is not the same : ", middleMileDriver.getLicenseType(), actualLicenseType);
            assertEquals("Comment is not the same : ", middleMileDriver.getComments(), actualComments);
        } finally
        {
            ((JavascriptExecutor) webDriver).executeScript("document.body.style.zoom='100%'");
            getWebDriver().switchTo().parentFrame();
        }
    }

    public void verifiesDataIsNotExisted(String driverName)
    {
        getWebDriver().switchTo().frame(findElementByXpath(IFRAME_XPATH));
        nameFilter.setValue(driverName);
        waitUntilVisibilityOfElementLocated(NO_RESULT_TABLE_XPATH);
        getWebDriver().switchTo().parentFrame();
    }

    public void clickViewButton()
    {
        try
        {
            getWebDriver().switchTo().frame(findElementByXpath(IFRAME_XPATH));
            click(VIEW_BUTTON_XPATH);
            viewDriverDialog.waitUntilVisible();
            antDotSpinner.waitUntilInvisible();
        } finally
        {
            getWebDriver().switchTo().parentFrame();
        }
    }

    public void verifiesDataInViewModalIsTheSame(MiddleMileDriver middleMileDriver)
    {
        try
        {
            getWebDriver().switchTo().frame(findElementByXpath(IFRAME_XPATH));

            assertEquals("Name is not the same : ", middleMileDriver.getName(), viewDriverDialog.name.getValue());
            assertEquals("Hub is not the same : ", middleMileDriver.getHub(), viewDriverDialog.hub.getValue());
            assertEquals("Contact number is not the same : ", middleMileDriver.getContactNumber(), viewDriverDialog.contactNumber.getValue());
            assertEquals("License Number is not the same : ", middleMileDriver.getLicenseNumber(), viewDriverDialog.licenseNumber.getValue());
            assertEquals("Expiry Date is not the same : ", middleMileDriver.getExpiryDate(), viewDriverDialog.licenseExpiryDate.getValue());
            assertEquals("Username is not the same : ", middleMileDriver.getUsername(), viewDriverDialog.username.getValue());
            assertEquals("Comments is not the same : ", middleMileDriver.getComments(), viewDriverDialog.comments.getValue());
        } finally
        {
            getWebDriver().switchTo().parentFrame();
        }
    }

    public void clickAvailabilityMode(String mode)
    {
        getWebDriver().switchTo().frame(findElementByXpath(IFRAME_XPATH));
        if (NO.equalsIgnoreCase(mode))
        {
            click(NO_COMING_BUTTON_XPATH);
            waitUntilVisibilityOfElementLocated(YES_COMING_BUTTON_XPATH);
        } else if (YES.equalsIgnoreCase(mode))
        {
            click(YES_COMING_BUTTON_XPATH);
            waitUntilVisibilityOfElementLocated(NO_COMING_BUTTON_XPATH);
        }
        getWebDriver().switchTo().parentFrame();
    }

    public void clickBulkAvailabilityMode(String mode)
    {
        getWebDriver().switchTo().frame(findElementByXpath(IFRAME_XPATH));
        click(DROP_DOWN_ON_TABLE_XPATH);
        waitUntilVisibilityOfElementLocated(SELECT_ALL_DROP_DOWN_SELECTION_XPATH);
        click(SELECT_ALL_DROP_DOWN_SELECTION_XPATH);
        waitUntilVisibilityOfElementLocated(APPLY_ACTION_DROP_DOWN_XPATH);
        click(APPLY_ACTION_DROP_DOWN_XPATH);

        if (YES.equalsIgnoreCase(mode))
        {
            click(SET_TO_COMING_DROP_DOWN_XPATH);
            waitUntilVisibilityOfElementLocated(YES_COMING_BUTTON_XPATH);
        } else if (NO.equalsIgnoreCase(mode))
        {
            click(SET_TO_NOT_COMING_DROP_DOWN_XPATH);
            waitUntilVisibilityOfElementLocated(NO_COMING_BUTTON_XPATH);
        }
        getWebDriver().switchTo().parentFrame();
    }

    public void verifiesDriverAvailability(boolean driverAvailability)
    {
        getWebDriver().switchTo().frame(findElementByXpath(IFRAME_XPATH));
        if (isElementExistFast(YES_COMING_BUTTON_XPATH))
        {
            assertTrue("Driver Availability is True : ", driverAvailability);
        } else if (isElementExistFast(NO_COMING_BUTTON_XPATH))
        {
            assertFalse("Driver Availability is false : ", driverAvailability);
        }
        getWebDriver().switchTo().parentFrame();
    }

    public void refreshAndWaitUntilLoadingDone()
    {
        try
        {
            getWebDriver().switchTo().frame(findElementByXpath(IFRAME_XPATH));
            getWebDriver().navigate().refresh();
            if (antDotSpinner.isDisplayedFast())
            {
                antDotSpinner.waitUntilInvisible();
            }
        } finally
        {
            getWebDriver().switchTo().parentFrame();
        }
    }

    public static class TableFilterPopup extends PageElement
    {
        public TableFilterPopup(WebDriver webDriver, WebElement webElement)
        {
            super(webDriver, webElement);
        }

        @FindBy(xpath = ".//button")
        public Button openButton;

        @FindBy(xpath = ".//button[.='OK']")
        public Button ok;

        @FindBy(xpath = ".//button[.='Reset']")
        public Button reset;
    }

    public static class StatusFilter extends TableFilterPopup
    {
        public StatusFilter(WebDriver webDriver, WebElement webElement)
        {
            super(webDriver, webElement);
        }

        @FindBy(xpath = ".//li[.='Active']//input")
        public CheckBox active;

        @FindBy(xpath = ".//li[.='Inactive']//input")
        public CheckBox inactive;
    }

    public static class EmploymentTypeFilter extends TableFilterPopup
    {
        public EmploymentTypeFilter(WebDriver webDriver, WebElement webElement)
        {
            super(webDriver, webElement);
        }

        @FindBy(xpath = ".//li[.='Full-time / Contract']//input")
        public CheckBox contract;

        @FindBy(xpath = ".//li[.='Part-time / Freelance']//input")
        public CheckBox freelance;

        @FindBy(xpath = ".//li[.='Vendor']//input")
        public CheckBox vendor;

        public void selectType(String type)
        {
            switch (type.toLowerCase())
            {
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

    public static class LicenseTypeFilter extends TableFilterPopup
    {
        private static final String TYPE_CHECKBOX_LOCATOR = ".//li[.='%s']//input";

        public LicenseTypeFilter(WebDriver webDriver, WebElement webElement)
        {
            super(webDriver, webElement);
        }

        public void selectType(String type)
        {
            new CheckBox(webDriver, findElementByXpath(f(TYPE_CHECKBOX_LOCATOR, type))).check();
        }
    }

    public static class ViewDriverDialog extends AntModal
    {
        public ViewDriverDialog(WebDriver webDriver, WebElement webElement)
        {
            super(webDriver, webElement);
        }

        @FindBy(id = "name")
        public TextBox name;

        @FindBy(id = "hubId")
        public AntSelect hub;

        @FindBy(id = "contactNumber")
        public TextBox contactNumber;

        @FindBy(id = "licenseNumber")
        public TextBox licenseNumber;

        @FindBy(xpath = "//span[@id='licenseExpiryDate']//input")
        public PageElement licenseExpiryDate;

        @FindBy(id = "username")
        public TextBox username;

        @FindBy(id = "comments")
        public TextBox comments;
    }
}
