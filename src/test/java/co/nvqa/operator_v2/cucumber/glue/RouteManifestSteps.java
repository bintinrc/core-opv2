package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.model.core.Order;
import co.nvqa.commons.model.core.route.Route;
import co.nvqa.commons.model.driver.FailureReason;
import co.nvqa.commons.util.factory.FailureReasonFactory;
import co.nvqa.operator_v2.model.PoaInfo;
import co.nvqa.operator_v2.model.PohInfo;
import co.nvqa.operator_v2.model.RouteManifestWaypointDetails;
import co.nvqa.operator_v2.selenium.page.RouteManifestPage;
import co.nvqa.operator_v2.util.TestConstants;
import io.cucumber.guice.ScenarioScoped;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import java.util.List;
import java.util.Map;
import org.apache.commons.lang3.StringUtils;
import org.assertj.core.api.Assertions;
import org.assertj.core.api.SoftAssertions;

import static co.nvqa.commons.util.factory.FailureReasonFactory.FAILURE_REASON_CODE_ID_ALL;
import static co.nvqa.commons.util.factory.FailureReasonFactory.FAILURE_REASON_DELIVERY;
import static co.nvqa.commons.util.factory.FailureReasonFactory.FAILURE_REASON_INDEX_MODE_FIRST;
import static co.nvqa.commons.util.factory.FailureReasonFactory.FAILURE_REASON_PICKUP;
import static co.nvqa.commons.util.factory.FailureReasonFactory.FAILURE_REASON_TYPE_NORMAL;
import static co.nvqa.operator_v2.selenium.page.RouteManifestPage.WaypointsTable.COLUMN_ORDER_TAGS;
import static co.nvqa.operator_v2.selenium.page.RouteManifestPage.WaypointsTable.COLUMN_TRACKING_IDS;

/**
 * @author Daniel Joi Partogi Hutapea
 */
@ScenarioScoped
public class RouteManifestSteps extends AbstractSteps {

  private RouteManifestPage routeManifestPage;

  public RouteManifestSteps() {
  }

  @Override
  public void init() {
    routeManifestPage = new RouteManifestPage(getWebDriver());
  }

  @When("^Operator go to created Route Manifest$")
  public void operatorGoToCreatedRouteManifest() {
    Route route = get(KEY_CREATED_ROUTE);
    getWebDriver().navigate()
        .to(f("%s/%s/route-manifest/%d", TestConstants.OPERATOR_PORTAL_BASE_URL,
            TestConstants.NV_SYSTEM_ID, route.getId()).toLowerCase());
  }

  @Then("^Operator verify 1 delivery success at Route Manifest$")
  public void operatorVerify1DeliverySuccessAtRouteManifest() {
    Route route = get(KEY_CREATED_ROUTE);
    Order order = get(KEY_ORDER_DETAILS);
    routeManifestPage.verify1DeliverySuccessAtRouteManifest(route, order);
  }

  @Then("^Operator verify 1 delivery fail at Route Manifest$")
  public void operatorVerify1DeliveryFailAtRouteManifest() {
    Route route = get(KEY_CREATED_ROUTE);
    Order order = get(KEY_ORDER_DETAILS);
    FailureReason selectedFailureReason = get(KEY_SELECTED_FAILURE_REASON);
    routeManifestPage.verify1DeliveryFailAtRouteManifest(route, order, selectedFailureReason);
  }

  @Then("^Operator verify waypoint at Route Manifest using data below:$")
  public void operatorVerifyWaypointAtRouteManifest(Map<String, String> mapOfData) {
    mapOfData = resolveKeyValues(mapOfData);

    RouteManifestWaypointDetails waypointDetails = new RouteManifestWaypointDetails();
    waypointDetails.fromMap(mapOfData);

    routeManifestPage.verifyWaypointDetails(waypointDetails);
  }

  @Then("^Operator verify waypoint tags at Route Manifest using data below:$")
  public void operatorVerifyWaypointTagsAtRouteManifest(Map<String, String> data) {
    data = resolveKeyValues(data);
    data.forEach((tag, expected) -> {
      routeManifestPage.waypointsTable.filterByColumn(COLUMN_ORDER_TAGS, tag);
      List<String> actual = routeManifestPage.waypointsTable.readColumn(COLUMN_TRACKING_IDS);
      Assertions.assertThat(actual).as("List of Tracking IDs for tag " + tag)
          .contains(splitAndNormalize(expected).toArray(new String[0]));
    });
  }

