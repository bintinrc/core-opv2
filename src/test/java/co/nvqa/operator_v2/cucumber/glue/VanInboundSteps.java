package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.operator_v2.selenium.page.EditOrderPage;
import co.nvqa.operator_v2.selenium.page.VanInboundPage;
import co.nvqa.operator_v2.selenium.page.VanInboundPage.ScannedParcelsDialog.OrderInfo;
import io.cucumber.guice.ScenarioScoped;
import io.cucumber.java.en.And;
import io.cucumber.java.en.Then;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;
import org.apache.commons.lang3.StringUtils;
import org.assertj.core.api.Assertions;
import org.openqa.selenium.Keys;

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

  @And("Operator fill the route ID on Van Inbound Page then click enter")
  public void fillRouteIdOnVanInboundPage() {
    Long routeId = get(KEY_CREATED_ROUTE_ID);
    vanInboundPage.fillRouteIdOnVanInboundPage(String.valueOf(routeId));
  }

  @And("Operator fill the tracking ID on Van Inbound Page then click enter")
  public void fillTrackingIdOnVanInboundPage() {
    String trackingId = get(KEY_CREATED_ORDER_TRACKING_ID);
    vanInboundPage.fillTrackingIdOnVanInboundPage(trackingId);
  }

  @And("Operator enters {value} tracking ID and press enter on Van Inbound Page")
  public void fillTrackingIdOnVanInboundPage(String trackingId) {
    vanInboundPage.trackingId.setValue(trackingId + Keys.ENTER);
  }

  @And("Operator scan {value} tracking ID on Van Inbound Page")
  public void scanTrackingIdOnVanInboundPage(String trackingId) {
    vanInboundPage.trackingIdScan.setValue(trackingId + Keys.ENTER);
    pause2s();
  }

  @Then("Operator verify the van inbound process is succeed")
  public void verifyVanInboundSucceed() {
    vanInboundPage.verifyVanInboundSucceed();
  }

  @Then("Operator verifies {string} scanned parcels displayed on Van Inbound Page")
  public void verifyScannedParcels(String expected) {
    Assertions.assertThat(vanInboundPage.scannedParcelsCount.getText())
        .as("Scanned parcels label")
        .isEqualTo(expected.trim() + " Parcels");
  }

  @Then("Operator click Scanned Parcels area on Van Inbound Page")
  public void clickScannedParcels() {
    vanInboundPage.scannedParcelsCount.click();
  }

  @Then("Operator verifies Scanned Parcels dialog contains orders info:")
  public void checkScannedParcelsDialogTable(List<Map<String, String>> data) {
    data = resolveListOfMaps(data);
    vanInboundPage.scannedParcelsDialog.waitUntilVisible();
    pause2s();
    List<OrderInfo> actual = vanInboundPage.scannedParcelsDialog.ordersTable.readAllEntities();
    List<OrderInfo> expected = data.stream().map(OrderInfo::new).collect(Collectors.toList());

    expected.forEach(item -> {
      OrderInfo actualItem = actual.stream()
          .filter(o -> StringUtils.equals(o.getTrackingId(), item.getTrackingId()))
          .findFirst()
          .orElseThrow(() -> new AssertionError(
              "Order with Tracking Id " + item.getTrackingId() + " was not found"));
      item.compareWithActual(actualItem);
    });
  }

  @Then("Operator verify order scan updated")
  public void verifyOrderScanUpdated() {
    editOrderPage.waitUntilInvisibilityOfLoadingOrder();
    editOrderPage.verifyInboundIsSucceed();
  }

  @And("Operator click on start route after van inbounding")
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

  @And("Operator fill the empty tracking ID on Van Inbound Page")
  public void emptyTrackingId() {
    String trackingId = "";
    vanInboundPage.fillTrackingIdOnVanInboundPage(trackingId);
  }

  @Then("Operator verify the tracking ID that has been input on Van Inbound Page is empty")
  public void verifyTrackingIdEmpty() {
    vanInboundPage.verifyTrackingIdEmpty();
  }
}
