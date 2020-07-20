package co.nvqa.operator_v2.selenium.page;

import co.nvqa.operator_v2.model.RoleManagement;
import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.CustomFieldDecorator;
import co.nvqa.operator_v2.selenium.elements.TextBox;
import co.nvqa.operator_v2.selenium.elements.ant.AntModal;
import co.nvqa.operator_v2.selenium.elements.ant.AntSelect;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.PageFactory;

import java.util.ArrayList;

/**
 *
 * @author Niko Susanto
 */
@SuppressWarnings("WeakerAccess")
public class RoleManagementV2Page extends OperatorV2SimplePage {

    public RoleManagementV2Page(WebDriver webDriver) {
        super(webDriver);
    }

    private static final String IFRAME_XPATH = "//iframe[contains(@src,'role-management-v2')]";
    private static final String COLUMN_DATA_TITLE_NAME = "//tbody[1]/tr[1]/td[@class='name']/span/span";
    private static final String COLUMN_DATA_TITLE_DESC = "//tbody[1]/tr[1]/td[@class='description']/span/span";
    private static final String EDIT_NAME_XPATH = "//div[contains(text(),'Name')]/following-sibling::a";
    private static final String EDIT_DESCRIPTION_XPATH = "//div[contains(text(),'Description')]/following-sibling::a";
    private static final String UPDATED_NAME_XPATH = "//div[contains(text(),'Name')]/..";
    private static final String UPDATED_DESCRIPTION_XPATH = "//div[contains(text(),'Description')]/..";

    @FindBy(xpath = "//button[.='Add New Role']")
    public Button add;

    @FindBy(css = "div.ant-modal")
    public AddRoleModal addRoleModal;

    @FindBy(xpath = "//div[@class='ant-col ant-col-24']//span[.='Id']")
    public TextBox sort;

    @FindBy (xpath = "//tbody[1]/tr[1]//button")
    public Button delete;

    @FindBy (xpath = "//button[.= 'Yes']")
    public Button confirm;

    @FindBy(css = "div.ant-modal")
    public UpdateNameModal updateNameModal;

    @FindBy(css = "div.ant-modal")
    public UpdateDescriptionModal updateDescriptionModal;

    @FindBy (xpath = "//button[.='Assign Scopes']")
    public Button assignScope;

    @FindBy(css = "div.ant-modal")
    public AssignScopesModal assignScopesModal;

    public void createNewRole(RoleManagement roleManagement)
    {
        getWebDriver().switchTo().frame(findElementByXpath(IFRAME_XPATH));
        add.waitUntilClickable();
        add.click();
        addRoleModal.waitUntilVisible();
        addRoleModal.roleName.setValue(roleManagement.getRoleName());
        addRoleModal.description.setValue(roleManagement.getDesc());
        addRoleModal.addRole.click();
        sort.click();
        sort.click();
    }

    public static class AddRoleModal extends AntModal
    {
        public AddRoleModal(WebDriver webDriver, WebElement webElement)
        {
            super(webDriver, webElement);
            PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
        }

        @FindBy(css = "[id^='name']")
        public TextBox roleName;

        @FindBy(css = "[id^='description']")
        public TextBox description;

        @FindBy(xpath = "//button[.='OK']")
        public Button addRole;

    }

    public void verifyRoleDetails(RoleManagement roleManagement)
    {
        assertEquals("Different Role Name Returned", roleManagement.getRoleName(), getText(COLUMN_DATA_TITLE_NAME));
        assertEquals("Different Description Returned", roleManagement.getDesc(), getText(COLUMN_DATA_TITLE_DESC));
    }

    public void deleteRole()
    {
        delete.click();
        confirm.click();
        refreshPage();
    }

    public void verifyRoleIsDeleted(RoleManagement roleManagement) {
        getWebDriver().switchTo().frame(findElementByXpath(IFRAME_XPATH));
        add.waitUntilClickable();
        sort.click();
        sort.click();
        assertNotEquals("Role Name is the same", roleManagement.getRoleName(), getText(COLUMN_DATA_TITLE_NAME));
        assertNotEquals("Role Description is the same", roleManagement.getDesc(), getText(COLUMN_DATA_TITLE_DESC));
    }

    public void editRole(RoleManagement roleManagementEdited) {
        click(COLUMN_DATA_TITLE_NAME);
        waitUntilPageLoaded();

        ArrayList tabs = new ArrayList(webDriver.getWindowHandles());
        webDriver.switchTo().window((String) tabs.get(1));
        refreshPage();

        getWebDriver().switchTo().frame(findElementByXpath(IFRAME_XPATH));
        click(EDIT_NAME_XPATH);
        UpdateName(roleManagementEdited.getRoleName());
        UpdateDescription(roleManagementEdited.getDesc());
        UpdateScope(roleManagementEdited.getScope());

    }

    public void UpdateName(String name)
    {
        updateNameModal.waitUntilVisible();
        updateNameModal.name.clear();
        updateNameModal.name.sendKeys(name);
        updateNameModal.save.click();
    }

    public void UpdateDescription(String description)
    {
        click(EDIT_DESCRIPTION_XPATH);
        updateDescriptionModal.waitUntilVisible();
        updateDescriptionModal.description.clear();
        updateDescriptionModal.description.sendKeys(description);
        updateDescriptionModal.save.click();
    }

    public void UpdateScope(String scope)
    {
        assignScope.click();
        assignScopesModal.waitUntilVisible();
        assignScopesModal.scope.selectValue(scope);
        assignScopesModal.save.click();
    }

    public static class UpdateNameModal extends AntModal
    {
        public UpdateNameModal(WebDriver webDriver, WebElement webElement)
        {
            super(webDriver, webElement);
            PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
        }

        @FindBy(id = "name")
        public TextBox name;

        @FindBy(xpath = "//button[.='OK']")
        public Button save;
    }

    public static class UpdateDescriptionModal extends AntModal
    {
        public UpdateDescriptionModal(WebDriver webDriver, WebElement webElement)
        {
            super(webDriver, webElement);
            PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
        }

        @FindBy(id = "description")
        public TextBox description;

        @FindBy(xpath = "//button[.='OK']")
        public Button save;
    }

    public static class AssignScopesModal extends AntModal
    {
        public AssignScopesModal(WebDriver webDriver, WebElement webElement)
        {
            super(webDriver, webElement);
            PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
        }

        @FindBy(xpath = "//div[contains(@class, 'ant-select-selection__')]")
        public AntSelect scope;

        @FindBy(xpath = "//button[.='OK']")
        public Button save;
    }

    public void verifyEditedRoleDetails(RoleManagement roleManagement)
    {
        String actualName = getText(UPDATED_NAME_XPATH).replace("NAME\n","");
        String actualDescription = getText(UPDATED_DESCRIPTION_XPATH).replace("DESCRIPTION\n","");
        assertEquals("Different Role Name Returned", roleManagement.getRoleName(), actualName.replace("\nEdit",""));
        assertEquals("Different Description Returned", roleManagement.getDesc(), actualDescription.replace("\nEdit",""));
        assertEquals("New Scope Not Found", roleManagement.getScope(), getText(f("//tbody[1]//span/span[.='%s']",roleManagement.getScope())));
    }
}
