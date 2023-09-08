package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.common.core.model.order.Order;
import co.nvqa.operator_v2.selenium.page.StampDisassociationPage;
import io.cucumber.guice.ScenarioScoped;
import io.cucumber.java.en.And;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import org.assertj.core.api.Assertions;
import org.openqa.selenium.Keys;

/**
 * @author Sergey Mishanin
 */
@ScenarioScoped
public class StampDisassociationSteps extends AbstractSteps {

  private StampDisassociationPage stampDisassociationPage;

  public StampDisassociationSteps() {
  }

  @Override
  public void init() {
    stampDisassociationPage = new StampDisassociationPage(getWebDriver());
  }


  @Then("Operator verify order details on Stamp Disassociation page for order {string}")
  public void operatorVerifyOrderDetailsOnStampDisassociationPage(String orderObject) {
    Order order = resolveValue(orderObject);
    String expectedOrderId = String.format("#%d - %s", order.getId(), order.getTrackingId());
    Assertions.assertThat(stampDisassociationPage.orderId.getText()).as("Order ID")
        .isEqualTo(expectedOrderId);
    Assertions.assertThat(stampDisassociationPage.deliveryAddress.getNormalizedText())
        .as("Delivery Address").isEqualTo(order.buildCompleteToAddress());
  }

  @Then("Operator verify the label says {string} on Stamp Disassociation page")
  public void operatorVerifyTheLabelSaysOnStampDisassociationPage(String labelText) {
    Assertions.assertThat(stampDisassociationPage.stampLabel.getText()).as("Label Text")
        .isEqualTo(resolveValue(labelText));
  }

  @And("Operator enters {string} value into 'Scan Stamp ID' field on Stamp Disassociation page")
  public void operatorEnterIScanStampIdField(String value) {
    stampDisassociationPage.waitWhilePageIsLoading();
    stampDisassociationPage.stampIdInput.setValue(resolveValue(value).toString() + Keys.ENTER);
  }

  @Then("Operator will get the {string} alert on Stamp Disassociation page")
  public void operatorWillGetTheAlertOfMessageShown(String alert) {
    Assertions.assertThat(stampDisassociationPage.alertLabel.getText()).as("Not Found Alert")
        .isEqualTo(resolveValue(alert));
  }

  @When("Operator click on the Disassociate Stamp button")
  public void operatorClickOnTheDisassociateStampButton() {
    stampDisassociationPage.disassociateStamp.clickAndWaitUntilDone();
  }

  @When("Disassociate Stamp button is disabled")
  public void disassociateStampButtonIsDisabled() {
    Assertions.assertThat(stampDisassociationPage.disassociateStamp.isDisabled())
        .as("Disassociate Stamp button is disabled").isTrue();
  }
}
