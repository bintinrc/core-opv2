package com.nv.qa.cucumber.glue.step;

import com.nv.qa.model.Linehaul;
import com.nv.qa.selenium.page.page.ShipmentLinehaulPage;
import com.nv.qa.support.JsonHelper;
import com.nv.qa.support.SeleniumSharedDriver;
import cucumber.api.Scenario;
import cucumber.api.java.After;
import cucumber.api.java.Before;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import cucumber.runtime.java.guice.ScenarioScoped;
import org.junit.Assert;
import org.openqa.selenium.OutputType;
import org.openqa.selenium.TakesScreenshot;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Map;

/**
 * Created by lanangjati
 * on 10/24/16.
 */
@ScenarioScoped
public class ShipmentLinehaulStep{

    private WebDriver driver;
    private ShipmentLinehaulPage shipmentLinehaulPage;
    private Linehaul linehaul;

    @Before
    public void setup() {
        driver = SeleniumSharedDriver.getInstance().getDriver();
        shipmentLinehaulPage = new ShipmentLinehaulPage(driver);
    }

    @After
    public void sem(Scenario scenario) {
        if (scenario.isFailed()) {
            final byte[] screenshot = ((TakesScreenshot) driver).getScreenshotAs(OutputType.BYTES);
            scenario.embed(screenshot, "image/png");
        }
    }

    @When("^create new linehaul:$")
    public void createLinehaul(Map<String, String> arg1) throws IOException {
        linehaul = JsonHelper.mapToObject(arg1, Linehaul.class);
        linehaul.setComment("Created at " + new SimpleDateFormat("yyyy-MM-dd").format(new Date()));
        shipmentLinehaulPage.clickCreateLinehaul();
        shipmentLinehaulPage.fillLinehaulNameFT(linehaul.getName());
        shipmentLinehaulPage.fillCommentsFT(linehaul.getComment());
        shipmentLinehaulPage.fillHubs(linehaul.getHubs());
        shipmentLinehaulPage.chooseFrequency(linehaul.getFrequency());
        shipmentLinehaulPage.chooseWorkingDays(linehaul.getDays());
        shipmentLinehaulPage.clickCreateButton();
    }

    @Then("^linehaul exist$")
    public void linehaulExist() throws Throwable {
        shipmentLinehaulPage.search(linehaul.getName());
        List<WebElement> list = shipmentLinehaulPage.grabListOfLinehaulComment();
        boolean isExist = false;
        for (WebElement item : list) {
            String text = item.getText();
            System.out.println("AIVBHELRKUAVJBLAURBVKBADLVNALRNVA " + text);
            if (text.contains(linehaul.getComment())) {
                isExist = true;
                break;
            }
        }

        Assert.assertTrue("linehaul not exist", isExist);
    }
}
