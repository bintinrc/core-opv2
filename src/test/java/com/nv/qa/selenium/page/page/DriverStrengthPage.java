package com.nv.qa.selenium.page.page;

import com.nv.qa.support.APIEndpoint;
import com.nv.qa.support.CommonUtil;
import com.nv.qa.support.DateUtil;
import com.nv.qa.support.ScenarioHelper;
import org.junit.Assert;
import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.PageFactory;

import java.io.File;
import java.util.List;

/**
 * Created by sw on 7/12/16.
 */
public class DriverStrengthPage {

    private final WebDriver driver;
    private final static String FILENAME = "drivers.csv";
    private String driverType;
    private String zone;

    public DriverStrengthPage(WebDriver driver) {
        this.driver = driver;
        PageFactory.initElements(driver, this);
    }

    public void downloadFile() throws InterruptedException {
        CommonUtil.clickBtn(driver, "//button[@filename='" + FILENAME + "']");
    }

    public void verifyDownloadedFile() {
        File f = new File(APIEndpoint.SELENIUM_WRITE_PATH + FILENAME);
        boolean isFileExisted = f.exists();
        if (isFileExisted) {
            f.delete();
        }
        Assert.assertTrue(isFileExisted);
    }

    public void filteredBy(String type) throws InterruptedException {
        String placeHolder = null;
        String filterKey = null;

        if (type.equals("zone")) {
            placeHolder = "Search or Select Zone(s)";
            filterKey = zone != null ? zone : "z-out of zone";
        } else if (type.equals("driver-type")) {
            placeHolder = "Search or Select Driver Type(s)";
            filterKey = driverType != null ? driverType : "Ops";
        }

        CommonUtil.inputListBox(driver, placeHolder, filterKey);
//        List<WebElement> listDriver = driver.findElements(By.xpath("//tr[@md-virtual-repeat='driver in ctrl.tableData'][@class='ng-scope']"));
        List<WebElement> listDriver = driver.findElements(By.xpath("//tr[@md-virtual-repeat='driver in ctrl.tableData']"));
        CommonUtil.pause100ms();

        Assert.assertTrue(listDriver.size() > 0);
    }

    public void findZoneAndType() {
        CommonUtil.pause100ms();
        driverType = driver.findElement(By.xpath("//tr[@md-virtual-repeat='driver in ctrl.tableData'][1]/td[@class='driver-type']")).getText();
        zone = driver.findElement(By.xpath("//tr[@md-virtual-repeat='driver in ctrl.tableData'][1]/td[@class='zone']/div")).getText();
    }

    public void searchDriver() throws InterruptedException {
        CommonUtil.inputText(driver,
                "//input[@placeholder='Search Drivers...'][@ng-model='searchText']",
                "Driver " + ScenarioHelper.getInstance().getTmpId());
    }

    public void verifyDriver() {
        boolean isFound = false;
//        List<WebElement> listDriver = driver.findElements(By.xpath("//tr[@md-virtual-repeat='driver in ctrl.tableData'][@class='ng-scope']"));
        List<WebElement> listDriver = driver.findElements(By.xpath("//tr[@md-virtual-repeat='driver in ctrl.tableData']"));
        for (WebElement d : listDriver) {
            List<WebElement> el = d.findElements(By.tagName("td"));
            for (WebElement e : el) {
                if (e.getText().trim().length() > 0) {
                    if (e.getText().trim().equalsIgnoreCase("Driver " + ScenarioHelper.getInstance().getTmpId())) {
                        isFound = true;
                    }
                }
            }
        }

        Assert.assertTrue(isFound);
    }

    public void changeComingStatus() throws InterruptedException {
        WebElement firstDriver = driver.findElements(By.xpath("//tr[@md-virtual-repeat='driver in ctrl.tableData']")).get(0);
        String before = getComingStatusState(firstDriver);
        changeComingStatusState(firstDriver);
        String after = getComingStatusState(firstDriver);
        Assert.assertTrue(!before.equals(after));
    }

    public void clickViewContactButton() throws InterruptedException {
        driver.findElement(By.xpath("//tr[@md-virtual-repeat='driver in ctrl.tableData']/td[@class='contact column-locked-right']/md-menu/button")).click();
        CommonUtil.pause1s();

        String name = "Driver " + ScenarioHelper.getInstance().getTmpId();
        boolean isFound = false;
        List<WebElement> elm = driver.findElements(By.xpath("//md-menu-item[@class='contact-info-details' and @role='menuitem']/div/div[@class='ng-binding']"));
        for (WebElement e : elm) {
            if (e.getText().equalsIgnoreCase(name)) {
                isFound = true;
                break;
            }
        }
        Assert.assertTrue(isFound);
        CommonUtil.closeModal(driver);
    }

