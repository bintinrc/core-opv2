package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.common.model.DataEntity;
import co.nvqa.common.utils.StandardTestConstants;
import co.nvqa.operator_v2.model.RouteLogsParams;
import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.ant.AntSelect3;
import co.nvqa.operator_v2.selenium.page.StationRoutePage;
import co.nvqa.operator_v2.selenium.page.StationRoutePage.CreatedRoutesDetailsTableRecord;
import co.nvqa.operator_v2.selenium.page.StationRoutePage.DriversRouteTableRecord;
import co.nvqa.operator_v2.selenium.page.StationRoutePage.DriversTableRecord;
import co.nvqa.operator_v2.selenium.page.StationRoutePage.Parcel;
import co.nvqa.operator_v2.util.TestUtils;
import io.cucumber.guice.ScenarioScoped;
import io.cucumber.java.en.When;
import java.io.File;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.stream.Collectors;
import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.io.FileUtils;
import org.apache.commons.lang3.RandomStringUtils;
import org.apache.commons.lang3.StringUtils;
import org.assertj.core.api.Assertions;
import org.assertj.core.api.SoftAssertions;
import org.openqa.selenium.NoSuchElementException;

import static co.nvqa.operator_v2.selenium.page.StationRoutePage.ParcelsTable.ACTION_REMOVE;
import static co.nvqa.operator_v2.selenium.page.StationRoutePage.ParcelsTable.COLUMN_ADDRESS;
import static co.nvqa.operator_v2.selenium.page.StationRoutePage.ParcelsTable.COLUMN_DRIVER_ID;
import static co.nvqa.operator_v2.selenium.page.StationRoutePage.ParcelsTable.COLUMN_ORDER_TAGS;
import static co.nvqa.operator_v2.selenium.page.StationRoutePage.ParcelsTable.COLUMN_PARCEL_SIZE;
import static co.nvqa.operator_v2.selenium.page.StationRoutePage.ParcelsTable.COLUMN_TRACKING_ID;
import static org.assertj.core.api.Assertions.assertThat;

/**
 * @author Sergey Mishanin
 */
@ScenarioScoped
public class StationRouteSteps extends AbstractSteps {

  public static final String STATION_ROUTE_ORDERS_CSV = "station-route-orders.csv";
  private StationRoutePage page;

  public StationRouteSteps() {
  }

  @Override
  public void init() {
    page = new StationRoutePage(getWebDriver());
  }

  @When("Operator select filters on Station Route page:")
  public void selectFilters(Map<String, String> data) {
    Map<String, String> finalData = resolveKeyValues(data);
    page.inFrame(() -> {
      page.waitUntilLoaded(2, 60);
      if (!page.assignDrivers.waitUntilVisible(30)) {
        page.refreshPage();
        page.waitUntilLoaded(2, 60);
        page.assignDrivers.waitUntilVisible();
      }

      if (finalData.containsKey("hub")) {
        page.hub.selectValue(finalData.get("hub"));
      }
      if (finalData.containsKey("driversOnLeave")) {
        page.driversOnLeave.clearValue();
        page.driversOnLeave.selectValues(splitAndNormalize(finalData.get("driversOnLeave")));
      }
      if (finalData.containsKey("shipmentType")) {
        page.shipmentType.clearValue();
        page.shipmentType.selectValues(splitAndNormalize(finalData.get("shipmentType")));
      }
      String value;
      if (finalData.containsKey("shipmentDateFrom") || finalData.containsKey("shipmentDateTo")) {
        value = finalData.get("shipmentDateFrom");
        if (StringUtils.isNotBlank(value)) {
          page.shipmentDate.setFromDate(value);
        }
        value = finalData.get("shipmentDateTo");
        if (StringUtils.isNotBlank(value)) {
          page.shipmentDate.setToDate(value);
        }
      }
      if (finalData.containsKey("shipmentCompletionTimeFrom") || finalData.containsKey(
          "shipmentCompletionTimeTo")) {
        value = finalData.get("shipmentCompletionTimeFrom");
        if (StringUtils.isNotBlank(value)) {
          page.shipmentCompletionTime.setFromDate(value);
        }
        value = finalData.get("shipmentCompletionTimeTo");
        if (StringUtils.isNotBlank(value)) {
          page.shipmentCompletionTime.setToDate(value);
        }
      }
      if (finalData.containsKey("alsoSearchInHub")) {
        page.alsoSearchInHub.setValue(Boolean.parseBoolean(finalData.get("alsoSearchInHub")));
      }
      if (finalData.containsKey("additionalTids")) {
        page.additionalTids.setValue(finalData.get("additionalTids").replace(",", "\n"));
      }
    });
  }

