package co.nvqa.operator_v2.selenium.page;

import co.nvqa.operator_v2.model.DpCompany;
import org.junit.Assert;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;

/**
 *
 * @author Daniel Joi Partogi Hutapea
 */
public class DpCompanyManagementPage extends SimplePage
{
    private static final String MD_VIRTUAL_REPEAT = "company in getTableData()";
    private static final String CSV_FILENAME = "company.csv";

    public static final String COLUMN_CLASS_NAME = "name";
    public static final String COLUMN_CLASS_EMAIL = "email";
    public static final String COLUMN_CLASS_CONTACT_NO = "contact-no";
    public static final String COLUMN_CLASS_DROP_OFF_WEBHOOK_URL = "drop-off-webhook-url";
    public static final String COLUMN_CLASS_COLLECT_WEBHOOK_URL = "collect-webhook-url";
    public static final String COLUMN_CLASS_INTEGRATED = "is-integrated-with-ninjavan";

    public static final String ACTION_BUTTON_EDIT = "Edit";
    public static final String ACTION_BUTTON_DELETE = "Delete";
    public static final String ACTION_BUTTON_SEE_VAULT = "See Vault";

    public DpCompanyManagementPage(WebDriver webDriver)
    {
        super(webDriver);
    }

    public void addDpCompany(DpCompany dpCompany)
    {
        click("//button[@aria-label='Add Company']");
        waitUntilVisibilityOfElementLocated("//md-dialog[contains(@class, 'dp-company-add')]");
        fillTheFormAndSubmit(dpCompany);
        waitUntilInvisibilityOfToast("Created Successfully");
    }

    public void editDpCompany(DpCompany dpCompany)
    {
        clickActionButtonOnTable(1, ACTION_BUTTON_EDIT);
        waitUntilVisibilityOfElementLocated("//md-dialog[contains(@class, 'dp-company-edit')]");
        fillTheFormAndSubmit(dpCompany);
        waitUntilInvisibilityOfToast("Updated Successfully");
    }

    private void fillTheFormAndSubmit(DpCompany dpCompany)
    {
        sendKeys("//input[@aria-label='Name']", dpCompany.getName());
        sendKeys("//input[@aria-label='Email']", dpCompany.getEmail());
        sendKeys("//input[@aria-label='commons.model.contact']", dpCompany.getContact());
        sendKeys("//input[@aria-label='Drop Off Webhook URL']", dpCompany.getDropOffWebhookUrl());
        sendKeys("//input[@aria-label='Collect Webhook URL']", dpCompany.getCollectWebhookUrl());

        WebElement integratedWe = findElementByXpath("//md-switch[@aria-label='Integrated']");
        String actualIntegrated = integratedWe.getText();
        String expectedIntegrated = getIntegratedAsString(dpCompany.isIntegrated());

        if(!actualIntegrated.equals(expectedIntegrated))
        {
            integratedWe.click();
        }

        click("//button[@aria-label='Save Button']");
        waitUntilInvisibilityOfElementLocated("//button[@aria-label='Save Button']//md-progress-circular");
    }

    public void deleteDpCompany(DpCompany dpCompany)
    {
        searchTableByName(dpCompany.getName());
        clickActionButtonOnTable(1, ACTION_BUTTON_DELETE);
        pause100ms();
        click("//md-dialog/md-dialog-actions/button[@aria-label='Delete']");
        waitUntilInvisibilityOfToast("Deleted Successfully");
    }

    public void downloadCsvFile()
    {
        click("//button[@aria-label='Download CSV File']");
    }

    public void verifyCsvFileDownloadedSuccessfully(DpCompany dpCompany)
    {
        String name = dpCompany.getName();
        String email = dpCompany.getEmail();
        String contact = dpCompany.getContact();
        String dropOffWebhookUrl = dpCompany.getDropOffWebhookUrl();
        String collectWebhookUrl = dpCompany.getCollectWebhookUrl();
        String integratedAsBooleanString = getIntegratedAsBooleanString(dpCompany.isIntegrated());
        String expectedText = String.format("\"%s\",\"%s\",\"%s\",\"%s\",\"%s\",%s", name, email, contact, dropOffWebhookUrl, collectWebhookUrl, integratedAsBooleanString);
        verifyFileDownloadedSuccessfully(CSV_FILENAME, expectedText);
    }

    public void verifyDpCompanyIsCreatedSuccessfully(DpCompany dpCompany)
    {
        searchTableByName(dpCompany.getName());
        verifyDpCompanyInfoIsCorrect(dpCompany);
    }

