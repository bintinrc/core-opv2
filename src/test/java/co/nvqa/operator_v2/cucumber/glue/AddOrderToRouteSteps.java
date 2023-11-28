package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.model.core.Order;
import co.nvqa.operator_v2.selenium.page.AddOrderToRoutePage;
import io.cucumber.java.en.And;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import java.util.List;
import org.assertj.core.api.Assertions;
import org.openqa.selenium.Keys;

/**
 * @author Sergey Mishanin
 */
public class AddOrderToRouteSteps extends AbstractSteps {

  private AddOrderToRoutePage addOrderToRoutePage;

  public AddOrderToRouteSteps() {
  }

  @Override
  public void init() {
    addOrderToRoutePage = new AddOrderToRoutePage(getWebDriver());
  }

  @When("Operator set {string} route id on Add Order to Route page")
  public void operatorAddTheRoute(String routeId) {
    addOrderToRoutePage.routeId.setValue(resolveValue(routeId));
  }

  @When("Operator set {string} transaction type on Add Order to Route page")
  public void operatorSetTransactionType(String transactionType) {
    addOrderToRoutePage.transactionType.selectValue(resolveValue(transactionType));
  }

  @When("Operator add {string} prefix on Add Order to Route page")
  public void operatorAddPrefix(String prefix) {
    addOrderToRoutePage.addPrefix(resolveValue(prefix));
  }

  @When("Operator add prefix of the created order on Add Order to Route page")
  public void operatorAddPrefix() {
    String requestedId;
    String trackingId;
    Order order = get(KEY_CREATED_ORDER);
    if (order != null) {
      requestedId = order.getRequestedTrackingId();
      trackingId = order.getTrackingId();
    } else {
      Object o = ((List<?>) get(
          KEY_LIST_OF_CREATED_ORDERS)).get(0);
      co.nvqa.common.core.model.order.Order comOrder = (co.nvqa.common.core.model.order.Order) o;

      requestedId = comOrder.getRequestedTrackingId();
      trackingId = comOrder.getTrackingId();
    }

    String prefix = trackingId.replace(requestedId, "");
    addOrderToRoutePage.addPrefix(prefix);
  }

  @And("Operator enters {string} tracking id on Add Order to Route page")
  public void operatorEntersTrackingId(String trackingId) {
    trackingId = resolveValue(trackingId);
    addOrderToRoutePage.trackingId.setValue(trackingId + Keys.ENTER);
  }

  @Then("Operator verifies the last scanned tracking id is {string}")
  public void operatorVerifiesTheLastScannedTrackingId(String expectedTrackingId) {
    Assertions.assertThat(addOrderToRoutePage.lastScannedTrackingId.getText())
        .as("Last scanned tracking id").isEqualTo(resolveValue(expectedTrackingId));
  }

  @Then("Operator verifies that {value} does not equal {value}")
  public void valueDoesNotEqual(String actual, String expected) {
    Assertions.assertThat(actual).isNotEqualTo(expected);
  }

  @Then("Operator verifies that {value} equals {value}")
  public void valueEquals(String actual, String expected) {
    Assertions.assertThat(actual).isEqualTo(expected);
  }
}