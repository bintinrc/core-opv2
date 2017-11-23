package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.operator_v2.util.TestUtils;
import com.google.inject.Inject;
import com.nv.qa.commons.utils.NvLogger;
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
public class ReservationSteps extends AbstractSteps
{
    private int eReservation = 0;
    private int nReservation = 0;
    private String comments = "";

    private static String RESERVED_DATE = "//div[@ng-repeat='day in week track by $index'][contains(@class,'nvYellow')]"; //-- the reservation slot inside a date.
    private static String UNRESERVED_DATE = "//div[@ng-repeat='day in week track by $index'][@class='layout-padding layout-column flex nvGreen nv-secondary']";

    @Inject
    public ReservationSteps(ScenarioManager scenarioManager)
    {
        super(scenarioManager);
    }

    @Override
    public void init()
    {
    }

    private void updateNumberOfReservedDate(String desc)
    {
        List<WebElement> listOfWe = getWebDriver().findElements(By.xpath(RESERVED_DATE));
        eReservation = listOfWe.size();

        NvLogger.infof("===== %s =====", desc);
        NvLogger.info("Elements:");

        for(WebElement we : listOfWe)
        {
            WebElement parentWe = we.findElement(By.xpath("../../.."));
            NvLogger.info("Child    : "+we.getAttribute("outerHTML"));
            NvLogger.info("Parent   : "+parentWe.getAttribute("outerHTML"));
            NvLogger.info("Tab Index: "+we.getAttribute("tabindex"));
        }

        NvLogger.info("");
        NvLogger.info("Number of Reserved Date: "+eReservation);
        NvLogger.info("==========================");
    }

    @When("^reservation, input shipper \"([^\"]*)\" and address \"([^\"]*)\"$")
    public void initReservation(String shipper, String address)
    {
        TestUtils.inputListBox(getWebDriver(), "Search or Select Shipper", shipper);
        takesScreenshot();
        TestUtils.waitUntilElementVisible(getWebDriver(), By.xpath("//input[@placeholder='Search or Select Address']"));
        takesScreenshot();

        TestUtils.inputListBox(getWebDriver(), "Search or Select Address", address);
        takesScreenshot();
        TestUtils.waitUntilElementVisible(getWebDriver(), By.xpath("//nv-calendar[@ng-model='ctrl.createForm.selectedDate']"));
        takesScreenshot();
    }

    @When("^reservation, create input shipper \"([^\"]*)\" and address \"([^\"]*)\" with volume \"([^\"]*)\"$")
    public void addShipperAndAddress(String shipper, String address, String volume)
    {
        initReservation(shipper, address);
        updateNumberOfReservedDate("BEFORE ADD NEW");

        List<WebElement> elms = getWebDriver().findElements(By.xpath(UNRESERVED_DATE));
        takesScreenshot();

        if(!elms.isEmpty())
        {
            elms.get(0).click();
            takesScreenshot();

            WebElement btn = getWebDriver().findElement(By.xpath("//button[@ng-click='ctrl.showCreateReservation()']"));
            takesScreenshot();
            ((JavascriptExecutor) getWebDriver()).executeScript("arguments[0].scrollIntoView();", btn);
            takesScreenshot();

            pause1s();
            btn.click();
            takesScreenshot();
            pause1s();
            btn.click();
            takesScreenshot();

            getWebDriver().findElement(By.xpath("//md-select[@ng-model='ctrl.createForm.approxVolume']")).click();
            takesScreenshot();
            List<WebElement> vols = getWebDriver().findElements(By.xpath("//md-option[@ng-repeat='volume in ctrl.volumeOptions']/div"));
            takesScreenshot();

            for(WebElement v : vols)
            {
                if(v.isDisplayed() && v.getText().equalsIgnoreCase(volume))
                {
                    v.click();
                    takesScreenshot();
                    break;
                }
            }

            comments = String.format("This reservation is created by automation test from Operator V2. Created at %s.", new Date().toString());
            TestUtils.inputText(getWebDriver(), "//md-input-container[@form='createForm']/input[@aria-label='Comments']", comments);
            takesScreenshot();

            getWebDriver().findElement(By.xpath("//button[@type='submit' and .//span[text()='Create Reservation']]")).click();
            takesScreenshot();
            pause1s();
        }
    }

    @When("^reservation, delete$")
    public void delete()
    {
        updateNumberOfReservedDate("BEFORE DELETE");

        List<WebElement> elms = getWebDriver().findElements(By.xpath(RESERVED_DATE));
        takesScreenshot();

        if(!elms.isEmpty())
        {
            WebElement el = elms.get(elms.size() - 1).findElement(By.xpath("//nv-icon-button[@name='Delete Reservation']"));
            takesScreenshot();

            Actions action = new Actions(getWebDriver());
            action.moveToElement(el).click().perform();
            takesScreenshot();
            getWebDriver().findElement(By.xpath("//button[span[text()='Delete']]")).click();
            takesScreenshot();
            pause1s();
        }
    }

    @When("^reservation, edit$")
    public void edit()
    {
        updateNumberOfReservedDate("BEFORE EDIT");

        List<WebElement> elms = getWebDriver().findElements(By.xpath(RESERVED_DATE));
        takesScreenshot();

        if(!elms.isEmpty())
        {
            WebElement el = elms.get(elms.size()-1).findElement(By.xpath("//nv-icon-button[@name='Edit Reservation']"));

            Actions action = new Actions(getWebDriver());
            action.moveToElement(el).click().perform();
            takesScreenshot();

            WebElement timeslot = getWebDriver().findElement(By.xpath("//form[@name='editForm']/div/nv-button-timeslot/div/div/button[@aria-label='12PM-3PM' and .//span[text()='12PM-3PM']]"));
            ((JavascriptExecutor) getWebDriver()).executeScript("arguments[0].scrollIntoView();", timeslot);
            takesScreenshot();

            comments = String.format("This reservation is updated by automation test from Operator V2. Updated at %s.", new Date().toString());
            TestUtils.inputText(getWebDriver(), "//md-input-container[@form='editForm']/input[@aria-label='Comments']", comments);
            takesScreenshot();
            getWebDriver().findElement(By.xpath("//button[@type='submit' and .//span[text()='Save changes']]")).click();
            takesScreenshot();
            pause1s();
        }
    }

    @Then("^reservation, verify \"([^\"]*)\"")
    public void verify(String type)
    {
        pause3s();

        if(type.equalsIgnoreCase("new"))
        {
            nReservation = getWebDriver().findElements(By.xpath(RESERVED_DATE)).size();
            Assert.assertEquals(eReservation + 1, nReservation);
        }

        if(type.equalsIgnoreCase("edit"))
        {
            nReservation = getWebDriver().findElements(By.xpath(RESERVED_DATE)).size();
            Assert.assertEquals(eReservation, nReservation);
        }

        if (type.equalsIgnoreCase("delete"))
        {
            nReservation = getWebDriver().findElements(By.xpath(RESERVED_DATE)).size();
            Assert.assertEquals(eReservation - 1, nReservation);
        }
    }
}