    public void clickAddNewDriver() {
        CommonUtil.clickBtn(driver, "//button[@aria-label='Add New Driver']");
        CommonUtil.pause1s();
    }

    public void enterDefaultValue() {
        String tmpId = DateUtil.getCurrentTime_HH_MM_SS();
        ScenarioHelper.getInstance().setTmpId(tmpId);


        CommonUtil.inputText(driver, "//input[@type='text'][@aria-label='First Name']", "Driver");
        CommonUtil.inputText(driver, "//input[@type='text'][@aria-label='Last Name']", tmpId);
        CommonUtil.inputText(driver, "//input[@type='text'][@aria-label='Driver License Number']", "D" + tmpId);
        CommonUtil.inputText(driver, "//input[@type='number'][@aria-label='COD Limit']", "100");

        // add vehicle
        CommonUtil.clickBtn(driver, "//button[@aria-label='Add More Vehicles']");
        CommonUtil.inputText(driver, "//input[@type='text'][@aria-label='License Number']", "D" + tmpId);
        CommonUtil.inputText(driver, "//input[@type='number'][@aria-label='Vehicle Capacity']", "100");

        // add contact
        CommonUtil.clickBtn(driver, "//button[@aria-label='Add More Contacts']");
        CommonUtil.inputText(driver, "//input[@type='text'][@aria-label='Contact']", "D" + tmpId + "@NV.CO");

        // add zone
        CommonUtil.clickBtn(driver, "//button[@aria-label='Add More Zones']");
        CommonUtil.inputText(driver, "//input[@type='number'][@aria-label='Min']", "1");
        CommonUtil.inputText(driver, "//input[@type='number'][@aria-label='Max']", "1");
        CommonUtil.inputText(driver, "//input[@type='number'][@aria-label='Cost']", "1");

        // username + password
        CommonUtil.inputText(driver, "//input[@type='text'][@aria-label='Username']", "D" + tmpId);
        CommonUtil.inputText(driver, "//input[@type='text'][@aria-label='Password']", "D00" + tmpId);

        // save
        CommonUtil.clickBtn(driver, "//button[@aria-label='Save Button']");
        CommonUtil.pause10s();
    }

    public void verifyNewDriver() {
        CommonUtil.inputText(driver,
                "//input[@placeholder='Search Drivers...'][@ng-model='searchText']",
                "Driver " + ScenarioHelper.getInstance().getTmpId());
        int size = driver.findElements(By.xpath("//tr[@md-virtual-repeat='driver in ctrl.tableData']")).size();
        Assert.assertTrue(size == 1);
    }

    public void searchingNewDriver() {
        CommonUtil.inputText(driver,
                "//input[@placeholder='Search Drivers...'][@ng-model='searchText']",
                "Driver " + ScenarioHelper.getInstance().getTmpId());
    }

    public void editNewDriver() {
        driver.findElement(By.xpath("//tr[@md-virtual-repeat='driver in ctrl.tableData']/td[@class='actions column-locked-right']/nv-icon-button[1]/button")).click();
        CommonUtil.pause1s();

        CommonUtil.inputText(driver, "//input[@type='number'][@aria-label='Vehicle Capacity']", "1000");
        CommonUtil.clickBtn(driver, "//button[@aria-label='Save Button']");
        CommonUtil.pause1s();
        CommonUtil.closeModal(driver);
    }

    public void deleteNewDriver() {
        driver.findElement(By.xpath("//tr[@md-virtual-repeat='driver in ctrl.tableData']/td[@class='actions column-locked-right']/nv-icon-button[2]/button")).click();
        CommonUtil.pause1s();

        driver.findElement(By.xpath("//md-dialog[@aria-label='Confirm deleteAre you ...']/md-dialog-actions/button[2]")).click();
        CommonUtil.pause1s();
    }

    public void createdDriverShouldNotExist() {
        int size = driver.findElements(By.xpath("//tr[@md-virtual-repeat='driver in ctrl.tableData']")).size();
        Assert.assertTrue(size == 0);
    }

    private void changeComingStatusState(WebElement el) throws InterruptedException {
        CommonUtil.pause1s();
        el.findElement(By.xpath("//td[@class='coming column-locked-right']/nv-toggle-button/button")).click();
        CommonUtil.pause1s();
    }

    private String getComingStatusState(WebElement el) {
        return el.findElement(By.xpath("//td[@class='coming column-locked-right']/nv-toggle-button")).getAttribute("md-theme");
    }

//    private void inputListBox(WebDriver driver, String placeHolder, String searchValue) throws InterruptedException {
//        WebElement el = driver.findElement(By.xpath("//input[@placeholder='" + placeHolder + "']"));
//        el.clear();
//        el.sendKeys(searchValue);
//        CommonUtil.pause1s();
//        el.sendKeys(Keys.RETURN);
//        CommonUtil.pause100ms();
//        CommonUtil.closeModal(driver);
//    }

}