package co.nvqa.operator_v2.selenium.page;

import co.nvqa.operator_v2.model.UserManagement;
import org.junit.Assert;
import org.openqa.selenium.Keys;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;

import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author Tristania Siagian
 */

public class UserManagementPage extends SimplePage {
    private static final String NG_REPEAT = "user in $data";
    private static final String COLUMN_DATA_TITLE_GRANT_TYPE = "ctrl.table.grantType";
    private static final String COLUMN_DATA_TITLE_FIRST_NAME = "ctrl.table.firstName";
    private static final String COLUMN_DATA_TITLE_LAST_NAME = "ctrl.table.lastName";
    private static final String COLUMN_DATA_TITLE_ROLE = "ctrl.table.roles";

    private static final String ACTION_BUTTON_EDIT = "Edit";

    public UserManagementPage(WebDriver webDriver) {
        super(webDriver);
    }

    public void createUser(UserManagement userManagement) {
        clickNvIconTextButtonByName("Add User");
        waitUntilVisibilityOfElementLocated("//md-dialog[contains(@class, 'user-add')]");
        fillTheForm(userManagement);
        clickNvApiTextButtonByNameAndWaitUntilDone("Add User");
    }

    public void verifyUserOnUserManagement(UserManagement userManagement) {
        sendKeys("//input[@type='text'][@ng-model='ctrl.keyword']",userManagement.getFirstName()+userManagement.getLastName());
        clickNvApiTextButtonByNameAndWaitUntilDone("Load Selected Users");
        String actualGrantType = getTextOnTable(1,  COLUMN_DATA_TITLE_GRANT_TYPE);
        Assert.assertEquals("Different Result Returned",userManagement.getGrantType(), actualGrantType);
        String actualFirstName = getTextOnTable(1, COLUMN_DATA_TITLE_FIRST_NAME);
        Assert.assertEquals("Different Result Returned",userManagement.getFirstName(), actualFirstName);
        String actualLastName = getTextOnTable(1, COLUMN_DATA_TITLE_LAST_NAME);
        Assert.assertEquals("Different Result Returned",userManagement.getLastName(), actualLastName);
        String actualRole = getTextOnTable(1, COLUMN_DATA_TITLE_ROLE);
        Assert.assertTrue("Different Result Returned", actualRole.contains(userManagement.getRoles()));
    }

    public void editUser(UserManagement userManagement, UserManagement userManagementEdited) {
        sendKeys("//input[@type='text'][@ng-model='ctrl.keyword']",userManagement.getFirstName()+userManagement.getLastName());
        clickNvApiTextButtonByNameAndWaitUntilDone("Load Selected Users");
        clickActionButtonOnTable(1, ACTION_BUTTON_EDIT);
        waitUntilVisibilityOfElementLocated("//md-dialog[contains(@class, 'user-edit')]");
        fillTheForm(userManagementEdited);
        clickNvApiTextButtonByNameAndWaitUntilDone("Save Changes");
    }

    public void fillTheForm(UserManagement userManagement)
    {
        sendKeysById("first-name", userManagement.getFirstName());
        sendKeysById("last-name", userManagement.getLastName());
        sendKeysById("email", userManagement.getEmail());
        selectValueFromMdAutocomplete("Search Role To Add", userManagement.getRoles());
    }

    public void verifyEditedUserOnUserManagement(UserManagement userManagement) {
        sendKeys("//input[@type='text'][@ng-model='ctrl.keyword']", userManagement.getLastName());
        clickNvApiTextButtonByNameAndWaitUntilDone("Load Selected Users");
        String actualGrantType = getTextOnTable(1, COLUMN_DATA_TITLE_GRANT_TYPE);
        Assert.assertEquals("Different Result Returned",userManagement.getGrantType(), actualGrantType);
        String actualFirstName = getTextOnTable(1, COLUMN_DATA_TITLE_FIRST_NAME);
        Assert.assertEquals("Different Result Returned",userManagement.getFirstName(), actualFirstName);
        String actualLastName = getTextOnTable(1, COLUMN_DATA_TITLE_LAST_NAME);
        Assert.assertEquals("Different Result Returned",userManagement.getLastName(), actualLastName);
        String actualRole = getTextOnTable(1, COLUMN_DATA_TITLE_ROLE);
        Assert.assertTrue("Different Result Returned", actualRole.contains(userManagement.getRoles()));
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
        List<WebElement> grantTyperows = findElementsByXpath("//td[@data-title='ctrl.table.grantType']");
        List<String> grantType = new ArrayList<>();

        int count= 0;
        for (WebElement we: grantTyperows) {
            if(count==10) {
                break;
            }
            grantType.add(we.getText());
            Assert.assertEquals("Different Result Returned",userManagement.getGrantType(),we.getText());
            count+=1;
        }

    }

    public String getTextOnTable(int rowNumber, String columnDataTitleText) {
        return getTextOnTableWithNgRepeatUsingDataTitleText(rowNumber, columnDataTitleText, NG_REPEAT);
    }

    public void clickActionButtonOnTable(int rowNumber, String actionButtonName)
    {
        clickActionButtonOnTableWithNgRepeat(rowNumber, actionButtonName, NG_REPEAT);
    }
}