  @When("Operator click Assign drivers button on Station Route page")
  public void clickAssignDrivers() {
    page.inFrame(() -> {
      if (page.assignDrivers.waitUntilVisible(1)) {
        page.assignDrivers.click();
      } else {
        page.assignDriversUpload.click();
      }
    });
  }

  @When("Operator verify {value} Shipment date error on Station Route page")
  public void verifyShipmentDateMessage(String expected) {
    page.inFrame(() -> {
      Assertions.assertThat(page.shipmentDateError.isDisplayed())
          .withFailMessage("Shipment date error is not displayed").isTrue();
      Assertions.assertThat(page.shipmentDateError.getNormalizedText()).as("Shipment date error")
          .isEqualTo(expected);
    });
  }

  @When("Operator verify {value} Shipment completion time error on Station Route page")
  public void verifyShipmentCompletionDateMessage(String expected) {
    page.inFrame(() -> {
      Assertions.assertThat(page.shipmentCompletionTimeError.isDisplayed())
          .withFailMessage("Shipment completion time error is not displayed").isTrue();
      Assertions.assertThat(page.shipmentCompletionTimeError.getNormalizedText())
          .as("Shipment completion time error").isEqualTo(expected);
    });
  }

  @When("Operator verify Assign drivers button is enabled on Station Route Page")
  public void assignDriversIsEnabled() {
    page.inFrame(() -> {
      Assertions.assertThat(page.assignDrivers.isEnabled())
          .as("Assign drivers button is enabled")
          .isTrue();
    });
  }

  @When("Operator verify Assign drivers button is disabled on Station Route page")
  public void assignDriversIsDisabled() {
    page.inFrame(() -> {
      Assertions.assertThat(page.assignDrivers.isEnabled())
          .as("Assign drivers button is not disabled").isFalse();
    });
  }

  @When("Operator verify Assign Drivers button is disabled on Station Route page")
  public void checkAssignDriversIsDisabled() {
    page.inFrame(() -> {
      Button button =
          page.assignDrivers.waitUntilVisible(1) ? page.assignDrivers : page.assignDriversUpload;
      assertThat(button.isEnabled()).withFailMessage("Assign Drivers button is enabled").isFalse();
    });
  }

  @When("Operator open Upload CSV tab on Station Route page")
  public void openUploadCsv() {
    page.inFrame(() -> {
      page.waitUntilLoaded(2, 30);
      page.uploadCsv.click();
    });
  }

  @When("Operator selects {value} hub on Station Route page")
  public void selectHub(String hubName) {
    page.inFrame(() -> {
      if (page.hub.waitUntilVisible(1)) {
        page.hub.selectValue(hubName);
      } else {
        page.hubUpload.selectValue(hubName);
      }
    });
  }

  @When("Operator cannot select {value} hub on Station Route page")
  public void cannotSelectHub(String hubName) {
    page.inFrame(() -> {
      AntSelect3 hub = page.hub.waitUntilVisible(1) ? page.hub : page.hubUpload;
      Assertions.assertThatThrownBy(() -> hub.selectValue(hubName))
          .withFailMessage("Can select %s hub", hubName).isInstanceOf(NoSuchElementException.class);
    });
  }

  @When("Operator upload CSV file on Station Route page:")
  public void uploadCsv(List<Map<String, String>> data) {
    page.inFrame(() -> {
      String content = resolveListOfMaps(data).stream().map(
          r -> StringUtils.trimToEmpty(r.get("driverId")) + "," + StringUtils.trimToEmpty(
              r.get("trackingId"))).collect(Collectors.joining("\n"));
      File file = TestUtils.createFileOnTempFolder(
          String.format("station_route_%s.csv", page.generateDateUniqueString()));
      try {
        FileUtils.write(file, content, StandardCharsets.UTF_8);
      } catch (IOException e) {
        throw new RuntimeException(e);
      }
      page.uploadFile.setValue(file);
    });
  }

