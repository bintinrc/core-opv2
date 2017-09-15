package com.nv.qa.cucumber.glue.step;

import com.nv.qa.model.Linehaul;
import com.nv.qa.selenium.page.ShipmentLinehaulPage;
import com.nv.qa.support.CommonUtil;
import com.nv.qa.support.JsonHelper;
import com.nv.qa.support.SeleniumSharedDriver;
import cucumber.api.java.Before;
import cucumber.api.java.en.Given;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import cucumber.runtime.java.guice.ScenarioScoped;
import org.hamcrest.Matchers;
import org.junit.Assert;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.*;

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

    @When("^op click create linehaul button$")
    public void createActionButtonClicked() throws Throwable {
        String url = driver.getCurrentUrl();
        if (url.endsWith("entries")) {
            shipmentLinehaulPage.clickCreateLinehaul();
        } else {
            shipmentLinehaulPage.clickCreateLinehaulOnSchedule();
        }
    }

    @When("^op click delete linehaul button$")
    public void deleteButtonClicked() throws Throwable {
        shipmentLinehaulPage.search(linehaulId);
        List<Linehaul> list = shipmentLinehaulPage.grabListofLinehaul();
        for (Linehaul item : list) {
            if (item.getId().equals(linehaulId)) {
                item.clickDeleteButton();
                break;
            }
        }
    }

    @When("^create new linehaul:$")
    public void createLinehaul(Map<String, String> arg1) throws IOException {
//        shipmentLinehaulPage.clickCreateLinehaul();
        fillLinehaulForm(arg1);
        shipmentLinehaulPage.clickOnLabelCreate();
        shipmentLinehaulPage.clickCreateButton();

        WebElement toast = CommonUtil.getToast(driver);
        Assert.assertTrue("toast message not contain linehaul xxx created", toast.getText().contains("Linehaul") && toast.getText().contains("created"));

        linehaulId = toast.getText().split(" ")[1];
    }

    @Then("^linehaul exist$")
    public void linehaulExist() throws Throwable {

        shipmentLinehaulPage.clickTab("LINEHAUL ENTRIES");
        shipmentLinehaulPage.clickLoadAllShipmentButton();
        shipmentLinehaulPage.search(linehaulId);
        List<WebElement> list = shipmentLinehaulPage.grabListOfLinehaulId();
        boolean isExist = false;
        for (WebElement item : list) {
            String text = item.getText();
            if (text.contains(linehaulId)) {
                isExist = true;
                break;
            }
        }

        Assert.assertTrue("linehaul not exist", isExist);
        CommonUtil.pause3s();
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

        shipmentLinehaulPage.search(linehaulId);
        List<Linehaul> list = shipmentLinehaulPage.grabListofLinehaul();
        for (Linehaul item : list) {
            if (item.getId().equals(linehaulId)) {
                item.clickEditButton();
                break;
            }
        }
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

    @Then("^linehaul deleted$")
    public void linehaulDeleted() throws Throwable {
        String msg = "Success delete Linehaul ID " + linehaulId;
        WebElement toast = CommonUtil.getToast(driver);

        if(toast==null)
        {
            Assert.fail("Cannot find toast message.");
        }
        else
        {
            Assert.assertThat(String.format("Toast message not contains: '%s'", msg), toast.getText(), Matchers.containsString(msg));
        }
    }

    @Then("^linehaul edited$")
    public void linehaul_edited() throws Throwable {
        String msg = "Linehaul " + linehaulId + " updated";
        WebElement toast = CommonUtil.getToast(driver);

        if(toast==null)
        {
            Assert.fail("Cannot find toast message.");
        }
        else
        {
            Assert.assertThat(String.format("Toast message not contains: '%s'", msg), toast.getText(), Matchers.containsString(msg));
        }

        shipmentLinehaulPage.clickTab("LINEHAUL DATE");
        linehaulExist();
        List<Linehaul> list = shipmentLinehaulPage.grabListofLinehaul();
        for (Linehaul item : list) {
            if (item.getId().equals(linehaulId)) {
                Assert.assertEquals("Linehaul name", linehaul.getName(), item.getName());
                Assert.assertEquals("Linehaul frequency", linehaul.getFrequency().toLowerCase(), item.getFrequency().toLowerCase());
                break;
            }
        }
    }

    @Then("^Schedule is right$")
    public void scheduleIsRight() throws Throwable {
        shipmentLinehaulPage.clickTab("LINEHAUL DATE");

        List<Calendar> dates = new ArrayList<>();
        for (String day : linehaul.getDays()) {
            Integer dayNumber = CommonUtil.dayToInteger(day);
            Calendar now = Calendar.getInstance();
            Integer todayNumber = now.get(Calendar.DAY_OF_WEEK);
            Integer diffToDayNumber = dayNumber - todayNumber;
            if (diffToDayNumber < 0) {
                diffToDayNumber += 7;
            }
            now.add(Calendar.DATE, diffToDayNumber);
            dates.add(now);
        }

        for (Calendar date : dates) {
            shipmentLinehaulPage.clickLinhaulScheduleDate(date);
            shipmentLinehaulPage.checkLinehaulAtDate(linehaulId);
        }

    }

    @When("^op click edit linehaul button on schedule$")
    public void op_click_edit_linehaul_button_on_schedule() throws Throwable {
        shipmentLinehaulPage.clickEditLinehaulAtDate(linehaulId);
    }

    @Given("^op click edit linhaul filter$")
    public void op_click_edit_filter() throws Throwable {
        shipmentLinehaulPage.clickEditSearchFilterButton();
        CommonUtil.pause1s();
    }
}
