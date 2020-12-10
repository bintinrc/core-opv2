package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.model.core.Order;
import co.nvqa.operator_v2.selenium.page.AddOrderToRoutePage;
import cucumber.api.java.en.And;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import org.openqa.selenium.Keys;

/**
 * @author Sergey Mishanin
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

    @When("Operator set \"(.+)\" route id on Add Order to Route page")
    public void operatorAddTheRoute(String routeId)
    {
        addOrderToRoutePage.routeId.setValue(resolveValue(routeId));
    }

    @When("Operator set \"(.+)\" transaction type on Add Order to Route page")
    public void operatorSetTransactionType(String transactionType)
    {
        addOrderToRoutePage.transactionType.selectValue(resolveValue(transactionType));
    }

    @When("Operator add \"(.+)\" prefix on Add Order to Route page")
    public void operatorAddPrefix(String prefix)
    {
        addOrderToRoutePage.addPrefix(resolveValue(prefix));
    }

    @When("Operator add prefix of the created order on Add Order to Route page")
    public void operatorAddPrefix()
    {
        Order order = get(KEY_CREATED_ORDER);
        String requestedId = order.getRequestedTrackingId();
        String trackingId = order.getTrackingId();
        String prefix = trackingId.replace(requestedId, "");
        addOrderToRoutePage.addPrefix(prefix);
    }

    @And("Operator enters \"(.+)\" tracking id on Add Order to Route page")
    public void operatorEntersTrackingId(String trackingId)
    {
        trackingId = resolveValue(trackingId);
        addOrderToRoutePage.trackingId.setValue(trackingId + Keys.ENTER);
    }

    @Then("Operator verifies the last scanned tracking id is \"(.+)\"")
    public void operatorVerifiesTheLastScannedTrackingId(String expectedTrackingId)
    {
        assertEquals("Last scanned tracking id", resolveValue(expectedTrackingId), addOrderToRoutePage.lastScannedTrackingId.getText());
    }
}