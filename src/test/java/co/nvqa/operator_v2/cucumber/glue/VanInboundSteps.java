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
import org.junit.Assert;
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

  @Then("Operator confirms that the modal: {string} is displayed and has {int} parcels")
  public void operator_confirms_that_the_modal_is_displayed_and_has_parcels(String modalName, Integer parcelNo) {
    vanInboundPage.waitUntilPageLoaded(60);
    String actualDialogHeader = vanInboundPage.shipmentInboundDialog.dialogHeader.getText().trim();
    String actualCount = vanInboundPage.shipmentInboundDialog.parcelNo.getText().trim();
    Assertions.assertThat(actualDialogHeader)
        .as(f("Assert that the dialog header displayed is %s", modalName))
        .isEqualTo(actualDialogHeader.trim());
    Assertions.assertThat(actualCount)
        .as(f("Assert that the number of parcels is %d", parcelNo))
        .isEqualTo(f("%d Parcels", parcelNo));
  }

  @Then("Operator verifies that tracking id is displayed and proceeds without hub inbounding")
  public void operator_verifies_that_tracking_id_is_displayed_and_proceeds_without_hub_inbounding() {
    String expectedTrackingId = get(KEY_CREATED_ORDER_TRACKING_ID);
    String actualTrackingId = vanInboundPage.shipmentInboundDialog.trackingId.getText().trim();
    Assertions.assertThat(actualTrackingId)
        .as(f("Assert that the tracking id : %s is displayed", expectedTrackingId))
        .isEqualTo(f("1. %s", expectedTrackingId));
    vanInboundPage.shipmentInboundDialog.proceedWithoutInbounding.click();
  }

  @Then("Operator verifies that tracking id is displayed and proceeds with hub inbounding")
  public void operator_verifies_that_tracking_id_is_displayed_and_proceeds_with_hub_inbounding() {
    String expectedTrackingId = get(KEY_CREATED_ORDER_TRACKING_ID);
    String actualTrackingId = vanInboundPage.shipmentInboundDialog.trackingId.getText().trim();
    Assertions.assertThat(actualTrackingId)
        .as(f("Assert that the tracking id : %s is displayed", expectedTrackingId))
        .isEqualTo(f("1. %s", expectedTrackingId));
    vanInboundPage.shipmentInboundDialog.hubInboundShipment.click();
  }

  @Then("Operator confirms that the modal: {string} is displayed and has tracking id displayed")
  public void operator_confirms_that_the_modal_is_displayed_and_has_tracking_id_displayed(String modalName) {
    String expectedTrackingId = get(KEY_CREATED_ORDER_TRACKING_ID);
    String actualDialogHeader = vanInboundPage.shipmentInboundDialog.dialogHeader.getText().trim();
    String actualTrackingId = vanInboundPage.shipmentInboundDialog.trackingIdInModal.getText().trim();
    Assertions.assertThat(actualDialogHeader)
        .as(f("Assert that the dialog header displayed is %s", modalName))
        .isEqualTo(actualDialogHeader.trim());
    Assertions.assertThat(actualTrackingId)
        .as(f("Assert that the tracking id: %s is shown in the modal", expectedTrackingId))
        .isEqualTo(expectedTrackingId);
    vanInboundPage.shipmentInboundDialog.proceedWithoutInbounding.click();
  }

  @Then("Operator verifies the route is started on clicking route start button")
  public void operator_verifies_the_route_is_started_on_clicking_route_start_button() {
    vanInboundPage.waitUntilPageLoaded(60);
    pause3s();
    vanInboundPage.routeStart.click();
    vanInboundPage.waitUntilPageLoaded();
    Assert.assertTrue("Assert that the route is started modal has been displayed!",
        vanInboundPage.routeStartedModal.size() > 0);
  }

  @Then("Operator verifies that van inbound page is displayed after clicking back to route input screen")
  public void operator_verifies_that_van_inbound_page_is_displayed_after_clicking_back_to_route_input_screen() {
    pause2s();
    vanInboundPage.backToRouteInputScreen.click();
    Assert.assertTrue("Assert that the van inbound main page is displayed "
            + "on clicking back to route input screen",
      vanInboundPage.vanInboundHomePage.size() > 0);
  }

}
