package com.nv.qa.selenium.page.page;

import com.nv.qa.support.CommonUtil;
import com.nv.qa.support.DateUtil;
import com.nv.qa.support.ScenarioHelper;
import org.junit.Assert;
import org.openqa.selenium.By;
import org.openqa.selenium.Keys;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.interactions.Actions;
import org.openqa.selenium.support.PageFactory;
import org.openqa.selenium.support.ui.LoadableComponent;

import java.io.File;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by sw on 7/12/16.
 */
public class DriverStrengthPage extends LoadableComponent<LoginPage> {

    private final WebDriver driver;
    private final String TMP_STORAGE = "/Users/sw/Downloads/";

    public DriverStrengthPage(WebDriver driver) {
        this.driver = driver;
        PageFactory.initElements(driver, this);
    }

    @Override
    protected void load() {

    }

    @Override
    protected void isLoaded() throws Error {

    }

    public void downloadFile() throws InterruptedException {
        String filename = "drivers.csv";
        CommonUtil.clickBtn(driver, "//button[@filename='" + filename + "']");
    }

    public void verifyDownloadedFile() {
        String filename = "drivers.csv";
        File f = new File(TMP_STORAGE + filename);
        boolean isFileExisted = f.exists();
        if (isFileExisted) {
            f.delete();
        }
        Assert.assertTrue(isFileExisted);
    }

    public void filteredBy(String type) throws InterruptedException {
        String className = null;
        String placeHolder = null;

        if (type.equals("zone")) {
            className = "zone";
            placeHolder = "Search or Select Zone(s)";
        } else if (type.equals("driver-type")) {
            className = "driver-type ng-binding";
            placeHolder = "Search or Select Driver Type(s)";
        }

        Map<String, Integer> map = numRowsBasedOnClass(className);
        Map.Entry<String, Integer> min = CommonUtil.getMinEntry(map);

        inputListBox(driver, placeHolder, min.getKey());
        List<WebElement> listDriver = driver.findElements(By.xpath("//tr[@md-virtual-repeat='driver in ctrl.tableData'][@class='ng-scope']"));
        CommonUtil.pause100ms();

        Assert.assertTrue(listDriver.size() == min.getValue());
    }

    public void searchDriver() throws InterruptedException {
        CommonUtil.inputText(driver,
                "//input[@placeholder='Search Drivers...'][@ng-model='searchText']",
                "Driver " + ScenarioHelper.getInstance().getTmpId());
    }

    public void verifyDriver() {
        boolean isFound = false;
        List<WebElement> listDriver = driver.findElements(By.xpath("//tr[@md-virtual-repeat='driver in ctrl.tableData'][@class='ng-scope']"));
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
        WebElement firstDriver = driver.findElements(By.xpath("//tr[@md-virtual-repeat='driver in ctrl.tableData'][@class='ng-scope']")).get(0);
        String before = getComingStatusState(firstDriver);
        changeComingStatusState(firstDriver);
        String after = getComingStatusState(firstDriver);
        Assert.assertTrue(!before.equals(after));
    }

    public void clickViewContactButton() throws InterruptedException {
        driver.findElement(By.xpath("//tr[@md-virtual-repeat='driver in ctrl.tableData']/td[@class='contact column-locked-right']/md-menu/button")).click();
        CommonUtil.pause1s();

        String name = "Driver " + ScenarioHelper.getInstance().getTmpId();
        WebElement el = driver.findElement(By.xpath("//div[@aria-hidden='false']/md-menu-content[@class='contact-info md-nvOrange-theme']/md-menu-item[@class='contact-info-details']/div[1]/div[2]"));
        Assert.assertTrue(name.equalsIgnoreCase(el.getText()));

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

    private Map<String, Integer> numRowsBasedOnClass(String className) {
        Map<String, Integer> map = new HashMap<>();
        List<WebElement> listDriver = driver.findElements(By.xpath("//tr[@md-virtual-repeat='driver in ctrl.tableData'][@class='ng-scope']"));
        for (WebElement d : listDriver) {
            List<WebElement> el = d.findElements(By.tagName("td"));
            for (WebElement e : el) {
                if (e.getAttribute("class").equals(className) && e.getText().trim().length() > 0) {
                    if (map.get(e.getText().trim()) != null) {
                        int counter = map.get(e.getText().trim()) + 1;
                        map.put(e.getText(), counter);
                    } else {
                        map.put(e.getText().trim(), 1);
                    }
                }
            }
        }
        return map;
    }

    private void inputListBox(WebDriver driver, String placeHolder, String searchValue) throws InterruptedException {
        WebElement el = driver.findElement(By.xpath("//input[@placeholder='" + placeHolder + "']"));
        el.clear();
        el.sendKeys(searchValue);
        CommonUtil.pause1s();
        el.sendKeys(Keys.RETURN);
        CommonUtil.pause100ms();
        CommonUtil.closeModal(driver);
    }


}