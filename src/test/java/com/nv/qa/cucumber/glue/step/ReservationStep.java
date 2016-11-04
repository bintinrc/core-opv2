package com.nv.qa.cucumber.glue.step;

import com.nv.qa.support.CommonUtil;
import com.nv.qa.support.SeleniumHelper;
import com.nv.qa.support.SeleniumSharedDriver;
import cucumber.api.Scenario;
import cucumber.api.java.After;
import cucumber.api.java.Before;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import cucumber.runtime.java.guice.ScenarioScoped;
import org.junit.Assert;
import org.openqa.selenium.*;
import org.openqa.selenium.interactions.Actions;

import java.util.List;

/**
 * Created by sw on 10/3/16.
 */
@ScenarioScoped
public class ReservationStep {

    private WebDriver driver;
    private int eReservation = 0;
    private int nReservation = 0;

    private static String RESERVED_DATE = "//div[@ng-repeat='day in week track by $index' and @class='layout-padding ng-scope ng-isolate-scope layout-column flex nvYellow disabled']";
    private static String UNRESERVED_DATE = "//div[@ng-repeat='day in week track by $index' and @class='layout-padding ng-scope ng-isolate-scope layout-column flex nvGreen nv-secondary']";

    @Before
    public void setup() {
        driver = SeleniumSharedDriver.getInstance().getDriver();
    }

    @After
    public void teardown(Scenario scenario) {
        if (scenario.isFailed()) {
            final byte[] screenshot = ((TakesScreenshot) driver).getScreenshotAs(OutputType.BYTES);
            scenario.embed(screenshot, "image/png");
        }
    }

    @When("^reservation, input shipper \"([^\"]*)\" and address \"([^\"]*)\"$")
    public void initResercation(String shipper, String address) throws Exception {
        CommonUtil.inputListBox(driver, "Search or Select Shipper", shipper);
        SeleniumHelper.waitUntilElementVisible(driver, driver.findElement(By.xpath("//input[@placeholder='Search or Select Address']")));

        CommonUtil.inputListBox(driver, "Search or Select Address", address);
        SeleniumHelper.waitUntilElementVisible(driver, driver.findElement(By.xpath("//nv-calendar[@ng-model='ctrl.createForm.selectedDate']")));
    }

    @When("^reservation, create input shipper \"([^\"]*)\" and address \"([^\"]*)\" with volume \"([^\"]*)\"$")
    public void addShipperAndAddress(String shipper, String address, String volume) throws Exception {
        initResercation(shipper, address);
        eReservation = driver.findElements(By.xpath(RESERVED_DATE)).size();

        List<WebElement> elms = driver.findElements(By.xpath(UNRESERVED_DATE));
        if (!elms.isEmpty()) {
            elms.get(0).click();

            WebElement btn = driver.findElement(By.xpath("//button[@ng-click='ctrl.showCreateReservation()']"));
            ((JavascriptExecutor) driver).executeScript("arguments[0].scrollIntoView();", btn);

            CommonUtil.pause1s();
            btn.click();
            CommonUtil.pause1s();
            btn.click();

            driver.findElement(By.xpath("//md-select[@ng-model='ctrl.createForm.approxVolume']")).click();
            List<WebElement> vols = driver.findElements(By.xpath("//md-option[@ng-repeat='volume in ctrl.volumeOptions']/div"));
            for (WebElement v : vols) {
                if (v.isDisplayed() && v.getText().equalsIgnoreCase(volume)) {
                    v.click();
                    break;
                }
            }

            driver.findElement(By.xpath("//button[@type='submit' and .//span[text()='Create Reservation']]")).click();
            CommonUtil.pause1s();
        }
    }

    @When("^reservation, delete$")
    public void delete() {
        eReservation = driver.findElements(By.xpath(RESERVED_DATE)).size();

        List<WebElement> elms = driver.findElements(By.xpath(RESERVED_DATE));
        if (!elms.isEmpty()) {
            WebElement el = elms.get(elms.size() - 1).findElement(By.xpath("//nv-icon-button[@name='Delete Reservation']"));

            Actions action = new Actions(driver);
            action.moveToElement(el).click().perform();
            driver.findElement(By.xpath("//button[span[text()='Delete']]")).click();
            CommonUtil.pause1s();
        }
    }

    @When("^reservation, edit")
    public void edit() {
        eReservation = driver.findElements(By.xpath(RESERVED_DATE)).size();

        List<WebElement> elms = driver.findElements(By.xpath(RESERVED_DATE));
        if (!elms.isEmpty()) {
            WebElement el = elms.get(elms.size() - 1).findElement(By.xpath("//nv-icon-button[@name='Edit Reservation']"));

            Actions action = new Actions(driver);
            action.moveToElement(el).click().perform();

            WebElement timeslot = driver.findElement(By.xpath("//form[@name='editForm']/div/nv-button-timeslot/div/div/button[@aria-label='12PM-3PM' and .//span[text()='12PM-3PM']]"));
            ((JavascriptExecutor) driver).executeScript("arguments[0].scrollIntoView();", timeslot);

            CommonUtil.inputText(driver, "//form[@name='editForm']/div/md-input-container/input[@type='text' and @aria-label='Comments' and @ng-model='model']", "EDIT VALUE");
            driver.findElement(By.xpath("//button[@type='submit' and .//span[text()='Save changes']]")).click();
            CommonUtil.pause1s();
        }
    }

    @Then("^reservation, verify \"([^\"]*)\"")
    public void verify(String type) {
        if (type.equalsIgnoreCase("new")) {
            nReservation = driver.findElements(By.xpath(RESERVED_DATE)).size();
            Assert.assertEquals(eReservation + 1, nReservation);
        }

        if (type.equalsIgnoreCase("edit")) {
            nReservation = driver.findElements(By.xpath(RESERVED_DATE)).size();
            Assert.assertEquals(eReservation, nReservation);
        }

        if (type.equalsIgnoreCase("delete")) {
            nReservation = driver.findElements(By.xpath(RESERVED_DATE)).size();
            Assert.assertEquals(eReservation - 1, nReservation);
        }
    }

}