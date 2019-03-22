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

    @When("^Operator adds Blocked Date$")
    public void operatorAddsBlockedDate()
    {
        blockedDatesPage.addBlockedDate();
    }

    @Then("^Operator verifies new Blocked Date is added successfully$")
    public void operatorVerifiesNewBlockedDateIsAddedSuccessfully()
    {
        blockedDatesPage.verifyBlockedDateAddedSuccessfully();
    }

    @When("^Operator removes Blocked Date$")
    public void operatorRemovesBlockedDate()
    {
        blockedDatesPage.removeBlockedDate();
    }

    @Then("^Operator verifies Blocked Date is removed successfully$")
    public void operatorVerifiesBlockedDateIsRemovedSuccessfully()
    {
        blockedDatesPage.verifyBlockedDateRemovedSuccessfully();
    }
}
