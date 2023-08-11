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

  @And("Operator fill the route ID {string} on Van Inbound Page then click enter")
  public void fillRouteIdOnVanInboundPage(String routeId) {
    vanInboundPage.fillRouteIdOnVanInboundPage(resolveValue(routeId));
  }

  @And("Operator fill the tracking ID {string} on Van Inbound Page then click enter")
  public void fillInTrackingIdOnVanInboundPage(String trackingId) {
    String tid = resolveValue(trackingId);
    vanInboundPage.fillTrackingIdOnVanInboundPage(tid);
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
    takesScreenshot();
  }

  @Then("Operator verifies {string} scanned parcels displayed on Van Inbound Page")
  public void verifyScannedParcels(String expected) {
    doWithRetry(
        () -> Assertions.assertThat(vanInboundPage.scannedParcelsCount.getText())
            .as("Scanned parcels label")
            .isEqualTo(expected.trim() + " Parcels"), "Check Scanned parcels label", 1000, 3);
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
    editOrderPage.waitWhilePageIsLoading(120);
    editOrderPage.verifyInboundIsSucceed();
  }

  @And("Operator click on start route after van inbounding")
  public void startRoute() {
    String trackingId = get(KEY_CREATED_ORDER_TRACKING_ID);
    vanInboundPage.startRoute(trackingId);
  }

  @And("Operator click on start route for tid {string} after van inbounding")
  public void startRoute(String tid) {
    vanInboundPage.startRoute(resolveValue(tid));
  }


  @Then("Operator verify the tracking ID {string} that has been input on Van Inbound Page is invalid")
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

  @Then("Operator verifies the route is started on clicking route start button")
  public void operator_verifies_the_route_is_started_on_clicking_route_start_button() {
    vanInboundPage.waitUntilPageLoaded(60);
    pause5s();
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

  @And("Operator verifies unable to Van Inbound message is displayed")
  public void operatorVerifiesUnableToVanInboundMessageIsDisplayed() {
    vanInboundPage.validateUnableToVanInboundModalIsDisplayed();
    takesScreenshot();
  }

  @And("Operator closes the modal")
  public void operatorClosesTheModal() {
    vanInboundPage.clickCloseIcon();
  }

  @And("Operator click Parcels Yet to scan area on Van Inbound Page")
  public void operatorClickParcelsYetToScanAreaOnVanInboundPage() {
    vanInboundPage.parcelsYetToScan.click();
  }

  @And("Operator closes the dialog")
  public void operatorClosesTheDialog() {
    vanInboundPage.clickCloseButton();
  }

  @Then("Operator verifies the following details in the modal")
  public void operatorVerifiesTheFollowingDetailsInTheModal(Map<String, String> values) {
    Map<String, String> expectedValues = resolveKeyValues(values);

    String expectedmodalName = expectedValues.get("ModalName");
    String actualDialogHeader = vanInboundPage.unScannedParcelsDialog.dialogHeader.getText().trim();
    Assertions.assertThat(actualDialogHeader)
        .as(f("Assert that the dialog header displayed is %s", expectedmodalName))
        .isEqualTo(expectedmodalName.trim());
    String expectedTrackingId = expectedValues.get("Tracking ID");
    String actualTrackingId = vanInboundPage.unScannedParcelsDialog.trackingId.getText().trim();
    Assertions.assertThat(actualTrackingId)
        .as(f("Assert that the tracking id: %s is shown in the modal", expectedTrackingId))
        .isEqualTo(expectedTrackingId);
    String expectedWarningMessage = expectedValues.get("WarningMessage");
    if (StringUtils.isNotBlank(expectedValues.get("WarningMessage"))) {
      String actualWarningMessage = vanInboundPage.unScannedParcelsDialog.commentsText.getText()
          .trim();
      Assertions.assertThat(actualWarningMessage)
          .as(f("Assert that the warning message: %s is shown in the Comments column",
              expectedWarningMessage))
          .isEqualTo(expectedWarningMessage);
      takesScreenshot();
    }
  }

  @Then("Operator verifies Parcel is not available in the modal")
  public void operatorVerifiesParcelIsNotAvailableInTheModal() {
    Assert.assertFalse(f("Assert that the tracking id: %s is shown in the modal",
        get(KEY_CREATED_ORDER_TRACKING_ID).toString()),
        vanInboundPage.unScannedParcelsDialog.trackingId.isDisplayed());
    takesScreenshot();
  }

  @And("Operator clicks the Hub Inbound Shipment button")
  public void operatorClicksTheHubInboundShipmentButton() {
    vanInboundPage.clickHubInboundShipmentButton();
  }

  @And("Operator clicks the Parcel Sweep button")
  public void operatorClicksTheParcelSweepButton() {
    vanInboundPage.clickParcelSweepButton();
  }

  @And("Operator clicks on the view button")
  public void operatorClicksOnTheViewButton() {
    vanInboundPage.clickViewButton();
  }

  @Then("Operator verifies edit order page is displayed on clicking the view button")
  public void operatorVerifiesEditOrderPageIsDisplayedOnClickingTheViewButton() {
    String trackingId = get(KEY_CREATED_ORDER_TRACKING_ID);
    vanInboundPage.verifyNavigationToEditOrderScreen(trackingId);
    takesScreenshot();
  }
}
