package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.model.core.Transaction;
import co.nvqa.operator_v2.selenium.page.AddOrderToRoutePage;
import cucumber.api.java.en.And;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;

/**
 *
 * @author Latika Jamnal
 */

public class AddOrderToRouteSteps extends AbstractSteps
{
    private AddOrderToRoutePage addOrderToRoutePage;

    public AddOrderToRouteSteps()
    {
    }

    @Override
    public void init()
    {
        addOrderToRoutePage = new AddOrderToRoutePage(getWebDriver());
    }

    @When("Operator add the route and transaction type")
    public void operatorAddTheRouteAndTransactionType()
    {
        Long route = get(KEY_CREATED_ROUTE_ID);
        String routeId = Long.toString(route);
        addOrderToRoutePage.setRouteIdAndTransactionType(routeId);
    }

    @When("Operator add the prefix")
    public void operatorAddThePrefix()
    {
        addOrderToRoutePage.addPrefix();
    }

    @And("Operator enters the valid tracking id")
    public void operatorEntersTheValidTrackingId()
    {
        String trackingId = get(KEY_CREATED_ORDER_TRACKING_ID);
        addOrderToRoutePage.enterTrackingId(trackingId);
    }

    @And("Operator enters the invalid tracking Id")
    public void operatorEntersTheInvalidTrackingId() {
        String trackingId = "NVSGTEST" + f(String.valueOf(System.currentTimeMillis() / 1000));
        put(KEY_CREATED_ORDER_TRACKING_ID, trackingId);
        addOrderToRoutePage.enterTrackingId(trackingId);
    }

    @Then("Operator verifies the last scanned with prefix tracking id")
    public void operatorVerifiesTheLastScannedTrackingId()
    {
        String trackingId = get(KEY_CREATED_ORDER_TRACKING_ID);
        addOrderToRoutePage.verifyLastScannedWithPrefix(trackingId);
    }

    @And("Operator verifies error messages")
    public void operatorVerifiesErrorMessages()
    {
        String trackingId = get(KEY_CREATED_ORDER_TRACKING_ID);
        String errorMessage = "Order DD"+trackingId+" not found!";
        addOrderToRoutePage.verifyErrorMessage(errorMessage);
    }

    @And("Operator verifies the success messages")
    public void operatorVerifiesTheSuccessMessages()
    {
        String trackingId = get(KEY_CREATED_ORDER_TRACKING_ID);
        String routeId = get(KEY_CREATED_ROUTE_ID).toString();
        String successMessage = "Order "+trackingId+" added to route "+routeId;
        addOrderToRoutePage.verifySuccessMessage(successMessage);
    }

    @Then("Operator verifies the last scanned without prefix tracking id")
    public void operatorVerifiesTheLastScannedWithoutPrefixTrackingId()
    {
        String trackingId = get(KEY_CREATED_ORDER_TRACKING_ID);
        addOrderToRoutePage.verifyLastScannedWithoutPrefix(trackingId);
    }

    @And("Operator verifies transaction tables for route")
    public void operatorVerifiesTransactionTablesForRoute() {
        Transaction transaction = get(KEY_TRANSACTION_DETAILS);
        Long orderId = get(KEY_CREATED_ORDER_ID);
        Long routeId = get(KEY_CREATED_ROUTE_ID);
        addOrderToRoutePage.verifyTransactionRouteDetails(transaction, orderId, routeId);
    }

    @And("Operator verifies error messages without prefix")
    public void operatorVerfiesErrorMessagesWithoutPrefix()
    {
        String trackingId = get(KEY_CREATED_ORDER_TRACKING_ID);
        String errorMessage = "Order "+trackingId+" not found!";
        addOrderToRoutePage.verifyErrorMessage(errorMessage);
    }
}
