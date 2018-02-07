package co.nvqa.operator_v2.selenium.page;

import co.nvqa.operator_v2.model.RoleManagement;
import org.junit.Assert;
import org.openqa.selenium.WebDriver;

/**
 *
 * @author Tristania Siagian
 */
public class RoleManagementPage extends OperatorV2SimplePage
{

    private static final String NG_REPEAT = "role in $data";

    private static final String COLUMN_DATA_TITLE_NAME = "ctrl.table.name";
    private static final String COLUMN_DATA_TITLE_DESC = "ctrl.table.description";

    public RoleManagementPage(WebDriver webDriver) {
        super(webDriver);
    }

    public void createNewRole(RoleManagement roleManagement) {
        clickNvIconTextButtonByNameAndWaitUntilDone("Add Role");
        fillTheForm(roleManagement);
        clickNvApiTextButtonByNameAndWaitUntilDone("Add Role");
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
        Assert.assertEquals("Different Role Name Returned", roleManagement.getRoleName(), actualName);
        String actualDesc = getTextOnTable(1, COLUMN_DATA_TITLE_DESC);
        Assert.assertEquals("Different Description Returned", roleManagement.getDesc(), actualDesc);
    }

    public void deleteRole() {
        clickNvIconButtonByNameAndWaitUntilEnabled("Edit");
        clickNvApiTextButtonByNameAndWaitUntilDone("Delete");
        refreshPage();
    }

    public void verifyRoleIsDeleted(RoleManagement roleManagement) {
        waitUntilVisibilityOfElementLocated("//table[@ng-table='ctrl.allRoleParams']/tbody/tr");
        searchTable(roleManagement.getRoleName());
        Assert.assertFalse("Row is exist.", isElementExistWait1Second("//table[@ng-table='ctrl.allRoleParams']/tbody/tr"));
    }

    public void editRole(RoleManagement roleManagement, RoleManagement roleManagementEdited) {
        searchTable(roleManagement.getRoleName());
        clickNvIconButtonByNameAndWaitUntilEnabled("Edit");
        fillTheForm(roleManagementEdited);
        clickNvApiTextButtonByNameAndWaitUntilDone("Save Changes");
        refreshPage();
    }

    public String getTextOnTable(int rowNumber, String columnDataTitleText) {
        return getTextOnTableWithNgRepeatUsingDataTitleText(rowNumber, columnDataTitleText, NG_REPEAT);
    }
}