    public void verifyDpCompanyIsUpdatedSuccessfully(DpCompany dpCompany)
    {
        verifyDpCompanyInfoIsCorrect(dpCompany);
    }

    private void verifyDpCompanyInfoIsCorrect(DpCompany dpCompany)
    {
        String actualName = getTextOnTable(1, COLUMN_CLASS_NAME);
        Assert.assertEquals("DP Company Name", dpCompany.getName(), actualName);

        String actualEmail = getTextOnTable(1, COLUMN_CLASS_EMAIL);
        Assert.assertEquals("DP Company Email", dpCompany.getEmail(), actualEmail);

        String actualContact = getTextOnTable(1, COLUMN_CLASS_CONTACT_NO);
        Assert.assertEquals("DP Company Contact", dpCompany.getContact(), actualContact);

        String actualDropOffWebhookUrl = getTextOnTable(1, COLUMN_CLASS_DROP_OFF_WEBHOOK_URL);
        Assert.assertEquals("DP Company Drop Off Webhook URL", dpCompany.getDropOffWebhookUrl(), actualDropOffWebhookUrl);

        String actualCollectWebhookUrl = getTextOnTable(1, COLUMN_CLASS_COLLECT_WEBHOOK_URL);
        Assert.assertEquals("DP Company Collect Webhook URL", dpCompany.getCollectWebhookUrl(), actualCollectWebhookUrl);

        String expectedIntegrated = getIntegratedAsString(dpCompany.isIntegrated());
        String actualIntegrated = getTextOnTable(1, COLUMN_CLASS_INTEGRATED);
        Assert.assertEquals("DP Company Integrated", expectedIntegrated, actualIntegrated);
    }

    public void verifyDpCompanyIsDeletedSuccessfully(DpCompany dpCompany)
    {
        searchTableByName(dpCompany.getName());
        boolean isTableEmpty = isTableEmpty();
        Assert.assertTrue("DP Company still exist in table. Fail to delete DP Company.", isTableEmpty);
    }

    public void verifyAllFiltersWorkFine(DpCompany dpCompany)
    {
        searchTableByName(dpCompany.getName());
        verifyDpCompanyInfoIsCorrect(dpCompany);
        searchTableByEmail(dpCompany.getEmail());
        verifyDpCompanyInfoIsCorrect(dpCompany);
        searchTableByContact(dpCompany.getContact());
        verifyDpCompanyInfoIsCorrect(dpCompany);
        searchTableByDropOffWebhookUrl(dpCompany.getDropOffWebhookUrl());
        verifyDpCompanyInfoIsCorrect(dpCompany);
        searchTableByCollectWebhookUrl(dpCompany.getCollectWebhookUrl());
        verifyDpCompanyInfoIsCorrect(dpCompany);
    }

    public void searchTableByName(String name)
    {
        searchTableCustom1("name", name);
    }

    public void searchTableByEmail(String email)
    {
        searchTableCustom1("email", email);
    }

    public void searchTableByContact(String contactNo)
    {
        searchTableCustom1("contact-no", contactNo);
    }

    public void searchTableByDropOffWebhookUrl(String dropOffWebhookUrl)
    {
        searchTableCustom1("drop-off-webhook-url", dropOffWebhookUrl);
    }

    public void searchTableByCollectWebhookUrl(String collectWebhookUrl)
    {
        searchTableCustom1("collect-webhook-url", collectWebhookUrl);
    }

    public void clickSeeVault(DpCompany dpCompany)
    {
        searchTableByName(dpCompany.getName());
        clickActionButtonOnTable(1, ACTION_BUTTON_SEE_VAULT);
        waitUntilVisibilityOfElementLocated("//button[@aria-label='Add Agent']");
    }

    public String getTextOnTable(int rowNumber, String columnDataClass)
    {
        return getTextOnTable(rowNumber, columnDataClass, MD_VIRTUAL_REPEAT);
    }

    public void clickActionButtonOnTable(int rowNumber, String actionButtonName)
    {
        clickActionButtonOnTableWithMdVirtualRepeat(rowNumber, actionButtonName, MD_VIRTUAL_REPEAT);
    }

    public String getIntegratedAsString(boolean integrated)
    {
        return integrated ? "Integrated" : "Not Integrated";
    }

    public String getIntegratedAsBooleanString(boolean integrated)
    {
        return integrated ? "TRUE" : "FALSE";
    }
}
