package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.model.order_create.v2.OrderRequestV2;
import co.nvqa.commons.utils.StandardScenarioStorage;
import co.nvqa.operator_v2.selenium.page.FailedDeliveryManagementPage;
import com.google.inject.Inject;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import cucumber.runtime.java.guice.ScenarioScoped;

/**
 *
 * @author Daniel Joi Partogi Hutapea
 */
@ScenarioScoped
public class FailedDeliveryManagementSteps extends AbstractSteps
{
    private FailedDeliveryManagementPage failedDeliveryManagementPage;

    @Inject
    public FailedDeliveryManagementSteps(ScenarioManager scenarioManager, StandardScenarioStorage scenarioStorage)
    {
        super(scenarioManager, scenarioStorage);
    }

    @Override
    public void init()
    {
        failedDeliveryManagementPage = new FailedDeliveryManagementPage(getWebDriver());
    }

    @Then("^Operator verify the failed delivery order is listed on Failed Delivery orders list$")
    public void operatorVerifyTheFailedDeliveryOrderIsListedOnFailedDeliveryOrderList()
    {
        OrderRequestV2 orderV2 = get(KEY_CREATED_ORDER);
        String trackingId = orderV2.getTrackingId();
        String orderType = orderV2.getType();
        failedDeliveryManagementPage.verifyFailedDeliveryOrderIsListed(trackingId, orderType);
    }

    @When("^Operator download CSV file of failed delivery order on Failed Delivery orders list$")
    public void operatorDownloadCsvFileOfFailedDeliveryOrderOnFailedDeliveryOrdersList()
    {
        String trackingId = get(KEY_CREATED_ORDER_TRACKING_ID);
        failedDeliveryManagementPage.downloadCsvFile(trackingId);
    }

    @Then("^Operator verify CSV file of failed delivery order on Failed Delivery orders list downloaded successfully$")
    public void operatorVerifyCsvFileOfFailedDeliveryOrderOnFailedDeliveryOrdersListDownloadedSuccessfully()
    {
        String trackingId = get(KEY_CREATED_ORDER_TRACKING_ID);
        failedDeliveryManagementPage.verifyCsvFileDownloadedSuccessfully(trackingId);
    }

    @When("^Operator reschedule failed delivery order on next day$")
    public void operatorRescheduleFailedDeliveryOrderOnNextDay()
    {
        String trackingId = get(KEY_CREATED_ORDER_TRACKING_ID);
        failedDeliveryManagementPage.rescheduleNextDay(trackingId);
    }

    @Then("^Operator verify failed delivery order rescheduled on next day successfully$")
    public void operatorVerifyFailedDeliveryOrderRescheduleOnNextDaySuccessfully()
    {
        String trackingId = get(KEY_CREATED_ORDER_TRACKING_ID);
        failedDeliveryManagementPage.verifyOrderIsRemovedFromTableAfterReschedule(trackingId);
    }

    @When("^Operator reschedule failed delivery order on next 2 days$")
    public void operatorRescheduleFailedDeliveryOrderOnNext2Days()
    {
        String trackingId = get(KEY_CREATED_ORDER_TRACKING_ID);
        failedDeliveryManagementPage.rescheduleNext2Days(trackingId);
    }

    @Then("^Operator verify failed delivery order rescheduled on next 2 days successfully$")
    public void operatorVerifyFailedDeliveryOrderRescheduleOnNext2DaysSuccessfully()
    {
        String trackingId = get(KEY_CREATED_ORDER_TRACKING_ID);
        failedDeliveryManagementPage.verifyOrderIsRemovedFromTableAfterReschedule(trackingId);
    }

    @When("^Operator RTS failed delivery order on next day$")
    public void operatorRtsFailedDeliveryOrderOnNextDay()
    {
        String trackingId = get(KEY_CREATED_ORDER_TRACKING_ID);
        failedDeliveryManagementPage.rtsSingleOrderNextDay(trackingId);
    }

    @Then("^Operator verify failed delivery order RTS-ed successfully$")
    public void operatorVerifyFailedDeliveryOrderRtsedSuccessfully()
    {
        String trackingId = get(KEY_CREATED_ORDER_TRACKING_ID);
        failedDeliveryManagementPage.verifyOrderIsRemovedFromTableAfterReschedule(trackingId);
    }

    @When("^Operator RTS selected failed delivery order on next day$")
    public void operatorRtsSelectedFailedDeliveryOrderOnNextDay()
    {
        String trackingId = get(KEY_CREATED_ORDER_TRACKING_ID);
        failedDeliveryManagementPage.rtsSelectedOrderNextDay(trackingId);
    }
}
