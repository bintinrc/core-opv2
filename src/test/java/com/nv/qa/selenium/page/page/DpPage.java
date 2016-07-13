package com.nv.qa.selenium.page.page;

import com.nv.qa.support.CommonUtil;
import com.nv.qa.support.DateUtil;
import com.nv.qa.support.ScenarioHelper;
import org.junit.Assert;
import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.PageFactory;
import org.openqa.selenium.support.ui.LoadableComponent;

import java.io.File;

/**
 * Created by sw on 7/4/16.
 */
public class DpPage extends LoadableComponent<LoginPage> {

    private final WebDriver driver;
    private final String TMP_STORAGE = "/Users/sw/Downloads/";

    public DpPage(WebDriver driver) {
        this.driver = driver;
        PageFactory.initElements(driver, this);
    }

    @Override
    protected void load() {

    }

    @Override
    protected void isLoaded() throws Error {

    }

    public void downloadFile(String type) throws InterruptedException {
        String filename = null;
        if (type.equals("dp-partners")) {
            filename = "dp-partners.csv";
        } else if (type.equals("dps")) {
            filename = "dps.csv";
        } else if (type.equals("dp-users")) {
            filename = "dp-users.csv";
        }

        CommonUtil.clickBtn(driver, "//button[@filename='" + filename + "']");
    }

    public void verifyDownloadedFile(String type) {
        String filename = null;
        if (type.equals("dp-partners")) {
            filename = "dp-partners.csv";
        } else if (type.equals("dps")) {
            filename = "dps.csv";
        } else if (type.equals("dp-users")) {
            filename = "dp-users.csv";
        }

        File f = new File(TMP_STORAGE + filename);
        boolean isFileExisted = f.exists();
        if (isFileExisted) {
            f.delete();
        }
        Assert.assertTrue(isFileExisted);
    }


    public void search(String type) throws InterruptedException {
        String placeHolder = null;
        String prefix = null;
        String ngTable = null;

        if (type.equals("dp-partners")) {
            placeHolder = "Search Distribution Point Partners...";
            prefix = "Partner %s";
            ngTable = "ctrl.dpPartnersTableParams";
        } else if (type.equals("dps")) {
            placeHolder = "Search Distribution Points...";
            prefix = "DP %s";
            ngTable = "ctrl.dpsTableParams";
        } else if (type.equals("dp-users")) {
            placeHolder = "Search Distribution Point Users...";
            prefix = "user%s";
            ngTable = "ctrl.dpUsersTableParams";
        }

        CommonUtil.inputText(driver,
                "//input[@placeholder='" + placeHolder + "'][@ng-model='searchText']",
                String.format(prefix, ScenarioHelper.getInstance().getTmpId()));

        String txt = String.format(prefix, ScenarioHelper.getInstance().getTmpId());
        WebElement result = CommonUtil.getResultInTable(driver, "//table[@ng-table='" + ngTable + "']/tbody/tr", txt);
        Assert.assertTrue(result != null);
    }


    public void verifyResult(String type) {
        String ngTable = null;
        String expectedValue = null;
        if (type.equals("add dp-partners")) {
            ngTable = "ctrl.dpPartnersTableParams";
            expectedValue = String.format("Partner %s", ScenarioHelper.getInstance().getTmpId());
        } else if (type.equals("add dps")) {
            ngTable = "ctrl.dpsTableParams";
            expectedValue = String.format("DP %s", ScenarioHelper.getInstance().getTmpId());
        } else if (type.equals("add dp-users")) {
            ngTable = "ctrl.dpUsersTableParams";
            expectedValue = String.format("user%s", ScenarioHelper.getInstance().getTmpId());
        } else if (type.equals("edit dp-partners")) {
            ngTable = "ctrl.dpPartnersTableParams";
            expectedValue = "No restrictions enforced.";
        } else if (type.equals("edit dps")) {
            ngTable = "ctrl.dpsTableParams";
            expectedValue = "No directions provided.";
        } else if (type.equals("edit dp-users")) {
            ngTable = "ctrl.dpUsersTableParams";
            expectedValue = String.format("8300%s", ScenarioHelper.getInstance().getTmpId());
        }

        WebElement result = CommonUtil.getResultInTable(driver, "//table[@ng-table='" + ngTable + "']/tbody/tr", expectedValue);
        Assert.assertTrue(result != null);
    }

    public void clickAddBtn(String type) throws InterruptedException {
        String btnXpath = null;
        if (type.equals("dp-partners")) {
            btnXpath = "//button[@aria-label='Add Partner']";
        } else if (type.equals("dps")) {
            btnXpath = "//button[@type='button'][@aria-label='Add DP']";
        } else if (type.equals("dp-users")) {
            btnXpath = "//button[@type='button'][@aria-label='Add Users']";
        }
        CommonUtil.clickBtn(driver, btnXpath);
    }


