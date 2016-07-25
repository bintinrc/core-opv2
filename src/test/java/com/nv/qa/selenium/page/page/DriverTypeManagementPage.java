package com.nv.qa.selenium.page.page;

import com.nv.qa.support.APIEndpoint;
import com.nv.qa.support.CommonUtil;
import org.junit.Assert;
import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.PageFactory;

import java.io.File;
import java.util.List;

/**
 * Created by sw on 7/13/16.
 */
public class DriverTypeManagementPage {

    private final WebDriver driver;

    public DriverTypeManagementPage(WebDriver driver) {
        this.driver = driver;
        PageFactory.initElements(driver, this);
    }

    public void filteredBy(String filterValue, String filterType) throws InterruptedException {
        driver.findElement(By.xpath("//button[@aria-label='" + filterValue + "']")).click();
        CommonUtil.pause1s();

        // get counter
        WebElement el = driver.findElement(By.xpath("//ng-pluralize[@class='nv-p-med count']"));
        String counter = el.getText().split(" ")[0];
        if (Integer.parseInt(counter) == 0) {
            return;
        }


        String[] tokens = filterType.toLowerCase().split(" ");
        String className = tokens.length == 2 ? tokens[0] + "-" + tokens[1] : tokens[0];

        boolean valid = true;
        List<WebElement> elm = driver.findElements(By.xpath("//tr[@md-virtual-repeat='driverTypeProp in ctrl.tableData']"));
        for (WebElement e : elm) {
            WebElement t = e.findElement(By.className(className));
            if (!t.getText().toLowerCase().contains(filterValue.toLowerCase()) && !t.getText().toLowerCase().contains("all")) {
                valid = false;
                break;
            }

        }
        Assert.assertTrue(valid);
    }

    public void downloadFile() throws InterruptedException {
        CommonUtil.clickBtn(driver, "//button[@filename='driver-types.csv']");
    }

    public void verifyFile() throws InterruptedException {
        File f = new File(APIEndpoint.SELENIUM_WRITE_PATH + "driver-types.csv");
        boolean isFileExisted = f.exists();
        if (isFileExisted) {
            f.delete();
        }
        Assert.assertTrue(isFileExisted);
    }

    public void clickDriverTypeButton() throws InterruptedException {
        driver.findElement(By.xpath("//button[@aria-label='Create Driver Type']")).click();
        CommonUtil.pause1s();

        CommonUtil.inputText(driver, "//input[@type='text'][@aria-label='Name']", "testing");
        CommonUtil.pause1s();

        driver.findElement(By.xpath("//button[@aria-label='Save Button']")).click();
        CommonUtil.pause1s();
    }

    public void verifyDriverType() throws InterruptedException {
        searchingCreatedDriver();

        boolean isFound = false;
        List<WebElement> elm = driver.findElements(By.xpath("//tr[@md-virtual-repeat='driverTypeProp in ctrl.tableData']"));
        for (WebElement e : elm) {
            List<WebElement> tds = e.findElements(By.tagName("td"));
            for (WebElement td : tds) {
                if (td.getText().equalsIgnoreCase("testing")) {
                    isFound = true;
                    break;
                }
            }
        }

        Assert.assertTrue(isFound);
    }

    public void searchingCreatedDriver() throws InterruptedException {
        CommonUtil.inputText(driver, "//input[@placeholder='Search Driver Types...'][@ng-model='searchText']", "testing");
        CommonUtil.pause1s();
    }

    public void searchingCreatedDriverEdit() throws InterruptedException {
        searchingCreatedDriver();

        driver.findElement(By.xpath("//tr[@md-virtual-repeat='driverTypeProp in ctrl.tableData']/td[9]/nv-icon-button[1]")).click();
        CommonUtil.pause1s();

        driver.findElement(By.xpath("//button[@class='button-group-button md-button md-nvBlue-theme md-ink-ripple'][@aria-label='Normal Delivery']")).click();
        CommonUtil.pause1s();

        driver.findElement(By.xpath("//button[@aria-label='Save Button']")).click();
        CommonUtil.pause1s();
    }

    public void verifyChangesCreatedDriver() {
        boolean isFound = false;
        List<WebElement> elm = driver.findElements(By.xpath("//tr[@md-virtual-repeat='driverTypeProp in ctrl.tableData']"));
        for (WebElement e : elm) {
            List<WebElement> tds = e.findElements(By.tagName("td"));
            for (WebElement td : tds) {
                if (td.getText().equalsIgnoreCase("Normal Delivery")) {
                    isFound = true;
                    break;
                }
            }
        }

        Assert.assertTrue(isFound);
    }

    public void deletedCreatedDriver() throws InterruptedException {
        driver.findElement(By.xpath("//tr[@md-virtual-repeat='driverTypeProp in ctrl.tableData']/td[9]/nv-icon-button[2]")).click();
        CommonUtil.pause1s();

        driver.findElement(By.xpath("//md-dialog[@aria-label='Confirm deleteAre you ...']/md-dialog-actions/button[2]")).click();
        CommonUtil.pause1s();
    }

    public void createdDriverShouldNotExist() {
        List<WebElement> elm = driver.findElements(By.xpath("//tr[@md-virtual-repeat='driverTypeProp in ctrl.tableData']"));
        Assert.assertTrue(elm.size() == 0);
    }
}