  @When("Operator upload CSV file with more then 10000 rows on Station Route page")
  public void uploaBigCsv() {
    page.inFrame(() -> {

      StringBuilder content = new StringBuilder();
      for (int i = 0; i <= 10_000; i++) {
        content.append("NVSGCOPV2")
            .append(RandomStringUtils.randomAlphanumeric(9).toUpperCase(Locale.ROOT)).append(",")
            .append(RandomStringUtils.randomNumeric(8)).append("\n");
      }
      File file = TestUtils.createFileOnTempFolder(
          String.format("station_route_%s.csv", page.generateDateUniqueString()));
      try {
        FileUtils.write(file, content, StandardCharsets.UTF_8);
      } catch (IOException e) {
        throw new RuntimeException(e);
      }
      page.uploadFile.setValue(file);
    });
  }

  @When("Operator upload downloaded CSV file on Station Route page")
  public void uploadDownloadedCsv() {
    page.inFrame(() -> {
      String pathname = StandardTestConstants.TEMP_DIR + STATION_ROUTE_ORDERS_CSV;
      page.uploadFile.setValue(pathname);
    });
  }

  @When("Operator verify Tracking IDs in Invalid Input dialog on Station Route page:")
  public void verifyTrackingIds(List<String> data) {
    page.inFrame(() -> {
      page.invalidInputDialog.waitUntilVisible();
      List<String> actual = page.invalidInputDialog.trackingIds.stream()
          .map(PageElement::getNormalizedText).collect(Collectors.toList());
      assertThat(actual).as("List of invalid tracking ids")
          .containsExactlyInAnyOrderElementsOf(resolveValues(data));
    });
  }

  @When("Operator verify Tracking IDs are not displayed in Invalid Input dialog on Station Route page")
  public void verifyTrackingIds() {
    page.inFrame(() -> {
      page.invalidInputDialog.waitUntilVisible();
      assertThat(page.invalidInputDialog.trackingIds).as("List of invalid tracking ids").isEmpty();
    });
  }

  @When("Operator verify Driver IDs are not displayed in Invalid Input dialog on Station Route page")
  public void verifyDriverIds() {
    page.inFrame(() -> {
      page.invalidInputDialog.waitUntilVisible();
      assertThat(page.invalidInputDialog.drivers).as("List of invalid driver ids").isEmpty();
    });
  }

  @When("Operator click Cancel button in Invalid Input dialog on Station Route page")
  public void clickCancel() {
    page.inFrame(() -> {
      page.invalidInputDialog.waitUntilVisible();
      page.invalidInputDialog.cancel.click();
    });
  }

  @When("Operator verify Driver IDs in Invalid Input dialog on Station Route page:")
  public void verifyDriverIds(List<String> data) {
    page.inFrame(() -> {
      page.invalidInputDialog.waitUntilVisible();
      List<String> actual = page.invalidInputDialog.drivers.stream()
          .map(PageElement::getNormalizedText).collect(Collectors.toList());
      assertThat(actual).as("List of invalid driver ids")
          .containsExactlyInAnyOrderElementsOf(resolveValues(data));
    });
  }

  @When("Operator click Download CSV button on Station Route page")
  public void clickDownloadsCsv() {
    page.inFrame(() -> {
      page.downloadCsv.click();
      page.waitUntilVisibilityOfNotification("CSV downloaded!");
    });
  }

  @When("Operator verify statistics on Station Route page")
  public void verifyStatistics() {
    page.inFrame(() -> {
      page.waitUntilLoaded();
      SoftAssertions assertions = new SoftAssertions();
      assertions.assertThat(page.numberOfShipments.isDisplayed())
          .withFailMessage("Number of shipments is not displayed").isTrue();
      assertions.assertThat(page.parcelCount.isDisplayed())
          .withFailMessage("Parcel count in shipments is not displayed").isTrue();
      assertions.assertThat(page.additionalParcels.isDisplayed())
          .withFailMessage("Additional parcels is not displayed").isTrue();
      assertions.assertThat(page.totalParcels.isDisplayed())
          .withFailMessage("Total parcels is not displayed").isTrue();
      assertions.assertThat(page.activeDrivers.isDisplayed())
          .withFailMessage("Active drivers is not displayed").isTrue();
      assertions.assertThat(page.averageParcels.isDisplayed())
          .withFailMessage("Average parcels per driver").isTrue();
      assertions.assertAll();
    });
  }

