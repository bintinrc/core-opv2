package com.nv.qa.selenium.page.page;

import com.nv.qa.support.APIEndpoint;
import com.nv.qa.support.DateUtil;
import com.nv.qa.support.ScenarioHelper;
import org.junit.Assert;
import org.openqa.selenium.NoSuchElementException;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.PageFactory;

import java.io.File;
import java.util.HashMap;
import java.util.Map;

/**
 *
 * @author Soewandi Wirjawan
 */
public class DpPage extends SimplePage
{
    public static final String COLUMN_CLASS_DP_PARTNER_NAME = "name ng-binding";
    public static final String COLUMN_CLASS_DP_PARTNER_RESTRICTION = "ng-binding";

    public static final String COLUMN_CLASS_DP_NAME = "name ng-binding";
    public static final String COLUMN_CLASS_DP_DIRECTION = "directions ng-binding";

    public static final String COLUMN_CLASS_DP_USER_USERNAME = "username ng-binding";
    public static final String COLUMN_CLASS_DP_USER_CONTACT_NO = "contact-no ng-binding";

    private static final Map<String, String> BTNNAME_FILENAME = new HashMap<String, String>()
    {
        {
            put("dp-partners","dp-partners.csv");
            put("dps","dps.csv");
            put("dp-users","dp-users.csv");
        }
    };

    public DpPage(WebDriver driver)
    {
        super(driver);
        PageFactory.initElements(driver, this);
    }

    public void downloadFile(String type) throws InterruptedException
    {
        click("//div[@filename='" + BTNNAME_FILENAME.get(type) + "']/nv-download-csv-button/div/nv-api-text-button/button");
    }

    public void verifyDownloadedFile(String type)
    {
        String pathname = APIEndpoint.SELENIUM_WRITE_PATH + BTNNAME_FILENAME.get(type);
        File f = new File(pathname);
        boolean isFileExisted = f.exists();

        if(isFileExisted)
        {
            f.delete();
        }

        Assert.assertTrue(pathname + "not exist", isFileExisted);
    }

    public void search(String type) throws InterruptedException
    {
        String placeHolder = null;
        String prefix = null;
        String ngRepeat = null;
        String columnClass = null;

        if(type.equals("dp-partners"))
        {
            placeHolder = "Search Distribution Point Partners...";
            prefix = "Partner %s";
            ngRepeat = "dpPartner in $data";
            columnClass = COLUMN_CLASS_DP_PARTNER_NAME;
        }
        else if(type.equals("dps"))
        {
            placeHolder = "Search Distribution Points...";
            prefix = "DP %s";
            ngRepeat = "dp in $data";
            columnClass = COLUMN_CLASS_DP_NAME;
        }
        else if(type.equals("dp-users"))
        {
            placeHolder = "Search Distribution Point Users...";
            prefix = "user%s";
            ngRepeat = "dpUser in $data";
            columnClass = COLUMN_CLASS_DP_USER_USERNAME;
        }

        String keywords = String.format(prefix, ScenarioHelper.getInstance().getTmpId());
        searchTable(keywords);
        //sendKeys("//input[@placeholder='" + placeHolder + "'][@ng-model='searchText']", keywords);
        pause100ms();

        String expectedValue = String.format(prefix, ScenarioHelper.getInstance().getTmpId());
        String actualValue = getTextOnTable(ngRepeat, 1, columnClass);
        Assert.assertEquals(expectedValue, actualValue);
    }