  @When("^Operator fail (delivery|pickup|reservation) waypoint from Route Manifest page$")
  public void operatorFailDeliveryWaypointFromRouteManifestPage(String waypointType) {
    String mode = FAILURE_REASON_PICKUP.equalsIgnoreCase(waypointType) ? FAILURE_REASON_PICKUP
        : FAILURE_REASON_DELIVERY;
    FailureReason failureReason = FailureReasonFactory.findAdvance(FAILURE_REASON_TYPE_NORMAL, mode,
        FAILURE_REASON_CODE_ID_ALL, FAILURE_REASON_INDEX_MODE_FIRST);
    routeManifestPage.failDeliveryWaypoint(failureReason);
    put(KEY_SELECTED_FAILURE_REASON, failureReason);
  }

  @When("Operator fail waypoint from Route Manifest page with following details in the row {string}")
  public void operatorFailWaypointFromRouteManifestPageWithFollowingDetails(
      String trackingID, Map<String, String> mapOfData) {
    trackingID = resolveValue(trackingID);
    routeManifestPage.failWaypointWithFailureDetails(mapOfData, trackingID);
    takesScreenshot();
  }

  @When("^Operator success (delivery|pickup|reservation) waypoint from Route Manifest page$")
  public void operatorSuccessDeliveryWaypointFromRouteManifestPage(String waypointType) {
    switch (waypointType) {
      case "reservation":
        routeManifestPage.successReservationWaypoint();
        break;
      default:
        routeManifestPage.successDeliveryWaypoint();
    }
  }

  @When("^Operator success (delivery|pickup) waypoint with COD collection from Route Manifest page:$")
  public void operatorSuccessDeliveryWaypointFromRouteManifestPage(String waypointType,
      List<Map<String, String>> data) {
    routeManifestPage.clickActionButtonOnTable(1, RouteManifestPage.ACTION_BUTTON_EDIT);
    routeManifestPage.chooseAnOutcomeForTheWaypointDialog.success.click();
    routeManifestPage.codCollectionDialog.waitUntilVisible();
    int count = routeManifestPage.codCollectionDialog.trackingId.size();
    data.forEach(entry -> {
      entry = resolveKeyValues(entry);
      String trackingId = entry.get("trackingId");
      boolean collected = Boolean.parseBoolean(entry.get("collected"));
      boolean found = false;
      for (int i = 0; i < count; i++) {
        if (StringUtils.equals(
            routeManifestPage.codCollectionDialog.trackingId.get(i).getNormalizedText(),
            trackingId)) {
          routeManifestPage.codCollectionDialog.collected.get(i).setValue(collected);
          found = true;
          break;
        }
      }
      Assertions.assertThat(found)
          .as("Tracking id " + trackingId + " was not found in COD collection dialog").isTrue();
    });
    routeManifestPage.codCollectionDialog.ok.clickAndWaitUntilDone();
    routeManifestPage.confirmationDialog.waitUntilVisible();
    routeManifestPage.confirmationDialog.proceed.click();
    routeManifestPage.confirmationDialog.waitUntilInvisible();
  }

  @When("^Operator open Route Manifest page for route ID \"(.+)\"$")
  public void operatorOpenRouteManifestPage(String routeId) {
    routeId = resolveValue(routeId);
    routeManifestPage.openPage(Long.parseLong(StringUtils.trim(routeId)));
    if (routeManifestPage.loadMoreData.waitUntilVisible(5)) {
      routeManifestPage.loadMoreData.waitUntilInvisible(60);
    }
  }

  @When("Operator verifies route details on Route Manifest page:")
  public void verifyRouteDetails(Map<String, String> data) {
    data = resolveKeyValues(data);
    SoftAssertions assertions = new SoftAssertions();
    if (data.containsKey("routeId")) {
      assertions.assertThat(routeManifestPage.routeId.getText()).as("Route ID")
          .isEqualTo(data.get("routeId"));
    }
    if (data.containsKey("codCollectionPending")) {
      assertions.assertThat(routeManifestPage.codCollectionPending.getText())
          .as("COD Collection - Pending")
          .isEqualTo(data.get("codCollectionPending"));
    }
    if (data.containsKey("driverId")) {
      assertions.assertThat(routeManifestPage.driverId.getText()).as("Driver ID")
          .isEqualTo(data.get("driverId"));
    }
    if (data.containsKey("driverName")) {
      assertions.assertThat(routeManifestPage.driverName.getText()).as("Driver Name")
          .isEqualTo(data.get("driverName"));
    }
    assertions.assertAll();
  }

