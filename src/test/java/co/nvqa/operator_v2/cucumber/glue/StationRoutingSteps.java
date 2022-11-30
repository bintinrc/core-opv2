package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.common.utils.StandardTestUtils;
import co.nvqa.operator_v2.selenium.page.StationRoutingPage;
import co.nvqa.operator_v2.selenium.page.StationRoutingPage.Assignment;
import io.cucumber.guice.ScenarioScoped;
import io.cucumber.java.en.Then;
import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;
import org.apache.commons.lang3.StringUtils;
import org.assertj.core.api.Assertions;


@ScenarioScoped
public class StationRoutingSteps extends AbstractSteps {

  private StationRoutingPage page;

  public StationRoutingSteps() {
  }

  @Override
  public void init() {
    page = new StationRoutingPage(getWebDriver());
  }

  @Then("Operator selects {value} hub on Station Routing page")
  public void selectHub(String hub) {
    page.inFrame(() -> {
      page.waitUntilLoaded();
      page.hub.selectValue(hub);
    });
  }

  @Then("Operator uploads CSV file on Station Routing page:")
  public void uploadFile(List<Map<String, String>> data) {
    String content = resolveListOfMaps(data).stream()
        .map(m -> m.get("driverId") + "," + m.get("trackingId"))
        .collect(Collectors.joining("\n"));
    File file = StandardTestUtils.createFile("station_routing.csv", content);
    page.inFrame(() -> page.upload.setValue(file));
  }

  @Then("Operator verifies orders info on Station Routing page:")
  public void verifyOrdersInfo(List<Map<String, String>> data) {
    List<Map<String, String>> expected = resolveListOfMaps(data);
    page.inFrame(() -> {
      page.waitUntil(() -> page.trackingIds.size() > 0, 5000);
      int count = page.trackingIds.size();
      List<Map<String, String>> actual = new ArrayList<>(count);
      for (int i = 0; i < count; i++) {
        Map<String, String> row = new HashMap<>();
        row.put("driverId", page.driverIds.get(i).getText());
        row.put("trackingId", page.trackingIds.get(i).getText());
        actual.add(row);
      }
      Assertions.assertThat(actual)
          .as("List of uploaded driver/order info")
          .isEqualTo(expected);
    });
  }

  @Then("Operator clicks Next button on Station Routing page")
  public void clickNextButton() {
    page.inFrame(() -> page.next.click());
    pause2s();
  }

  @Then("Operator verifies assignments records on Station Routing page:")
  public void verifyAssignmentsRecords(List<Map<String, String>> data) {
    List<Assignment> expected = data.stream().
        map(m -> new Assignment(resolveKeyValues(m)))
        .collect(Collectors.toList());

    page.inFrame(() -> {
      List<Assignment> actual = page.assignmentsTable.readAllEntities();
      Assertions.assertThat(actual)
          .as("List of assignment records")
          .containsExactlyInAnyOrderElementsOf(expected);
    });
  }

  @Then("Operator verifies driver count is {int} on Station Routing page")
  public void verifyDriverCount(int expected) {
    page.inFrame(() -> {
      Assertions.assertThat(page.driverCount.getText())
          .as("Driver count")
          .isEqualTo(String.valueOf(expected));
    });
  }

  @Then("Operator verifies parcel count is {int} on Station Routing page")
  public void verifyParcelCount(int expected) {
    page.inFrame(() -> {
      Assertions.assertThat(page.parcelCount.getText())
          .as("Parcel count")
          .isEqualTo(String.valueOf(expected));
    });
  }

  @Then("Operator filter assignments table on Station Routing page:")
  public void filterTable(Map<String, String> data) {
    Assignment filters = new Assignment(resolveKeyValues(data));

    page.inFrame(() -> {
      page.assignmentsTable.clearColumnFilters();
      if (StringUtils.isNotBlank(filters.getTrackingId())) {
        page.assignmentsTable.filterByColumn("id", filters.getTrackingId());
      }
      if (StringUtils.isNotBlank(filters.getAddress())) {
        page.assignmentsTable.filterByColumn("address", filters.getAddress());
      }
      if (StringUtils.isNotBlank(filters.getDriverId())) {
        page.assignmentsTable.filterByColumn("driverId", filters.getDriverId());
      }
    });
  }

  @Then("Operator clear filters of assignments table on Station Routing page")
  public void clearTableFilters() {
    page.inFrame(() -> page.assignmentsTable.clearColumnFilters());
  }

  @Then("Operator clicks Remove button for {value} parcel on Station Routing page")
  public void clickRemove(String trackingId) {
    page.inFrame(() -> {
      page.assignmentsTable.filterByColumn("id", trackingId);
      page.assignmentsTable.clickActionButton(1, "Remove");
    });
  }

  @Then("Operator verifies {value} parcel marked as removed on Station Routing page")
  public void checkRemoved(String trackingId) {
    page.inFrame(() -> {
      page.assignmentsTable.filterByColumn("id", trackingId);
      Assertions.assertThat(page.assignmentsTable.isRowDisabled(1))
          .withFailMessage("Parcel %s is not marked as disabled", trackingId)
          .isTrue();
    });
  }

  @Then("Operator selects {value} action on Station Routing page")
  public void selectAction(String action) {
    page.inFrame(() -> page.selectAction(action));
  }
}