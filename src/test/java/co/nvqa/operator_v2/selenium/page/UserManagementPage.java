package co.nvqa.operator_v2.selenium.page;

import co.nvqa.operator_v2.model.UserManagement;
import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.CustomFieldDecorator;
import co.nvqa.operator_v2.selenium.elements.TextBox;
import co.nvqa.operator_v2.selenium.elements.md.MdAutocomplete;
import co.nvqa.operator_v2.selenium.elements.md.MdDialog;
import co.nvqa.operator_v2.selenium.elements.md.MdSelect;
import co.nvqa.operator_v2.selenium.elements.nv.NvApiTextButton;
import co.nvqa.operator_v2.selenium.elements.nv.NvAutocomplete;
import co.nvqa.operator_v2.selenium.elements.nv.NvIconTextButton;
import co.nvqa.operator_v2.util.TestConstants;
import com.google.common.collect.ImmutableMap;
import org.hamcrest.Matchers;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.PageFactory;

import java.util.List;

/**
 * @author Tristania Siagian
 */
@SuppressWarnings("WeakerAccess")
public class UserManagementPage extends OperatorV2SimplePage
{

    @FindBy(name = "Add User")
    public NvIconTextButton addUser;

    @FindBy(name = "Load Selected Users")
    public NvApiTextButton loadSelectedUsers;

    @FindBy(css = "md-dialog")
    public AddUserModal addUserModal;

    @FindBy(css = "md-dialog")
    public EditUserModal editUserModal;

    @FindBy(id = "id")
    public TextBox searchKeywordInput;

    @FindBy(xpath = "//nv-filter-box[@main-title='Grant Types']//nv-autocomplete")
    public NvAutocomplete grantTypeFilter;

    public UsersTable usersTable;

    private static final String COLUMN_DATA_TITLE_GRANT_TYPE = "'container.user-management.grantType'";

    public UserManagementPage(WebDriver webDriver)
    {
        super(webDriver);
        usersTable = new UsersTable(webDriver);
    }

    public void createUser(UserManagement userManagement)
    {
        addUser.click();
        addUserModal.waitUntilVisible();
        addUserModal.firstName.setValue(userManagement.getFirstName());
        addUserModal.lastName.setValue(userManagement.getLastName());
        addUserModal.email.setValue(userManagement.getEmail());
        addUserModal.countryAuthentication.selectValue(TestConstants.COUNTRY_CODE.toLowerCase());
        addUserModal.role.selectValue(userManagement.getRoles());
        addUserModal.addUser.clickAndWaitUntilDone();
        addUserModal.waitUntilInvisible();
    }

    public void verifyUserOnUserManagement(UserManagement userManagement)
    {
        refreshPage();
        searchKeywordInput.setValue(userManagement.getEmail());
        loadSelectedUsers.clickAndWaitUntilDone();
        UserManagement actualUserManagement = usersTable.readEntity(1);
        assertEquals("Grant Type", userManagement.getGrantType(), actualUserManagement.getGrantType());
        assertEquals("First Name", userManagement.getFirstName(), actualUserManagement.getFirstName());
        assertEquals("Last Name", userManagement.getLastName(), actualUserManagement.getLastName());
        assertThat("Roles", actualUserManagement.getRoles(), Matchers.containsString(userManagement.getRoles()));
    }

    public void editUser(UserManagement userManagement, UserManagement userManagementEdited)
    {
        searchKeywordInput.setValue(userManagement.getEmail());
        loadSelectedUsers.clickAndWaitUntilDone();
        usersTable.clickActionButton(1, "Edit");
        editUserModal.waitUntilVisible();
        editUserModal.remove.click();
        editUserModal.countryAuthentication.selectValue(TestConstants.COUNTRY_CODE.toLowerCase());
        editUserModal.role.selectValue(userManagement.getRoles());
        editUserModal.saveUser.clickAndWaitUntilDone();
        editUserModal.waitUntilInvisible();
    }

    public void selectGrantTypeFilter(String grantType)
    {
        grantTypeFilter.selectValue(grantType);
        grantTypeFilter.click();
        pause1s();
        loadSelectedUsers.clickAndWaitUntilDone();
    }

    public void verifyGrantType(UserManagement userManagement)
    {
        List<String> actualGrantTypes = usersTable.readColumn("grantType");
        for (int i = 1; i <= actualGrantTypes.size(); i++)
        {
            assertEquals("Grant Type [" + i + "]", userManagement.getGrantType(), actualGrantTypes.get(i - 1));
        }
    }

    public static class AddUserModal extends MdDialog
    {
        public AddUserModal(WebDriver webDriver, WebElement webElement)
        {
            super(webDriver, webElement);
            PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
        }

        @FindBy(css = "[aria-label='First Name']")
        public TextBox firstName;

        @FindBy(css = "[aria-label='Last Name']")
        public TextBox lastName;

        @FindBy(css = "[aria-label='Email']")
        public TextBox email;

        @FindBy(css = "md-select[ng-model='ctrl.selectedCountry']")
        public MdSelect countryAuthentication;

        @FindBy(css = "md-autocomplete[placeholder='Search Role To Add']")
        public MdAutocomplete role;

        @FindBy(name = "Add User")
        public NvApiTextButton addUser;
    }

    public static class EditUserModal extends MdDialog
    {
        public EditUserModal(WebDriver webDriver, WebElement webElement)
        {
            super(webDriver, webElement);
            PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
        }


        @FindBy(css = "md-select[ng-model='ctrl.selectedCountry']")
        public MdSelect countryAuthentication;

        @FindBy(css = "md-autocomplete[placeholder='Search Role To Add']")
        public MdAutocomplete role;

        @FindBy(css = "button[aria-label='Remove']")
        public Button remove;

        @FindBy(name = "Save Changes")
        public NvApiTextButton saveUser;
    }

    public static class UsersTable extends NgRepeatTable<UserManagement>
    {
        public static final String NG_REPEAT = "user in $data";

        public UsersTable(WebDriver webDriver)
        {
            super(webDriver);
            setNgRepeat(NG_REPEAT);
            setColumnLocators(ImmutableMap.<String, String>builder()
                    .put("email", "//td[@data-title-text='Email/Username']")
                    .put("grantType", "//td[@data-title-text='Grant type']")
                    .put("firstName", "//td[@data-title-text='First Name']")
                    .put("lastName", "//td[@data-title-text='Last Name']")
                    .put("roles", "//td[@data-title-text='Role(s)']")
                    .build());
            setActionButtonsLocators(ImmutableMap.of("Edit", "Edit"));
            setEntityClass(UserManagement.class);
        }
    }
}
