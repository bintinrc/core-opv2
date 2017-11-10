package co.nvqa.operator_v2.selenium.page;

import co.nvqa.operator_v2.model.DpCompany;
import co.nvqa.operator_v2.model.DpCompanyAgent;
import org.junit.Assert;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;

/**
 *
 * @author Daniel Joi Partogi Hutapea
 */
public class DpCompanyAgentPage extends SimplePage
{
    private static final String MD_VIRTUAL_REPEAT = "agent in getTableData()";

    public static final String COLUMN_CLASS_NAME = "name";
    public static final String COLUMN_CLASS_EMAIL = "email";
    public static final String COLUMN_CLASS_CONTACT_NO = "contact-no";
    public static final String COLUMN_CLASS_UNLOCK_CODE = "unlock-code";

    public static final String ACTION_BUTTON_EDIT = "Edit";
    public static final String ACTION_BUTTON_DELETE = "Delete";

    public DpCompanyAgentPage(WebDriver webDriver)
    {
        super(webDriver);
    }

    public void addDpCompanyAgent(DpCompanyAgent dpCompanyAgent)
    {
        click("//button[@aria-label='Add Agent']");
        waitUntilVisibilityOfElementLocated("//md-dialog[contains(@class, 'dp-agent-add')]");
        fillTheFormAndSubmit(dpCompanyAgent);
    }

    public void editDpCompanyAgent(DpCompanyAgent dpCompanyAgent)
    {
        clickActionButtonOnTable(1, ACTION_BUTTON_EDIT);
        waitUntilVisibilityOfElementLocated("//md-dialog[contains(@class, 'dp-agent-edit')]");
        fillTheFormAndSubmit(dpCompanyAgent);
    }

    private void fillTheFormAndSubmit(DpCompanyAgent dpCompanyAgent)
    {
        sendKeys("//input[@aria-label='Name']", dpCompanyAgent.getName());
        sendKeys("//input[@aria-label='Email']", dpCompanyAgent.getEmail());
        sendKeys("//input[@aria-label='Contact']", dpCompanyAgent.getContact());
        sendKeys("//input[@aria-label='Unlock Code']", dpCompanyAgent.getUnlockCode());
        click("//button[@aria-label='Save Button']");
        waitUntilInvisibilityOfElementLocated("//button[@aria-label='Save Button']//md-progress-circular");
    }

    public void deleteDpCompanyAgent(DpCompanyAgent dpCompanyAgent)
    {
        searchTableByName(dpCompanyAgent.getName());
        clickActionButtonOnTable(1, ACTION_BUTTON_DELETE);
        pause100ms();
        click("//md-dialog/md-dialog-actions/button[@aria-label='Delete']");
    }

    public void verifyDpCompanyAgentIsCreatedSuccessfully(DpCompanyAgent dpCompanyAgent)
    {
        searchTableByName(dpCompanyAgent.getName());
        verifyDpCompanyInfoIsCorrect(dpCompanyAgent);
    }

    public void verifyDpCompanyAgentIsUpdatedSuccessfully(DpCompanyAgent dpCompanyAgent)
    {
        verifyDpCompanyInfoIsCorrect(dpCompanyAgent);
    }

    private void verifyDpCompanyInfoIsCorrect(DpCompanyAgent dpCompanyAgent)
    {
        String actualName = getTextOnTable(1, COLUMN_CLASS_NAME);
        Assert.assertEquals("DP Company Agent Name", dpCompanyAgent.getName(), actualName);

        String actualEmail = getTextOnTable(1, COLUMN_CLASS_EMAIL);
        Assert.assertEquals("DP Company Agent Email", dpCompanyAgent.getEmail(), actualEmail);

        String actualContact = getTextOnTable(1, COLUMN_CLASS_CONTACT_NO);
        Assert.assertEquals("DP Company Agent Contact", dpCompanyAgent.getContact(), actualContact);

        String actualUnlockCode = getTextOnTable(1, COLUMN_CLASS_UNLOCK_CODE);
        Assert.assertEquals("DP Company Agent Unlock Code", dpCompanyAgent.getUnlockCode(), actualUnlockCode);
    }

    public void verifyDpCompanyAgentIsDeletedSuccessfully(DpCompanyAgent dpCompanyAgent)
    {
        searchTableByName(dpCompanyAgent.getName());
        boolean isTableEmpty = isTableEmpty();
        Assert.assertTrue("DP Company Agent still exist in table. Fail to delete DP Company Agent.", isTableEmpty);
    }

    public void backToDpCompanyManagementPage(DpCompany dpCompany)
    {
        click(String.format("//button[contains(@aria-label, '%s')]", dpCompany.getName()));
        waitUntilVisibilityOfElementLocated("//button[@aria-label='Add Company']");
    }

    public void searchTableByName(String name)
    {
        sendKeys("//th[contains(@class, 'name')]/nv-search-input-filter/md-input-container/div/input", name);
        pause100ms();
    }

    public boolean isTableEmpty()
    {
        WebElement we = findElementByXpath("//h5[text()='No Results Found']");
        return we!=null;
    }

    public String getTextOnTable(int rowNumber, String columnDataClass)
    {
        return getTextOnTable(rowNumber, columnDataClass, MD_VIRTUAL_REPEAT);
    }

    public void clickActionButtonOnTable(int rowNumber, String actionButtonName)
    {
        clickActionButtonOnTableWithMdVirtualRepeat(rowNumber, actionButtonName, MD_VIRTUAL_REPEAT);
    }
}
