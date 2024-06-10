package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.common.model.DataEntity;
import co.nvqa.operator_v2.model.RouteManifestWaypointDetails;
import co.nvqa.operator_v2.model.RouteManifestWaypointDetails.Delivery;
import co.nvqa.operator_v2.model.RouteManifestWaypointDetails.Pickup;
import co.nvqa.operator_v2.model.RouteManifestWaypointDetails.Reservation;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.page.RouteManifestPage;
import io.cucumber.guice.ScenarioScoped;
import io.cucumber.java.en.Given;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import java.util.List;
import java.util.Map;
import org.apache.commons.lang3.StringUtils;
import org.assertj.core.api.Assertions;
import org.assertj.core.api.SoftAssertions;

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


  @Then("Operator verify Route summary Parcel count on Route Manifest page:")
  public void verifyParcelCount(Map<String, Map<String, String>> data) {
    SoftAssertions assertions = new SoftAssertions();
    page.inFrame(() -> {
      data.forEach((type, map) -> resolveKeyValues(map).forEach(
          (status, value) -> assertions.assertThat(page.getParcelCountValue(type, status))
              .as("%s %s", type, status).isEqualTo(value)));
    });
    assertions.assertAll();
  }

  @Then("Operator verify Route summary Waypoint type on Route Manifest page:")
  public void verifyWaypointType(Map<String, Map<String, String>> data) {
    SoftAssertions assertions = new SoftAssertions();
    page.inFrame(() -> {
      data.forEach((type, map) -> resolveKeyValues(map).forEach(
          (status, value) -> assertions.assertThat(page.getWpTypeValue(type, status))
              .as("%s %s", type, status).isEqualTo(value)));
    });
    assertions.assertAll();
  }

  @Then("Operator verify Route summary Timeslot on Route Manifest page:")
  public void verifyTimeslot(Map<String, Map<String, String>> data) {
    SoftAssertions assertions = new SoftAssertions();
    page.inFrame(() -> {
      data.forEach((timeslot, map) -> resolveKeyValues(map).forEach(
          (status, value) -> assertions.assertThat(page.getTimeslotValue(timeslot, status))
              .as("%s %s", timeslot, status).isEqualTo(value)));
    });
    assertions.assertAll();
  }

  @Then("Operator verify Route summary COD collection on Route Manifest page:")
  public void verifyCODCollection(Map<String, Map<String, String>> data) {
    SoftAssertions assertions = new SoftAssertions();
    page.inFrame(() -> {
      data.forEach((type, map) -> resolveKeyValues(map).forEach(
          (status, value) -> assertions.assertThat(page.getCODCollectionValue(type))
              .as("%s %s", type, status).isEqualTo(value)));
    });
    assertions.assertAll();
  }

  @Then("Operator verify waypoint at Route Manifest using data below:")
  public void operatorVerifyWaypointAtRouteManifest(Map<String, String> mapOfData) {
    page.inFrame(() -> page.verifyWaypointDetails(
        new RouteManifestWaypointDetails(resolveKeyValues(mapOfData))));
  }

  @When("Operator reveals masked information")
  public void operatorRevealsMaskedInfo() {
    page.inFrame(() -> {
      page.waypointsTable.addressReveal.click();
      page.waypointsTable.contactReveal.click();
    });
  }

  @Then("Operator open {value} waypoint details on Route Manifest page")
  public void operatorOpenWaypointDetails(String waypointId) {
    page.inFrame(() -> {
      page.waypointsTable.clearColumnFilters();
      page.waypointsTable.filterByColumn("id", waypointId);
      page.waypointsTable.clickActionButton(1, "details");
      page.waypointDetailsDialog.waitUntilVisible();
    });
  }

  @Then("Operator verify waypoint details on Route Manifest page:")
  public void verifyWaypointDetails(Map<String, String> data) {
    var finalData = resolveKeyValues(data);
    page.inFrame(() -> {
      page.waypointDetailsDialog.waitUntilVisible();
      SoftAssertions assertions = new SoftAssertions();
      if (finalData.containsKey("waypointId")) {
        assertions.assertThat(page.waypointDetailsDialog.waypointId.getNormalizedText())
            .as("Waypoint ID").isEqualTo(finalData.get("waypointId"));
      }
      if (finalData.containsKey("waypointStatus")) {
        assertions.assertThat(page.waypointDetailsDialog.waypointStatus.getNormalizedText())
            .as("Waypoint status").isEqualTo(finalData.get("waypointStatus"));
      }
      if (finalData.containsKey("highestPriority")) {
        assertions.assertThat(page.waypointDetailsDialog.highestPriority.getNormalizedText())
            .as("Highest priority").isEqualTo(finalData.get("highestPriority"));
      }
      if (finalData.containsKey("serviceTypes")) {
        assertions.assertThat(page.waypointDetailsDialog.serviceTypes.getNormalizedText())
            .as("Service type(s)").isEqualTo(finalData.get("serviceTypes"));
      }
      if (finalData.containsKey("addressee")) {
        assertions.assertThat(page.waypointDetailsDialog.addressee.getNormalizedText())
            .as("Addressee").isEqualTo(finalData.get("addressee"));
      }
      if (finalData.containsKey("contact")) {
        assertions.assertThat(page.waypointDetailsDialog.contact.getNormalizedText()).as("Contact")
            .isEqualTo(finalData.get("contact"));
      }
      if (finalData.containsKey("recipient")) {
        assertions.assertThat(page.waypointDetailsDialog.recipient.getNormalizedText())
            .as("Recipient").isEqualTo(finalData.get("recipient"));
      }
      if (finalData.containsKey("relationship")) {
        assertions.assertThat(page.waypointDetailsDialog.relationship.getNormalizedText())
            .as("Relationship").isEqualTo(finalData.get("relationship"));
      }
      assertions.assertAll();
    });
  }

  @Then("Operator verify reservation record in Waypoint Details dialog on Route Manifest page:")
  @Then("Operator verify pickup appointment job record in Waypoint Details dialog on Route Manifest page:")
  public void verifyReservationRecord(Map<String, String> data) {
    var expected = new Reservation(resolveKeyValues(data));
    page.inFrame(() -> {
      var actual = page.waypointDetailsDialog.reservationsTable.readAllEntities();
      DataEntity.assertListContains(actual, expected, "Reservation details");
    });
  }

  @Then("Operator verify pickup record in Waypoint Details dialog on Route Manifest page:")
  public void verifyPickupRecord(Map<String, String> data) {
    var expected = new Pickup(resolveKeyValues(data));
    page.inFrame(() -> {
      var actual = page.waypointDetailsDialog.pickupsTable.readAllEntities();
      DataEntity.assertListContains(actual, expected, "Pickup details");
    });
  }

  @Then("Operator verify delivery record in Waypoint Details dialog on Route Manifest page:")
  public void verifyDeliveryRecord(Map<String, String> data) {
    var expected = new Delivery(resolveKeyValues(data));
    page.inFrame(() -> {
      var actual = page.waypointDetailsDialog.deliveryTable.readAllEntities();
      DataEntity.assertListContains(actual, expected, "Pickup details");
    });
  }

  @Then("Operator verify 'View POP' button is disabled for {value} reservation in Waypoint Details dialog on Route Manifest page")
  @Then("Operator verify 'View POP' button is disabled for {value} pickup appointment job in Waypoint Details dialog on Route Manifest page")
  public void verifyViewPopIsDisabledForReservation(String id) {
    page.inFrame(() -> {
      int count = page.waypointDetailsDialog.reservationsTable.getRowsCount();
      for (int i = 1; i <= count; i++) {
        if (page.waypointDetailsDialog.reservationsTable.getColumnText(i, "id").equals(id)) {
          Assertions.assertThat(
                  page.waypointDetailsDialog.reservationsTable.getActionButton(i, "view pop")
                      .isEnabled()).withFailMessage("View POP button is enabled for reservation %s", id)
              .isFalse();
          return;
        }
      }
      Assertions.fail("Reservation %s was not found", id);
    });
  }

  @Then("Operator verify 'View POP' button is disabled for {value} pickup in Waypoint Details dialog on Route Manifest page")
  public void verifyViewPopIsDisabledForPickup(String trackingId) {
    page.inFrame(() -> {
      int count = page.waypointDetailsDialog.pickupsTable.getRowsCount();
      for (int i = 1; i <= count; i++) {
        if (page.waypointDetailsDialog.pickupsTable.getColumnText(i, "trackingId")
            .equals(trackingId)) {
          Assertions.assertThat(
                  page.waypointDetailsDialog.pickupsTable.getActionButton(i, "view pop")
                      .isEnabled())
              .withFailMessage("View POP button is enabled for pickup %s", trackingId)
              .isFalse();
          return;
        }
      }
      Assertions.fail("Record %s was not found", trackingId);
    });
  }

  @Then("Operator verify 'View POD' button is disabled for {value} delivery in Waypoint Details dialog on Route Manifest page")
  public void verifyViewPopIsDisabledForDelivery(String trackingId) {
    page.inFrame(() -> {
      int count = page.waypointDetailsDialog.deliveryTable.getRowsCount();
      for (int i = 1; i <= count; i++) {
        if (page.waypointDetailsDialog.deliveryTable.getColumnText(i, "trackingId")
            .equals(trackingId)) {
          Assertions.assertThat(
                  page.waypointDetailsDialog.deliveryTable.getActionButton(i, "view pod")
                      .isEnabled())
              .withFailMessage("View POP button is enabled for delivery %s", trackingId)
              .isFalse();
          return;
        }
      }
      Assertions.fail("Record %s was not found", trackingId);
    });
  }

  @Then("Operator click 'View POP' button for {value} reservation in Waypoint Details dialog on Route Manifest page")
  public void clickViewPopForReservation(String id) {
    page.inFrame(() -> {
      int count = page.waypointDetailsDialog.reservationsTable.getRowsCount();
      for (int i = 1; i <= count; i++) {
        if (page.waypointDetailsDialog.reservationsTable.getColumnText(i, "id").equals(id)) {
          page.waypointDetailsDialog.reservationsTable.getActionButton(i, "view pop").click();
          return;
        }
      }
      Assertions.fail("Reservation %s was not found", id);
    });
  }

  @Then("Operator click 'View POP' button for {value} pickup in Waypoint Details dialog on Route Manifest page")
  public void clickViewPopForPickup(String trackingId) {
    page.inFrame(() -> {
      int count = page.waypointDetailsDialog.pickupsTable.getRowsCount();
      for (int i = 1; i <= count; i++) {
        if (page.waypointDetailsDialog.pickupsTable.getColumnText(i, "trackingId")
            .equals(trackingId)) {
          page.waypointDetailsDialog.pickupsTable.getActionButton(i, "view pop").click();
          return;
        }
      }
      Assertions.fail("Record %s was not found", trackingId);
    });
  }

  @Then("Operator click 'View POD' button for {value} delivery in Waypoint Details dialog on Route Manifest page")
  public void clickViewPodForDelivery(String trackingId) {
    page.inFrame(() -> {
      int count = page.waypointDetailsDialog.deliveryTable.getRowsCount();
      for (int i = 1; i <= count; i++) {
        if (page.waypointDetailsDialog.deliveryTable.getColumnText(i, "trackingId")
            .equals(trackingId)) {
          page.waypointDetailsDialog.deliveryTable.getActionButton(i, "view pod").click();
          return;
        }
      }
      Assertions.fail("Record %s was not found", trackingId);
    });
  }

  @Then("Operator verify POP details on Route Manifest page:")
  public void verifyPOPDetails(Map<String, String> data) {
    var finalData = resolveKeyValues(data);
    page.inFrame(() -> {
      page.proofOfPickupDialog.waitUntilVisible();
      SoftAssertions assertions = new SoftAssertions();
      if (finalData.containsKey("reservationId")) {
        assertions.assertThat(page.proofOfPickupDialog.reservationId.getNormalizedText())
            .as("Reservation ID").endsWith(finalData.get("reservationId"));
      }
      if (finalData.containsKey("pickupAppointmentJobId")) {
        assertions.assertThat(page.proofOfPickupDialog.pickupAppointmentJobId.getNormalizedText())
            .as("Pickup appointment job ID").endsWith(finalData.get("pickupAppointmentJobId"));
      }

      if (finalData.containsKey("trackingId")) {
        assertions.assertThat(page.proofOfPickupDialog.trackingId.getNormalizedText())
            .as("Tracking ID").endsWith(finalData.get("trackingId"));
      }

      if (finalData.containsKey("shipper")) {
        assertions.assertThat(page.proofOfPickupDialog.shipper.getNormalizedText()).as("Shipper")
            .isEqualTo(finalData.get("shipper"));
      }
      if (finalData.containsKey("phone")) {
        assertions.assertThat(page.proofOfPickupDialog.phone.getNormalizedText()).as("Phone")
            .isEqualTo(finalData.get("phone"));
      }
      if (finalData.containsKey("email")) {
        assertions.assertThat(page.proofOfPickupDialog.email.getNormalizedText()).as("Email")
            .isEqualTo(finalData.get("email"));
      }
      if (finalData.containsKey("status")) {
        assertions.assertThat(page.proofOfPickupDialog.status.getNormalizedText()).as("Status")
            .isEqualTo(finalData.get("status"));
      }
      if (finalData.containsKey("pickupQuantity")) {
        assertions.assertThat(page.proofOfPickupDialog.pickupQuantity.getNormalizedText())
            .as("Pickup quantity").isEqualTo(finalData.get("pickupQuantity"));
      }
      if (finalData.containsKey("receivedFrom")) {
        assertions.assertThat(page.proofOfPickupDialog.receivedFrom.getNormalizedText())
            .as("Received from")
            .isEqualTo(finalData.get("receivedFrom"));
      }
      if (finalData.containsKey("relationship")) {
        assertions.assertThat(page.proofOfPickupDialog.relationship.getNormalizedText())
            .as("Relationship")
            .isEqualTo(finalData.get("relationship"));
      }
      if (finalData.containsKey("receiptDateTime")) {
        assertions.assertThat(page.proofOfPickupDialog.receiptDateTime.getNormalizedText())
            .as("receiptDateTime")
            .contains(finalData.get("receiptDateTime"));
      }
      if (finalData.containsKey("trackingIds")) {
        assertions.assertThat(
                page.proofOfPickupDialog.trackingIds.stream().map(PageElement::getNormalizedText))
            .as("Tracking Ids")
            .containsExactlyInAnyOrderElementsOf(splitAndNormalize(finalData.get("trackingIds")));
      }
      assertions.assertAll();
    });
  }

  @Then("Operator verify POD details on Route Manifest page:")
  public void verifyPODDetails(Map<String, String> data) {
    var finalData = resolveKeyValues(data);
    page.inFrame(() -> {
      page.proofOfDeliveryDialog.waitUntilVisible();
      SoftAssertions assertions = new SoftAssertions();
      if (finalData.containsKey("trackingId")) {
        assertions.assertThat(page.proofOfDeliveryDialog.trackingId.getNormalizedText())
            .as("Tracking ID").endsWith(finalData.get("trackingId"));
      }
      if (finalData.containsKey("phone")) {
        assertions.assertThat(page.proofOfDeliveryDialog.phone.getNormalizedText()).as("Phone")
            .isEqualTo(finalData.get("phone"));
      }
      if (finalData.containsKey("email")) {
        assertions.assertThat(page.proofOfDeliveryDialog.email.getNormalizedText()).as("Email")
            .isEqualTo(finalData.get("email"));
      }
      if (finalData.containsKey("status")) {
        assertions.assertThat(page.proofOfDeliveryDialog.status.getNormalizedText()).as("Status")
            .isEqualTo(finalData.get("status"));
      }
      if (finalData.containsKey("receivedBy")) {
        assertions.assertThat(page.proofOfDeliveryDialog.receivedBy.getNormalizedText())
            .as("Received by")
            .isEqualTo(finalData.get("receivedBy"));
      }
      if (finalData.containsKey("relationship")) {
        assertions.assertThat(page.proofOfDeliveryDialog.relationship.getNormalizedText())
            .as("Relationship")
            .isEqualTo(finalData.get("relationship"));
      }
      if (finalData.containsKey("code")) {
        assertions.assertThat(page.proofOfDeliveryDialog.code.getNormalizedText())
            .as("Code")
            .isEqualTo(finalData.get("code"));
      }
      if (finalData.containsKey("hiddenLocation")) {
        assertions.assertThat(page.proofOfDeliveryDialog.hiddenLocation.getNormalizedText())
            .as("Hidden location")
            .isEqualTo(finalData.get("hiddenLocation"));
      }
      if (finalData.containsKey("receiptDateTime")) {
        assertions.assertThat(page.proofOfDeliveryDialog.receiptDateTime.getNormalizedText())
            .as("receiptDateTime")
            .contains(finalData.get("receiptDateTime"));
      }
      if (finalData.containsKey("deliveryQuantity")) {
        assertions.assertThat(page.proofOfDeliveryDialog.deliveryQuantity.getNormalizedText())
            .as("Delivery quantity").isEqualTo(finalData.get("deliveryQuantity"));
      }
      assertions.assertAll();
    });
  }

  @Then("Operator is able to download signature in POP details dialog on Route Manifest page")
  public void verifyDownloadSignatureInPOPDetails() {
    page.inFrame(() -> {
      page.proofOfPickupDialog.waitUntilVisible();
      Assertions.assertThat(page.proofOfPickupDialog.isEnabled())
          .withFailMessage("Download signature button is disabled").isTrue();
    });
  }

  @Then("Operator is able to download signature in POD details dialog on Route Manifest page")
  public void verifyDownloadSignatureInPODDetails() {
    page.inFrame(() -> {
      page.proofOfDeliveryDialog.waitUntilVisible();
      Assertions.assertThat(page.proofOfDeliveryDialog.isEnabled())
          .withFailMessage("Download signature button is disabled").isTrue();
    });
  }

  @Then("Operator verify waypoint tags at Route Manifest using data below:")
  public void operatorVerifyWaypointTagsAtRouteManifest(Map<String, String> data) {
    page.inFrame(() -> resolveKeyValues(data).forEach((tag, expected) -> {
      page.waypointsTable.filterByColumn(COLUMN_ORDER_TAGS, tag);
      List<String> actual = page.waypointsTable.readColumn(COLUMN_TRACKING_IDS);
      Assertions.assertThat(actual).as("List of Tracking IDs for tag " + tag)
          .contains(splitAndNormalize(expected).toArray(new String[0]));
    }));
  }

  @When("Operator fail {} waypoint from Route Manifest page")
  public void operatorFailDeliveryWaypointFromRouteManifestPage(String waypointType,
      Map<String, String> data) {
    page.inFrame(() -> {
      var reason = page.failDeliveryWaypoint(data);
      put(KEY_SELECTED_FAILURE_REASON, reason);
    });
  }

  @When("Operator fail waypoint from Route Manifest page with following details in the row {string}")
  public void operatorFailWaypointFromRouteManifestPageWithFollowingDetails(String trackingID,
      Map<String, String> mapOfData) {
    trackingID = resolveValue(trackingID);
    page.failWaypointWithFailureDetails(mapOfData, trackingID);
    takesScreenshot();
  }

  @When("Operator success {} waypoint from Route Manifest page")
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

  @When("Operator success {} waypoint with COD collection from Route Manifest page:")
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
          if (StringUtils.equals(page.codCollectionDialog.trackingId.get(i).getNormalizedText(),
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

  @When("Operator open Route Manifest page for route ID {string}")
  public void operatorOpenRouteManifestPage(String routeId) {
    routeId = resolveValue(routeId);
    page.openPage(Long.parseLong(StringUtils.trim(routeId)));
    page.waitUntilPageLoaded();
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
        assertions.assertThat(page.codCollectionPending.getText()).as("COD Collection - Pending")
            .isEqualTo(finalData.get("codCollectionPending"));
      }
      if(finalData.containsKey("codCollectionPendingNoComa")) {
        String codNoComa = page.codCollectionPending.getText().replace(",", "").trim();
        assertions.assertThat(codNoComa).as("COD Collection - Pending")
            .isEqualTo(finalData.get("codCollectionPendingNoComa"));
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
    page.inFrame(() -> Assertions.assertThat(page.codCollectionPending.isDisplayedFast())
        .withFailMessage("Unexpected COD is displayed").isFalse());
  }

  @Then("Operator verifies route detail information below on Route Manifest page:")
  public void operatorVerifiesRouteDetailInformation(Map<String, String> dataTable) {
    Map<String, String> resolvedData = resolveKeyValues(dataTable);
    page.waitUntilPageLoaded();
    retryIfAssertionErrorOrRuntimeExceptionOccurred(() -> {
      if (resolvedData.get("Route ID") != null) {
        Assertions.assertThat(page.getRouteDetailItem("Route ID")).as("Route Id is the same")
            .isEqualToIgnoringCase(resolvedData.get("Route ID"));
      }
      if (resolvedData.get("Driver ID") != null) {
        Assertions.assertThat(page.getRouteDetailItem("Driver ID")).as("Driver ID is the same")
            .isEqualToIgnoringCase(resolvedData.get("Driver ID"));
      }
      if (resolvedData.get("Driver Name") != null) {
        Assertions.assertThat(page.getRouteDetailItem("Driver Name")).as("Driver Name is the same")
            .isEqualToIgnoringCase(resolvedData.get("Driver Name"));
      }
      if (resolvedData.get("Date") != null) {
        Assertions.assertThat(page.getRouteDetailItem("Date")).as("Date is the same")
            .isEqualToIgnoringCase(resolvedData.get("Date"));
      }
    }, 2000, 3);
  }

  @Given("Operator unmask Route Manifest page")
  public void unmaskEditOrder() {
    page.inFrame(() -> {
      while (page.mask.isDisplayedFast()) {
        page.mask.click();
        page.waitUntilLoaded();
      }
    });
  }
}
