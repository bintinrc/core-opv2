package co.nvqa.operator_v2.selenium.page;

import co.nvqa.operator_v2.model.HubAppUser;
import org.apache.poi.ss.formula.functions.T;
import org.openqa.selenium.Keys;
import org.openqa.selenium.WebDriver;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Locale;

/**
 * @author Tristania Siagian
 */
public class HubAppUserManagementPage extends OperatorV2SimplePage
{
    private static final String ADD_HUB_USER_BUTTON_XPATH = "//button[@id='btnAddUser']";
    private static final String ADD_HUB_USER_DIALOG_XPATH = "//div[contains(@id,'rcDialogTitle')]";
    private static final String EMPLOYMENT_TYPE_COMBOBOX_XPATH = "//div[contains(@class,'ant-card-bordered')]//div[@id='employment_type']";
    private static final String FULL_TIME_EMPLOYMENT_TYPE_XPATH = "//li[text()='FULL_TIME']";
    private static final String PART_TIME_EMPLOYMENT_TYPE_XPATH = "//li[text()='PART_TIME']";
    private static final String HUB_SELECTION_XPATH = "//li[text()='%s']";
    private static final String EMPLOYMENT_START_DATE_XPATH = "//div[contains(@class,'ant-card-bordered')]//span[@id='employment_start_date']";
    private static final String TEXT_AREA_START_DATE_XPATH = "//div[contains(@class,'calendar-picker-container-placement-bottomLeft')]//input[@placeholder='Select date']";
    private static final String HUB_COMBOBOX_XPATH = "//div[contains(@class,'ant-card-bordered')]//div[@id='hub_id']";
    private static final String CREATE_BUTTON_ADD_HUB_DIALOG_XPATH = "//button[@id='btnUpsertUser']";
    private static final String CLOSE_BUTTON_MODAL_XPATH = "//button[@aria-label='Close']";

    private static final String CLEAR_FILTERS_BUTTON_XPATH = "//button[span[text()='Clear Filters']]";
    private static final String IFRAME_XPATH = "//iframe[contains(@src,'hub-user-management')]";
    private static final String LOAD_ALL_HUB_APP_USER_BUTTON_XPATH = "//button[span[text()='Load Hub Users']]";
    private static final String USERNAME_TABLE_FILTER_XPATH = "//th[contains(@class,'username')]//input";
    private static final String TABLE_RESULT_XPATH = "//td[contains(@class,'%s')]/span/%s";
    private static final String LOAD_ICON_XPATH = "//div[contains(@class,'ant-spin-spinning')]";
    private static final String TOAST_HUB_APP_USER_CREATED_XPATH = "//div[contains(@class,'notification-notice-content')]//div[contains(text(),'Hub User has been created')]";
    private static final String ERROR_TOAST_DUPLICATION_USERNAME_XPATH = "//div[contains(@class,'toast-error')]//strong[text()='username %s already exists']";
    private static final String ERROR_TOAST_DUPLICATION_CLOSE_XPATH = "//i[text()='close']";
    private static final String ERROR_MESSAGE_EMPTY_FIELD_XPATH = "//div[@class='ant-form-explain']/span[text()='%s']";

    private static final String FIRST_NAME_ID = "first_name";
    private static final String LAST_NAME_ID = "last_name";
    private static final String CONTACT_DETAIL_ID = "contact_details";
    private static final String USERNAME_ID = "username";
    private static final String PASSWORD_ID = "password";
    private static final String WAREHOUSE_TEAM_FORMATION_ID = "team";
    private static final String POSITION_ID = "position";
    private static final String COMMENT_ID = "comment";

    private static final String USERNAME_CLASS = "username";
    private static final String HUB_CLASS = "hub_id";
    private static final String POSITION_CLASS = "position";
    private static final String EMPLOYMENT_TYPE_CLASS = "employment_type";
    private static final String FIRST_NAME_CLASS = "first_name";
    private static final String LAST_NAME_CLASS = "last_name";
    private static final String EMPLOYMENT_START_DATE_CLASS = "employment_start_date";

    public HubAppUserManagementPage(WebDriver webDriver)
    {
        super(webDriver);
    }