  @When("Operator verify downloaded CSV on Station Route page:")
  public void verifyDownloadedCsv(List<Map<String, String>> data) {
    page.inFrame(() -> {
      page.waitUntilLoaded();
      String expected = resolveListOfMaps(data).stream()
          .map(row -> "\"\"," + row.get("trackingId") + "," + row.get("address"))
          .collect(Collectors.joining("\n"));
      page.verifyFileDownloadedSuccessfully(STATION_ROUTE_ORDERS_CSV, expected);
    });
  }

  @When("Operator verify statistics on Station Route page:")
  public void verifyStatistics(Map<String, String> data) {
    page.inFrame(() -> {
      page.waitUntilLoaded();
      SoftAssertions assertions = new SoftAssertions();
      if (data.containsKey("additionalParcels")) {
        assertions.assertThat(page.additionalParcels.getText()).as("Additional parcels")
            .isEqualTo(data.get("additionalParcels"));
      }
      assertions.assertAll();
    });
  }

  @When("Operator verify parcel is displayed on Station Route page:")
  public void verifyParcel(Map<String, String> data) {
    Parcel expected = new Parcel(resolveKeyValues(data));
    page.inFrame(() -> {
      page.parcelsTable.filterByColumn(COLUMN_TRACKING_ID, expected.getTrackingId());
      assertThat(page.parcelsTable.isTableEmpty()).withFailMessage(
          "Parcel " + expected.getTrackingId() + " is not displayed").isFalse();
      Parcel actual = page.parcelsTable.readEntity(1);
      expected.compareWithActual(actual);
    });
  }

  @When("Operator verify any parcel is displayed on Station Route page:")
  public void verifyParcel(List<Map<String, String>> list) {
    boolean found = false;
    for (Map<String, String> data : list) {
      try {
        verifyParcel(data);
        found = true;
        break;
      } catch (AssertionError err) {

      }
    }
    Assertions.assertThat(found).withFailMessage("No one parcel record was not found: " + list)
        .isTrue();
  }

  @When("Operator verify parcels table is empty on Station Route page")
  public void verifyParcelsTableIsEmpty() {
    page.inFrame(() -> {
      assertThat(page.parcelsTable.isTableEmpty()).withFailMessage("Parcels table is not empty")
          .isTrue();
    });
  }

  @When("Operator clear parcels table filters on Station Route page")
  public void clearFilters(Map<String, String> data) {
    Parcel expected = new Parcel(resolveKeyValues(data));
    page.inFrame(() -> page.parcelsTable.clearColumnFilters());
  }

  @When("Operator filter parcels table on Station Route page:")
  public void filterParcels(Map<String, String> data) {
    Parcel expected = new Parcel(resolveKeyValues(data));
    page.inFrame(() -> {
      page.parcelsTable.clearColumnFilters();
      if (StringUtils.isNotBlank(expected.getTrackingId())) {
        page.parcelsTable.filterByColumn(COLUMN_TRACKING_ID, expected.getTrackingId());
      }
      if (StringUtils.isNotBlank(expected.getAddress())) {
        page.parcelsTable.filterByColumn(COLUMN_ADDRESS, expected.getAddress());
      }
      if (StringUtils.equalsIgnoreCase("true", data.get("shownOnlyMatchingArea"))) {
        page.showOnlyMatchingArea.check();
      } else {
        page.showOnlyMatchingArea.uncheck();
      }
      if (StringUtils.isNotBlank(expected.getParcelSize())) {
        page.parcelsTable.filterByColumn(COLUMN_PARCEL_SIZE, expected.getParcelSize());
      }
      if (CollectionUtils.isNotEmpty(expected.getOrderTags())) {
        page.parcelsTable.filterByColumn(COLUMN_ORDER_TAGS, expected.getOrderTags().get(0));
      }
      if (StringUtils.isNotBlank(expected.getDriverId())) {
        page.parcelsTable.filterByColumn(COLUMN_DRIVER_ID, expected.getDriverId());
      }
      if (StringUtils.isNotBlank(data.get("action"))) {
        page.actionsFilter.selectValue(data.get("action"));
      }
    });
  }

