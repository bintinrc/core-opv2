package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.operator_v2.model.Linehaul;
import co.nvqa.operator_v2.selenium.page.ShipmentLinehaulPage;
import co.nvqa.operator_v2.util.TestUtils;
import com.google.inject.Inject;
import com.nv.qa.commons.support.JsonHelper;
import cucumber.api.java.en.Given;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import cucumber.runtime.java.guice.ScenarioScoped;
import org.hamcrest.Matchers;
import org.junit.Assert;
import org.openqa.selenium.WebElement;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.*;

/**
 *
 * @author Lanang Jati
 *
 * Modified by Daniel Joi Partogi Hutapea
 */
@ScenarioScoped
public class ShipmentLinehaulSteps extends AbstractSteps
{
    private ShipmentLinehaulPage shipmentLinehaulPage;
    private Linehaul linehaul;
    private String linehaulId = "0";

    @Inject
    public ShipmentLinehaulSteps(ScenarioManager scenarioManager)
    {
        super(scenarioManager);
    }

    @Override
    public void init()
    {
        shipmentLinehaulPage = new ShipmentLinehaulPage(getWebDriver());
    }

    @When("^op click create linehaul button$")
    public void createActionButtonClicked()
    {
        String url = getWebDriver().getCurrentUrl();

        if(url.endsWith("entries"))
        {
            shipmentLinehaulPage.clickCreateLinehaul();
        }
        else
        {
            shipmentLinehaulPage.clickCreateLinehaulOnSchedule();
        }
    }

    @When("^op click delete linehaul button$")
    public void deleteButtonClicked()
    {
        shipmentLinehaulPage.search(linehaulId);
        List<Linehaul> list = shipmentLinehaulPage.grabListofLinehaul();

        for(Linehaul item : list)
        {
            if(item.getId().equals(linehaulId))
            {
                item.clickDeleteButton();
                break;
            }
        }
    }

    @When("^create new linehaul:$")
    public void createLinehaul(Map<String, String> arg1) throws IOException
    {
        //shipmentLinehaulPage.clickCreateLinehaul();
        fillLinehaulForm(arg1);
        shipmentLinehaulPage.clickOnLabelCreate();
        shipmentLinehaulPage.clickCreateButton();

        WebElement toast = TestUtils.getToast(getWebDriver());
        Assert.assertTrue("toast message not contain linehaul xxx created", toast.getText().contains("Linehaul") && toast.getText().contains("created"));

        linehaulId = toast.getText().split(" ")[1];
    }

    @Then("^op wait until 'Linehaul Entries' tab on 'Linehaul Management' page is loaded$")
    public void waitUntilLinehaulEntriesTabIsLoaded()
    {
        shipmentLinehaulPage.waitUntilLinehaulEntriesIsLoaded();
    }

    @Then("^op wait until 'Linehaul Date' tab on 'Linehaul Management' page is loaded$")
    public void waitUntilLinehaulDateTabIsLoaded()
    {
        shipmentLinehaulPage.waitUntilLinehaulDateTabIsLoaded();
    }

    @Then("^linehaul exist$")
    public void linehaulExist()
    {
        shipmentLinehaulPage.clickTab("LINEHAUL ENTRIES");
        shipmentLinehaulPage.clickLoadAllShipmentButton();
        shipmentLinehaulPage.search(linehaulId);
        List<WebElement> list = shipmentLinehaulPage.grabListOfLinehaulId();
        boolean isExist = false;

        for(WebElement item : list)
        {
            String text = item.getText();

            if(text.contains(linehaulId))
            {
                isExist = true;
                break;
            }
        }

        Assert.assertTrue("linehaul not exist", isExist);
        pause3s();
    }

    @Given("^op click tab ([^\"]*)$")
    public void opClickTabLinehaul(String tabName)
    {
        shipmentLinehaulPage.clickTab(tabName);
    }

    @When("^op search linehaul with name ([^\"]*)$")
    public void op_search_linehaul(String linehaulName)
    {
        shipmentLinehaulPage.search(linehaulName);
    }

    @When("^op click edit action button$")
    public void editActionButtonClicked()
    {
        shipmentLinehaulPage.search(linehaulId);
        List<Linehaul> list = shipmentLinehaulPage.grabListofLinehaul();

        for(Linehaul item : list)
        {
            if(item.getId().equals(linehaulId))
            {
                item.clickEditButton();
                break;
            }
        }
    }

    @When("^edit linehaul with:$")
    public void edit_linehaul_with(Map<String, String> arg1) throws IOException
    {
        fillLinehaulForm(arg1);
        shipmentLinehaulPage.clickOnLabelEdit();
        shipmentLinehaulPage.clickSaveChangesButton();
    }

    private void fillLinehaulForm(Map<String, String> arg1) throws IOException
    {
        linehaul = JsonHelper.mapToObject(arg1, Linehaul.class);
        linehaul.setComment(linehaul.getComment() + " " + new SimpleDateFormat("yyyy-MM-dd").format(new Date()));
        shipmentLinehaulPage.fillLinehaulNameFT(linehaul.getName());
        shipmentLinehaulPage.fillCommentsFT(linehaul.getComment());
        shipmentLinehaulPage.fillHubs(linehaul.getHubs());
        shipmentLinehaulPage.chooseFrequency(linehaul.getFrequency());
        shipmentLinehaulPage.chooseWorkingDays(linehaul.getDays());
    }

    @Then("^linehaul deleted$")
    public void linehaulDeleted()
    {
        String msg = "Success delete Linehaul ID " + linehaulId;
        WebElement toast = TestUtils.getToast(getWebDriver());

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
    public void linehaul_edited()
    {
        String msg = "Linehaul " + linehaulId + " updated";
        WebElement toast = TestUtils.getToast(getWebDriver());

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

        for(Linehaul item : list)
        {
            if(item.getId().equals(linehaulId))
            {
                Assert.assertEquals("Linehaul name", linehaul.getName(), item.getName());
                Assert.assertEquals("Linehaul frequency", linehaul.getFrequency().toLowerCase(), item.getFrequency().toLowerCase());
                break;
            }
        }
    }

    @Then("^Schedule is right$")
    public void scheduleIsRight()
    {
        shipmentLinehaulPage.clickTab("LINEHAUL DATE");
        List<Calendar> dates = new ArrayList<>();

        for(String day : linehaul.getDays())
        {
            Integer dayNumber = TestUtils.dayToInteger(day);
            Calendar now = Calendar.getInstance();
            Integer todayNumber = now.get(Calendar.DAY_OF_WEEK);
            Integer diffToDayNumber = dayNumber - todayNumber;

            if(diffToDayNumber < 0)
            {
                diffToDayNumber += 7;
            }

            now.add(Calendar.DATE, diffToDayNumber);
            dates.add(now);
        }

        for(Calendar date : dates)
        {
            shipmentLinehaulPage.clickLinhaulScheduleDate(date);
            shipmentLinehaulPage.checkLinehaulAtDate(linehaulId);
        }
    }

    @When("^op click edit linehaul button on schedule$")
    public void op_click_edit_linehaul_button_on_schedule()
    {
        shipmentLinehaulPage.clickEditLinehaulAtDate(linehaulId);
    }

    @Given("^op click edit linhaul filter$")
    public void op_click_edit_filter()
    {
        shipmentLinehaulPage.clickEditSearchFilterButton();
        pause1s();
    }
}
