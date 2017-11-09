package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.operator_v2.support.CommonUtil;
import co.nvqa.operator_v2.support.SeleniumHelper;
import com.google.inject.Inject;
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
        List<WebElement> listOfWe = getDriver().findElements(By.xpath(RESERVED_DATE));
        eReservation = listOfWe.size();

        System.out.println(String.format("===== %s =====", desc));
        System.out.println("Elements:");

        for(WebElement we : listOfWe)
        {
            WebElement parentWe = we.findElement(By.xpath("../../.."));
            System.out.println("Child    : "+we.getAttribute("outerHTML"));
            System.out.println("Parent   : "+parentWe.getAttribute("outerHTML"));
            System.out.println("Tab Index: "+we.getAttribute("tabindex"));
        }

        System.out.println();
        System.out.println("Number of Reserved Date: "+eReservation);
        System.out.println("==========================");
    }

    @When("^reservation, input shipper \"([^\"]*)\" and address \"([^\"]*)\"$")
    public void initReservation(String shipper, String address) throws Exception
    {
        CommonUtil.inputListBox(getDriver(), "Search or Select Shipper", shipper);
        takesScreenshot();
        SeleniumHelper.waitUntilElementVisible(getDriver(), By.xpath("//input[@placeholder='Search or Select Address']"));
        takesScreenshot();

        CommonUtil.inputListBox(getDriver(), "Search or Select Address", address);
        takesScreenshot();
        SeleniumHelper.waitUntilElementVisible(getDriver(), By.xpath("//nv-calendar[@ng-model='ctrl.createForm.selectedDate']"));
        takesScreenshot();
    }

    @When("^reservation, create input shipper \"([^\"]*)\" and address \"([^\"]*)\" with volume \"([^\"]*)\"$")
    public void addShipperAndAddress(String shipper, String address, String volume) throws Exception
    {
        initReservation(shipper, address);
        updateNumberOfReservedDate("BEFORE ADD NEW");

        List<WebElement> elms = getDriver().findElements(By.xpath(UNRESERVED_DATE));
        takesScreenshot();

        if(!elms.isEmpty())
        {
            elms.get(0).click();
            takesScreenshot();

            WebElement btn = getDriver().findElement(By.xpath("//button[@ng-click='ctrl.showCreateReservation()']"));
            takesScreenshot();
            ((JavascriptExecutor) getDriver()).executeScript("arguments[0].scrollIntoView();", btn);
            takesScreenshot();

            CommonUtil.pause1s();
            btn.click();
            takesScreenshot();
            CommonUtil.pause1s();
            btn.click();
            takesScreenshot();

            getDriver().findElement(By.xpath("//md-select[@ng-model='ctrl.createForm.approxVolume']")).click();
            takesScreenshot();
            List<WebElement> vols = getDriver().findElements(By.xpath("//md-option[@ng-repeat='volume in ctrl.volumeOptions']/div"));
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
            CommonUtil.inputText(getDriver(), "//md-input-container[@form='createForm']/input[@aria-label='Comments']", comments);
            takesScreenshot();

            getDriver().findElement(By.xpath("//button[@type='submit' and .//span[text()='Create Reservation']]")).click();
            takesScreenshot();
            CommonUtil.pause1s();
        }
    }

    @When("^reservation, delete$")
    public void delete()
    {
        updateNumberOfReservedDate("BEFORE DELETE");

        List<WebElement> elms = getDriver().findElements(By.xpath(RESERVED_DATE));
        takesScreenshot();

        if(!elms.isEmpty())
        {
            WebElement el = elms.get(elms.size() - 1).findElement(By.xpath("//nv-icon-button[@name='Delete Reservation']"));
            takesScreenshot();

            Actions action = new Actions(getDriver());
            action.moveToElement(el).click().perform();
            takesScreenshot();
            getDriver().findElement(By.xpath("//button[span[text()='Delete']]")).click();
            takesScreenshot();
            CommonUtil.pause1s();
        }
    }

    @When("^reservation, edit")
    public void edit()
    {
        updateNumberOfReservedDate("BEFORE EDIT");

        List<WebElement> elms = getDriver().findElements(By.xpath(RESERVED_DATE));
        takesScreenshot();

        if(!elms.isEmpty())
        {
            WebElement el = elms.get(elms.size()-1).findElement(By.xpath("//nv-icon-button[@name='Edit Reservation']"));

            Actions action = new Actions(getDriver());
            action.moveToElement(el).click().perform();
            takesScreenshot();

            WebElement timeslot = getDriver().findElement(By.xpath("//form[@name='editForm']/div/nv-button-timeslot/div/div/button[@aria-label='12PM-3PM' and .//span[text()='12PM-3PM']]"));
            ((JavascriptExecutor) getDriver()).executeScript("arguments[0].scrollIntoView();", timeslot);
            takesScreenshot();

            comments = String.format("This reservation is updated by automation test from Operator V2. Updated at %s.", new Date().toString());
            CommonUtil.inputText(getDriver(), "//md-input-container[@form='editForm']/input[@aria-label='Comments']", comments);
            takesScreenshot();
            getDriver().findElement(By.xpath("//button[@type='submit' and .//span[text()='Save changes']]")).click();
            takesScreenshot();
            CommonUtil.pause1s();
        }
    }

    @Then("^reservation, verify \"([^\"]*)\"")
    public void verify(String type)
    {
        CommonUtil.pause3s();

        if(type.equalsIgnoreCase("new"))
        {
            nReservation = getDriver().findElements(By.xpath(RESERVED_DATE)).size();
            Assert.assertEquals(eReservation + 1, nReservation);
        }

        if(type.equalsIgnoreCase("edit"))
        {
            nReservation = getDriver().findElements(By.xpath(RESERVED_DATE)).size();
            Assert.assertEquals(eReservation, nReservation);
        }

        if (type.equalsIgnoreCase("delete"))
        {
            nReservation = getDriver().findElements(By.xpath(RESERVED_DATE)).size();
            Assert.assertEquals(eReservation - 1, nReservation);
        }
    }
}