  @When("Operator verify parcels table contains {value} value in {value} column on Station Route page")
  public void checkParcelsTableColumn(String value, String columnId) {
    page.inFrame(() -> {
      List<String> actual = page.parcelsTable.readColumn(columnId);
      assertThat(actual).as("List of %s column values", columnId).isNotEmpty()
          .allSatisfy(val -> assertThat(val).containsIgnoringCase(value));
    });
  }

  @When("Operator verify parcels table not contains {value} value in {value} column on Station Route page")
  public void checkParcelsTableColumnNotShow(String value, String columnId) {
    page.inFrame(() -> {
      page.parcelsTable.filterByColumn(columnId, value);
      List<String> actual = page.parcelsTable.readColumn(columnId);
      assertThat(actual).as("List of %s column values", columnId).isEmpty();
    });
  }

  @When("Operator verify parcels table row {int} marked as removed on Station Route page")
  public void checkRemovedParcel(int index) {
    page.inFrame(() -> assertThat(page.parcelsTable.isRowRemoved(index)).withFailMessage(
        "Row %s is not marked as removed", index).isTrue());
  }

  @When("Operator verify parcels table row {int} not marked as removed on Station Route page")
  public void checkNotRemovedParcel(int index) {
    page.inFrame(() -> assertThat(page.parcelsTable.isRowRemoved(index)).withFailMessage(
        "Row %s is marked as removed", index).isFalse());
  }

  @When("Operator verify exactly parcels are displayed on Upload CSV tab on Station Route page:")
  public void verifyExactlyUploadedParcels(List<Map<String, String>> data) {
    List<Parcel> expected = data.stream().map(r -> new Parcel(resolveKeyValues(r)))
        .collect(Collectors.toList());
    page.inFrame(() -> {
      page.waitUntilLoaded();
      List<Parcel> actual = page.uploadedParcelsTable.readAllEntities();
      assertThat(actual).as("Uploaded parcels").containsExactlyInAnyOrderElementsOf(expected);
    });
  }

  @When("Operator verify parcels are displayed on Upload CSV tab on Station Route page:")
  public void verifyUploadedParcels(List<Map<String, String>> data) {
    List<Parcel> expected = data.stream().map(r -> new Parcel(resolveKeyValues(r)))
        .collect(Collectors.toList());
    page.inFrame(() -> {
      page.waitUntilLoaded();
      List<Parcel> actual = page.uploadedParcelsTable.readAllEntities();
      assertThat(actual).as("Uploaded parcels").containsAll(expected);
    });
  }

  @When("Operator verify banner is displayed on Station Route page")
  public void verifyBanner() {
    page.inFrame(() -> {
      assertThat(page.banner.isDisplayed()).withFailMessage(
              "Banner [To check assignment and create routes, there should be no \"UNASSIGNED\" for the \"Assigned driver\" column.\n] is not displayed")
          .isTrue();
    });
  }

  @When("Operator verify area match {value} is displayed in row {int} on Station Route page")
  @When("Operator verify area match {value} is displayed on {int} position on Station Route page")
  public void verifyAreaMatch(String value, int index) {
    page.inFrame(() -> {
      assertThat(page.areaMatch).as("Displayed row count").hasSizeGreaterThanOrEqualTo(index - 1);
      assertThat(page.areaMatch.get(index - 1).getText()).as("Area match in row %d", index)
          .isEqualTo(StringUtils.normalizeSpace(value));
    });
  }

  @When("Operator verify any area match is displayed on {int} position on Station Route page:")
  public void verifyAreaMatch(int index, List<String> data) {
    page.inFrame(() -> {
      assertThat(page.areaMatch).as("Displayed row count").hasSizeGreaterThanOrEqualTo(index - 1);
      assertThat(page.areaMatch.get(index - 1).getText()).as("Area match in row %d", index)
          .isIn(resolveValues(data));
    });
  }

  @When("Operator verify area match is not displayed on Station Route page")
  public void verifyNoAreaMatch() {
    page.inFrame(() -> assertThat(page.areaMatch).as("Area match list").isEmpty());
  }

