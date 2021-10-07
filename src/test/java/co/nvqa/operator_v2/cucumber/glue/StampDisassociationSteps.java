package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.model.core.Order;
import co.nvqa.operator_v2.selenium.page.StampDisassociationPage;
import io.cucumber.java.en.And;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import io.cucumber.guice.ScenarioScoped;
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

  @Then("^Operator verify order details on Stamp Disassociation page$")
  public void operatorVerifyOrderDetailsOnStampDisassociationPage() {
    Order order = get(KEY_CREATED_ORDER);
    String expectedOrderId = String.format("#%d - %s", order.getId(), order.getTrackingId());
    assertEquals("Order ID", expectedOrderId, stampDisassociationPage.orderId.getText());
    assertEquals("Delivery Address", order.buildCompleteToAddress(),
        stampDisassociationPage.deliveryAddress.getNormalizedText());
  }

  @Then("^Operator verify the label says \"([^\"]*)\" on Stamp Disassociation page$")
  public void operatorVerifyTheLabelSaysOnStampDisassociationPage(String labelText) {
    assertEquals("Label Text", resolveValue(labelText),
        stampDisassociationPage.stampLabel.getText());
  }

  @And("Operator enters {string} value into 'Scan Stamp ID' field on Stamp Disassociation page")
  public void operatorEnterIScanStampIdField(String value) {
    stampDisassociationPage.waitWhilePageIsLoading();
    stampDisassociationPage.stampIdInput.setValue(resolveValue(value).toString() + Keys.ENTER);
  }

  @Then("^Operator will get the ([^\"]*) alert on Stamp Disassociation page")
  public void operatorWillGetTheAlertOfMessageShown(String alert) {
    assertEquals("Not Found Alert", resolveValue(alert),
        stampDisassociationPage.alertLabel.getText());
  }

  @When("Operator click on the Disassociate Stamp button")
  public void operatorClickOnTheDisassociateStampButton() {
    stampDisassociationPage.disassociateStamp.clickAndWaitUntilDone();
  }

  @When("Disassociate Stamp button is disabled")
  public void disassociateStampButtonIsDisabled() {
    assertTrue("Disassociate Stamp button is disabled",
        stampDisassociationPage.disassociateStamp.isDisabled());
  }
}
