package com.nv.qa.selenium.page.page;

import com.nv.qa.support.CommonUtil;
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

    public void searchDriver(String value) throws InterruptedException {
        CommonUtil.inputText(driver,
                "//input[@placeholder='Search Drivers...'][@ng-model='searchText']",
                value);
    }

    public void verifyDriver(String value) {
        boolean isFound = false;
        List<WebElement> listDriver = driver.findElements(By.xpath("//tr[@md-virtual-repeat='driver in ctrl.tableData'][@class='ng-scope']"));
        for (WebElement d : listDriver) {
            List<WebElement> el = d.findElements(By.tagName("td"));
            for (WebElement e : el) {
                if (e.getText().trim().length() > 0) {
                    if (e.getText().trim().equalsIgnoreCase(value)) {
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

    public void clickViewContactButton(String name) throws InterruptedException {
        driver.findElement(By.xpath("//tr[@md-virtual-repeat='driver in ctrl.tableData']/td[@class='contact column-locked-right']/md-menu/button")).click();
        CommonUtil.pause1s();

        WebElement el = driver.findElement(By.xpath("//div[@aria-hidden='false']/md-menu-content[@class='contact-info md-nvOrange-theme']/md-menu-item[@class='contact-info-details']/div[1]/div[2]"));
        Assert.assertTrue(name.trim().equalsIgnoreCase(el.getText()));

        CommonUtil.closeModal(driver);
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