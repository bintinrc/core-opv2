package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.operator_v2.selenium.page.AddOrderToRoutePage;
import io.cucumber.java.en.And;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import java.util.Map;
import org.apache.commons.lang3.StringUtils;
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
    addOrderToRoutePage.inFrame(() -> {
      addOrderToRoutePage.routeId.setValue(resolveValue(routeId));
    });
  }

  @When("Operator set {string} transaction type on Add Order to Route page")
  public void operatorSetTransactionType(String transactionType) {
    addOrderToRoutePage.inFrame((page) -> {
      page.transactionType.selectValue(resolveValue(transactionType));
    });
  }

  @When("Operator add {string} prefix on Add Order to Route page")
  public void operatorAddPrefix(String prefix) {
    addOrderToRoutePage.inFrame(() -> {
      addOrderToRoutePage.addPrefix(resolveValue(prefix));
    });
  }

  @When("Operator add prefix of the created order on Add Order to Route page")
  public void operatorAddPrefix(Map<String, String> data) {
    Map<String, String> resolvedData = resolveKeyValues(data);
    addOrderToRoutePage.inFrame(() -> {
      final String requestedId = resolvedData.get("requestedTrackingId");
      final String trackingId = resolvedData.get("trackingId");
      String prefix = trackingId.replace(requestedId, "");
      addOrderToRoutePage.addPrefix(prefix);
    });
  }

  @And("Operator enters {string} tracking id on Add Order to Route page")
  public void operatorEntersTrackingId(String trackingId) {
    addOrderToRoutePage.inFrame(() -> {
      String trackingIdValue = resolveValue(trackingId);
      addOrderToRoutePage.trackingId.setValue(trackingIdValue + Keys.ENTER);
    });
  }

  @Then("Operator verifies the last scanned tracking id is {string}")
  public void operatorVerifiesTheLastScannedTrackingId(String expectedTrackingId) {
    addOrderToRoutePage.inFrame(() -> {
      Assertions.assertThat(addOrderToRoutePage.lastScannedTrackingId.getText())
          .as("Last scanned tracking id").isEqualTo(resolveValue(expectedTrackingId));
    });
  }

  @Then("Operator verifies that {value} does not equal {value}")
  public void valueDoesNotEqual(String actual, String expected) {
    addOrderToRoutePage.inFrame(() -> {
      Assertions.assertThat(actual).isNotEqualTo(expected);
    });
  }

  @Then("Operator verifies that {value} equals {value}")
  public void valueEquals(String actual, String expected) {
    Assertions.assertThat(actual).isEqualTo(expected);
  }

  @Then("Operator verifies that success notification displayed:")
  @And("Operator verifies that error notification displayed:")
  public void operatorVerifySuccessReactToast(Map<String, String> data) {
    Map<String, String> finalData = resolveKeyValues(data);
    addOrderToRoutePage.inFrame((page) -> {
      String value = finalData.get("top");
      if (StringUtils.isNotBlank(value)) {
        String actual = page.message.getAttribute("textContent");
        Assertions.assertThat(actual).as("toast message is correct").isEqualTo(value);
      }
      value = finalData.get("bottom");
      if (StringUtils.isNotBlank(value)) {
        Assertions.assertThat(page.description.getText()).as("toast description is correct")
            .contains(value);
      }
    });
  }
}