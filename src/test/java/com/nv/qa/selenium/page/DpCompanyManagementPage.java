package com.nv.qa.selenium.page;

import com.nv.qa.model.DpCompany;
import org.junit.Assert;
import org.openqa.selenium.WebDriver;

/**
 *
 * @author Daniel Joi Partogi Hutapea
 */
public class DpCompanyManagementPage extends SimplePage
{
    private static final int MAX_TIMEOUT_IN_SECONDS = 120;
    public static final String COLUMN_CLASS_NAME = "name";
    public static final String COLUMN_CLASS_EMAIL = "email";
    public static final String COLUMN_CLASS_CONTACT_NO = "contact-no";
    public static final String COLUMN_CLASS_DROP_OFF_WEBHOOK_URL = "drop-off-webhook-url";
    public static final String COLUMN_CLASS_COLLECT_WEBHOOK_URL = "collect-webhook-url";
    public static final String COLUMN_CLASS_INTEGRATED = "is-integrated-with-ninjavan";

    public DpCompanyManagementPage(WebDriver driver)
    {
        super(driver);
    }

    public void addDpCompany(DpCompany dpCompany)
    {
        click("//button[@aria-label='Add Company']");
        waitUntilVisibilityOfElementLocated("//md-dialog[contains(@class, 'dp-company-add')]", MAX_TIMEOUT_IN_SECONDS);
        sendKeys("//input[@aria-label='Name']", dpCompany.getName());
        sendKeys("//input[@aria-label='Email']", dpCompany.getEmail());
        sendKeys("//input[@aria-label='commons.model.contact']", dpCompany.getContact());
        sendKeys("//input[@aria-label='Drop Off Webhook URL']", dpCompany.getDropOffWebhookUrl());
        sendKeys("//input[@aria-label='Collect Webhook URL']", dpCompany.getCollectWebhookUrl());
        click("//button[@aria-label='Save Button']");
        waitUntilInvisibilityOfElementLocated("//button[@aria-label='Save Button']//md-progress-circular", MAX_TIMEOUT_IN_SECONDS);
    }

    public void searchTableByName(String name)
    {
        sendKeys("//th[contains(@class, 'name')]/nv-search-input-filter/md-input-container/div/input", name);
    }

    public void verifyDpCompanyIsCreatedSuccessfully(DpCompany dpCompany)
    {
        searchTableByName(dpCompany.getName());

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

        String expectedIntegrated = dpCompany.isIntegrated() ? "Integrated" : "Not Integrated";
        String actualIntegrated = getTextOnTable(1, COLUMN_CLASS_INTEGRATED);
        Assert.assertEquals("DP Company Integrated", expectedIntegrated, actualIntegrated);
    }

    public String getTextOnTable(int rowNumber, String columnDataClass)
    {
        return getTextOnTable(rowNumber, columnDataClass, "company in getTableData()");
    }
}
