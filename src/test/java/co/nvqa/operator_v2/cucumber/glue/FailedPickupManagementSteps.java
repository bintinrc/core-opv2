package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.operator_v2.selenium.page.FailedPickupManagementPage;
import cucumber.api.java.en.And;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import cucumber.runtime.java.guice.ScenarioScoped;

import java.util.Collections;
import java.util.List;

/**
 * @author Daniel Joi Partogi Hutapea
 */
@ScenarioScoped
public class FailedPickupManagementSteps extends AbstractSteps
{
    private FailedPickupManagementPage failedPickupManagementPage;

    public FailedPickupManagementSteps()
    {
    }

    @Override
    public void init()
    {
        failedPickupManagementPage = new FailedPickupManagementPage(getWebDriver());
    }

    @Then("^Operator verify the failed pickup C2C/Return order is listed on Failed Pickup orders list$")
    public void operatorVerifyTheFailedPickupC2cOrReturnOrderIsListedOnFailedPickupOrderList()
    {
        String trackingId = get(KEY_CREATED_ORDER_TRACKING_ID);
        failedPickupManagementPage.verifyTheFailedC2cOrReturnOrderIsListed(trackingId);
    }

    @When("^Operator download CSV file of failed pickup C2C/Return order on Failed Pickup orders list$")
    public void operatorDownloadCsvFileOfFailedPickupC2cOrReturnOrderOnFailedPickupOrdersList()
    {
        String trackingId = get(KEY_CREATED_ORDER_TRACKING_ID);
        failedPickupManagementPage.downloadCsvFile(trackingId);
    }

    @Then("^Operator verify CSV file of failed pickup C2C/Return order on Failed Pickup orders list downloaded successfully$")
    public void operatorVerifyCsvFileOfFailedPickupC2cOrReturnOrderOnFailedPickupOrdersListDownloadedSuccessfully()
    {
        String trackingId = get(KEY_CREATED_ORDER_TRACKING_ID);
        failedPickupManagementPage.verifyCsvFileDownloadedSuccessfully(trackingId);
    }

    @When("^Operator reschedule failed pickup C2C/Return order on next day$")
    public void operatorRescheduleFailedPickupC2cOrReturnOrderOnNextDay()
    {
        String trackingId = get(KEY_CREATED_ORDER_TRACKING_ID);
        failedPickupManagementPage.rescheduleNextDay(trackingId);
    }

    @Then("^Operator verify failed pickup C2C/Return order rescheduled on next day successfully$")
    public void operatorVerifyFailedPickupC2cOrReturnOrderRescheduleOnNextDaySuccessfully()
    {
        String trackingId = get(KEY_CREATED_ORDER_TRACKING_ID);
        failedPickupManagementPage.verifyOrderIsRemovedFromTableAfterReschedule(trackingId);
    }

    @When("^Operator reschedule failed pickup C2C/Return order on next 2 days$")
    public void operatorRescheduleFailedPickupC2cOrReturnOrderOnNext2Days()
    {
        String trackingId = get(KEY_CREATED_ORDER_TRACKING_ID);
        failedPickupManagementPage.rescheduleNext2Days(trackingId);
    }

    @When("^Operator reschedule multiple failed pickup C2C/Return orders on next 2 days$")
    public void operatorRescheduleMultipleFailedPickupC2cOrReturnOrdersOnNext2Days()
    {
        List<String> trackingIds = get(KEY_LIST_OF_CREATED_ORDER_TRACKING_ID);
        failedPickupManagementPage.rescheduleNext2Days(trackingIds);
    }

    @Then("^Operator verify failed pickup C2C/Return order rescheduled on next 2 days successfully$")
    public void operatorVerifyFailedPickupC2cOrReturnOrderRescheduleOnNext2DaysSuccessfully()
    {
        String trackingId = get(KEY_CREATED_ORDER_TRACKING_ID);
        failedPickupManagementPage.verifyOrderIsRemovedFromTableAfterReschedule(trackingId);
    }

    @Then("^Operator verify multiple failed pickup C2C/Return orders rescheduled on next 2 days successfully$")
    public void operatorVerifyMultipleFailedPickupC2cOrReturnOrdersRescheduledOnNext2DaysSuccessfully()
    {
        List<String> trackingIds = get(KEY_LIST_OF_CREATED_ORDER_TRACKING_ID);
        trackingIds.forEach(trackingId -> failedPickupManagementPage.verifyOrderIsRemovedFromTableAfterReschedule(trackingId));
    }

    @And("^Operator cancel order on Failed Pickup Management page$")
    public void operatorCancelOrderOnFailedPickupManagement()
    {
        String trackingId = get(KEY_CREATED_ORDER_TRACKING_ID);
        failedPickupManagementPage.cancelSelected(Collections.singletonList(trackingId));
    }

    @And("^Operator cancel multiple orders on Failed Pickup Management page$")
    public void operatorCancelMultipleOrdersOnFailedPickupManagement()
    {
        List<String> trackingIds = get(KEY_LIST_OF_CREATED_ORDER_TRACKING_ID);
        failedPickupManagementPage.cancelSelected(trackingIds);
    }
}