  @When("Operator verify keyword match {value} is displayed in row {int} on Station Route page")
  @When("Operator verify keyword match {value} is displayed on {int} position on Station Route page")
  public void verifyKeywordMatch(String value, int index) {
    page.inFrame(() -> {
      assertThat(page.keywordMatch).as("Displayed row count")
          .hasSizeGreaterThanOrEqualTo(index - 1);
      assertThat(page.keywordMatch.get(index - 1).getText()).as("Keyword match in row %d", index)
          .isEqualTo(StringUtils.normalizeSpace(value));
    });
  }

  @When("Operator verify any keyword match is displayed on {int} position on Station Route page:")
  public void verifyKeywordMatch(int index, List<String> data) {
    page.inFrame(() -> {
      if (data.contains("empty") && page.keywordMatch.size() < index) {
        return;
      }
      data.remove("empty");
      assertThat(page.keywordMatch).as("Displayed row count")
          .hasSizeGreaterThanOrEqualTo(index - 1);

      assertThat(page.keywordMatch.get(index - 1).getText()).as("Keyword match in row %d", index)
          .isIn(resolveValues(data));
    });
  }

  @When("Operator verify keyword match is not displayed on Station Route page")
  public void verifyNoKeywordMatch() {
    page.inFrame(() -> {
      assertThat(page.keywordMatch).as("Keyword match list").isEmpty();
    });
  }

  @When("Operator click Check assignment button on Station Route page")
  public void clickCheckAssignment() {
    page.inFrame(() -> page.checkAssignment.click());
  }

  @When("Operator verify Check assignment button is disabled on Station Route page")
  public void clickCheckAssignmentIsDisabled() {
    page.inFrame(() -> assertThat(page.checkAssignment.isEnabled()).withFailMessage(
        "Check assignment button is enabled").isFalse());
  }

  @When("Operator verify driver records on Select route creation method screen on Station Route page:")
  public void checkDriversRecords(List<Map<String, String>> data) {
    page.inFrame(() -> {
      List<DriversTableRecord> actual = page.driversTable.readAllEntities();
      data.forEach(r -> {
        DriversTableRecord expected = new DriversTableRecord(resolveKeyValues(r));
        DataEntity.assertListContains(actual, expected, "Assigned driver record");
      });
    });
  }

  @When("Operator verify parcel count is {int} on Select route creation method screen on Station Route page")
  public void checkParcelCount(int count) {
    page.inFrame(() -> {
      assertThat(page.rcParcelCount.getText()).as("Parcel count").isEqualTo(String.valueOf(count));
    });
  }

  @When("Operator verify driver count is {int} on Select route creation method screen on Station Route page")
  public void checkDriverCount(int count) {
    page.inFrame(() -> {
      assertThat(page.rcDriverCount.getText()).as("Driver count").isEqualTo(String.valueOf(count));
    });
  }

  @When("Operator select Add to existing routes on Station Route page")
  public void clickAddToExistingRoutes() {
    page.inFrame(() -> page.addToExistingRoutes.click());
  }

  @When("Operator select Create new routes on Station Route page")
  public void clickCreateNewRoutes() {
    page.inFrame(() -> page.createNewRoutes.click());
  }

  @When("Operator click Next button on Station Route page")
  public void clickNextButton() {
    page.inFrame(() -> {
      if (page.next.waitUntilVisible(2)) {
        page.next.click();
      } else {
        page.next2.click();
      }
    });
  }

  @When("Operator verify table records on Add to existing routes screen on Station Route page:")
  public void checkDriversRoutesTableRecords(List<Map<String, String>> data) {
    page.inFrame(() -> {
      List<DriversRouteTableRecord> actual = page.driversRouteTable.readAllEntities();
      data.forEach(r -> {
        DriversRouteTableRecord expected = new DriversRouteTableRecord(resolveKeyValues(r));
        DataEntity.assertListContains(actual, expected, "Assigned driver to route record");
      });
    });
  }

  @When("Operator verify table records on Created routes detail screen on Station Route page:")
  public void checkCreatedRoutesDetailsTableRecords(List<Map<String, String>> data) {
    page.inFrame(() -> {
      pause2s();
      List<CreatedRoutesDetailsTableRecord> actual = page.createdRoutesDetailsTable.readAllEntities();
      actual.stream().filter(r -> StringUtils.isNotBlank(r.getRouteId()))
          .map(r -> Long.valueOf(r.getRouteId()))
          .forEach(id -> putInList(KEY_LIST_OF_CREATED_ROUTE_ID, id));
      data.forEach(r -> {
        CreatedRoutesDetailsTableRecord expected = new CreatedRoutesDetailsTableRecord(
            resolveKeyValues(r));
        DataEntity.assertListContains(actual, expected, "Created routes detail record");
      });
    });
  }