    public void clickAddHubUserButton()
    {
        getWebDriver().switchTo().frame(findElementByXpath(IFRAME_XPATH));
        waitUntilVisibilityOfElementLocated(LOAD_ALL_HUB_APP_USER_BUTTON_XPATH);
        click(ADD_HUB_USER_BUTTON_XPATH);
        waitUntilVisibilityOfElementLocated(ADD_HUB_USER_DIALOG_XPATH);
        getWebDriver().switchTo().parentFrame();
    }

    public void fillFirstName(String firstName)
    {
        getWebDriver().switchTo().frame(findElementByXpath(IFRAME_XPATH));
        sendKeysById(FIRST_NAME_ID, firstName);
        getWebDriver().switchTo().parentFrame();
    }

    public void fillLastName(String lastName)
    {
        getWebDriver().switchTo().frame(findElementByXpath(IFRAME_XPATH));
        sendKeysById(LAST_NAME_ID, lastName);
        getWebDriver().switchTo().parentFrame();
    }

    public void fillContact(String contact)
    {
        getWebDriver().switchTo().frame(findElementByXpath(IFRAME_XPATH));
        sendKeysById(CONTACT_DETAIL_ID,contact);
        getWebDriver().switchTo().parentFrame();
    }

    public void fillUsername(String username)
    {
        getWebDriver().switchTo().frame(findElementByXpath(IFRAME_XPATH));
        sendKeysById(USERNAME_ID, username);
        getWebDriver().switchTo().parentFrame();
    }

    public void fillPassword(String password)
    {
        getWebDriver().switchTo().frame(findElementByXpath(IFRAME_XPATH));
        sendKeysById(PASSWORD_ID, password);
        getWebDriver().switchTo().parentFrame();
    }

    public void selectEmploymentType(String employmentType)
    {
        getWebDriver().switchTo().frame(findElementByXpath(IFRAME_XPATH));
        click(EMPLOYMENT_TYPE_COMBOBOX_XPATH);
        if ("FULL_TIME".equalsIgnoreCase(employmentType))
        {
            waitUntilVisibilityOfElementLocated(FULL_TIME_EMPLOYMENT_TYPE_XPATH);
            click(FULL_TIME_EMPLOYMENT_TYPE_XPATH);
        } else if ("PART_TIME".equalsIgnoreCase(employmentType))
        {
            waitUntilVisibilityOfElementLocated(PART_TIME_EMPLOYMENT_TYPE_XPATH);
            click(PART_TIME_EMPLOYMENT_TYPE_XPATH);
        }
        getWebDriver().switchTo().parentFrame();
    }

    public void selectEmploymentStartDate(String startDate)
    {
        getWebDriver().switchTo().frame(findElementByXpath(IFRAME_XPATH));
        click(EMPLOYMENT_START_DATE_XPATH);
        waitUntilVisibilityOfElementLocated(TEXT_AREA_START_DATE_XPATH);

        sendKeys(TEXT_AREA_START_DATE_XPATH, startDate);
        sendKeys(TEXT_AREA_START_DATE_XPATH, Keys.ENTER);
        getWebDriver().switchTo().parentFrame();
    }

    public void selectHubForHubAppUser(String hubName)
    {
        getWebDriver().switchTo().frame(findElementByXpath(IFRAME_XPATH));
        click(HUB_COMBOBOX_XPATH);
        waitUntilVisibilityOfElementLocated(f(HUB_SELECTION_XPATH, hubName));
        click(f(HUB_SELECTION_XPATH, hubName));
        getWebDriver().switchTo().parentFrame();
    }

    public void fillWareHouseTeamFormation(String warehouseTeamFormation)
    {
        getWebDriver().switchTo().frame(findElementByXpath(IFRAME_XPATH));
        sendKeysById(WAREHOUSE_TEAM_FORMATION_ID, warehouseTeamFormation);
        getWebDriver().switchTo().parentFrame();
    }

    public void fillPosition(String position)
    {
        getWebDriver().switchTo().frame(findElementByXpath(IFRAME_XPATH));
        sendKeysById(POSITION_ID, position);
        getWebDriver().switchTo().parentFrame();
    }