    public void verifyResult(String type)
    {
        String ngRepeat = null;
        String columnClass = null;
        String expectedValue = null;

        if(type.equals("add dp-partners"))
        {
            ngRepeat = "dpPartner in $data";
            columnClass = COLUMN_CLASS_DP_PARTNER_NAME;
            expectedValue = String.format("Partner %s", ScenarioHelper.getInstance().getTmpId());
        }
        else if(type.equals("add dps"))
        {
            ngRepeat = "dp in $data";
            columnClass = COLUMN_CLASS_DP_NAME;
            expectedValue = String.format("DP %s", ScenarioHelper.getInstance().getTmpId());
        }
        else if(type.equals("add dp-users"))
        {
            ngRepeat = "dpUser in $data";
            columnClass = COLUMN_CLASS_DP_USER_USERNAME;
            expectedValue = String.format("user%s", ScenarioHelper.getInstance().getTmpId());
        }
        else if(type.equals("edit dp-partners"))
        {
            ngRepeat = "dpPartner in $data";
            columnClass = COLUMN_CLASS_DP_PARTNER_RESTRICTION;
            expectedValue = String.format("No restrictions enforced. [%s]", ScenarioHelper.getInstance().getTmpId());
        }
        else if(type.equals("edit dps"))
        {
            ngRepeat = "dp in $data";
            columnClass = COLUMN_CLASS_DP_DIRECTION;
            expectedValue = "No directions provided.";
        }
        else if(type.equals("edit dp-users"))
        {
            ngRepeat = "dpUser in $data";
            columnClass = COLUMN_CLASS_DP_USER_CONTACT_NO;
            expectedValue = String.format("8300%s", ScenarioHelper.getInstance().getTmpId());
        }

        searchTable(expectedValue);
        pause100ms();
        String actualValue = getTextOnTable(ngRepeat, 1, columnClass);
        Assert.assertEquals(expectedValue, actualValue);
    }

    public void clickAddBtn(String type) throws InterruptedException
    {
        String btnXpath = null;

        if(type.equals("dp-partners"))
        {
            btnXpath = "//button[@aria-label='Add Partner']";
        }
        else if(type.equals("dps"))
        {
            btnXpath = "//button[@type='button'][@aria-label='Add DP']";
        }
        else if(type.equals("dp-users"))
        {
            btnXpath = "//button[@type='button'][@aria-label='Add Users']";
        }

        click(btnXpath);
    }

    public void enterDefaultValue(String type) throws InterruptedException
    {
        if(type.equals("dp-partners"))
        {
            String tmpId = DateUtil.getTimestamp();
            ScenarioHelper.getInstance().setTmpId(tmpId);

            sendKeys("//input[@type='text'][@aria-label='Partner Name']", String.format("Partner %s", tmpId));
            sendKeys("//input[@type='text'][@aria-label='POC Name']", String.format("Poc %s", tmpId));
            sendKeys("//input[@type='tel'][@aria-label='POC No.']", String.format("8000%s", tmpId));
            sendKeys("//input[@type='email'][@aria-label='POC Email']", String.format("%s@poc.co", tmpId));
            sendKeys("//textarea[@name='restrictions'][@aria-label='Restrictions']", "NA");
        }
        else if(type.equals("dps"))
        {
            sendKeys("//input[@type='text'][@aria-label='Name']", String.format("DP %s", ScenarioHelper.getInstance().getTmpId()));
            sendKeys("//input[@type='text'][@aria-label='Shortname']", String.format("DP%s", ScenarioHelper.getInstance().getTmpId()));
            sendKeys("//input[@type='tel'][@aria-label='Contact No.']", String.format("8100%s", ScenarioHelper.getInstance().getTmpId()));
            sendKeys("//div[label[text()='Shipper Account']]//input", "QA\n");
            sendKeys("//input[@type='text'][@aria-label='Address Line 1']", "Jl. Utan Kayu Raya No. 76");
            sendKeys("//input[@type='text'][@aria-label='Address Line 2']", "Rawamangun");
            sendKeys("//input[@type='text'][@aria-label='City']", "Jakarta");
            sendKeys("//input[@type='text'][@aria-label='Country']", "Indonesia");
            sendKeys("//input[@type='text'][@aria-label='Postcode']", "13120");
            sendKeys("//input[@type='text'][@aria-label='Latitude']", "-6.1981719");
            sendKeys("//input[@type='text'][@aria-label='Longitude']", "106.8628021");
        }
        else if(type.equals("dp-users"))
        {
            sendKeys("//input[@type='text'][@aria-label='First Name']", "User");
            sendKeys("//input[@type='text'][@aria-label='Last Name']", ScenarioHelper.getInstance().getTmpId());
            sendKeys("//input[@type='tel'][@aria-label='Contact No.']", String.format("8200%s", ScenarioHelper.getInstance().getTmpId()));
            sendKeys("//input[@type='email'][@aria-label='Email']", String.format("%s@poc.co", ScenarioHelper.getInstance().getTmpId()));
            sendKeys("//input[@type='text'][@aria-label='Username']", String.format("user%s", ScenarioHelper.getInstance().getTmpId()));
            sendKeys("//input[@type='password'][@aria-label='Password']", "Ninjitsu89");
        }

        click("//button[@type='submit'][@aria-label='Save Button']");
    }


