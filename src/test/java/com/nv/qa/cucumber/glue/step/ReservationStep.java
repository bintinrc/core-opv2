package com.nv.qa.cucumber.glue.step;

import com.nv.qa.support.CommonUtil;
import com.nv.qa.support.SeleniumHelper;
import com.nv.qa.support.SeleniumSharedDriver;
import cucumber.api.java.Before;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import cucumber.runtime.java.guice.ScenarioScoped;
import org.junit.Assert;
import org.openqa.selenium.*;
import org.openqa.selenium.interactions.Actions;

import java.util.Date;
import java.util.List;

/**
 *
 * @author Soewandi Wirjawan
 */
@ScenarioScoped
public class ReservationStep {

    private WebDriver driver;
    private int eReservation = 0;
    private int nReservation = 0;
    private String comments = "";

//    private static String RESERVED_DATE = "//div[@ng-repeat='day in week track by $index'][contains(@class, 'nvYellow')]"; //-- reservation date.
    private static String RESERVED_DATE = "//span[@class='reservation-calendar-item-time ng-binding']"; //-- the reservation slot inside a date.
    private static String UNRESERVED_DATE = "//div[@ng-repeat='day in week track by $index'][@class='layout-padding ng-scope ng-isolate-scope layout-column flex nvGreen nv-secondary']";

    @Before
    public void setup() {
        driver = SeleniumSharedDriver.getInstance().getDriver();
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
        System.out.println("Reservation count before add new : " + eReservation);

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

            comments = String.format("This reservation is created by automation test from Operator V2. Created at %s.", new Date().toString());
            CommonUtil.inputText(driver, "//md-input-container[@form='createForm']/input[@aria-label='Comments']", comments);

            driver.findElement(By.xpath("//button[@type='submit' and .//span[text()='Create Reservation']]")).click();
            CommonUtil.pause1s();
        }
    }

    @When("^reservation, delete$")
    public void delete() {
        eReservation = driver.findElements(By.xpath(RESERVED_DATE)).size();
        System.out.println("Reservation count before delete : " + eReservation);

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
        System.out.println("Reservation count before edit : " + eReservation);

        List<WebElement> elms = driver.findElements(By.xpath(RESERVED_DATE));
        if (!elms.isEmpty()) {
            WebElement el = elms.get(elms.size() - 1).findElement(By.xpath("//nv-icon-button[@name='Edit Reservation']"));

            Actions action = new Actions(driver);
            action.moveToElement(el).click().perform();

            WebElement timeslot = driver.findElement(By.xpath("//form[@name='editForm']/div/nv-button-timeslot/div/div/button[@aria-label='12PM-3PM' and .//span[text()='12PM-3PM']]"));
            ((JavascriptExecutor) driver).executeScript("arguments[0].scrollIntoView();", timeslot);

            comments = String.format("This reservation is updated by automation test from Operator V2. Updated at %s.", new Date().toString());
            CommonUtil.inputText(driver, "//md-input-container[@form='editForm']/input[@aria-label='Comments']", comments);
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