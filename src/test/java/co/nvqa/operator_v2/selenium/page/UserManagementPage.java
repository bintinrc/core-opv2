package co.nvqa.operator_v2.selenium.page;

import co.nvqa.operator_v2.model.UserManagement;
import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.md.MdDialog;
import co.nvqa.operator_v2.util.TestConstants;
import org.hamcrest.Matchers;
import org.openqa.selenium.Keys;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;

import java.util.List;

/**
 *
 * @author Tristania Siagian
 */
@SuppressWarnings("WeakerAccess")
public class UserManagementPage extends OperatorV2SimplePage {

    private static final String NG_REPEAT = "user in $data";
    private static final String COLUMN_DATA_TITLE_GRANT_TYPE = "'container.user-management.grantType'";
    private static final String COLUMN_DATA_TITLE_FIRST_NAME = "'commons.first-name'";
    private static final String COLUMN_DATA_TITLE_LAST_NAME = "'commons.last-name'";
    private static final String COLUMN_DATA_TITLE_ROLE = "'container.user-management.roles'";

    private static final String ACTION_BUTTON_EDIT = "Edit";
    private static final String XPATH_OF_SAVE_CHANGES = "//nv-api-text-button//button[@aria-label='Save Changes']";
    private static final String XPATH_OF_REMOVE_BUTTON = "//tbody//tr[1]//button[@aria-label='Remove']";
    private static final String XPATH_OF_ADD_USER_BUTTON = "//nv-api-text-button//button[@aria-label='Add User']";

    @FindBy(css = "md-dialog")
    public AddUserDialog addUserDialog;

    @FindBy(css = "md-dialog")
    public EditUserDialog editUserDialog;

    public UserManagementPage(WebDriver webDriver) {
        super(webDriver);
    }

    public void createUser(UserManagement userManagement) {
        clickNvIconTextButtonByName("Add User");
        fillTheForm(userManagement, true);
        addUserDialog.addUser.waitUntilClickable();
        addUserDialog.addUser.click();
    }

    public static class AddUserDialog extends MdDialog
    {
        public AddUserDialog(WebDriver webDriver, WebElement webElement)
        {
            super(webDriver, webElement);
        }

        @FindBy(xpath = XPATH_OF_ADD_USER_BUTTON)
        public Button addUser;
    }

    public void verifyUserOnUserManagement(UserManagement userManagement) {
        sendKeys("//input[@type='text'][@ng-model='ctrl.keyword']",userManagement.getEmail());
        clickNvApiTextButtonByNameAndWaitUntilDone("Load Selected Users");
        String actualGrantType = getTextOnTable(1,  COLUMN_DATA_TITLE_GRANT_TYPE);
        assertEquals("Different Grant Type Returned", userManagement.getGrantType(), actualGrantType);
        String actualFirstName = getTextOnTable(1, COLUMN_DATA_TITLE_FIRST_NAME);
        assertEquals("Different First Name Returned", userManagement.getFirstName(), actualFirstName);
        String actualLastName = getTextOnTable(1, COLUMN_DATA_TITLE_LAST_NAME);
        assertEquals("Different Last Name Returned", userManagement.getLastName(), actualLastName);
        String actualRole = getTextOnTable(1, COLUMN_DATA_TITLE_ROLE);
        assertThat("Different Roles Returned", actualRole, Matchers.containsString(userManagement.getRoles()));
    }

    public void editUser(UserManagement userManagement, UserManagement userManagementEdited) {
        sendKeys("//input[@type='text'][@ng-model='ctrl.keyword']",userManagement.getEmail());
        clickNvApiTextButtonByNameAndWaitUntilDone("Load Selected Users");
        clickActionButtonOnTable(1, ACTION_BUTTON_EDIT);
        editUserDialog.remove.click();
        fillTheForm(userManagementEdited, false);
        editUserDialog.saveChanges.waitUntilClickable();
        editUserDialog.saveChanges.click();
        clickNvApiTextButtonByNameAndWaitUntilDone("Save Changes");
    }

    public static class EditUserDialog extends MdDialog
    {
        public EditUserDialog(WebDriver webDriver, WebElement webElement)
        {
            super(webDriver, webElement);
        }

        @FindBy(xpath = XPATH_OF_REMOVE_BUTTON)
        public Button remove;

        @FindBy(xpath = XPATH_OF_SAVE_CHANGES)
        public Button saveChanges;
    }

    public void fillTheForm(UserManagement userManagement, boolean isCreate) {
        if(isCreate) {
            sendKeysById("first-name", userManagement.getFirstName());
            sendKeysById("last-name", userManagement.getLastName());
            sendKeysById("email", userManagement.getEmail());
        }
        pause300ms();
        selectValueFromMdSelect("ctrl.selectedCountry", TestConstants.COUNTRY_CODE.toLowerCase());
        pause300ms();
        selectValueFromMdAutocomplete("Search Role To Add", userManagement.getRoles());
        pause300ms();
    }

    public void verifyEditedUserOnUserManagement(UserManagement userManagement) {
        sendKeys("//input[@type='text'][@ng-model='ctrl.keyword']", userManagement.getLastName());
        pause500ms();
        clickNvApiTextButtonByNameAndWaitUntilDone("Load Selected Users");
        pause500ms();
        String actualRole = getTextOnTable(1, COLUMN_DATA_TITLE_ROLE);
        assertThat("Different Roles Returned", actualRole, Matchers.containsString(userManagement.getRoles()));
    }

    public void clickGrantTypeFilter() {
        sendKeys("//nv-filter-box[@main-title='Grant Types']//md-autocomplete[@placeholder='Search or Select...']//input", "Google");
        pause1s();
        findElementByXpath("//nv-filter-box[@main-title='Grant Types']//md-autocomplete[@placeholder='Search or Select...']//input").sendKeys(Keys.RETURN);
        pause1s();
        click("//md-content/md-content/div/div");
        clickNvApiTextButtonByNameAndWaitUntilDone("Load Selected Users");
    }

    public void verifyGrantType(UserManagement userManagement) {
        List<WebElement> grantTypeRows = findElementsByXpath(String.format("//td[@data-title=\"%s\"]", COLUMN_DATA_TITLE_GRANT_TYPE));
        int count = 0;

        for(WebElement we: grantTypeRows) {
            if(count==10) {
                break;
            }
            assertEquals("Different Grant Type Returned.", userManagement.getGrantType(), we.getText());
            count += 1;
        }
    }

    public String getTextOnTable(int rowNumber, String columnDataTitle) {
        return getTextOnTableWithNgRepeatUsingDataTitle(rowNumber, columnDataTitle, NG_REPEAT);
    }

    public void clickActionButtonOnTable(int rowNumber, String actionButtonName) {
        clickActionButtonOnTableWithNgRepeat(rowNumber, actionButtonName, NG_REPEAT);
    }
}