    public void fillComments(String comments)
    {
        getWebDriver().switchTo().frame(findElementByXpath(IFRAME_XPATH));
        sendKeysById(COMMENT_ID, comments);
        getWebDriver().switchTo().parentFrame();
    }

    public void clickCreateHubUserButton(boolean isInvalid)
    {
        getWebDriver().switchTo().frame(findElementByXpath(IFRAME_XPATH));
        click(CREATE_BUTTON_ADD_HUB_DIALOG_XPATH);
        if (!isInvalid) {
            waitUntilVisibilityOfElementLocated(TOAST_HUB_APP_USER_CREATED_XPATH);
            waitUntilInvisibilityOfElementLocated(TOAST_HUB_APP_USER_CREATED_XPATH);
        }
        getWebDriver().switchTo().parentFrame();
    }

    public void clickAllHubAppUser()
    {
        getWebDriver().switchTo().frame(findElementByXpath(IFRAME_XPATH));
        click(LOAD_ALL_HUB_APP_USER_BUTTON_XPATH);
        if (isElementExist(LOAD_ICON_XPATH)) {
            waitUntilInvisibilityOfElementLocated(LOAD_ICON_XPATH);
        }
        getWebDriver().switchTo().parentFrame();
    }

    public void clickClearFilters()
    {
        getWebDriver().switchTo().frame(findElementByXpath(IFRAME_XPATH));
        click(CLEAR_FILTERS_BUTTON_XPATH);
        getWebDriver().switchTo().parentFrame();
    }

    public void verifiesDuplicationErrorToastShown(String existedUsername)
    {
        waitUntilVisibilityOfElementLocated(ERROR_TOAST_DUPLICATION_USERNAME_XPATH, existedUsername);
        click(ERROR_TOAST_DUPLICATION_CLOSE_XPATH);
    }

    public void emptyErrorMessage(String errorMessage)
    {
        getWebDriver().switchTo().frame(findElementByXpath(IFRAME_XPATH));
        waitUntilVisibilityOfElementLocated(f(ERROR_MESSAGE_EMPTY_FIELD_XPATH, errorMessage));
        click(CLOSE_BUTTON_MODAL_XPATH);
        getWebDriver().switchTo().parentFrame();
    }

    public void checkTheHubAppUserIsCreated(String username, HubAppUser hubAppUser)
    {
        getWebDriver().switchTo().frame(findElementByXpath(IFRAME_XPATH));
        sendKeys(USERNAME_TABLE_FILTER_XPATH, username);

        String actualUsernameShown = getText(f(TABLE_RESULT_XPATH, USERNAME_CLASS, "mark"));
        assertEquals("Username is different : ", username, actualUsernameShown);

        String actualHubShown = getText(f(TABLE_RESULT_XPATH, HUB_CLASS, "span"));
        assertEquals("Hub is different : ", hubAppUser.getHub(), actualHubShown);

        String actualPositionShown = getText(f(TABLE_RESULT_XPATH, POSITION_CLASS, "span"));
        assertEquals("Position is different : ", hubAppUser.getPosition(), actualPositionShown);

        String actualEmploymentTypeShown = getText(f(TABLE_RESULT_XPATH, EMPLOYMENT_TYPE_CLASS, "span"));
        assertEquals("Employment Type is different : ", hubAppUser.getEmploymentType(), actualEmploymentTypeShown);

        String actualFirstNameShown = getText(f(TABLE_RESULT_XPATH, FIRST_NAME_CLASS, "span"));
        assertEquals("First Name is different : ", hubAppUser.getFirstName(), actualFirstNameShown);

        String actualLastNameShown = getText(f(TABLE_RESULT_XPATH, LAST_NAME_CLASS, "span"));
        assertEquals("Last Name is different : ", hubAppUser.getLastName(), actualLastNameShown);

        String actualEmploymentStartDateShown = getText(f(TABLE_RESULT_XPATH, EMPLOYMENT_START_DATE_CLASS, "span"));
        assertEquals("Employment Start Date is different : ", hubAppUser.getEmploymentStartDate(), actualEmploymentStartDateShown);

        getWebDriver().switchTo().parentFrame();
    }
}
