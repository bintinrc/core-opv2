package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.model.core.Order;
import co.nvqa.operator_v2.selenium.page.StampDisassociationPage;
import cucumber.api.java.en.And;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import cucumber.runtime.java.guice.ScenarioScoped;

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

  @And("^Operator enter Stamp ID of the created order on Stamp Disassociation page$")
  public void operatorEnterStampIDOfTheCreatedOrder() {
    String trackingId = get(KEY_CREATED_ORDER_TRACKING_ID);
    stampDisassociationPage.enterStampId(trackingId);
  }

  @Then("^Operator verify order details on Stamp Disassociation page$")
  public void operatorVerifyOrderDetailsOnStampDisassociationPage() {
    Order order = get(KEY_CREATED_ORDER);
    stampDisassociationPage.verifyOrderDetails(order);
  }

  @Then("^Operator verify the label says \"([^\"]*)\" on Stamp Disassociation page$")
  public void operatorVerifyTheLabelSaysOnStampDisassociationPage(String labelText) {
    stampDisassociationPage.verifyLabelText(labelText);
  }

  @And("^Operator enter Invalid Stamp ID on Stamp Disassociation page$")
  public void operatorEnterInvalidStampID() {
    String trackingId = "INVALID_TR_ID";
    stampDisassociationPage.enterStampId(trackingId);
  }

  @Then("Operator will get the ([^\"]*) alert")
  public void operatorWillGetTheAlertOfMessageShown(String toastText) {
    stampDisassociationPage.checkAlert(toastText);
  }

  @When("Operator click on the Disassociate Stamp button")
  public void operatorClickOnTheDisassociateStampButton() {
    stampDisassociationPage.clickOnTheDisassociateStampButton();
  }
}
