package com.nv.qa.cucumber.glue.step;

import com.nv.qa.model.Linehaul;
import com.nv.qa.selenium.page.page.ShipmentLinehaulPage;
import com.nv.qa.support.CommonUtil;
import com.nv.qa.support.JsonHelper;
import com.nv.qa.support.SeleniumSharedDriver;
import cucumber.api.Scenario;
import cucumber.api.java.After;
import cucumber.api.java.Before;
import cucumber.api.java.en.Given;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import cucumber.runtime.java.guice.ScenarioScoped;
import org.junit.Assert;
import org.openqa.selenium.*;

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
    private String linehaulId = "0";

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

    @When("^op click create linehaul button$")
    public void createActionButtonClicked() throws Throwable {
        shipmentLinehaulPage.clickCreateLinehaul();
    }

    @When("^create new linehaul:$")
    public void createLinehaul(Map<String, String> arg1) throws IOException {
        fillLinehaulForm(arg1);
        shipmentLinehaulPage.clickOnLabelCreate();
        shipmentLinehaulPage.clickCreateButton();
    }

    @Then("^linehaul exist$")
    public void linehaulExist() throws Throwable {
        shipmentLinehaulPage.search(linehaul.getName());
        List<WebElement> list = shipmentLinehaulPage.grabListOfLinehaulComment();
        boolean isExist = false;
        for (WebElement item : list) {
            String text = item.getText();
            if (text.contains(linehaul.getComment())) {
                isExist = true;
                break;
            }
        }

        Assert.assertTrue("linehaul not exist", isExist);
    }

    @Given("^op click tab ([^\"]*)$")
    public void opClickTabLinehaul(String tabName) throws Throwable {
        shipmentLinehaulPage.clickTab(tabName);
    }

    @When("^op search linehaul with name ([^\"]*)$")
    public void op_search_linehaul(String linehaulName) throws Throwable {
        shipmentLinehaulPage.search(linehaulName);
    }

    @When("^op click edit action button$")
    public void editActionButtonClicked() throws Throwable {
        List<WebElement> list = shipmentLinehaulPage.grabListOfLinehaul();
        Linehaul tmp = shipmentLinehaulPage.extractLinehaulInfoFromTable(list.get(0));
        linehaulId = tmp.getId();
        list.get(0).findElement(By.tagName("button")).click();
        CommonUtil.pause1s();
    }

    @When("^edit linehaul with:$")
    public void edit_linehaul_with(Map<String, String> arg1) throws Throwable {
        fillLinehaulForm(arg1);
        shipmentLinehaulPage.clickOnLabelEdit();
        shipmentLinehaulPage.clickSaveChangesButton();
    }

    private void fillLinehaulForm(Map<String, String> arg1) throws IOException {
        linehaul = JsonHelper.mapToObject(arg1, Linehaul.class);
        linehaul.setComment(linehaul.getComment() + " " + new SimpleDateFormat("yyyy-MM-dd").format(new Date()));
        shipmentLinehaulPage.fillLinehaulNameFT(linehaul.getName());
        shipmentLinehaulPage.fillCommentsFT(linehaul.getComment());
        shipmentLinehaulPage.fillHubs(linehaul.getHubs());
        shipmentLinehaulPage.chooseFrequency(linehaul.getFrequency());
        shipmentLinehaulPage.chooseWorkingDays(linehaul.getDays());
    }
}
