package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.operator_v2.selenium.page.StationRoutePage;
import co.nvqa.operator_v2.selenium.page.StationRoutePage.Parcel;
import co.nvqa.operator_v2.selenium.page.StationRoutePage.ParcelsTable;
import io.cucumber.guice.ScenarioScoped;
import io.cucumber.java.en.When;
import java.util.Map;
import org.apache.commons.lang3.StringUtils;
import org.assertj.core.api.Assertions;
import org.assertj.core.api.SoftAssertions;

/**
 * @author Sergey Mishanin
 */
@ScenarioScoped
public class StationRouteSteps extends AbstractSteps {

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
      page.waitUntilLoaded(2);
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
          page.shipmentDate.selectFromHours("00");
          page.shipmentDate.selectFromMinutes("00");
        }
        value = finalData.get("shipmentDateTo");
        if (StringUtils.isNotBlank(value)) {
          page.shipmentDate.setToDate(value);
          page.shipmentDate.selectToHours("00");
          page.shipmentDate.selectToMinutes("00");
        }
      }
      if (finalData.containsKey("shipmentCompletionTimeFrom") || finalData.containsKey(
          "shipmentCompletionTimeTo")) {
        value = finalData.get("shipmentCompletionTimeFrom");
        if (StringUtils.isNotBlank(value)) {
          page.shipmentCompletionTime.setFromDate(value);
          page.shipmentCompletionTime.selectFromHours("00");
          page.shipmentCompletionTime.selectFromMinutes("00");
        }
        value = finalData.get("shipmentCompletionTimeTo");
        if (StringUtils.isNotBlank(value)) {
          page.shipmentCompletionTime.setToDate(value);
          page.shipmentCompletionTime.selectToHours("00");
          page.shipmentCompletionTime.selectToMinutes("00");
        }
      }
      if (finalData.containsKey("additionalTids")) {
        page.additionalTids.setValue(finalData.get("additionalTids").replace(",", "\n"));
      }
    });
  }

  @When("Operator click Assign drivers button on Station Route page")
  public void clickAssignDrivers() {
    page.inFrame(() -> page.assignDrivers.click());
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
    page.inFrame(() -> {
      Assertions.assertThat(page.areaMatch)
          .as("Area match list")
          .isEmpty();
    });
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
