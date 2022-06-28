package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.model.core.Order;
import co.nvqa.commons.model.core.route.Route;
import co.nvqa.commons.model.driver.FailureReason;
import co.nvqa.commons.util.factory.FailureReasonFactory;
import co.nvqa.operator_v2.model.RouteManifestWaypointDetails;
import co.nvqa.operator_v2.selenium.page.RouteManifestPage;
import co.nvqa.operator_v2.util.TestConstants;
import io.cucumber.guice.ScenarioScoped;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import java.util.List;
import java.util.Map;
import org.apache.commons.lang3.StringUtils;
import org.assertj.core.api.SoftAssertions;
import org.hamcrest.Matchers;

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
            TestConstants.COUNTRY_CODE, route.getId()).toLowerCase());
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
      assertThat("List of Tracking IDs for tag " + tag, actual,
          Matchers.containsInAnyOrder(splitAndNormalize(expected).toArray(new String[0])));
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
      assertTrue("Tracking id " + trackingId + " was not found in COD collection dialog", found);
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
    assertions.assertAll();
  }
}
