package co.nvqa.operator_v2.cucumber.glue.step;

import com.google.inject.Inject;
import com.nv.qa.model.order_creation.v2.Order;
import co.nvqa.operator_v2.selenium.page.FailedDeliveryManagementPage;
import co.nvqa.operator_v2.support.ScenarioStorage;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;

/**
 *
 * @author Daniel Joi Partogi Hutapea
 */
public class FailedDeliveryManagementSteps extends AbstractSteps
{
    @Inject private ScenarioStorage scenarioStorage;
    private FailedDeliveryManagementPage failedDeliveryManagementPage;

    @Inject
    public FailedDeliveryManagementSteps(ScenarioManager scenarioManager)
    {
        super(scenarioManager);
    }

    @Override
    public void init()
    {
        failedDeliveryManagementPage = new FailedDeliveryManagementPage(getDriver());
    }

    @Then("^Operator verify the failed delivery order is listed on Failed Delivery orders list$")
    public void operatorVerifyTheFailedDeliveryOrderIsListedOnFailedDeliveryOrderList()
    {
        Order order = scenarioStorage.get("order");
        String trackingId = order.getTracking_id();
        String orderType = order.getType();
        failedDeliveryManagementPage.verifyFailedDeliveryOrderIsListed(trackingId, orderType);
    }

    @When("^Operator download CSV file of failed delivery order on Failed Delivery orders list$")
    public void operatorDownloadCsvFileOfFailedDeliveryOrderOnFailedDeliveryOrdersList()
    {
        String trackingId = scenarioStorage.get("trackingId");
        failedDeliveryManagementPage.downloadCsvFile(trackingId);
    }

    @Then("^Operator verify CSV file of failed delivery order on Failed Delivery orders list downloaded successfully$")
    public void operatorVerifyCsvFileOfFailedDeliveryOrderOnFailedDeliveryOrdersListDownloadedSuccessfully()
    {
        String trackingId = scenarioStorage.get("trackingId");
        failedDeliveryManagementPage.verifyCsvFileDownloadedSuccessfully(trackingId);
    }

    @When("^Operator reschedule failed delivery order on next day$")
    public void operatorRescheduleFailedDeliveryOrderOnNextDay()
    {
        String trackingId = scenarioStorage.get("trackingId");
        failedDeliveryManagementPage.rescheduleNextDay(trackingId);
    }

    @Then("^Operator verify failed delivery order rescheduled on next day successfully$")
    public void operatorVerifyFailedDeliveryOrderRescheduleOnNextDaySuccessfully()
    {
        String trackingId = scenarioStorage.get("trackingId");
        failedDeliveryManagementPage.verifyOrderIsRemovedFromTableAfterReschedule(trackingId);
    }

    @When("^Operator reschedule failed delivery order on next 2 days$")
    public void operatorRescheduleFailedDeliveryOrderOnNext2Days()
    {
        String trackingId = scenarioStorage.get("trackingId");
        failedDeliveryManagementPage.rescheduleNext2Days(trackingId);
    }

    @Then("^Operator verify failed delivery order rescheduled on next 2 days successfully$")
    public void operatorVerifyFailedDeliveryOrderRescheduleOnNext2DaysSuccessfully()
    {
        String trackingId = scenarioStorage.get("trackingId");
        failedDeliveryManagementPage.verifyOrderIsRemovedFromTableAfterReschedule(trackingId);
    }

    @When("^Operator RTS failed delivery order on next day$")
    public void operatorRtsFailedDeliveryOrderOnNextDay()
    {
        String trackingId = scenarioStorage.get("trackingId");
        failedDeliveryManagementPage.rtsSingleOrderNextDay(trackingId);
    }

    @Then("^Operator verify failed delivery order RTS-ed successfully$")
    public void operatorVerifyFailedDeliveryOrderRtsedSuccessfully()
    {
        String trackingId = scenarioStorage.get("trackingId");
        failedDeliveryManagementPage.verifyOrderIsRemovedFromTableAfterReschedule(trackingId);
    }

    @When("^Operator RTS selected failed delivery order on next day$")
    public void operatorRtsSelectedFailedDeliveryOrderOnNextDay()
    {
        String trackingId = scenarioStorage.get("trackingId");
        failedDeliveryManagementPage.rtsSelectedOrderNextDay(trackingId);
    }
}