  @When("Operator fill Create new routes form on Station Route page:")
  public void operatorCreateNewRouteUsingDataBelow(Map<String, String> data) {
    RouteLogsParams newParams = new RouteLogsParams(resolveKeyValues(data));

    page.inFrame(() -> {
      if (StringUtils.isNotBlank(newParams.getDate())) {
        page.crRouteDate.setValue(newParams.getDate());
      }
      if (CollectionUtils.isNotEmpty(newParams.getTags())) {
        page.crRouteTags.selectValues(newParams.getTags());
      }
      if (StringUtils.isNotBlank(newParams.getZone())) {
        page.crZone.selectValue(newParams.getZone());
      }
      if (StringUtils.equalsIgnoreCase("true", data.get("usePreferredZone"))) {
        page.crUsePreferredZone.check();
      }
      if (StringUtils.isNotBlank(newParams.getHub())) {
        page.crHub.selectValue(newParams.getHub());
      }
      if (StringUtils.isNotBlank(newParams.getComments())) {
        page.crComments.setValue(newParams.getComments());
      }
    });
  }

  @When("Operator verify Create new routes form on Station Route page:")
  public void verifyCreateNewRouteUsingDataBelow(Map<String, String> data) {
    RouteLogsParams newParams = new RouteLogsParams(resolveKeyValues(data));
    SoftAssertions assertions = new SoftAssertions();
    page.inFrame(() -> {
      if (StringUtils.isNotBlank(newParams.getZone())) {
        assertions.assertThat(page.crZone.getValue()).as("Zone").isEqualTo(newParams.getZone());
      }
    });
    assertions.assertAll();
  }

  @When("Operator click Create routes button on Station Route page")
  public void clickCreateRoutesButton() {
    page.inFrame(() -> page.createRoutes.click());
  }

  @When("Operator verify errors are displayed on Station Route page:")
  public void checkErrors(List<String> data) {
    page.inFrame(() -> {
      page.errorsDialog.waitUntilVisible();
      Assertions.assertThat(
              page.errorsDialog.error.stream().map(PageElement::getText).collect(Collectors.toList()))
          .as("List of errors").containsExactlyInAnyOrderElementsOf(resolveValues(data));
    });
  }

  @When("Operator click Cancel button in Error dialog on Station Route page")
  public void clickCancelInErrorDialog() {
    page.inFrame(() -> {
      page.errorsDialog.waitUntilVisible();
      page.errorsDialog.cancel.click();
    });
  }

  @When("Operator assign {value} driver for {int} row parcel on Station Route page")
  public void assignDriver(String driverName, int index) {
    page.inFrame(() -> page.parcelsTable.assignDriver(driverName, index));
  }

  @When("Operator assign {value} driver to parcels on Station Route page:")
  public void assignDriver(String driverName, List<String> trackingIds) {
    page.inFrame(() -> {
      resolveValues(trackingIds).forEach(id -> {
        page.parcelsTable.filterByColumn(COLUMN_TRACKING_ID, id);
        page.parcelsTable.selectRow(1);
      });
      page.selectDrivers.selectValue(driverName);
    });
  }

  @When("Operator remove parcels on Station Route page:")
  public void removeParcels(List<String> trackingIds) {
    page.inFrame(() -> {
      resolveValues(trackingIds).forEach(id -> {
        page.parcelsTable.filterByColumn(COLUMN_TRACKING_ID, id);
        page.parcelsTable.clickActionButton(1, ACTION_REMOVE);
      });
    });
  }

  @When("Operator select parcels on Station Route page:")
  public void selectParcels(List<String> trackingIds) {
    page.inFrame(() -> {
      resolveValues(trackingIds).forEach(id -> {
        page.parcelsTable.filterByColumn(COLUMN_TRACKING_ID, id);
        page.parcelsTable.selectRow(1);
      });
    });
  }

  @When("Operator click Remove all selected parcels on Station Route page")
  public void removeAllSelectedParcelsParcels() {
    page.inFrame(() -> page.removeAllSelectedParcels.click());
  }
}