  @When("Operator verifies COD is not displayed on Route Manifest page")
  public void verifyCodIsNotDisplayed() {
    Assertions.assertThat(routeManifestPage.codCollectionPending.isDisplayedFast())
        .withFailMessage("Unexpected COD is displayed")
        .isFalse();
  }

  @When("Operator click view POA/POH button on Route Manifest page")
  public void clickViewPoaPoh() {
    routeManifestPage.clickViewPoaPoH();
  }

  @Then("Operator verify POA/POH button is disabled on Route Manifest page")
  public void verifyViewPoaPohDisabled() {
    Assertions.assertThat(routeManifestPage.isViewPoaPohDisabled());
  }

  @Then("Operator verifies Proof of Arrival table for the row number {string} on Route Manifest page:")
  public void verifyTableEntry(String row, Map<String, String> data) {
    data = resolveKeyValues(data);
    PoaInfo expected = new PoaInfo(data);
    final String expectedVerifiedByGps = data.get("verifiedByGps");
    final String expectedDistanceFromSortHub = data.get("distanceFromSortHub");
    final int index = Integer.parseInt(row) - 1;

    expected.setVerifiedByGps(expectedVerifiedByGps);
    expected.setDistanceFromSortHub(expectedDistanceFromSortHub);

    routeManifestPage.proofOfArrivalAndHandoverDialog.inFrame(
        page -> page.proofOfArrivalTable.verifyPoAInfo(expected, index));
  }

  @When("Operator click View on Map")
  public void clickViewOnMapButton() {
    routeManifestPage.proofOfArrivalAndHandoverDialog.inFrame(
        page -> page.proofOfArrivalTable.clickViewOnMap());
  }

  @Then("Operator verifies Proof of Handover table for the row number {string} on Route Manifest page:")
  public void verifyPoHTableEntry(String row, Map<String, String> data) {
    data = resolveKeyValues(data);
    PohInfo expected = new PohInfo(data);
    final String expectedEstQty = data.get("estQty");
    final String expectedCntQty = data.get("cntQty");
    final String expectedStaffUsername = data.get("staffUsername");
    final String expectedHandover = data.get("handover");
    final String expectedCSortHubName = data.get("sortHubName");
    final int index = Integer.parseInt(row) - 1;

    expected.setEstQty(Integer.parseInt(expectedEstQty));
    expected.setCntQty(Integer.parseInt(expectedCntQty));
    expected.setHandover(expectedHandover);
    expected.setSortHubName(expectedCSortHubName);
    expected.setStaffUsername(expectedStaffUsername);

    routeManifestPage.proofOfArrivalAndHandoverDialog.inFrame(
        page -> page.proofOfHandoverTable.verifyPoHInfo(expected, index));
  }

  @When("Operator click View Photo")
  public void clickViewPhotoButton() {
    routeManifestPage.proofOfArrivalAndHandoverDialog.inFrame(
        page -> page.proofOfHandoverTable.clickViewPhoto());
  }

  @Then("Operator verifies route detail information below on Route Manifest page:")
  public void operatorVerifiesRouteDetailInformation(Map<String, String> dataTable) {
    Map<String, String> resolvedData = resolveKeyValues(dataTable);
    routeManifestPage.waitUntilPageLoaded();
    retryIfAssertionErrorOrRuntimeExceptionOccurred(() -> {
      if (resolvedData.get("Route ID") != null) {
        Assertions.assertThat(routeManifestPage.getRouteDetailItem("Route ID")).
            as("Route Id is the same").isEqualToIgnoringCase(resolvedData.get("Route ID"));
      }
      if (resolvedData.get("Driver ID") != null) {
        Assertions.assertThat(routeManifestPage.getRouteDetailItem("Driver ID")).
            as("Driver ID is the same").isEqualToIgnoringCase(resolvedData.get("Driver ID"));
      }
      if (resolvedData.get("Driver Name") != null) {
        Assertions.assertThat(routeManifestPage.getRouteDetailItem("Driver Name")).
            as("Driver Name is the same").isEqualToIgnoringCase(resolvedData.get("Driver Name"));
      }
      if (resolvedData.get("Date") != null) {
        Assertions.assertThat(routeManifestPage.getRouteDetailItem("Date")).
            as("Date is the same").isEqualToIgnoringCase(resolvedData.get("Date"));
      }
    }, 2000, 3);
  }
}
