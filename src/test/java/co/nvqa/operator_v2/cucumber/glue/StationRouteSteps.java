package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.common.utils.StandardTestConstants;
import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.ant.AntSelect3;
import co.nvqa.operator_v2.selenium.page.StationRoutePage;
import co.nvqa.operator_v2.selenium.page.StationRoutePage.Parcel;
import co.nvqa.operator_v2.selenium.page.StationRoutePage.ParcelsTable;
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
import org.apache.commons.io.FileUtils;
import org.apache.commons.lang3.RandomStringUtils;
import org.apache.commons.lang3.StringUtils;
import org.assertj.core.api.Assertions;
import org.assertj.core.api.SoftAssertions;
import org.openqa.selenium.NoSuchElementException;

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
      page.assignDrivers.waitUntilVisible();
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

  @When("Operator verify Assign Drivers button is disabled on Station Route page")
  public void checkAssignDriversIsDisabled() {
    page.inFrame(() -> {
      Button button = page.assignDrivers.waitUntilVisible(1) ?
          page.assignDrivers :
          page.assignDriversUpload;
      Assertions.assertThat(button.isEnabled())
          .withFailMessage("Assign Drivers button is enabled")
          .isFalse();
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
      AntSelect3 hub = page.hub.waitUntilVisible(1) ?
          page.hub : page.hubUpload;
      Assertions.assertThatThrownBy(() -> hub.selectValue(hubName))
          .withFailMessage("Can select %s hub", hubName)
          .isInstanceOf(NoSuchElementException.class);
    });
  }

  @When("Operator upload CSV file on Station Route page:")
  public void uploadCsv(List<Map<String, String>> data) {
    page.inFrame(() -> {
      String content = resolveListOfMaps(data).stream()
          .map(r -> StringUtils.trimToEmpty(r.get("driverId")) + "," + StringUtils.trimToEmpty(
              r.get("trackingId")))
          .collect(Collectors.joining("\n"));
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
        content.append("NVSGCOPV2").append(RandomStringUtils.randomAlphanumeric(9).toUpperCase(
            Locale.ROOT)).append(",").append(RandomStringUtils.randomNumeric(8)).append("\n");
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
      Assertions.assertThat(actual)
          .as("List of invalid tracking ids")
          .containsExactlyInAnyOrderElementsOf(resolveValues(data));
    });
  }

  @When("Operator verify Tracking IDs are not displayed in Invalid Input dialog on Station Route page")
  public void verifyTrackingIds() {
    page.inFrame(() -> {
      page.invalidInputDialog.waitUntilVisible();
      Assertions.assertThat(page.invalidInputDialog.trackingIds)
          .as("List of invalid tracking ids")
          .isEmpty();
    });
  }

  @When("Operator verify Driver IDs are not displayed in Invalid Input dialog on Station Route page")
  public void verifyDriverIds() {
    page.inFrame(() -> {
      page.invalidInputDialog.waitUntilVisible();
      Assertions.assertThat(page.invalidInputDialog.drivers)
          .as("List of invalid driver ids")
          .isEmpty();
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
      Assertions.assertThat(actual)
          .as("List of invalid driver ids")
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
          .withFailMessage("Number of shipments is not displayed")
          .isTrue();
      assertions.assertThat(page.parcelCount.isDisplayed())
          .withFailMessage("Parcel count in shipments is not displayed")
          .isTrue();
      assertions.assertThat(page.additionalParcels.isDisplayed())
          .withFailMessage("Additional parcels is not displayed")
          .isTrue();
      assertions.assertThat(page.totalParcels.isDisplayed())
          .withFailMessage("Total parcels is not displayed")
          .isTrue();
      assertions.assertThat(page.activeDrivers.isDisplayed())
          .withFailMessage("Active drivers is not displayed")
          .isTrue();
      assertions.assertThat(page.averageParcels.isDisplayed())
          .withFailMessage("Average parcels per driver")
          .isTrue();
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
        assertions.assertThat(page.additionalParcels.getText())
            .as("Additional parcels")
            .isEqualTo(data.get("additionalParcels"));
      }
      assertions.assertAll();
    });
  }

  @When("Operator verify parcel is displayed on Station Route page:")
  public void verifyParcel(Map<String, String> data) {
    Parcel expected = new Parcel(resolveKeyValues(data));
    page.inFrame(() -> {
      page.parcelsTable.filterByColumn(ParcelsTable.COLUMN_TRACKING_ID, expected.getTrackingId());
      Assertions.assertThat(page.parcelsTable.isTableEmpty())
          .withFailMessage("Parcel " + expected.getTrackingId() + " is not displayed")
          .isFalse();
      Parcel actual = page.parcelsTable.readEntity(1);
      expected.compareWithActual(actual);
    });
  }

  @When("Operator verify exactly parcels are displayed on Upload CSV tab on Station Route page:")
  public void verifyExactlyUploadedParcels(List<Map<String, String>> data) {
    List<Parcel> expected = data.stream()
        .map(r -> new Parcel(resolveKeyValues(r)))
        .collect(Collectors.toList());
    page.inFrame(() -> {
      page.waitUntilLoaded();
      List<Parcel> actual = page.uploadedParcelsTable.readAllEntities();
      Assertions.assertThat(actual)
          .as("Uploaded parcels")
          .containsExactlyInAnyOrderElementsOf(expected);
    });
  }

  @When("Operator verify parcels are displayed on Upload CSV tab on Station Route page:")
  public void verifyUploadedParcels(List<Map<String, String>> data) {
    List<Parcel> expected = data.stream()
        .map(r -> new Parcel(resolveKeyValues(r)))
        .collect(Collectors.toList());
    page.inFrame(() -> {
      page.waitUntilLoaded();
      List<Parcel> actual = page.uploadedParcelsTable.readAllEntities();
      Assertions.assertThat(actual)
          .as("Uploaded parcels")
          .containsAll(expected);
    });
  }

  @When("Operator verify banner is displayed on Station Route page")
  public void verifyBanner() {
    page.inFrame(() -> {
      Assertions.assertThat(page.banner.isDisplayed())
          .withFailMessage(
              "Banner [To check assignment and create routes, there should be no \"UNASSIGNED\" for the \"Assigned driver\" column.\n] is not displayed")
          .isTrue();
    });
  }

  @When("Operator verify area match {value} is displayed in row {int} on Station Route page")
  @When("Operator verify area match {value} is displayed on {int} position on Station Route page")
  public void verifyAreaMatch(String value, int index) {
    page.inFrame(() -> {
      Assertions.assertThat(page.areaMatch)
          .as("Displayed row count")
          .hasSizeGreaterThanOrEqualTo(index - 1);
      Assertions.assertThat(page.areaMatch.get(index - 1).getText())
          .as("Area match in row %d", index)
          .isEqualTo(StringUtils.normalizeSpace(value));
    });
  }

  @When("Operator verify area match is not displayed on Station Route page")
  public void verifyNoAreaMatch() {
    page.inFrame(() -> Assertions.assertThat(page.areaMatch)
        .as("Area match list")
        .isEmpty());
  }

  @When("Operator verify keyword match {value} is displayed in row {int} on Station Route page")
  public void verifyKeywordMatch(String value, int index) {
    page.inFrame(() -> {
      Assertions.assertThat(page.keywordMatch)
          .as("Displayed row count")
          .hasSizeGreaterThanOrEqualTo(index - 1);
      Assertions.assertThat(page.keywordMatch.get(index - 1).getText())
          .as("Keyword match in row %d", index)
          .isEqualTo(StringUtils.normalizeSpace(value));
    });
  }

  @When("Operator verify keyword match is not displayed on Station Route page")
  public void verifyNoKeywordMatch() {
    page.inFrame(() -> {
      Assertions.assertThat(page.keywordMatch)
          .as("Keyword match list")
          .isEmpty();
    });
  }

}
