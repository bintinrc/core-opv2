package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.operator_v2.selenium.page.StampDisassociationPage;
import io.cucumber.guice.ScenarioScoped;
import io.cucumber.java.en.And;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import java.util.Map;
import lombok.val;
import org.assertj.core.api.Assertions;
import org.openqa.selenium.Keys;

/**
 * @author Sergey Mishanin
 */
@ScenarioScoped
public class StampDisassociationSteps extends AbstractSteps {

  private StampDisassociationPage page;

  public StampDisassociationSteps() {
  }

  @Override
  public void init() {
    page = new StampDisassociationPage(getWebDriver());
  }


  @Then("Operator verify order details on Stamp Disassociation page:")
  public void operatorVerifyOrderDetailsOnStampDisassociationPage(Map<String, String> data) {
    val finalData = resolveKeyValues(data);
    page.inFrame(() -> {
      String expectedOrderId = String.format("#%s - %s", finalData.get("orderId"),
          finalData.get("trackingId"));
      Assertions.assertThat(page.orderId.getText()).as("Order ID")
          .isEqualTo(expectedOrderId);
      if (finalData.containsKey("deliveryAddress")) {
        Assertions.assertThat(page.deliveryAddress.getNormalizedText())
            .as("Delivery Address").isEqualTo(finalData.get("deliveryAddress"));
      }
    });
  }

  @Then("Operator verify the label says {string} on Stamp Disassociation page")
  public void operatorVerifyTheLabelSaysOnStampDisassociationPage(String labelText) {
    page.inFrame(() ->
        Assertions.assertThat(page.stampLabel.getText()).as("Label Text")
            .isEqualTo(resolveValue(labelText))
    );
  }

  @And("Operator enters {string} value into 'Scan Stamp ID' field on Stamp Disassociation page")
  public void operatorEnterIScanStampIdField(String value) {
    page.inFrame(() -> {
      page.waitUntilLoaded();
      page.stampIdInput.setValue(resolveValue(value).toString() + Keys.ENTER);
    });
  }

  @Then("Operator will get the {string} alert on Stamp Disassociation page")
  public void operatorWillGetTheAlertOfMessageShown(String alert) {
    page.inFrame(() ->
        Assertions.assertThat(page.alertLabel.getText()).as("Not Found Alert")
            .isEqualTo(resolveValue(alert))
    );
  }

  @When("Operator click on the Disassociate Stamp button")
  public void operatorClickOnTheDisassociateStampButton() {
    page.inFrame(() -> {
      page.disassociateStamp.click();
      page.waitUntilLoaded();
    });
  }

  @When("Disassociate Stamp button is disabled")
  public void disassociateStampButtonIsDisabled() {
    page.inFrame(() ->
        Assertions.assertThat(page.disassociateStamp.isEnabled())
            .as("Disassociate Stamp button is disabled").isFalse()
    );
  }
}