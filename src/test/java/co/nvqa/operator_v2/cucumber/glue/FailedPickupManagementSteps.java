package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.operator_v2.selenium.page.FailedPickupManagementPage;
import co.nvqa.operator_v2.util.ScenarioStorage;
import com.google.inject.Inject;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;

/**
 *
 * @author Daniel Joi Partogi Hutapea
 */
public class FailedPickupManagementSteps extends AbstractSteps
{
    @Inject private ScenarioStorage scenarioStorage;
    private FailedPickupManagementPage failedPickupManagementPage;

    @Inject
    public FailedPickupManagementSteps(ScenarioManager scenarioManager)
    {
        super(scenarioManager);
    }

    @Override
    public void init()
    {
        failedPickupManagementPage = new FailedPickupManagementPage(getWebDriver());
    }

    @Then("^Operator verify the failed pickup C2C/Return order is listed on Failed Pickup orders list$")
    public void operatorVerifyTheFailedPickupC2cOrReturnOrderIsListedOnFailedPickupOrderList()
    {
        String trackingId = scenarioStorage.get("trackingId");
        failedPickupManagementPage.verifyTheFailedC2cOrReturnOrderIsListed(trackingId);
    }

    @When("^Operator download CSV file of failed pickup C2C/Return order on Failed Pickup orders list$")
    public void operatorDownloadCsvFileOfFailedPickupC2cOrReturnOrderOnFailedPickupOrdersList()
    {
        String trackingId = scenarioStorage.get("trackingId");
        failedPickupManagementPage.downloadCsvFile(trackingId);
    }

    @Then("^Operator verify CSV file of failed pickup C2C/Return order on Failed Pickup orders list downloaded successfully$")
    public void operatorVerifyCsvFileOfFailedPickupC2cOrReturnOrderOnFailedPickupOrdersListDownloadedSuccessfully()
    {
        String trackingId = scenarioStorage.get("trackingId");
        failedPickupManagementPage.verifyCsvFileDownloadedSuccessfully(trackingId);
    }

    @When("^Operator reschedule failed pickup C2C/Return order on next day$")
    public void operatorRescheduleFailedPickupC2cOrReturnOrderOnNextDay()
    {
        String trackingId = scenarioStorage.get("trackingId");
        failedPickupManagementPage.rescheduleNextDay(trackingId);
    }

    @Then("^Operator verify failed pickup C2C/Return order rescheduled on next day successfully$")
    public void operatorVerifyFailedPickupC2cOrReturnOrderRescheduleOnNextDaySuccessfully()
    {
        String trackingId = scenarioStorage.get("trackingId");
        failedPickupManagementPage.verifyOrderIsRemovedFromTableAfterReschedule(trackingId);
    }

    @When("^Operator reschedule failed pickup C2C/Return order on next 2 days$")
    public void operatorRescheduleFailedPickupC2cOrReturnOrderOnNext2Days()
    {
        String trackingId = scenarioStorage.get("trackingId");
        failedPickupManagementPage.rescheduleNext2Days(trackingId);
    }

    @Then("^Operator verify failed pickup C2C/Return order rescheduled on next 2 days successfully$")
    public void operatorVerifyFailedPickupC2cOrReturnOrderRescheduleOnNext2DaysSuccessfully()
    {
        String trackingId = scenarioStorage.get("trackingId");
        failedPickupManagementPage.verifyOrderIsRemovedFromTableAfterReschedule(trackingId);
    }
}