    public void clickEditBtn(String type) throws InterruptedException
    {
        String ngRepeat = null;
        String columnClass = null;
        String placeHolder = null;
        String textAreaXpath = null;
        String editValue = null;

        if(type.equals("dp-partners"))
        {
            ngRepeat = "dpPartner in $data";
            columnClass = COLUMN_CLASS_DP_PARTNER_NAME;
            placeHolder = "Search Distribution Point Partners...";
            textAreaXpath = "//textarea[@name='restrictions'][@aria-label='Restrictions']";
            editValue = String.format("No restrictions enforced. [%s]", ScenarioHelper.getInstance().getTmpId());
        }
        else if(type.equals("dps"))
        {
            ngRepeat = "dp in $data";
            columnClass = COLUMN_CLASS_DP_NAME;

            placeHolder = "Search Distribution Points...";
            textAreaXpath = "//textarea[@name='directions'][@aria-label='Directions']";
            editValue = "No directions provided.";
        }
        else if(type.equals("dp-users"))
        {
            ngRepeat = "dpUser in $data";
            columnClass = COLUMN_CLASS_DP_USER_USERNAME;

            placeHolder = "Search Distribution Point Users...";
            textAreaXpath = "//input[@type='tel'][@aria-label='Contact No.']";
            editValue = String.format("8300%s", ScenarioHelper.getInstance().getTmpId());
        }

        /**
         * Verify searching results.
         */
        String expectedValue = findElementByXpath("//input[@placeholder='" + placeHolder + "'][@ng-model='searchText']").getAttribute("value");
        String actualValue = getTextOnTable(ngRepeat, 1, columnClass);
        Assert.assertEquals(expectedValue, actualValue);

        pause100ms();
        click("//nv-icon-button[@name='Edit']");
        pause100ms();

        if(type.equals("dp-users"))
        {
            /**
             * Since 9 January 2017, we cannot change DP User password from edit dialog.
             *
             * Password:
             * Please contact it-support if you want to change the password.
             */
            //sendKeys("//input[@type='password'][@aria-label='Password']", "Ninjitsu89");
        }
        else if(type.equals("dps"))
        {
            sendKeys("//div[label[text()='Shipper Account']]//input", "QA\n");
        }

        sendKeys(textAreaXpath, editValue);
        click("//button[@type='submit'][@aria-label='Save Button']");
        pause3s();
    }

    public void clickViewBtn(String type) throws InterruptedException
    {
        if(type.equals("dps"))
        {
            click("//nv-icon-button[@name='View DPs']");
        }
        else if(type.equals("dp-users"))
        {
            click("//nv-icon-button[@name='View Users']");
        }

        pause100ms();
    }

    public void verifyPage(String type) throws InterruptedException
    {
        String mainTitle = null;

        if(type.equals("dps"))
        {
            mainTitle = "Distribution Points";
        }
        else if(type.equals("dp-users"))
        {
            mainTitle = "Distribution Point Users";
        }

        WebElement we = findElementByXpath("//div[@class='data-header ng-scope ng-isolate-scope layout-row']");
        String text = we.getAttribute("main-title");
        pause100ms();
        Assert.assertTrue(text.equals(mainTitle));
    }

    public void searchTable(String keyword)
    {
        sendKeys("//input[@type='text'][@ng-model='searchText']", keyword);
    }

    public String getTextOnTable(String ngRepeat, int rowNumber, String columnDataClass)
    {
        String text = null;

        try
        {
            WebElement we = findElementByXpath(String.format("//tr[@ng-repeat='%s'][%d]/td[@class='%s']", ngRepeat, rowNumber, columnDataClass));
            text = we.getText().trim();
        }
        catch(NoSuchElementException ex)
        {
        }

        return text;
    }
}
