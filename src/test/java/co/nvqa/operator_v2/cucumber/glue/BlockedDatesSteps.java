package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.operator_v2.selenium.page.BlockedDatesPage;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import cucumber.runtime.java.guice.ScenarioScoped;

/**
 *
 * @author Soewandi Wirjawan
 *
 * Modified by Daniel Joi Partogi Hutapea
 */
@ScenarioScoped
public class BlockedDatesSteps extends AbstractSteps
{
    private BlockedDatesPage blockedDatesPage;

    public BlockedDatesSteps()
    {
    }

    @Override
    public void init()
    {
        blockedDatesPage = new BlockedDatesPage(getWebDriver());
    }

    @When("^blocked dates add$")
    public void add()
    {
        blockedDatesPage.addBlockedDate();
    }

    @Then("^blocked dates verify add$")
    public void verifyAdd()
    {
        blockedDatesPage.verifyBlockedDateAddedSuccessfully();
    }

    @When("^blocked dates remove$")
    public void remove()
    {
        blockedDatesPage.removeBlockedDate();
    }

    @Then("^blocked dates verify remove$")
    public void verifyRemove()
    {
        blockedDatesPage.verifyBlockedDateRemovedSuccessfully();
    }
}
