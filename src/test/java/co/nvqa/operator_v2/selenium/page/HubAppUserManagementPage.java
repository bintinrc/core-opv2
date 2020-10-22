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
    private static final String FILTER_XPATH = "//div[@id='%s']";
    private static final String EMPLOYMENT_START_DATE_FILTER_XPATH = "//span[@id='employmentStartDate']";
    private static final String START_DATE_INPUT_XPATH = "//div[contains(@class,'calendar-range-left')]//td[@title='%s']";
    private static final String ACTIVE_EMPLOYMENT_FILTER_XPATH = "//li[text()='ACTIVE']";
    private static final String INACTIVE_EMPLOYMENT_FILTER_XPATH = "//li[text()='INACTIVE']";
    private static final String UNSELECTABLE_FILTER = "//div[@id='%s']//span[@unselectable='on']";

    private static final String ADD_EDIT_HUB_USER_DIALOG_XPATH = "//div[contains(@id,'rcDialogTitle')]";
    private static final String EMPLOYMENT_TYPE_COMBOBOX_XPATH = "//div[contains(@class,'ant-card-bordered')]//div[@id='employmentType']";
    private static final String FULL_TIME_EMPLOYMENT_TYPE_XPATH = "//li[text()='FULL_TIME']";
    private static final String PART_TIME_EMPLOYMENT_TYPE_XPATH = "//li[text()='PART_TIME']";
    private static final String HUB_SELECTION_XPATH = "//li[text()='%s']";
    private static final String EMPLOYMENT_START_DATE_XPATH = "//div[contains(@class,'ant-card-bordered')]//span[@id='employmentStartDate']";
    private static final String RECENT_MONTH_XPATH = "//a[contains(@class,'month-select')]";
    private static final String HUB_COMBOBOX_XPATH = "//div[contains(@class,'ant-card-bordered')]//div[@id='hubId']";
    private static final String CREATE_UPDATE_BUTTON_ADD_HUB_DIALOG_XPATH = "//button[@id='btnUpsertUser']";
    private static final String CLOSE_BUTTON_MODAL_XPATH = "//button[@aria-label='Close']";
    private static final String EDIT_LINK_TEXT_XPATH = "//a[contains(@class, 'edit-user')]";
    private static final String STATUS_COMBOBOX_XPATH = "//form[contains(@class,'StyledForm')]//div[@id='isActive']";

    private static final String CLEAR_FILTERS_BUTTON_XPATH = "//button[span[text()='Clear Filters']]";
    private static final String IFRAME_XPATH = "//iframe[contains(@src,'hub-user-management')]";
    private static final String LOAD_ALL_HUB_APP_USER_BUTTON_XPATH = "//button[span[text()='Load Hub Users']]";
    private static final String USERNAME_TABLE_FILTER_XPATH = "//th[contains(@class,'username')]//input";
    private static final String TABLE_RESULT_XPATH = "//td[contains(@class,'%s')]/span/%s";
    private static final String TOAST_HUB_APP_USER_CREATED_XPATH = "//div[contains(@class,'notification-notice-content')]//div[contains(text(),'Hub User has been created')]";
    private static final String TOAST_HUB_APP_USER_UPDATED_XPATH = "//div[contains(@class,'notification-notice-content')]//div[contains(text(),'Hub User has been updated')]";
    private static final String ERROR_TOAST_DUPLICATION_USERNAME_XPATH = "//div[contains(@class,'notification-notice-message') and (contains(text(),'username %s already exists'))]";
    private static final String ERROR_TOAST_DUPLICATION_CLOSE_XPATH = "//a[contains(@class,'notification-notice-close')]";
    private static final String ERROR_MESSAGE_EMPTY_FIELD_XPATH = "//div[@class='ant-form-explain']/span[text()='%s']";
    private static final String TEST_CALENDAR = "//td[@title='%s']/div";

    private static final String FIRST_NAME_ID = "firstName";
    private static final String LAST_NAME_ID = "lastName";
    private static final String CONTACT_DETAIL_ID = "contactDetails";
    private static final String USERNAME_ID = "username";
    private static final String PASSWORD_ID = "password";
    private static final String WAREHOUSE_TEAM_FORMATION_ID = "team";
    private static final String POSITION_ID = "position";
    private static final String COMMENT_ID = "comment";
    private static final String STATUS_ID = "isActive";

    private static final String USERNAME_CLASS = "username";
    private static final String HUB_CLASS = "hubId";
    private static final String POSITION_CLASS = "position";
    private static final String EMPLOYMENT_TYPE_CLASS = "employmentType";
    private static final String FIRST_NAME_CLASS = "firstName";
    private static final String LAST_NAME_CLASS = "lastName";
    private static final String EMPLOYMENT_START_DATE_CLASS = "employmentStartDate";

    public HubAppUserManagementPage(WebDriver webDriver)
    {
        super(webDriver);
    }

    public void clickAddHubUserButton()
    {
        getWebDriver().switchTo().frame(findElementByXpath(IFRAME_XPATH));
        waitUntilVisibilityOfElementLocated(LOAD_ALL_HUB_APP_USER_BUTTON_XPATH);
        click(ADD_HUB_USER_BUTTON_XPATH);
        waitUntilVisibilityOfElementLocated(ADD_EDIT_HUB_USER_DIALOG_XPATH);
        getWebDriver().switchTo().parentFrame();
    }

    public void fillFirstName(String firstName)
    {
        getWebDriver().switchTo().frame(findElementByXpath(IFRAME_XPATH));
        if (firstName == null || "".equalsIgnoreCase(firstName)) {
            sendKeysById(FIRST_NAME_ID, "a");
            findElementByXpath(f("//input[@id='%s']", FIRST_NAME_ID)).sendKeys(Keys.BACK_SPACE);
        } else {
            sendKeysById(FIRST_NAME_ID, firstName);
        }
        getWebDriver().switchTo().parentFrame();
    }

    public void fillLastName(String lastName)
    {
        getWebDriver().switchTo().frame(findElementByXpath(IFRAME_XPATH));
        if (lastName == null || "".equalsIgnoreCase(lastName)) {
            sendKeysById(LAST_NAME_ID, "a");
            findElementByXpath(f("//input[@id='%s']", LAST_NAME_ID)).sendKeys(Keys.BACK_SPACE);
        } else {
            sendKeysById(LAST_NAME_ID, lastName);
        }
        getWebDriver().switchTo().parentFrame();
    }

    public void fillContact(String contact)
    {
        getWebDriver().switchTo().frame(findElementByXpath(IFRAME_XPATH));
        if (contact == null || "".equalsIgnoreCase(contact)) {
            sendKeysById(CONTACT_DETAIL_ID, "a");
            findElementByXpath(f("//input[@id='%s']", CONTACT_DETAIL_ID)).sendKeys(Keys.BACK_SPACE);
        } else {
            sendKeysById(CONTACT_DETAIL_ID, contact);
        }
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
        waitUntilVisibilityOfElementLocated(RECENT_MONTH_XPATH);
        click(f(TEST_CALENDAR, startDate));
//        sendKeys(RECENT_MONTH_XPATH, startDate);
//        sendKeys(RECENT_MONTH_XPATH, Keys.ENTER);
        getWebDriver().switchTo().parentFrame();
    }

    public void selectEmploymentActivity(String employmentActivity)
    {
        getWebDriver().switchTo().frame(findElementByXpath(IFRAME_XPATH));
        click(STATUS_COMBOBOX_XPATH);
        if ("ACTIVE".equalsIgnoreCase(employmentActivity))
        {
            waitUntilVisibilityOfElementLocated(ACTIVE_EMPLOYMENT_FILTER_XPATH);
            click(ACTIVE_EMPLOYMENT_FILTER_XPATH);
        } else if ("INACTIVE".equalsIgnoreCase(employmentActivity))
        {
            waitUntilVisibilityOfElementLocated(INACTIVE_EMPLOYMENT_FILTER_XPATH);
            click(INACTIVE_EMPLOYMENT_FILTER_XPATH);
        }
        getWebDriver().switchTo().parentFrame();
    }

    public void selectHubForHubAppUser(String hubName)
    {
        getWebDriver().switchTo().frame(findElementByXpath(IFRAME_XPATH));
        click(HUB_COMBOBOX_XPATH);
        waitUntilVisibilityOfElementLocated(f(HUB_SELECTION_XPATH, hubName));
        pause1s();
        click(f(HUB_SELECTION_XPATH, hubName));
        getWebDriver().switchTo().parentFrame();
    }

    public void fillWareHouseTeamFormation(String warehouseTeamFormation)
    {
        getWebDriver().switchTo().frame(findElementByXpath(IFRAME_XPATH));
        if (warehouseTeamFormation == null || "".equalsIgnoreCase(warehouseTeamFormation)) {
            sendKeysById(WAREHOUSE_TEAM_FORMATION_ID, "a");
            findElementByXpath(f("//input[@id='%s']", WAREHOUSE_TEAM_FORMATION_ID)).sendKeys(Keys.BACK_SPACE);
        } else {
            sendKeysById(WAREHOUSE_TEAM_FORMATION_ID, warehouseTeamFormation);
        }
        getWebDriver().switchTo().parentFrame();
    }

    public void fillPosition(String position)
    {
        getWebDriver().switchTo().frame(findElementByXpath(IFRAME_XPATH));
        if (position == null || "".equalsIgnoreCase(position)) {
            sendKeysById(POSITION_ID, "a");
            findElementByXpath(f("//input[@id='%s']", POSITION_ID)).sendKeys(Keys.BACK_SPACE);
        } else {
            sendKeysById(POSITION_ID, position);
        }
        getWebDriver().switchTo().parentFrame();
    }

    public void fillComments(String comments)
    {
        getWebDriver().switchTo().frame(findElementByXpath(IFRAME_XPATH));
        if (comments == null || "".equalsIgnoreCase(comments)) {
            sendKeysById(COMMENT_ID, "a");
            findElementByXpath(f("//input[@id='%s']", COMMENT_ID)).sendKeys(Keys.BACK_SPACE);
        } else {
            sendKeysById(COMMENT_ID, comments);
        }
        getWebDriver().switchTo().parentFrame();
    }

    public void clickCreateEditHubUserButton(boolean isInvalid, boolean isUpdated)
    {
        getWebDriver().switchTo().frame(findElementByXpath(IFRAME_XPATH));
        click(CREATE_UPDATE_BUTTON_ADD_HUB_DIALOG_XPATH);
        waitUntilInvisibilityOfElementLocated("//md-dialog");
        if (isUpdated) {
            waitUntilVisibilityOfElementLocated(TOAST_HUB_APP_USER_UPDATED_XPATH);
            waitUntilInvisibilityOfElementLocated(TOAST_HUB_APP_USER_UPDATED_XPATH);
        }
        if (!isInvalid) {
            waitUntilVisibilityOfElementLocated(TOAST_HUB_APP_USER_CREATED_XPATH);
            waitUntilInvisibilityOfElementLocated(TOAST_HUB_APP_USER_CREATED_XPATH);
        }
        getWebDriver().switchTo().parentFrame();
    }

    public void clickCreateEditHubUserButton(boolean isInvalid)
    {
        clickCreateEditHubUserButton(isInvalid, false);
    }

    public void clickAllHubAppUser()
    {
        getWebDriver().switchTo().frame(findElementByXpath(IFRAME_XPATH));
        click(LOAD_ALL_HUB_APP_USER_BUTTON_XPATH);
        waitUntilVisibilityOfElementLocated("//tbody//td[@class='hubId']");
        getWebDriver().switchTo().parentFrame();
    }

    public void clickClearFilters()
    {
        getWebDriver().switchTo().frame(findElementByXpath(IFRAME_XPATH));
        click(CLEAR_FILTERS_BUTTON_XPATH);
        getWebDriver().switchTo().parentFrame();
    }

    public void selectFilter(String filterName, HubAppUser hubAppUser)
    {
        getWebDriver().switchTo().frame(findElementByXpath(IFRAME_XPATH));

        switch (filterName)
        {
            case "hub" :
                click(f(FILTER_XPATH, HUB_CLASS));
                waitUntilVisibilityOfElementLocated(f(HUB_SELECTION_XPATH, hubAppUser.getHub()));
                click(f(HUB_SELECTION_XPATH, hubAppUser.getHub()));
                break;

            case "employment type" :
                click(f(FILTER_XPATH, EMPLOYMENT_TYPE_CLASS));
                waitUntilVisibilityOfElementLocated(FULL_TIME_EMPLOYMENT_TYPE_XPATH);
                click(FULL_TIME_EMPLOYMENT_TYPE_XPATH);
                break;

            case "employment start date" :
                LocalDateTime today = LocalDateTime.now();
                DateTimeFormatter formatter = DateTimeFormatter.ofPattern("MMMM d, yyyy", Locale.ENGLISH);

                click(EMPLOYMENT_START_DATE_FILTER_XPATH);
                waitUntilVisibilityOfElementLocated(f(START_DATE_INPUT_XPATH, formatter.format(today)));
                click(f(START_DATE_INPUT_XPATH, formatter.format(today)));
                click(f(START_DATE_INPUT_XPATH, formatter.format(today)));
                break;

            case "status" :
                click(f(FILTER_XPATH, STATUS_ID));
                waitUntilVisibilityOfElementLocated(ACTIVE_EMPLOYMENT_FILTER_XPATH);
                click(ACTIVE_EMPLOYMENT_FILTER_XPATH);
                break;

            case "multiple" :
                click(f(FILTER_XPATH, HUB_CLASS));
                waitUntilVisibilityOfElementLocated(f(HUB_SELECTION_XPATH, hubAppUser.getHub()));
                click(f(HUB_SELECTION_XPATH, hubAppUser.getHub()));

                pause1s();
                click(f(FILTER_XPATH, EMPLOYMENT_TYPE_CLASS));
                waitUntilVisibilityOfElementLocated(FULL_TIME_EMPLOYMENT_TYPE_XPATH);
                click(FULL_TIME_EMPLOYMENT_TYPE_XPATH);

                pause1s();
                click(f(FILTER_XPATH, STATUS_ID));
                waitUntilVisibilityOfElementLocated(ACTIVE_EMPLOYMENT_FILTER_XPATH);
                click(ACTIVE_EMPLOYMENT_FILTER_XPATH);
                break;
        }

        getWebDriver().switchTo().parentFrame();
    }

    public void selectFilterWithoutCreatingHubAppUser()
    {
        getWebDriver().switchTo().frame(findElementByXpath(IFRAME_XPATH));

        pause1s();
        click(f(FILTER_XPATH, EMPLOYMENT_TYPE_CLASS));
        waitUntilVisibilityOfElementLocated(FULL_TIME_EMPLOYMENT_TYPE_XPATH);
        click(FULL_TIME_EMPLOYMENT_TYPE_XPATH);

        pause1s();
        click(f(FILTER_XPATH, STATUS_ID));
        waitUntilVisibilityOfElementLocated(ACTIVE_EMPLOYMENT_FILTER_XPATH);
        click(ACTIVE_EMPLOYMENT_FILTER_XPATH);

        getWebDriver().switchTo().parentFrame();
    }

    public void verifiesDuplicationErrorToastShown(String existedUsername)
    {
        getWebDriver().switchTo().frame(findElementByXpath(IFRAME_XPATH));
        waitUntilVisibilityOfElementLocated(ERROR_TOAST_DUPLICATION_USERNAME_XPATH, existedUsername);
        getWebDriver().switchTo().parentFrame();
    }

    public void emptyErrorMessage(String errorMessage)
    {
        getWebDriver().switchTo().frame(findElementByXpath(IFRAME_XPATH));
        waitUntilVisibilityOfElementLocated(f(ERROR_MESSAGE_EMPTY_FIELD_XPATH, errorMessage));
        click(CLOSE_BUTTON_MODAL_XPATH);
        getWebDriver().switchTo().parentFrame();
    }

    public void checkTheHubAppUserIsCreated(HubAppUser hubAppUser)
    {
        getWebDriver().switchTo().frame(findElementByXpath(IFRAME_XPATH));
        sendKeys(USERNAME_TABLE_FILTER_XPATH, hubAppUser.getUsername());
        waitUntilVisibilityOfElementLocated(f(TABLE_RESULT_XPATH, USERNAME_CLASS, "mark"));

        String actualUsernameShown = getText(f(TABLE_RESULT_XPATH, USERNAME_CLASS, "mark"));
        assertEquals("Username is different : ", hubAppUser.getUsername(), actualUsernameShown);

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

    public void verifiesUnselectedFilter()
    {
        getWebDriver().switchTo().frame(findElementByXpath(IFRAME_XPATH));
        isElementExistFast(f(UNSELECTABLE_FILTER, HUB_CLASS));
        isElementExistFast(f(UNSELECTABLE_FILTER, EMPLOYMENT_TYPE_CLASS));
        isElementExistFast(f(UNSELECTABLE_FILTER, STATUS_ID));
        getWebDriver().switchTo().parentFrame();
    }

    public void clickEditHubAppUser()
    {
        getWebDriver().switchTo().frame(findElementByXpath(IFRAME_XPATH));
        click(EDIT_LINK_TEXT_XPATH);
        waitUntilVisibilityOfElementLocated(ADD_EDIT_HUB_USER_DIALOG_XPATH);
        getWebDriver().switchTo().parentFrame();
    }
}
