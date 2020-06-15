package co.nvqa.operator_v2.selenium.page;

import co.nvqa.operator_v2.model.RoleManagement;
import co.nvqa.operator_v2.selenium.elements.CustomFieldDecorator;
import co.nvqa.operator_v2.selenium.elements.TextBox;
import co.nvqa.operator_v2.selenium.elements.md.MdAutocomplete;
import co.nvqa.operator_v2.selenium.elements.md.MdDialog;
import co.nvqa.operator_v2.selenium.elements.nv.NvApiTextButton;
import co.nvqa.operator_v2.selenium.elements.nv.NvIconTextButton;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.PageFactory;

/**
 *
 * @author Tristania Siagian
 */
@SuppressWarnings("WeakerAccess")
public class RoleManagementPage extends OperatorV2SimplePage {

    @FindBy(name = "Add Role")
    public NvIconTextButton addRole;

    @FindBy(css = "md-dialog")
    public AddRoleModal addRoleModal;

    private static final String NG_REPEAT = "role in $data";

    private static final String COLUMN_DATA_TITLE_NAME = "ctrl.table.name";
    private static final String COLUMN_DATA_TITLE_DESC = "ctrl.table.description";

    public RoleManagementPage(WebDriver webDriver) {
        super(webDriver);
    }

    public void createNewRole(RoleManagement roleManagement) {
        waitUntilInvisibilityOfElementLocated("//div[contains(@class, 'loading-sheet')]/md-progress-circular");
        waitUntilInvisibilityOfToast();
        addRole.waitUntilClickable();
        addRole.click();
        addRoleModal.waitUntilVisible();
        addRoleModal.roleName.setValue(roleManagement.getRoleName());
        addRoleModal.description.setValue(roleManagement.getDesc());
        addRoleModal.scope.selectValue(roleManagement.getScope());
        addRoleModal.addRole.clickAndWaitUntilDone();
        refreshPage();
    }

    public void fillTheForm(RoleManagement roleManagement) {
        sendKeysById("role-name", roleManagement.getRoleName());
        sendKeysById("description(optional)", roleManagement.getDesc());
        selectValueFromMdAutocomplete("Search Scope To Add", roleManagement.getScope());
        pause100ms();
    }

    public void verifyRoleDetails(RoleManagement roleManagement) {
        waitUntilVisibilityOfElementLocated("//table[@ng-table='ctrl.allRoleParams']/tbody/tr");
        searchTable(roleManagement.getRoleName());

        String actualName = getTextOnTable(1, COLUMN_DATA_TITLE_NAME);
        assertEquals("Different Role Name Returned", roleManagement.getRoleName(), actualName);
        String actualDesc = getTextOnTable(1, COLUMN_DATA_TITLE_DESC);
        assertEquals("Different Description Returned", roleManagement.getDesc(), actualDesc);
    }

    public void deleteRole() {
        clickNvIconButtonByNameAndWaitUntilEnabled("Edit");
        clickNvApiTextButtonByNameAndWaitUntilDone("Delete");
        refreshPage();
    }

    public void verifyRoleIsDeleted(RoleManagement roleManagement) {
        waitUntilVisibilityOfElementLocated("//table[@ng-table='ctrl.allRoleParams']/tbody/tr");
        searchTable(roleManagement.getRoleName());
        assertFalse("Row is exist.", isElementExistWait1Second("//table[@ng-table='ctrl.allRoleParams']/tbody/tr"));
    }

    public void editRole(RoleManagement roleManagement, RoleManagement roleManagementEdited) {
        searchTable(roleManagement.getRoleName());
        clickNvIconButtonByNameAndWaitUntilEnabled("Edit");
        fillTheForm(roleManagementEdited);
        clickNvApiTextButtonByNameAndWaitUntilDone("Save Changes");
        refreshPage();
    }

    public String getTextOnTable(int rowNumber, String columnDataTitle) {
        return getTextOnTableWithNgRepeatUsingDataTitle(rowNumber, columnDataTitle, NG_REPEAT);
    }

    public static class AddRoleModal extends MdDialog
    {
        public AddRoleModal(WebDriver webDriver, WebElement webElement)
        {
            super(webDriver, webElement);
            PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
        }

        @FindBy(css = "[id^='role-name']")
        public TextBox roleName;

        @FindBy(css = "[id^='description(optional)']")
        public TextBox description;

        @FindBy(css = "md-autocomplete[placeholder='Search Scope To Add']")
        public MdAutocomplete scope;

        @FindBy(name = "Add Role")
        public NvApiTextButton addRole;

    }
}
