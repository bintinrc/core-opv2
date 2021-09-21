package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.operator_v2.selenium.page.EditOrderPage;
import co.nvqa.operator_v2.selenium.page.VanInboundPage;
import io.cucumber.java.en.And;
import io.cucumber.java.en.Then;
import io.cucumber.guice.ScenarioScoped;

/**
 * @author Tristania Siagian
 */
@ScenarioScoped
public class VanInboundSteps extends AbstractSteps {

  private VanInboundPage vanInboundPage;
  private EditOrderPage editOrderPage;

  public VanInboundSteps() {
  }

  @Override
  public void init() {
    vanInboundPage = new VanInboundPage(getWebDriver());
    editOrderPage = new EditOrderPage(getWebDriver());
  }

  @And("^Operator fill the route ID on Van Inbound Page then click enter$")
  public void fillRouteIdOnVanInboundPage() {
    Long routeId = get(KEY_CREATED_ROUTE_ID);
    vanInboundPage.fillRouteIdOnVanInboundPage(String.valueOf(routeId));
  }

  @And("^Operator fill the tracking ID on Van Inbound Page then click enter$")
  public void fillTrackingIdOnVanInboundPage() {
    String trackingId = get(KEY_CREATED_ORDER_TRACKING_ID);
    vanInboundPage.fillTrackingIdOnVanInboundPage(trackingId);
  }

  @Then("^Operator verify the van inbound process is succeed$")
  public void verifyVanInboundSucceed() {
    vanInboundPage.verifyVanInboundSucceed();
  }

  @Then("^Operator verify order scan updated$")
  public void verifyOrderScanUpdated() {
    editOrderPage.waitUntilInvisibilityOfLoadingOrder();
    editOrderPage.verifyInboundIsSucceed();
  }

  @And("^Operator click on start route after van inbounding$")
  public void startRoute() {
    String trackingId = get(KEY_CREATED_ORDER_TRACKING_ID);
    vanInboundPage.startRoute(trackingId);
  }

  @And("^Operator fill the invalid tracking ID ([^\"]*) on Van Inbound Page$")
  public void fillInvalidTrackingId(String trackingId) {
    vanInboundPage.fillTrackingIdOnVanInboundPage(trackingId);
  }

  @Then("^Operator verify the tracking ID ([^\"]*) that has been input on Van Inbound Page is invalid$")
  public void verifyInvalidTrackingId(String trackingId) {
    vanInboundPage.verifyInvalidTrackingId(trackingId);
  }

  @And("^Operator fill the empty tracking ID on Van Inbound Page$")
  public void emptyTrackingId() {
    String trackingId = "";
    vanInboundPage.fillTrackingIdOnVanInboundPage(trackingId);
  }

  @Then("^Operator verify the tracking ID that has been input on Van Inbound Page is empty$")
  public void verifyTrackingIdEmpty() {
    vanInboundPage.verifyTrackingIdEmpty();
  }
}
