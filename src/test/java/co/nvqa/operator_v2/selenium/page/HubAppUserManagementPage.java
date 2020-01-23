package co.nvqa.operator_v2.selenium.page;

import co.nvqa.operator_v2.model.HubAppUser;
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
    private static final String LOAD_ALL_HUB_APP_USER_BUTTON_XPATH = "//button[span[text()='Load Hub Users']]";
    private static final String USERNAME_TABLE_FILTER_XPATH = "//th[contains(@class,'username')]//input";
    private static final String TABLE_RESULT_XPATH = "//td[contains(@class,'%s')]/span/span";
    private static final String LOAD_ICON_XPATH = "//div[contains(@class,'ant-spin-spinning')]";
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
        waitUntilVisibilityOfElementLocated(LOAD_ALL_HUB_APP_USER_BUTTON_XPATH);
        click(ADD_HUB_USER_BUTTON_XPATH);
        waitUntilVisibilityOfElementLocated(ADD_HUB_USER_DIALOG_XPATH);
    }

    public void fillFirstName(String firstName)
    {
        sendKeysById(FIRST_NAME_ID, firstName);
    }

    public void fillLastName(String lastName)
    {
        sendKeysById(LAST_NAME_ID, lastName);
    }

    public void fillContact(String contact)
    {
        sendKeysById(CONTACT_DETAIL_ID,contact);
    }

    public void fillUsername(String username)
    {
        sendKeysById(USERNAME_ID, username);
    }

    public void fillPassword(String password)
    {
        sendKeysById(PASSWORD_ID, password);
    }

    public void selectEmploymentType(String employmentType)
    {
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
    }

    public void selectEmploymentStartDate(String startDate)
    {
        click(EMPLOYMENT_START_DATE_XPATH);
        waitUntilVisibilityOfElementLocated(TEXT_AREA_START_DATE_XPATH);

        if ("TODAY".equalsIgnoreCase(startDate))
        {
            LocalDateTime today = LocalDateTime.now();
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd", Locale.ENGLISH);
            startDate = formatter.format(today);
        }

        sendKeys(TEXT_AREA_START_DATE_XPATH, startDate);
        sendKeys(TEXT_AREA_START_DATE_XPATH, Keys.ENTER);
    }

    public void selectHubForHubAppUser(String hubName)
    {
        click(HUB_COMBOBOX_XPATH);
        waitUntilVisibilityOfElementLocated(f(HUB_SELECTION_XPATH, hubName));
        click(f(HUB_SELECTION_XPATH, hubName));
    }

    public void fillWareHouseTeamFormation(String warehouseTeamFormation)
    {
        sendKeysById(WAREHOUSE_TEAM_FORMATION_ID, warehouseTeamFormation);
    }

    public void fillPosition(String position)
    {
        sendKeysById(POSITION_ID, position);
    }

    public void fillComments(String comments)
    {
        sendKeysById(COMMENT_ID, comments);
    }

    public void clickCreateHubUserButton()
    {
        click(CREATE_BUTTON_ADD_HUB_DIALOG_XPATH);
        waitUntilVisibilityOfToast("Hub User created");
        waitUntilInvisibilityOfToast();
    }

    public void clickAllHubAppUser()
    {
        click(LOAD_ALL_HUB_APP_USER_BUTTON_XPATH);
        if (isElementExist(LOAD_ICON_XPATH)) {
            waitUntilInvisibilityOfElementLocated(LOAD_ICON_XPATH);
        }
    }

    public void clickClearFilters()
    {
        click(CLEAR_FILTERS_BUTTON_XPATH);
    }

    public void verifiesDuplicationErrorToastShown()
    {
        waitUntilVisibilityOfElementLocated(ERROR_TOAST_DUPLICATION_USERNAME_XPATH);
        click(ERROR_TOAST_DUPLICATION_CLOSE_XPATH);
    }

    public void emptyErrorMessage(String errorMessage)
    {
        waitUntilVisibilityOfElementLocated(f(ERROR_MESSAGE_EMPTY_FIELD_XPATH, errorMessage));
        click(CLOSE_BUTTON_MODAL_XPATH);
    }

    public void checkTheHubAppUserIsCreated(HubAppUser hubAppUser)
    {
        sendKeys(USERNAME_TABLE_FILTER_XPATH, hubAppUser.getUsername());

        String actualUsernameShown = getText(f(TABLE_RESULT_XPATH, USERNAME_CLASS));
        assertEquals("Username is different : ", hubAppUser.getUsername(), actualUsernameShown);

        String actualHubShown = getText(f(TABLE_RESULT_XPATH, HUB_CLASS));
        assertEquals("Hub is different : ", hubAppUser.getHub(), actualHubShown);

        String actualPositionShown = getText(f(TABLE_RESULT_XPATH, POSITION_CLASS));
        assertEquals("Position is different : ", hubAppUser.getPosition(), actualPositionShown);

        String actualEmploymentTypeShown = getText(f(TABLE_RESULT_XPATH, EMPLOYMENT_TYPE_CLASS));
        assertEquals("Employment Type is different : ", hubAppUser.getEmploymentType(), actualEmploymentTypeShown);

        String actualFirstNameShown = getText(f(TABLE_RESULT_XPATH, FIRST_NAME_CLASS));
        assertEquals("First Name is different : ", hubAppUser.getFirstName(), actualFirstNameShown);

        String actualLastNameShown = getText(f(TABLE_RESULT_XPATH, LAST_NAME_CLASS));
        assertEquals("Last Name is different : ", hubAppUser.getLastName(), actualLastNameShown);

        String actualEmploymentStartDateShown = getText(f(TABLE_RESULT_XPATH, EMPLOYMENT_START_DATE_CLASS));
        assertEquals("Employment Start Date is different : ", hubAppUser.getEmploymentStartDate(), actualEmploymentStartDateShown);
    }
}