    public void enterDefaultValue(String type) throws InterruptedException {
        if (type.equals("dp-partners")) {
            String tmpId = DateUtil.getCurrentTime_HH_MM_SS();
            ScenarioHelper.getInstance().setTmpId(tmpId);

            CommonUtil.inputText(driver, "//input[@type='text'][@aria-label='Partner Name']", String.format("Partner %s", tmpId));
            CommonUtil.inputText(driver, "//input[@type='text'][@aria-label='POC Name']", String.format("Poc %s", tmpId));
            CommonUtil.inputText(driver, "//input[@type='tel'][@aria-label='POC No.']", String.format("8000%s", tmpId));
            CommonUtil.inputText(driver, "//input[@type='email'][@aria-label='POC Email']", String.format("%s@%s.poc", tmpId, tmpId));
            CommonUtil.inputText(driver, "//textarea[@name='restrictions'][@aria-label='Restrictions']", "NA");
        } else if (type.equals("dps")) {
            CommonUtil.inputText(driver, "//input[@type='text'][@aria-label='Name']", String.format("DP %s", ScenarioHelper.getInstance().getTmpId()));
            CommonUtil.inputText(driver, "//input[@type='text'][@aria-label='Shortname']", String.format("DP%s", ScenarioHelper.getInstance().getTmpId()));
            CommonUtil.inputText(driver, "//input[@type='tel'][@aria-label='Contact No.']", String.format("8100%s", ScenarioHelper.getInstance().getTmpId()));
            CommonUtil.inputText(driver, "//input[@type='text'][@aria-label='Address Line 1']", "Jl. Utan Kayu Raya No. 76");
            CommonUtil.inputText(driver, "//input[@type='text'][@aria-label='Address Line 2']", "Rawamangun");
            CommonUtil.inputText(driver, "//input[@type='text'][@aria-label='City']", "Jakarta");
            CommonUtil.inputText(driver, "//input[@type='text'][@aria-label='Country']", "Indonesia");
            CommonUtil.inputText(driver, "//input[@type='text'][@aria-label='Postcode']", "13120");
            CommonUtil.inputText(driver, "//input[@type='text'][@aria-label='Latitude']", "-6.1981719");
            CommonUtil.inputText(driver, "//input[@type='text'][@aria-label='Longitude']", "106.8628021");
        } else if (type.equals("dp-users")) {
            CommonUtil.inputText(driver, "//input[@type='text'][@aria-label='First Name']", "User");
            CommonUtil.inputText(driver, "//input[@type='text'][@aria-label='Last Name']", ScenarioHelper.getInstance().getTmpId());
            CommonUtil.inputText(driver, "//input[@type='tel'][@aria-label='Contact No.']", String.format("8200%s", ScenarioHelper.getInstance().getTmpId()));
            CommonUtil.inputText(driver, "//input[@type='email'][@aria-label='Email']", String.format("%s@%s.poc", ScenarioHelper.getInstance().getTmpId(), ScenarioHelper.getInstance().getTmpId()));
            CommonUtil.inputText(driver, "//input[@type='text'][@aria-label='Username']", String.format("user%s", ScenarioHelper.getInstance().getTmpId()));
            CommonUtil.inputText(driver, "//input[@type='password'][@aria-label='Password']", "Ninjitsu89");
        }

        CommonUtil.clickBtn(driver, "//button[@type='submit'][@aria-label='Save Button']");
    }


    public void clickEditBtn(String type) throws InterruptedException {
        String placeHolder = null;
        String ngTable = null;
        String textAreaXpath = null;
        String editValue = null;

        if (type.equals("dp-partners")) {
            placeHolder = "Search Distribution Point Partners...";
            ngTable = "ctrl.dpPartnersTableParams";
            textAreaXpath = "//textarea[@name='restrictions'][@aria-label='Restrictions']";
            editValue = "No restrictions enforced.";
        } else if (type.equals("dps")) {
            placeHolder = "Search Distribution Points...";
            ngTable = "ctrl.dpsTableParams";
            textAreaXpath = "//textarea[@name='directions'][@aria-label='Directions']";
            editValue = "No directions provided.";
        } else if (type.equals("dp-users")) {
            placeHolder = "Search Distribution Point Users...";
            ngTable = "ctrl.dpUsersTableParams";
            textAreaXpath = "//input[@type='tel'][@aria-label='Contact No.']";
            editValue = String.format("8300%s", ScenarioHelper.getInstance().getTmpId());
        }

        WebElement el = CommonUtil.verifySearchingResults(driver, placeHolder, ngTable);
        WebElement editBtn = el.findElement(By.xpath("//nv-icon-button[@name='Edit']"));
        CommonUtil.pause100ms();
        CommonUtil.moveAndClick(driver, editBtn);

        if (type.equals("dp-users")) {
            CommonUtil.inputText(driver, "//input[@type='password'][@aria-label='Password']", "Ninjitsu89");
        }

        CommonUtil.inputText(driver, textAreaXpath, editValue);
        CommonUtil.clickBtn(driver, "//button[@type='submit'][@aria-label='Save Button']");
    }

    public void clickViewBtn(String type) throws InterruptedException {
        if (type.equals("dps")) {
            CommonUtil.clickBtn(driver, "//nv-icon-button[@name='View DPs']");
            CommonUtil.pause100ms();
        } else if(type.equals("dp-users")) {
            CommonUtil.clickBtn(driver, "//nv-icon-button[@name='View Users']");
            CommonUtil.pause100ms();
        }

    }

    public void verifyPage(String type) throws InterruptedException {
        String mainTitle = null;
        if (type.equals("dps")) {
            mainTitle = "Distribution Points";
        } else if (type.equals("dp-users")) {
            mainTitle = "Distribution Point Users";
        }

        WebElement el = driver.findElement(By.xpath("//div[@class='data-header ng-scope ng-isolate-scope layout-row']"));
        String txt = el.getAttribute("main-title");
        CommonUtil.pause100ms();
        Assert.assertTrue(txt.equals(mainTitle));
    }

}
