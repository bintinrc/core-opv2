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

  private RouteManifestPage page;

  public RouteManifestSteps() {
  }

  @Override
  public void init() {
    page = new RouteManifestPage(getWebDriver());
  }

  @When("^Operator go to created Route Manifest$")
  public void operatorGoToCreatedRouteManifest() {
    Route route = get(KEY_CREATED_ROUTE);
    getWebDriver().navigate()
        .to(f("%s/%s/route-manifest-v2/%d", TestConstants.OPERATOR_PORTAL_BASE_URL,
            TestConstants.NV_SYSTEM_ID, route.getId()).toLowerCase());
  }

  @Then("^Operator verify 1 delivery success at Route Manifest$")
  public void operatorVerify1DeliverySuccessAtRouteManifest() {
    Route route = get(KEY_CREATED_ROUTE);
    Order order = get(KEY_ORDER_DETAILS);
    page.verify1DeliverySuccessAtRouteManifest(route, order);
  }

  @Then("^Operator verify 1 delivery fail at Route Manifest$")
  public void operatorVerify1DeliveryFailAtRouteManifest() {
    Route route = get(KEY_CREATED_ROUTE);
    Order order = get(KEY_ORDER_DETAILS);
    FailureReason selectedFailureReason = get(KEY_SELECTED_FAILURE_REASON);
    page.verify1DeliveryFailAtRouteManifest(route, order, selectedFailureReason);
  }

  @Then("Operator verify Route summary Parcel count on Route Manifest page:")
  public void verifyParcelCount(Map<String, Map<String, String>> data) {
    SoftAssertions assertions = new SoftAssertions();
    page.inFrame(() -> {
      data.forEach((type, map) ->
          resolveKeyValues(map).forEach((status, value) ->
              assertions.assertThat(page.getParcelCountValue(type, status))
                  .as("%s %s", type, status)
                  .isEqualTo(value)
          )
      );
    });
    assertions.assertAll();
  }

  @Then("Operator verify Route summary Waypoint type on Route Manifest page:")
  public void verifyWaypointType(Map<String, Map<String, String>> data) {
    SoftAssertions assertions = new SoftAssertions();
    page.inFrame(() -> {
      data.forEach((type, map) ->
          resolveKeyValues(map).forEach((status, value) ->
              assertions.assertThat(page.getWpTypeValue(type, status))
                  .as("%s %s", type, status)
                  .isEqualTo(value)
          )
      );
    });
    assertions.assertAll();
  }

  @Then("^Operator verify waypoint at Route Manifest using data below:$")
  public void operatorVerifyWaypointAtRouteManifest(Map<String, String> mapOfData) {
    page.inFrame(() -> page.verifyWaypointDetails(
        new RouteManifestWaypointDetails(resolveKeyValues(mapOfData))));
  }

  @Then("^Operator verify waypoint tags at Route Manifest using data below:$")
  public void operatorVerifyWaypointTagsAtRouteManifest(Map<String, String> data) {
    page.inFrame(() -> resolveKeyValues(data).forEach((tag, expected) -> {
      page.waypointsTable.filterByColumn(COLUMN_ORDER_TAGS, tag);
      List<String> actual = page.waypointsTable.readColumn(COLUMN_TRACKING_IDS);
      Assertions.assertThat(actual).as("List of Tracking IDs for tag " + tag)
          .contains(splitAndNormalize(expected).toArray(new String[0]));
    }));
  }

  @When("^Operator fail (delivery|pickup|reservation) waypoint from Route Manifest page$")
  public void operatorFailDeliveryWaypointFromRouteManifestPage(String waypointType) {
    String mode = FAILURE_REASON_PICKUP.equalsIgnoreCase(waypointType) ? FAILURE_REASON_PICKUP
        : FAILURE_REASON_DELIVERY;
    String type = FAILURE_REASON_PICKUP.equalsIgnoreCase(waypointType) ? "Return"
        : FAILURE_REASON_TYPE_NORMAL;
    FailureReason failureReason = FailureReasonFactory.findAdvance(type, mode,
        FAILURE_REASON_CODE_ID_ALL, FAILURE_REASON_INDEX_MODE_FIRST);
    page.inFrame(() -> {
      var reason = page.failDeliveryWaypoint(failureReason);
      put(KEY_SELECTED_FAILURE_REASON, reason);
    });
  }

  @When("Operator fail waypoint from Route Manifest page with following details in the row {string}")
  public void operatorFailWaypointFromRouteManifestPageWithFollowingDetails(
      String trackingID, Map<String, String> mapOfData) {
    trackingID = resolveValue(trackingID);
    page.failWaypointWithFailureDetails(mapOfData, trackingID);
    takesScreenshot();
  }

  @When("^Operator success (delivery|pickup|reservation) waypoint from Route Manifest page$")
  public void operatorSuccessDeliveryWaypointFromRouteManifestPage(String waypointType) {
    page.inFrame(() -> {
      switch (waypointType) {
        case "reservation":
          page.successReservationWaypoint();
          break;
        default:
          page.successDeliveryWaypoint();
      }
    });
  }

  @When("^Operator success (delivery|pickup) waypoint with COD collection from Route Manifest page:$")
  public void operatorSuccessDeliveryWaypointFromRouteManifestPage(String waypointType,
      List<Map<String, String>> data) {
    page.inFrame(() -> {
      page.waypointsTable.clickActionButton(1, "edit");
      page.chooseAnOutcomeForTheWaypointDialog.success.click();
      page.codCollectionDialog.waitUntilVisible();
      int count = page.codCollectionDialog.trackingId.size();
      data.forEach(entry -> {
        entry = resolveKeyValues(entry);
        String trackingId = entry.get("trackingId");
        boolean collected = Boolean.parseBoolean(entry.get("collected"));
        boolean found = false;
        for (int i = 0; i < count; i++) {
          if (StringUtils.equals(
              page.codCollectionDialog.trackingId.get(i).getNormalizedText(),
              trackingId)) {
            page.codCollectionDialog.collected.get(i).setValue(collected);
            found = true;
            break;
          }
        }
        Assertions.assertThat(found)
            .as("Tracking id " + trackingId + " was not found in COD collection dialog").isTrue();
      });
      page.codCollectionDialog.ok.click();
      page.confirmationDialog.waitUntilVisible();
      page.confirmationDialog.proceed.click();
      page.confirmationDialog.waitUntilInvisible();
    });
  }

  @When("^Operator open Route Manifest page for route ID \"(.+)\"$")
  public void operatorOpenRouteManifestPage(String routeId) {
    routeId = resolveValue(routeId);
    page.openPage(Long.parseLong(StringUtils.trim(routeId)));
  }

  @When("Operator verifies route details on Route Manifest page:")
  public void verifyRouteDetails(Map<String, String> data) {
    SoftAssertions assertions = new SoftAssertions();
    Map<String, String> finalData = resolveKeyValues(data);
    page.inFrame(() -> {
      if (finalData.containsKey("routeId")) {
        assertions.assertThat(page.routeId.getText()).as("Route ID")
            .isEqualTo(finalData.get("routeId"));
      }
      if (finalData.containsKey("codCollectionPending")) {
        assertions.assertThat(page.codCollectionPending.getText())
            .as("COD Collection - Pending")
            .isEqualTo(finalData.get("codCollectionPending"));
      }
      if (finalData.containsKey("driverId")) {
        assertions.assertThat(page.driverId.getText()).as("Driver ID")
            .isEqualTo(finalData.get("driverId"));
      }
      if (finalData.containsKey("driverName")) {
        assertions.assertThat(page.driverName.getText()).as("Driver Name")
            .isEqualTo(finalData.get("driverName"));
      }
    });
    assertions.assertAll();
  }

  @When("Operator verifies COD is not displayed on Route Manifest page")
  public void verifyCodIsNotDisplayed() {
    page.inFrame(() ->
        Assertions.assertThat(page.codCollectionPending.isDisplayedFast())
            .withFailMessage("Unexpected COD is displayed")
            .isFalse()
    );
  }

  @When("Operator click view POA/POH button on Route Manifest page")
  public void clickViewPoaPoh() {
    page.clickViewPoaPoH();
  }

  @Then("Operator verify POA/POH button is disabled on Route Manifest page")
  public void verifyViewPoaPohDisabled() {
    Assertions.assertThat(page.isViewPoaPohDisabled());
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

    page.proofOfArrivalAndHandoverDialog.inFrame(
        page -> page.proofOfArrivalTable.verifyPoAInfo(expected, index));
  }

  @When("Operator click View on Map")
  public void clickViewOnMapButton() {
    page.proofOfArrivalAndHandoverDialog.inFrame(
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

    page.proofOfArrivalAndHandoverDialog.inFrame(
        page -> page.proofOfHandoverTable.verifyPoHInfo(expected, index));
  }

  @When("Operator click View Photo")
  public void clickViewPhotoButton() {
    page.proofOfArrivalAndHandoverDialog.inFrame(
        page -> page.proofOfHandoverTable.clickViewPhoto());
  }

  @Then("Operator verifies route detail information below on Route Manifest page:")
  public void operatorVerifiesRouteDetailInformation(Map<String, String> dataTable) {
    Map<String, String> resolvedData = resolveKeyValues(dataTable);
    page.waitUntilPageLoaded();
    retryIfAssertionErrorOrRuntimeExceptionOccurred(() -> {
      if (resolvedData.get("Route ID") != null) {
        Assertions.assertThat(page.getRouteDetailItem("Route ID")).
            as("Route Id is the same").isEqualToIgnoringCase(resolvedData.get("Route ID"));
      }
      if (resolvedData.get("Driver ID") != null) {
        Assertions.assertThat(page.getRouteDetailItem("Driver ID")).
            as("Driver ID is the same").isEqualToIgnoringCase(resolvedData.get("Driver ID"));
      }
      if (resolvedData.get("Driver Name") != null) {
        Assertions.assertThat(page.getRouteDetailItem("Driver Name")).
            as("Driver Name is the same").isEqualToIgnoringCase(resolvedData.get("Driver Name"));
      }
      if (resolvedData.get("Date") != null) {
        Assertions.assertThat(page.getRouteDetailItem("Date")).
            as("Date is the same").isEqualToIgnoringCase(resolvedData.get("Date"));
      }
    }, 2000, 3);
  }
}
