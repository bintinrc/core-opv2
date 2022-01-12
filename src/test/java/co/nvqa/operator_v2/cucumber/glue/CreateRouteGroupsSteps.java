package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.model.DataEntity;
import co.nvqa.commons.model.core.Order;
import co.nvqa.commons.model.core.RouteGroup;
import co.nvqa.commons.model.core.Transaction;
import co.nvqa.commons.util.StandardTestConstants;
import co.nvqa.operator_v2.model.TxnRsvn;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.page.CreateRouteGroupsPage;
import com.google.common.collect.ImmutableList;
import io.cucumber.guice.ScenarioScoped;
import io.cucumber.java.en.Given;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.stream.Collectors;
import org.apache.commons.lang3.StringUtils;
import org.assertj.core.api.Assertions;
import org.assertj.core.api.SoftAssertions;

import static co.nvqa.operator_v2.selenium.page.CreateRouteGroupsPage.TxnRsvnTable.COLUMN_ID;
import static co.nvqa.operator_v2.selenium.page.CreateRouteGroupsPage.TxnRsvnTable.COLUMN_TRACKING_ID;
import static co.nvqa.operator_v2.selenium.page.CreateRouteGroupsPage.TxnRsvnTable.COLUMN_TYPE;

/**
 * @author Daniel Joi Partogi Hutapea
 */
@ScenarioScoped
public class CreateRouteGroupsSteps extends AbstractSteps {

  public static final String LIST_OF_TXN_RSVN = "LIST_OF_TXN_RSVN";
  public static final String CSV_FILE_NAME = "create_route_group.csv";

  private CreateRouteGroupsPage createRouteGroupsPage;

  public CreateRouteGroupsSteps() {
  }

  @Override
  public void init() {
    createRouteGroupsPage = new CreateRouteGroupsPage(getWebDriver());
  }

  @When("^Operator wait until 'Create Route Group' page is loaded$")
  public void waitUntilCreateRouteGroupIsLoaded() {
    createRouteGroupsPage.waitUntilRouteGroupPageIsLoaded();
  }

  @When("^Operator V2 add created Transaction to Route Group$")
  public void addCreatedTransactionToRouteGroup() {
    String expectedTrackingId = get(KEY_CREATED_ORDER_TRACKING_ID);
    RouteGroup routeGroup = get(KEY_CREATED_ROUTE_GROUP);

    createRouteGroupsPage.removeFilter("Start Datetime");
    createRouteGroupsPage.removeFilter("End Datetime");
    createRouteGroupsPage.setCreationTimeFilter();
    createRouteGroupsPage.loadSelection.clickAndWaitUntilDone();
    createRouteGroupsPage.searchByTrackingId(expectedTrackingId);
    createRouteGroupsPage.txnRsvnTable.selectAllShown();
    createRouteGroupsPage.addToRouteGroup.click();
    createRouteGroupsPage.selectRouteGroupOnAddToRouteGroupDialog(routeGroup.getName());
    pause1s();
    takesScreenshot();
    createRouteGroupsPage.clickAddTransactionsOnAddToRouteGroupDialog();
    takesScreenshot();
    pause1s();
  }

  @When("Operator adds following transactions to new Route Group {string}:")
  public void addTransactionsToNewRouteGroup(String groupName, List<Map<String, String>> data) {
    groupName = resolveValue(groupName);
    data.forEach(entry -> {
      entry = resolveKeyValues(entry);
      String trackingId = entry.get("trackingId");
      String type = entry.get("type");
      createRouteGroupsPage.txnRsvnTable.filterByColumn(COLUMN_TRACKING_ID, trackingId);
      if (StringUtils.isNotBlank(type)) {
        createRouteGroupsPage.txnRsvnTable.filterByColumn(COLUMN_TYPE, type);
      }
      createRouteGroupsPage.txnRsvnTable.selectAllShown();
    });
    createRouteGroupsPage.addToRouteGroup.click();
    createRouteGroupsPage.addToRouteGroupDialog.waitUntilVisible();
    createRouteGroupsPage.addToRouteGroupDialog.createNewRouteGroup.click();
    createRouteGroupsPage.addToRouteGroupDialog.newRouteGroup.setValue(groupName);
    createRouteGroupsPage.addToRouteGroupDialog.addTransactionsReservations.clickAndWaitUntilDone();
    RouteGroup routeGroup = new RouteGroup();
    routeGroup.setName(groupName);
    put(KEY_CREATED_ROUTE_GROUP, routeGroup);
    putInList(KEY_LIST_OF_CREATED_ROUTE_GROUPS, routeGroup);
  }

  @When("Operator adds following reservations to new Route Group {string}:")
  public void addReservationsToNewRouteGroup(String groupName, List<Map<String, String>> data) {
    groupName = resolveValue(groupName);
    data.forEach(entry -> {
      entry = resolveKeyValues(entry);
      String id = entry.get("id");
      createRouteGroupsPage.txnRsvnTable.filterByColumn(COLUMN_ID, id);
      createRouteGroupsPage.txnRsvnTable.selectAllShown();
    });
    createRouteGroupsPage.addToRouteGroup.click();
    createRouteGroupsPage.addToRouteGroupDialog.waitUntilVisible();
    createRouteGroupsPage.addToRouteGroupDialog.createNewRouteGroup.click();
    createRouteGroupsPage.addToRouteGroupDialog.newRouteGroup.setValue(groupName);
    createRouteGroupsPage.addToRouteGroupDialog.addTransactionsReservations.clickAndWaitUntilDone();
    RouteGroup routeGroup = new RouteGroup();
    routeGroup.setName(groupName);
    put(KEY_CREATED_ROUTE_GROUP, routeGroup);
    putInList(KEY_LIST_OF_CREATED_ROUTE_GROUPS, routeGroup);
  }

  @When("Operator adds following transactions to Route Group {string}:")
  public void addTransactionsToRouteGroup(String groupName, List<Map<String, String>> data) {
    groupName = resolveValue(groupName);
    data.forEach(entry -> {
      entry = resolveKeyValues(entry);
      String trackingId = entry.get("trackingId");
      String type = entry.get("type");
      createRouteGroupsPage.txnRsvnTable.filterByColumn(COLUMN_TRACKING_ID, trackingId);
      if (StringUtils.isNotBlank(type)) {
        createRouteGroupsPage.txnRsvnTable.filterByColumn(COLUMN_TYPE, type);
      }
      createRouteGroupsPage.txnRsvnTable.selectAllShown();
    });
    createRouteGroupsPage.addToRouteGroup.click();
    createRouteGroupsPage.addToRouteGroupDialog.waitUntilVisible();
    createRouteGroupsPage.addToRouteGroupDialog.existingRouteGroup.click();
    createRouteGroupsPage.addToRouteGroupDialog.routeGroup.searchAndSelectValue(groupName);
    createRouteGroupsPage.addToRouteGroupDialog.addTransactionsReservations.clickAndWaitUntilDone();
  }

  @Given("^Operator removes all General Filters except following: \"([^\"]*)\"$")
  public void operatorRemovesAllGeneralFiltersExceptFollowingCreationTime(String filtersAsString) {
    List<String> filters = Arrays.asList(filtersAsString.replaceAll(", ", ",").split(","));
    createRouteGroupsPage.removeAllFilterExceptGiven(filters);
  }

  @Given("^Operator choose \"([^\"]*)\" on Transaction Filters section on Create Route Group page$")
  public void operatorChooseOnTransactionFiltersSectionOnCreateRouteGroupPage(String value) {
    createRouteGroupsPage.selectTransactionFiltersMode(value);
  }

  @Given("^Operator choose \"([^\"]*)\" on Reservation Filters section on Create Route Group page$")
  public void operatorChooseOnReservationFiltersSectionOnCreateRouteGroupPage(String value) {
    createRouteGroupsPage.selectReservationFiltersMode(value);
  }

  @When("^Operator verifies selected Transactions Filters on Create Route Group page:$")
  public void operatorVerifiesSelectedTransactionFilters(Map<String, String> data) {
    data = resolveKeyValues(data);

    SoftAssertions assertions = new SoftAssertions();

    if (data.containsKey("granularOrderStatus")) {
      if (!createRouteGroupsPage.transactionsFiltersForm.granularOrderStatusFilter
          .isDisplayedFast()) {
        assertions.fail("Granular Order Status is not displayed");
      } else {
        assertions.assertThat(
                createRouteGroupsPage.transactionsFiltersForm.granularOrderStatusFilter
                    .getSelectedValues())
            .as("Granular Order Status")
            .containsExactlyInAnyOrderElementsOf(
                splitAndNormalize(data.get("granularOrderStatus")));
      }
    }

    if (data.containsKey("orderServiceType")) {
      if (!createRouteGroupsPage.transactionsFiltersForm.orderServiceTypeFilter.isDisplayedFast()) {
        assertions.fail("Order Service Type is not displayed");
      } else {
        assertions.assertThat(
                createRouteGroupsPage.transactionsFiltersForm.orderServiceTypeFilter
                    .getSelectedValues())
            .as("Order Service Type")
            .containsExactlyInAnyOrderElementsOf(
                splitAndNormalize(data.get("orderServiceType")));
      }
    }

    if (data.containsKey("zone")) {
      if (!createRouteGroupsPage.transactionsFiltersForm.zoneFilter.isDisplayedFast()) {
        assertions.fail("Zone is not displayed");
      } else {
        assertions.assertThat(
                createRouteGroupsPage.transactionsFiltersForm.zoneFilter
                    .getSelectedValues())
            .as("Zone")
            .containsExactlyInAnyOrderElementsOf(
                splitAndNormalize(data.get("zone")));
      }
    }

    if (data.containsKey("orderType")) {
      if (!createRouteGroupsPage.transactionsFiltersForm.orderTypeFilter.isDisplayedFast()) {
        assertions.fail("Order Type is not displayed");
      } else {
        assertions.assertThat(
                createRouteGroupsPage.transactionsFiltersForm.orderTypeFilter
                    .getSelectedValues())
            .as("Order Type")
            .containsExactlyInAnyOrderElementsOf(
                splitAndNormalize(data.get("orderType")));
      }
    }

    if (data.containsKey("ppDdLeg")) {
      if (!createRouteGroupsPage.transactionsFiltersForm.ppDdLegFilter.isDisplayedFast()) {
        assertions.fail("PP/DD Leg is not displayed");
      } else {
        assertions.assertThat(
                createRouteGroupsPage.transactionsFiltersForm.ppDdLegFilter
                    .getSelectedValues())
            .as("PP/DD Leg")
            .containsExactlyInAnyOrderElementsOf(
                splitAndNormalize(data.get("ppDdLeg")));
      }
    }

    if (data.containsKey("transactionStatus")) {
      if (!createRouteGroupsPage.transactionsFiltersForm.transactionStatusFilter
          .isDisplayedFast()) {
        assertions.fail("Transaction Status is not displayed");
      } else {
        assertions.assertThat(
                createRouteGroupsPage.transactionsFiltersForm.transactionStatusFilter
                    .getSelectedValues())
            .as("Transaction Status")
            .containsExactlyInAnyOrderElementsOf(
                splitAndNormalize(data.get("transactionStatus")));
      }
    }

    if (data.containsKey("rts")) {
      if (!createRouteGroupsPage.transactionsFiltersForm.rtsFilter.isDisplayedFast()) {
        assertions.fail("Transaction Status is not displayed");
      } else {
        assertions.assertThat(
                createRouteGroupsPage.transactionsFiltersForm.rtsFilter.getValue())
            .as("Transaction Status")
            .isEqualTo(data.get("rts"));
      }
    }

    if (data.containsKey("parcelSize")) {
      if (!createRouteGroupsPage.transactionsFiltersForm.parcelSizeFilter.isDisplayedFast()) {
        assertions.fail("Parcel Size is not displayed");
      } else {
        assertions.assertThat(
                createRouteGroupsPage.transactionsFiltersForm.parcelSizeFilter
                    .getSelectedValues())
            .as("Parcel Size")
            .containsExactlyInAnyOrderElementsOf(
                splitAndNormalize(data.get("parcelSize")));
      }
    }

    if (data.containsKey("timeslots")) {
      if (!createRouteGroupsPage.transactionsFiltersForm.timeslotsFilter.isDisplayedFast()) {
        assertions.fail("Timeslots is not displayed");
      } else {
        assertions.assertThat(
                createRouteGroupsPage.transactionsFiltersForm.timeslotsFilter
                    .getSelectedValues())
            .as("Timeslots")
            .containsExactlyInAnyOrderElementsOf(
                splitAndNormalize(data.get("timeslots")));
      }
    }

    if (data.containsKey("deliveryType")) {
      if (!createRouteGroupsPage.transactionsFiltersForm.deliveryTypeFilter.isDisplayedFast()) {
        assertions.fail("Delivery Type is not displayed");
      } else {
        assertions.assertThat(
                createRouteGroupsPage.transactionsFiltersForm.deliveryTypeFilter
                    .getSelectedValues())
            .as("Delivery Type")
            .containsExactlyInAnyOrderElementsOf(
                splitAndNormalize(data.get("deliveryType")));
      }
    }

    if (data.containsKey("dnrGroup")) {
      if (!createRouteGroupsPage.transactionsFiltersForm.dnrGroupFilter.isDisplayedFast()) {
        assertions.fail("DNR Group is not displayed");
      } else {
        assertions.assertThat(
                createRouteGroupsPage.transactionsFiltersForm.dnrGroupFilter
                    .getSelectedValues())
            .as("DNR Group")
            .containsExactlyInAnyOrderElementsOf(
                splitAndNormalize(data.get("dnrGroup")));
      }
    }

    if (data.containsKey("bulkyTypes")) {
      if (!createRouteGroupsPage.transactionsFiltersForm.bulkyTypesFilter.isDisplayedFast()) {
        assertions.fail("Bulky Types is not displayed");
      } else {
        assertions.assertThat(
                createRouteGroupsPage.transactionsFiltersForm.bulkyTypesFilter
                    .getSelectedValues())
            .as("Bulky Types")
            .containsExactlyInAnyOrderElementsOf(
                splitAndNormalize(data.get("bulkyTypes")));
      }
    }
  }

  @Given("^Operator add following filters on Transactions Filters section on Create Route Group page:$")
  public void operatorAddFollowingFiltersOnTransactionsFiltersSectionOnCreateRouteGroupPage(
      Map<String, String> data) {
    data = resolveKeyValues(data);

    createRouteGroupsPage.includeTransactions.click();

    String value = data.get("granularOrderStatus");
    if (StringUtils.isNotBlank(value)) {
      if (!createRouteGroupsPage.transactionsFiltersForm.granularOrderStatusFilter
          .isDisplayedFast()) {
        createRouteGroupsPage.transactionsFiltersForm.addFilter
            .selectValue("Granular Order Status");
      }
      createRouteGroupsPage.transactionsFiltersForm.granularOrderStatusFilter.clearAll();
      createRouteGroupsPage.transactionsFiltersForm.granularOrderStatusFilter
          .selectFilter(splitAndNormalize(value));
    }

    value = data.get("orderServiceType");
    if (StringUtils.isNotBlank(value)) {
      if (!createRouteGroupsPage.transactionsFiltersForm.orderServiceTypeFilter.isDisplayedFast()) {
        createRouteGroupsPage.transactionsFiltersForm.addFilter.selectValue("Order Service Type");
      }
      createRouteGroupsPage.transactionsFiltersForm.orderServiceTypeFilter.clearAll();
      createRouteGroupsPage.transactionsFiltersForm.orderServiceTypeFilter
          .strictlySelectFilter(splitAndNormalize(value));
    }

    value = data.get("zone");
    if (StringUtils.isNotBlank(value)) {
      if (!createRouteGroupsPage.transactionsFiltersForm.zoneFilter.isDisplayedFast()) {
        createRouteGroupsPage.transactionsFiltersForm.addFilter.selectValue("Zone");
      }
      createRouteGroupsPage.transactionsFiltersForm.zoneFilter.clearAll();
      createRouteGroupsPage.transactionsFiltersForm.zoneFilter
          .selectFilter(splitAndNormalize(value));
    }

    value = data.get("orderType");
    if (StringUtils.isNotBlank(value)) {
      if (!createRouteGroupsPage.transactionsFiltersForm.orderTypeFilter.isDisplayedFast()) {
        createRouteGroupsPage.transactionsFiltersForm.addFilter.selectValue("Order Type");
      }
      createRouteGroupsPage.transactionsFiltersForm.orderTypeFilter.clearAll();
      createRouteGroupsPage.transactionsFiltersForm.orderTypeFilter
          .selectFilter(splitAndNormalize(value));
    }

    value = data.get("ppDdLeg");
    if (StringUtils.isNotBlank(value)) {
      if (!createRouteGroupsPage.transactionsFiltersForm.ppDdLegFilter.isDisplayedFast()) {
        createRouteGroupsPage.transactionsFiltersForm.addFilter.selectValue("PP/DD Leg");
      }
      createRouteGroupsPage.transactionsFiltersForm.ppDdLegFilter.clearAll();
      createRouteGroupsPage.transactionsFiltersForm.ppDdLegFilter
          .selectFilter(splitAndNormalize(value));
    }

    value = data.get("transactionStatus");
    if (StringUtils.isNotBlank(value)) {
      if (!createRouteGroupsPage.transactionsFiltersForm.transactionStatusFilter
          .isDisplayedFast()) {
        createRouteGroupsPage.transactionsFiltersForm.addFilter.selectValue("Transaction Status");
      }
      createRouteGroupsPage.transactionsFiltersForm.transactionStatusFilter.clearAll();
      createRouteGroupsPage.transactionsFiltersForm.transactionStatusFilter
          .selectFilter(splitAndNormalize(value));
    }

    value = data.get("rts");
    if (StringUtils.isNotBlank(value)) {
      if (!createRouteGroupsPage.transactionsFiltersForm.rtsFilter.isDisplayedFast()) {
        createRouteGroupsPage.transactionsFiltersForm.addFilter.selectValue("RTS");
      }
      createRouteGroupsPage.transactionsFiltersForm.rtsFilter
          .selectFilter(StringUtils.equalsIgnoreCase("Show", value));
    }

    value = data.get("parcelSize");
    if (StringUtils.isNotBlank(value)) {
      if (!createRouteGroupsPage.transactionsFiltersForm.parcelSizeFilter.isDisplayedFast()) {
        createRouteGroupsPage.transactionsFiltersForm.addFilter.selectValue("Parcel Size");
      }
      createRouteGroupsPage.transactionsFiltersForm.parcelSizeFilter.clearAll();
      createRouteGroupsPage.transactionsFiltersForm.parcelSizeFilter
          .strictlySelectFilter(splitAndNormalize(value));
    }

    value = data.get("timeslots");
    if (StringUtils.isNotBlank(value)) {
      if (!createRouteGroupsPage.transactionsFiltersForm.timeslotsFilter.isDisplayedFast()) {
        createRouteGroupsPage.transactionsFiltersForm.addFilter.selectValue("Timeslots");
      }
      createRouteGroupsPage.transactionsFiltersForm.timeslotsFilter.clearAll();
      createRouteGroupsPage.transactionsFiltersForm.timeslotsFilter
          .strictlySelectFilter(splitAndNormalize(value));
    }

    value = data.get("deliveryType");
    if (StringUtils.isNotBlank(value)) {
      if (!createRouteGroupsPage.transactionsFiltersForm.deliveryTypeFilter.isDisplayedFast()) {
        createRouteGroupsPage.transactionsFiltersForm.addFilter.selectValue("Delivery Type");
      }
      createRouteGroupsPage.transactionsFiltersForm.deliveryTypeFilter.clearAll();
      createRouteGroupsPage.transactionsFiltersForm.deliveryTypeFilter
          .selectFilter(splitAndNormalize(value));
    }

    value = data.get("dnrGroup");
    if (StringUtils.isNotBlank(value)) {
      if (!createRouteGroupsPage.transactionsFiltersForm.dnrGroupFilter.isDisplayedFast()) {
        createRouteGroupsPage.transactionsFiltersForm.addFilter.selectValue("DNR Group");
      }
      createRouteGroupsPage.transactionsFiltersForm.dnrGroupFilter.clearAll();
      createRouteGroupsPage.transactionsFiltersForm.dnrGroupFilter
          .selectFilter(splitAndNormalize(value));
    }

    value = data.get("bulkyTypes");
    if (StringUtils.isNotBlank(value)) {
      if (!createRouteGroupsPage.transactionsFiltersForm.bulkyTypesFilter.isDisplayedFast()) {
        createRouteGroupsPage.transactionsFiltersForm.addFilter.selectValue("Bulky Types");
      }
      createRouteGroupsPage.transactionsFiltersForm.bulkyTypesFilter.clearAll();
      createRouteGroupsPage.transactionsFiltersForm.bulkyTypesFilter
          .selectFilter(splitAndNormalize(value));
    }

    value = data.get("weight");
    if (StringUtils.isNotBlank(value)) {
      if (!createRouteGroupsPage.transactionsFiltersForm.weightFilter.isDisplayedFast()) {
        createRouteGroupsPage.transactionsFiltersForm.addFilter.selectValue("Weight");
      }
      createRouteGroupsPage.transactionsFiltersForm.weightFilter.selectFilter(value);
    }

    value = data.get("priorityLevel");
    if (StringUtils.isNotBlank(value)) {
      if (!createRouteGroupsPage.transactionsFiltersForm.priorityLevelFilter.isDisplayedFast()) {
        createRouteGroupsPage.transactionsFiltersForm.addFilter.selectValue("Priority Level");
      }
      createRouteGroupsPage.transactionsFiltersForm.priorityLevelFilter.selectFilter(value);
    }
  }

  @Given("^Operator add following filters on Reservation Filters section on Create Route Group page:$")
  public void operatorAddFollowingFiltersOnReservationFiltersSectionOnCreateRouteGroupPage(
      Map<String, String> data) {
    data = resolveKeyValues(data);

    createRouteGroupsPage.includeReservations.click();

    String value = data.get("pickUpSize");
    if (StringUtils.isNotBlank(value)) {
      if (!createRouteGroupsPage.reservationFiltersForm.pickUpSizeFilter.isDisplayedFast()) {
        createRouteGroupsPage.reservationFiltersForm.addFilter.selectValue("Pick Up Size");
      }
      createRouteGroupsPage.reservationFiltersForm.pickUpSizeFilter.clearAll();
      createRouteGroupsPage.reservationFiltersForm.pickUpSizeFilter
          .selectFilter(splitAndNormalize(value));
    }

    value = data.get("reservationType");
    if (StringUtils.isNotBlank(value)) {
      if (!createRouteGroupsPage.reservationFiltersForm.reservationTypeFilter.isDisplayedFast()) {
        createRouteGroupsPage.reservationFiltersForm.addFilter.selectValue("Reservation Type");
      }
      createRouteGroupsPage.reservationFiltersForm.reservationTypeFilter.clearAll();
      createRouteGroupsPage.reservationFiltersForm.reservationTypeFilter
          .selectFilter(splitAndNormalize(value));
    }

    value = data.get("reservationStatus");
    if (StringUtils.isNotBlank(value)) {
      if (!createRouteGroupsPage.reservationFiltersForm.reservationStatusFilter.isDisplayedFast()) {
        createRouteGroupsPage.reservationFiltersForm.addFilter.selectValue("Reservation Status");
      }
      createRouteGroupsPage.reservationFiltersForm.reservationStatusFilter.clearAll();
      createRouteGroupsPage.reservationFiltersForm.reservationStatusFilter
          .selectFilter(splitAndNormalize(value));
    }
  }

  @When("^Operator verifies selected Reservation Filters on Create Route Group page:$")
  public void operatorVerifiesSelectedReservationFilters(Map<String, String> data) {
    data = resolveKeyValues(data);

    SoftAssertions assertions = new SoftAssertions();

    if (data.containsKey("pickUpSize")) {
      if (!createRouteGroupsPage.reservationFiltersForm.pickUpSizeFilter
          .isDisplayedFast()) {
        assertions.fail("Pick Up Size is not displayed");
      } else {
        assertions.assertThat(
                createRouteGroupsPage.reservationFiltersForm.pickUpSizeFilter
                    .getSelectedValues())
            .as("Pick Up Size")
            .containsExactlyInAnyOrderElementsOf(
                splitAndNormalize(data.get("pickUpSize")));
      }
    }

    if (data.containsKey("reservationType")) {
      if (!createRouteGroupsPage.reservationFiltersForm.reservationTypeFilter
          .isDisplayedFast()) {
        assertions.fail("Reservation Type is not displayed");
      } else {
        assertions.assertThat(
                createRouteGroupsPage.reservationFiltersForm.reservationTypeFilter
                    .getSelectedValues())
            .as("Reservation Type")
            .containsExactlyInAnyOrderElementsOf(
                splitAndNormalize(data.get("reservationType")));
      }
    }

    if (data.containsKey("reservationStatus")) {
      if (!createRouteGroupsPage.reservationFiltersForm.reservationStatusFilter
          .isDisplayedFast()) {
        assertions.fail("Reservation Status is not displayed");
      } else {
        assertions.assertThat(
                createRouteGroupsPage.reservationFiltersForm.reservationStatusFilter
                    .getSelectedValues())
            .as("Reservation Status")
            .containsExactlyInAnyOrderElementsOf(
                splitAndNormalize(data.get("reservationStatus")));
      }
    }
  }

  @Given("^Operator add following filters on General Filters section on Create Route Group page:$")
  public void operatorAddFollowingFiltersOnGeneralFiltersSectionOnCreateRouteGroupPage(
      Map<String, String> mapOfData) {
    createRouteGroupsPage.addGeneralFilters(resolveKeyValues(mapOfData));
  }

  @Given("^Operator set General Filters on Create Route Group page:$")
  public void operatorSetGeneralFilters(Map<String, String> data) {
    data = resolveKeyValues(data);

    createRouteGroupsPage.waitUntilPageLoaded();

    String value;
    if (data.containsKey("startDateTimeFrom") || data.containsKey("startDateTimeTo")) {
      if (!createRouteGroupsPage.generalFiltersForm.startDateTimeFilter
          .isDisplayedFast()) {
        createRouteGroupsPage.generalFiltersForm.addFilter
            .selectValue("Start Datetime");
      }
      value = data.get("startDateTimeFrom");
      if (StringUtils.isNotBlank(value)) {
        createRouteGroupsPage.generalFiltersForm.startDateTimeFilter.selectFromDate(value);
      }
      value = data.get("startDateTimeTo");
      if (StringUtils.isNotBlank(value)) {
        createRouteGroupsPage.generalFiltersForm.startDateTimeFilter.selectToDate(value);
      }
    } else if (!createRouteGroupsPage.generalFiltersForm.startDateTimeFilter.isDisplayedFast()) {
      createRouteGroupsPage.generalFiltersForm.startDateTimeFilter.removeFilter();
    }

    if (data.containsKey("endDateTimeFrom") || data.containsKey("endDateTimeTo")) {
      if (!createRouteGroupsPage.generalFiltersForm.endDateTimeFilter
          .isDisplayedFast()) {
        createRouteGroupsPage.generalFiltersForm.addFilter
            .selectValue("End Datetime");
      }
      value = data.get("endDateTimeFrom");
      if (StringUtils.isNotBlank(value)) {
        createRouteGroupsPage.generalFiltersForm.endDateTimeFilter.selectFromDate(value);
      }
      value = data.get("endDateTimeTo");
      if (StringUtils.isNotBlank(value)) {
        createRouteGroupsPage.generalFiltersForm.endDateTimeFilter.selectToDate(value);
      }
    } else if (createRouteGroupsPage.generalFiltersForm.endDateTimeFilter.isDisplayedFast()) {
      createRouteGroupsPage.generalFiltersForm.endDateTimeFilter.removeFilter();
    }

    if (data.containsKey("creationTimeFrom") || data.containsKey("creationTimeTo")) {
      if (!createRouteGroupsPage.generalFiltersForm.creationTimeFilter
          .isDisplayedFast()) {
        createRouteGroupsPage.generalFiltersForm.addFilter
            .selectValue("Creation Time");
      }

      value = data.get("creationTimeFrom");
      if (StringUtils.isNotBlank(value)) {
        createRouteGroupsPage.generalFiltersForm.creationTimeFilter.selectFromDate(value);
        createRouteGroupsPage.generalFiltersForm.creationTimeFilter.selectFromHours("00");
        createRouteGroupsPage.generalFiltersForm.creationTimeFilter.selectFromMinutes("00");
      }

      value = data.get("creationTimeTo");
      if (StringUtils.isNotBlank(value)) {
        createRouteGroupsPage.generalFiltersForm.creationTimeFilter.selectToDate(value);
        createRouteGroupsPage.generalFiltersForm.creationTimeFilter.selectToHours("00");
        createRouteGroupsPage.generalFiltersForm.creationTimeFilter.selectToMinutes("00");
      }
    } else if (createRouteGroupsPage.generalFiltersForm.creationTimeFilter.isDisplayedFast()) {
      createRouteGroupsPage.generalFiltersForm.creationTimeFilter.removeFilter();
    }

    value = data.get("shipper");
    if (StringUtils.isNotBlank(value)) {
      if (!createRouteGroupsPage.generalFiltersForm.shipperFilter
          .isDisplayedFast()) {
        createRouteGroupsPage.generalFiltersForm.addFilter
            .selectValue("Shipper");
      }
      createRouteGroupsPage.generalFiltersForm.shipperFilter.clearAll();
      createRouteGroupsPage.generalFiltersForm.shipperFilter.selectFilter(value);
    } else if (createRouteGroupsPage.generalFiltersForm.shipperFilter.isDisplayedFast()) {
      createRouteGroupsPage.generalFiltersForm.shipperFilter.removeFilter();
    }

    value = data.get("dpOrder");
    if (StringUtils.isNotBlank(value)) {
      if (!createRouteGroupsPage.generalFiltersForm.dpOrderFilter
          .isDisplayedFast()) {
        createRouteGroupsPage.generalFiltersForm.addFilter
            .selectValue("DP Order");
      }
      createRouteGroupsPage.generalFiltersForm.dpOrderFilter.clearAll();
      createRouteGroupsPage.generalFiltersForm.dpOrderFilter.selectFilter(value);
    } else if (createRouteGroupsPage.generalFiltersForm.dpOrderFilter.isDisplayedFast()) {
      createRouteGroupsPage.generalFiltersForm.dpOrderFilter.removeFilter();
    }

    value = data.get("routeGrouping");
    if (StringUtils.isNotBlank(value)) {
      if (!createRouteGroupsPage.generalFiltersForm.routeGroupingFilter
          .isDisplayedFast()) {
        createRouteGroupsPage.generalFiltersForm.addFilter
            .selectValue("Route Grouping");
      }
      createRouteGroupsPage.generalFiltersForm.routeGroupingFilter.clearAll();
      createRouteGroupsPage.generalFiltersForm.routeGroupingFilter.selectFilter(value);
    } else if (createRouteGroupsPage.generalFiltersForm.routeGroupingFilter.isDisplayedFast()) {
      createRouteGroupsPage.generalFiltersForm.routeGroupingFilter.removeFilter();
    }

    value = data.get("routed");
    if (StringUtils.isNotBlank(value)) {
      if (!createRouteGroupsPage.generalFiltersForm.routedFilter
          .isDisplayedFast()) {
        createRouteGroupsPage.generalFiltersForm.addFilter
            .selectValue("Routed");
      }
      createRouteGroupsPage.generalFiltersForm.routedFilter
          .selectFilter(StringUtils.equalsIgnoreCase(value, "Show"));
    } else if (createRouteGroupsPage.generalFiltersForm.routedFilter.isDisplayedFast()) {
      createRouteGroupsPage.generalFiltersForm.routedFilter.removeFilter();
    }

    value = data.get("masterShipper");
    if (StringUtils.isNotBlank(value)) {
      if (!createRouteGroupsPage.generalFiltersForm.masterShipperFilter
          .isDisplayedFast()) {
        createRouteGroupsPage.generalFiltersForm.addFilter
            .selectValue("Master Shipper");
      }
      createRouteGroupsPage.generalFiltersForm.masterShipperFilter.clearAll();
      createRouteGroupsPage.generalFiltersForm.masterShipperFilter.selectFilter(value);
    } else if (createRouteGroupsPage.generalFiltersForm.masterShipperFilter.isDisplayedFast()) {
      createRouteGroupsPage.generalFiltersForm.masterShipperFilter.removeFilter();
    }
  }

  @Given("^Operator updates General Filters on Create Route Group page:$")
  public void operatorUpdatesGeneralFilters(Map<String, String> data) {
    data = resolveKeyValues(data);

    createRouteGroupsPage.waitUntilPageLoaded();

    String value;
    if (data.containsKey("startDateTimeFrom") || data.containsKey("startDateTimeTo")) {
      if (!createRouteGroupsPage.generalFiltersForm.startDateTimeFilter
          .isDisplayedFast()) {
        createRouteGroupsPage.generalFiltersForm.addFilter
            .selectValue("Start Datetime");
      }
      value = data.get("startDateTimeFrom");
      if (StringUtils.isNotBlank(value)) {
        createRouteGroupsPage.generalFiltersForm.startDateTimeFilter.selectFromDate(value);
      }
      value = data.get("startDateTimeTo");
      if (StringUtils.isNotBlank(value)) {
        createRouteGroupsPage.generalFiltersForm.startDateTimeFilter.selectToDate(value);
      }
    }

    if (data.containsKey("endDateTimeFrom") || data.containsKey("endDateTimeTo")) {
      if (!createRouteGroupsPage.generalFiltersForm.endDateTimeFilter
          .isDisplayedFast()) {
        createRouteGroupsPage.generalFiltersForm.addFilter
            .selectValue("End Datetime");
      }
      value = data.get("endDateTimeFrom");
      if (StringUtils.isNotBlank(value)) {
        createRouteGroupsPage.generalFiltersForm.endDateTimeFilter.selectFromDate(value);
      }
      value = data.get("endDateTimeTo");
      if (StringUtils.isNotBlank(value)) {
        createRouteGroupsPage.generalFiltersForm.endDateTimeFilter.selectToDate(value);
      }
    }

    if (data.containsKey("creationTimeFrom") || data.containsKey("creationTimeTo")) {
      if (!createRouteGroupsPage.generalFiltersForm.creationTimeFilter
          .isDisplayedFast()) {
        createRouteGroupsPage.generalFiltersForm.addFilter
            .selectValue("Creation Time");
      }

      value = data.get("creationTimeFrom");
      if (StringUtils.isNotBlank(value)) {
        createRouteGroupsPage.generalFiltersForm.creationTimeFilter.selectFromDate(value);
        createRouteGroupsPage.generalFiltersForm.creationTimeFilter.selectFromHours("00");
        createRouteGroupsPage.generalFiltersForm.creationTimeFilter.selectFromMinutes("00");
      }

      value = data.get("creationTimeTo");
      if (StringUtils.isNotBlank(value)) {
        createRouteGroupsPage.generalFiltersForm.creationTimeFilter.selectToDate(value);
        createRouteGroupsPage.generalFiltersForm.creationTimeFilter.selectToHours("00");
        createRouteGroupsPage.generalFiltersForm.creationTimeFilter.selectToMinutes("00");
      }
    }

    value = data.get("shipper");
    if (StringUtils.isNotBlank(value)) {
      if (!createRouteGroupsPage.generalFiltersForm.shipperFilter
          .isDisplayedFast()) {
        createRouteGroupsPage.generalFiltersForm.addFilter
            .selectValue("Shipper");
      }
      createRouteGroupsPage.generalFiltersForm.shipperFilter.clearAll();
      createRouteGroupsPage.generalFiltersForm.shipperFilter.selectFilter(value);
    } else if (createRouteGroupsPage.generalFiltersForm.shipperFilter.isDisplayedFast()) {
      createRouteGroupsPage.generalFiltersForm.shipperFilter.removeFilter();
    }

    value = data.get("dpOrder");
    if (StringUtils.isNotBlank(value)) {
      if (!createRouteGroupsPage.generalFiltersForm.dpOrderFilter
          .isDisplayedFast()) {
        createRouteGroupsPage.generalFiltersForm.addFilter
            .selectValue("DP Order");
      }
      createRouteGroupsPage.generalFiltersForm.dpOrderFilter.clearAll();
      createRouteGroupsPage.generalFiltersForm.dpOrderFilter.selectFilter(value);
    }

    value = data.get("routeGrouping");
    if (StringUtils.isNotBlank(value)) {
      if (!createRouteGroupsPage.generalFiltersForm.routeGroupingFilter
          .isDisplayedFast()) {
        createRouteGroupsPage.generalFiltersForm.addFilter
            .selectValue("Route Grouping");
      }
      createRouteGroupsPage.generalFiltersForm.routeGroupingFilter.clearAll();
      createRouteGroupsPage.generalFiltersForm.routeGroupingFilter.selectFilter(value);
    }

    value = data.get("routed");
    if (StringUtils.isNotBlank(value)) {
      if (!createRouteGroupsPage.generalFiltersForm.routedFilter
          .isDisplayedFast()) {
        createRouteGroupsPage.generalFiltersForm.addFilter
            .selectValue("Routed");
      }
      createRouteGroupsPage.generalFiltersForm.routedFilter
          .selectFilter(StringUtils.equalsIgnoreCase(value, "Show"));
    }

    value = data.get("masterShipper");
    if (StringUtils.isNotBlank(value)) {
      if (!createRouteGroupsPage.generalFiltersForm.masterShipperFilter
          .isDisplayedFast()) {
        createRouteGroupsPage.generalFiltersForm.addFilter
            .selectValue("Master Shipper");
      }
      createRouteGroupsPage.generalFiltersForm.masterShipperFilter.clearAll();
      createRouteGroupsPage.generalFiltersForm.masterShipperFilter.selectFilter(value);
    }
  }

  @When("^Operator verifies selected General Filters on Create Route Group page:$")
  public void operatorVerifiesSelectedFilters(Map<String, String> data) {
    data = resolveKeyValues(data);

    SoftAssertions assertions = new SoftAssertions();

    if (data.containsKey("startDateTimeFrom") || data.containsKey("startDateTimeTo")) {
      if (!createRouteGroupsPage.generalFiltersForm.startDateTimeFilter.isDisplayedFast()) {
        assertions.fail("Start Datetime is not displayed");
      } else {
        if (data.containsKey("startDateTimeFrom")) {
          assertions.assertThat(
                  createRouteGroupsPage.generalFiltersForm.startDateTimeFilter.fromDate.getValue())
              .as("Start Datetime from")
              .isEqualTo(data.get("startDateTimeFrom"));
        }
        if (data.containsKey("startDateTimeTo")) {
          assertions.assertThat(
                  createRouteGroupsPage.generalFiltersForm.startDateTimeFilter.toDate.getValue())
              .as("Start Datetime to")
              .isEqualTo(data.get("startDateTimeTo"));
        }
      }
    }

    if (data.containsKey("endDateTimeFrom") || data.containsKey("endDateTimeTo")) {
      if (!createRouteGroupsPage.generalFiltersForm.endDateTimeFilter.isDisplayedFast()) {
        assertions.fail("End Datetime is not displayed");
      } else {
        if (data.containsKey("endDateTimeFrom")) {
          assertions.assertThat(
                  createRouteGroupsPage.generalFiltersForm.endDateTimeFilter.fromDate.getValue())
              .as("End Datetime from")
              .isEqualTo(data.get("endDateTimeFrom"));
        }
        if (data.containsKey("endDateTimeTo")) {
          assertions.assertThat(
                  createRouteGroupsPage.generalFiltersForm.endDateTimeFilter.toDate.getValue())
              .as("End Datetime to")
              .isEqualTo(data.get("endDateTimeTo"));
        }
      }
    }

    if (data.containsKey("creationTimeFrom")) {
      boolean isDisplayed = createRouteGroupsPage.generalFiltersForm.creationTimeFilter
          .isDisplayedFast();
      if (!isDisplayed) {
        assertions.fail("Creation Time is not displayed");
      } else {
        assertions.assertThat(
                createRouteGroupsPage.generalFiltersForm.creationTimeFilter.fromDate.getValue())
            .as("Creation Time from")
            .isEqualTo(data.get("creationTimeFrom"));
      }
    }

    if (data.containsKey("creationTimeTo")) {
      boolean isDisplayed = createRouteGroupsPage.generalFiltersForm.creationTimeFilter
          .isDisplayedFast();
      if (!isDisplayed) {
        assertions.fail("Creation Time is not displayed");
      } else {
        assertions.assertThat(
                createRouteGroupsPage.generalFiltersForm.creationTimeFilter.toDate.getValue())
            .as("Creation Time to")
            .isEqualTo(data.get("creationTimeTo"));
      }
    }

    if (data.containsKey("shipper")) {
      boolean isDisplayed = createRouteGroupsPage.generalFiltersForm.shipperFilter
          .isDisplayedFast();
      if (!isDisplayed) {
        assertions.fail("Shipper is not displayed");
      } else {
        assertions
            .assertThat(createRouteGroupsPage.generalFiltersForm.shipperFilter.getSelectedValues())
            .as("Shipper")
            .containsExactlyInAnyOrderElementsOf(splitAndNormalize(data.get("shipper")));
      }
    }

    if (data.containsKey("dpOrder")) {
      boolean isDisplayed = createRouteGroupsPage.generalFiltersForm.dpOrderFilter
          .isDisplayedFast();
      if (!isDisplayed) {
        assertions.fail("DP Order is not displayed");
      } else {
        assertions
            .assertThat(createRouteGroupsPage.generalFiltersForm.dpOrderFilter.getSelectedValues())
            .as("DP Order")
            .containsExactlyInAnyOrderElementsOf(splitAndNormalize(data.get("dpOrder")));
      }
    }

    if (data.containsKey("routeGrouping")) {
      boolean isDisplayed = createRouteGroupsPage.generalFiltersForm.routeGroupingFilter
          .isDisplayedFast();
      if (!isDisplayed) {
        assertions.fail("Route Grouping is not displayed");
      } else {
        assertions.assertThat(
                createRouteGroupsPage.generalFiltersForm.routeGroupingFilter.getSelectedValues())
            .as("Route Grouping")
            .containsExactlyInAnyOrderElementsOf(splitAndNormalize(data.get("routeGrouping")));
      }
    }

    if (data.containsKey("routed")) {
      boolean isDisplayed = createRouteGroupsPage.generalFiltersForm.routedFilter.isDisplayedFast();
      if (!isDisplayed) {
        assertions.fail("Routed is not displayed");
      } else {
        assertions.assertThat(createRouteGroupsPage.generalFiltersForm.routedFilter.getValue())
            .as("Routed")
            .isEqualToIgnoringCase(data.get("routed"));
      }
    }

    if (data.containsKey("masterShipper")) {
      boolean isDisplayed = createRouteGroupsPage.generalFiltersForm.masterShipperFilter
          .isDisplayedFast();
      if (!isDisplayed) {
        assertions.fail("Master Shipper is not displayed");
      } else {
        assertions.assertThat(
                createRouteGroupsPage.generalFiltersForm.masterShipperFilter.getSelectedValues())
            .as("Master Shipper")
            .containsExactlyInAnyOrderElementsOf(splitAndNormalize(data.get("masterShipper")));
      }
    }

    assertions.assertAll();
  }

  @Given("^Operator set Shipment Filters on Create Route Group page:$")
  public void operatorSetShipmentFilters(Map<String, String> data) {
    data = resolveKeyValues(data);

    createRouteGroupsPage.includeShipments.click();

    String value;
    if (data.containsKey("shipmentDateFrom") || data.containsKey("shipmentDateTo")) {
      if (!createRouteGroupsPage.shipmentFiltersForm.shipmentDateFilter
          .isDisplayedFast()) {
        createRouteGroupsPage.shipmentFiltersForm.addFilter
            .selectValue("Shipment Date");
      }
      value = data.get("shipmentDateFrom");
      if (StringUtils.isNotBlank(value)) {
        createRouteGroupsPage.shipmentFiltersForm.shipmentDateFilter.selectFromDate(value);
        createRouteGroupsPage.shipmentFiltersForm.shipmentDateFilter.selectFromHours("00");
        createRouteGroupsPage.shipmentFiltersForm.shipmentDateFilter.selectFromMinutes("00");
      }
      value = data.get("shipmentDateTo");
      if (StringUtils.isNotBlank(value)) {
        createRouteGroupsPage.shipmentFiltersForm.shipmentDateFilter.selectToDate(value);
        createRouteGroupsPage.shipmentFiltersForm.shipmentDateFilter.selectToHours("00");
        createRouteGroupsPage.shipmentFiltersForm.shipmentDateFilter.selectToMinutes("00");
      }
    } else if (createRouteGroupsPage.shipmentFiltersForm.shipmentDateFilter.isDisplayedFast()) {
      createRouteGroupsPage.shipmentFiltersForm.shipmentDateFilter.removeFilter();
    }

    if (data.containsKey("etaDateTimeFrom") || data.containsKey("etaDateTimeTo")) {
      if (!createRouteGroupsPage.shipmentFiltersForm.etaDateTimeFilter
          .isDisplayedFast()) {
        createRouteGroupsPage.shipmentFiltersForm.addFilter
            .selectValue("ETA (Date Time)");
      }
      value = data.get("etaDateTimeFrom");
      if (StringUtils.isNotBlank(value)) {
        createRouteGroupsPage.shipmentFiltersForm.etaDateTimeFilter.selectFromDate(value);
        createRouteGroupsPage.shipmentFiltersForm.etaDateTimeFilter.selectFromHours("00");
        createRouteGroupsPage.shipmentFiltersForm.etaDateTimeFilter.selectFromMinutes("00");
      }
      value = data.get("etaDateTimeTo");
      if (StringUtils.isNotBlank(value)) {
        createRouteGroupsPage.shipmentFiltersForm.etaDateTimeFilter.selectToDate(value);
        createRouteGroupsPage.shipmentFiltersForm.etaDateTimeFilter.selectToHours("00");
        createRouteGroupsPage.shipmentFiltersForm.etaDateTimeFilter.selectToMinutes("00");
      }
    } else if (createRouteGroupsPage.shipmentFiltersForm.etaDateTimeFilter.isDisplayedFast()) {
      createRouteGroupsPage.shipmentFiltersForm.etaDateTimeFilter.removeFilter();
    }

    value = data.get("startHub");
    if (StringUtils.isNotBlank(value)) {
      if (!createRouteGroupsPage.shipmentFiltersForm.startHubFilter
          .isDisplayedFast()) {
        createRouteGroupsPage.shipmentFiltersForm.addFilter
            .selectValue("Start Hub");
      }
      createRouteGroupsPage.shipmentFiltersForm.startHubFilter.clearAll();
      createRouteGroupsPage.shipmentFiltersForm.startHubFilter.selectFilter(value);
    } else if (createRouteGroupsPage.shipmentFiltersForm.startHubFilter.isDisplayedFast()) {
      createRouteGroupsPage.shipmentFiltersForm.startHubFilter.removeFilter();
    }

    value = data.get("endHub");
    if (StringUtils.isNotBlank(value)) {
      if (!createRouteGroupsPage.shipmentFiltersForm.endHubFilter
          .isDisplayedFast()) {
        createRouteGroupsPage.shipmentFiltersForm.addFilter
            .selectValue("End Hub");
      }
      createRouteGroupsPage.shipmentFiltersForm.endHubFilter.clearAll();
      createRouteGroupsPage.shipmentFiltersForm.endHubFilter.selectFilter(value);
    } else if (createRouteGroupsPage.shipmentFiltersForm.endHubFilter.isDisplayedFast()) {
      createRouteGroupsPage.shipmentFiltersForm.endHubFilter.removeFilter();
    }

    value = data.get("lastInboundHub");
    if (StringUtils.isNotBlank(value)) {
      if (!createRouteGroupsPage.shipmentFiltersForm.lastInboundHubFilter
          .isDisplayedFast()) {
        createRouteGroupsPage.shipmentFiltersForm.addFilter
            .selectValue("Last Inbound Hub");
      }
      createRouteGroupsPage.shipmentFiltersForm.lastInboundHubFilter.clearAll();
      createRouteGroupsPage.shipmentFiltersForm.lastInboundHubFilter.selectFilter(value);
    } else if (createRouteGroupsPage.shipmentFiltersForm.lastInboundHubFilter.isDisplayedFast()) {
      createRouteGroupsPage.shipmentFiltersForm.lastInboundHubFilter.removeFilter();
    }

    value = data.get("mawb");
    if (StringUtils.isNotBlank(value)) {
      if (!createRouteGroupsPage.shipmentFiltersForm.mawbFilter
          .isDisplayedFast()) {
        createRouteGroupsPage.shipmentFiltersForm.addFilter
            .selectValue("MAWB");
      }
      createRouteGroupsPage.shipmentFiltersForm.mawbFilter.setValue(value);
    } else if (createRouteGroupsPage.shipmentFiltersForm.mawbFilter.isDisplayedFast()) {
      createRouteGroupsPage.shipmentFiltersForm.mawbFilter.removeFilter();
    }

    if (data.containsKey("shipmentCompletionDateTimeFrom") || data
        .containsKey("shipmentCompletionDateTimeTo")) {
      if (!createRouteGroupsPage.shipmentFiltersForm.shipmentCompletionDateTimeFilter
          .isDisplayedFast()) {
        createRouteGroupsPage.shipmentFiltersForm.addFilter
            .selectValue("Shipment Completion Date Time");
      }
      value = data.get("shipmentCompletionDateTimeFrom");
      if (StringUtils.isNotBlank(value)) {
        createRouteGroupsPage.shipmentFiltersForm.shipmentCompletionDateTimeFilter
            .selectFromDate(value);
        createRouteGroupsPage.shipmentFiltersForm.shipmentCompletionDateTimeFilter
            .selectFromHours("00");
        createRouteGroupsPage.shipmentFiltersForm.shipmentCompletionDateTimeFilter
            .selectFromMinutes("00");
      }
      value = data.get("shipmentCompletionDateTimeTo");
      if (StringUtils.isNotBlank(value)) {
        createRouteGroupsPage.shipmentFiltersForm.shipmentCompletionDateTimeFilter
            .selectToDate(value);
        createRouteGroupsPage.shipmentFiltersForm.shipmentCompletionDateTimeFilter
            .selectToHours("00");
        createRouteGroupsPage.shipmentFiltersForm.shipmentCompletionDateTimeFilter
            .selectToMinutes("00");
      }
    } else if (createRouteGroupsPage.shipmentFiltersForm.shipmentCompletionDateTimeFilter
        .isDisplayedFast()) {
      createRouteGroupsPage.shipmentFiltersForm.shipmentCompletionDateTimeFilter.removeFilter();
    }

    value = data.get("shipmentStatus");
    if (StringUtils.isNotBlank(value)) {
      if (!createRouteGroupsPage.shipmentFiltersForm.shipmentStatusFilter
          .isDisplayedFast()) {
        createRouteGroupsPage.shipmentFiltersForm.addFilter
            .selectValue("Shipment Status");
      }
      createRouteGroupsPage.shipmentFiltersForm.shipmentStatusFilter.clearAll();
      createRouteGroupsPage.shipmentFiltersForm.shipmentStatusFilter.selectFilter(value);
    } else if (createRouteGroupsPage.shipmentFiltersForm.shipmentStatusFilter.isDisplayedFast()) {
      createRouteGroupsPage.shipmentFiltersForm.shipmentStatusFilter.removeFilter();
    }

    value = data.get("shipmentType");
    if (StringUtils.isNotBlank(value)) {
      if (!createRouteGroupsPage.shipmentFiltersForm.shipmentTypeFilter
          .isDisplayedFast()) {
        createRouteGroupsPage.shipmentFiltersForm.addFilter
            .selectValue("Shipment Type");
      }
      createRouteGroupsPage.shipmentFiltersForm.shipmentTypeFilter.clearAll();
      createRouteGroupsPage.shipmentFiltersForm.shipmentTypeFilter.selectFilter(value);
    } else if (createRouteGroupsPage.shipmentFiltersForm.shipmentTypeFilter.isDisplayedFast()) {
      createRouteGroupsPage.shipmentFiltersForm.shipmentTypeFilter.removeFilter();
    }

    if (data.containsKey("transitDateTimeFrom") || data.containsKey("transitDateTimeTo")) {
      if (!createRouteGroupsPage.shipmentFiltersForm.transitDateTimeFilter
          .isDisplayedFast()) {
        createRouteGroupsPage.shipmentFiltersForm.addFilter
            .selectValue("Transit Date Time");
      }
      value = data.get("transitDateTimeFrom");
      if (StringUtils.isNotBlank(value)) {
        createRouteGroupsPage.shipmentFiltersForm.transitDateTimeFilter.selectFromDate(value);
        createRouteGroupsPage.shipmentFiltersForm.transitDateTimeFilter.selectFromHours("00");
        createRouteGroupsPage.shipmentFiltersForm.transitDateTimeFilter.selectFromMinutes("00");
      }
      value = data.get("transitDateTimeTo");
      if (StringUtils.isNotBlank(value)) {
        createRouteGroupsPage.shipmentFiltersForm.transitDateTimeFilter.selectToDate(value);
        createRouteGroupsPage.shipmentFiltersForm.transitDateTimeFilter.selectToHours("00");
        createRouteGroupsPage.shipmentFiltersForm.transitDateTimeFilter.selectToMinutes("00");
      }
    } else if (createRouteGroupsPage.shipmentFiltersForm.transitDateTimeFilter.isDisplayedFast()) {
      createRouteGroupsPage.shipmentFiltersForm.transitDateTimeFilter.removeFilter();
    }

  }

  @When("^Operator verifies selected Shipment Filters on Create Route Group page:$")
  public void operatorVerifiesSelectedShipmentFilters(Map<String, String> data) {
    data = resolveKeyValues(data);

    SoftAssertions assertions = new SoftAssertions();

    if (data.containsKey("shipmentDateFrom") || data.containsKey("shipmentDateTo")) {
      if (!createRouteGroupsPage.shipmentFiltersForm.shipmentDateFilter.isDisplayedFast()) {
        assertions.fail("Start Datetime is not displayed");
      } else {
        if (data.containsKey("shipmentDateFrom")) {
          assertions.assertThat(
                  createRouteGroupsPage.shipmentFiltersForm.shipmentDateFilter.fromDate.getValue())
              .as("Shipment Date from")
              .isEqualTo(data.get("shipmentDateFrom"));
        }
        if (data.containsKey("shipmentDateTo")) {
          assertions.assertThat(
                  createRouteGroupsPage.shipmentFiltersForm.shipmentDateFilter.toDate.getValue())
              .as("Shipment Date to")
              .isEqualTo(data.get("shipmentDateTo"));
        }
      }
    }

    if (data.containsKey("etaDateTimeFrom") || data.containsKey("etaDateTimeTo")) {
      if (!createRouteGroupsPage.shipmentFiltersForm.etaDateTimeFilter.isDisplayedFast()) {
        assertions.fail("ETA (Date Time) is not displayed");
      } else {
        if (data.containsKey("etaDateTimeFrom")) {
          assertions.assertThat(
                  createRouteGroupsPage.shipmentFiltersForm.etaDateTimeFilter.fromDate.getValue())
              .as("ETA (Date Time) from")
              .isEqualTo(data.get("etaDateTimeFrom"));
        }
        if (data.containsKey("etaDateTimeTo")) {
          assertions.assertThat(
                  createRouteGroupsPage.shipmentFiltersForm.etaDateTimeFilter.toDate.getValue())
              .as("ETA (Date Time) to")
              .isEqualTo(data.get("etaDateTimeTo"));
        }
      }
    }

    if (data.containsKey("shipmentCompletionDateTimeFrom") || data
        .containsKey("shipmentCompletionDateTimeTo")) {
      if (!createRouteGroupsPage.shipmentFiltersForm.shipmentCompletionDateTimeFilter
          .isDisplayedFast()) {
        assertions.fail("Shipment Completion Date Time is not displayed");
      } else {
        if (data.containsKey("shipmentCompletionDateTimeFrom")) {
          assertions.assertThat(
                  createRouteGroupsPage.shipmentFiltersForm.shipmentCompletionDateTimeFilter.fromDate
                      .getValue())
              .as("Shipment Completion Date Time from")
              .isEqualTo(data.get("shipmentCompletionDateTimeFrom"));
        }
        if (data.containsKey("shipmentCompletionDateTimeTo")) {
          assertions.assertThat(
                  createRouteGroupsPage.shipmentFiltersForm.shipmentCompletionDateTimeFilter.toDate
                      .getValue())
              .as("Shipment Completion Date Time to")
              .isEqualTo(data.get("shipmentCompletionDateTimeTo"));
        }
      }
    }

    if (data.containsKey("transitDateTimeFrom") || data.containsKey("transitDateTimeTo")) {
      if (!createRouteGroupsPage.shipmentFiltersForm.transitDateTimeFilter.isDisplayedFast()) {
        assertions.fail("Transit Date Time is not displayed");
      } else {
        if (data.containsKey("transitDateTimeFrom")) {
          assertions.assertThat(
                  createRouteGroupsPage.shipmentFiltersForm.transitDateTimeFilter.fromDate.getValue())
              .as("Transit Date Time from")
              .isEqualTo(data.get("transitDateTimeFrom"));
        }
        if (data.containsKey("transitDateTimeTo")) {
          assertions.assertThat(
                  createRouteGroupsPage.shipmentFiltersForm.transitDateTimeFilter.toDate.getValue())
              .as("Transit Date Time to")
              .isEqualTo(data.get("transitDateTimeTo"));
        }
      }
    }

    if (data.containsKey("startHub")) {
      if (!createRouteGroupsPage.shipmentFiltersForm.startHubFilter.isDisplayedFast()) {
        assertions.fail("Start Hub is not displayed");
      } else {
        assertions.assertThat(
                createRouteGroupsPage.shipmentFiltersForm.startHubFilter.getSelectedValues())
            .as("Start Hub")
            .containsExactlyInAnyOrderElementsOf(splitAndNormalize(data.get("startHub")));
      }
    }

    if (data.containsKey("endHub")) {
      if (!createRouteGroupsPage.shipmentFiltersForm.endHubFilter.isDisplayedFast()) {
        assertions.fail("End Hub is not displayed");
      } else {
        assertions.assertThat(
                createRouteGroupsPage.shipmentFiltersForm.endHubFilter.getSelectedValues())
            .as("End Hub")
            .containsExactlyInAnyOrderElementsOf(splitAndNormalize(data.get("endHub")));
      }
    }

    if (data.containsKey("lastInboundHub")) {
      if (!createRouteGroupsPage.shipmentFiltersForm.lastInboundHubFilter.isDisplayedFast()) {
        assertions.fail("Last Inbound Hub is not displayed");
      } else {
        assertions.assertThat(
                createRouteGroupsPage.shipmentFiltersForm.lastInboundHubFilter.getSelectedValues())
            .as("Last Inbound Hub")
            .containsExactlyInAnyOrderElementsOf(splitAndNormalize(data.get("lastInboundHub")));
      }
    }

    if (data.containsKey("mawb")) {
      if (!createRouteGroupsPage.shipmentFiltersForm.mawbFilter.isDisplayedFast()) {
        assertions.fail("MAWB is not displayed");
      } else {
        assertions.assertThat(
                createRouteGroupsPage.shipmentFiltersForm.mawbFilter.getValue())
            .as("MAWB")
            .isEqualToIgnoringCase(data.get("mawb"));
      }
    }

    if (data.containsKey("shipmentStatus")) {
      if (!createRouteGroupsPage.shipmentFiltersForm.shipmentStatusFilter.isDisplayedFast()) {
        assertions.fail("Shipment Status is not displayed");
      } else {
        assertions.assertThat(
                createRouteGroupsPage.shipmentFiltersForm.shipmentStatusFilter.getSelectedValues())
            .as("Shipment Status")
            .containsExactlyInAnyOrderElementsOf(splitAndNormalize(data.get("shipmentStatus")));
      }
    }

    if (data.containsKey("shipmentType")) {
      if (!createRouteGroupsPage.shipmentFiltersForm.shipmentTypeFilter.isDisplayedFast()) {
        assertions.fail("Shipment Type is not displayed");
      } else {
        assertions.assertThat(
                createRouteGroupsPage.shipmentFiltersForm.shipmentTypeFilter.getSelectedValues())
            .as("Shipment Type")
            .containsExactlyInAnyOrderElementsOf(splitAndNormalize(data.get("shipmentType")));
      }
    }
  }

  @Given("^Operator click Load Selection on Create Route Group page$")
  public void operatorClickLoadSelectionOnCreateRouteGroupPage() {
    createRouteGroupsPage.loadSelection.clickAndWaitUntilDone();
  }

  @Given("^Operator sort Transactions/Reservations table by Tracking ID on Create Route Group page$")
  public void operatorSortTableOnCreateRouteGroupPage() {
    createRouteGroupsPage.txnRsvnTable.sortColumn(COLUMN_TRACKING_ID, true);
  }

  @Given("^Operator save records from Transactions/Reservations table on Create Route Group page$")
  public void operatorSaveTableOnCreateRouteGroupPage() {
    List<TxnRsvn> records = createRouteGroupsPage.txnRsvnTable.readAllEntities("sequence");
    put(LIST_OF_TXN_RSVN, records);
  }

  @Given("^Operator download CSV file on Create Route Group page$")
  public void operatorDownloadCsvFileOnCreateRouteGroupPage() {
    createRouteGroupsPage.downloadCsvFile.click();
    createRouteGroupsPage.verifyFileDownloadedSuccessfully(CSV_FILE_NAME);
  }

  @Given("^Operator verify Transactions/Reservations CSV file on Create Route Group page$")
  public void operatorVerifyCsvFile() {
    List<TxnRsvn> expected = get(LIST_OF_TXN_RSVN);
    String fileName = createRouteGroupsPage.getLatestDownloadedFilename(CSV_FILE_NAME);
    String pathName = StandardTestConstants.TEMP_DIR + fileName;
    List<TxnRsvn> actual = DataEntity.fromCsvFile(TxnRsvn.class, pathName, true);
    assertEquals("Number of records in " + CSV_FILE_NAME, expected.size(), actual.size());

    for (int i = 0; i < expected.size(); i++) {
      expected.get(i).compareWithActual(actual.get(i));
    }
  }

  @Then("^Operator verifies Transaction record on Create Route Group page using data below:$")
  public void operatorVerifyTransactionReservationRecordOnCreateRouteGroupPageUsingDataBelow(
      Map<String, String> data) {
    operatorVerifyTransactionRecordOnCreateRouteGroupPageUsingDataBelow(
        ImmutableList.of(data));
  }

  @Then("^Operator verifies Transaction records on Create Route Group page using data below:$")
  public void operatorVerifyTransactionRecordOnCreateRouteGroupPageUsingDataBelow(
      List<Map<String, String>> data) {
    data.forEach(entry -> {
      Map<String, String> mutableEntry = new HashMap<>(entry);
      String id = mutableEntry.get("id");
      mutableEntry.remove("id");

      TxnRsvn expected = new TxnRsvn(resolveKeyValues(mutableEntry));

      if (StringUtils.isBlank(expected.getTrackingId())) {
        throw new IllegalArgumentException("trackingId value was not defined");
      }
      if (StringUtils.isBlank(expected.getType())) {
        throw new IllegalArgumentException("type value was not defined");
      }

      if (StringUtils.isNotBlank(id)) {
        Pattern p = Pattern.compile("GET_FROM_CREATED_ORDER\\[(\\d+)]");
        Matcher m = p.matcher(id);
        if (m.find()) {
          int index = Integer.parseInt(m.group(1));
          List<Order> orders = get(KEY_LIST_OF_CREATED_ORDER);
          String type = expected.getType().split("\\s")[0];

          Order order = orders.get(index - 1);
          Transaction transaction = order.getTransactions().stream()
              .filter(txn -> StringUtils.equalsIgnoreCase(type, txn.getType()))
              .findFirst()
              .orElseThrow(() -> new RuntimeException(
                  f("Order [%s] doesn't have %s transactions", order.getTrackingId(), type)));
          expected.setId(transaction.getId());
        } else if (StringUtils.isNumeric(id)) {
          expected.setId(id);
        }
      }

      createRouteGroupsPage.txnRsvnTable
          .filterByColumn(COLUMN_TRACKING_ID, expected.getTrackingId());
      createRouteGroupsPage.txnRsvnTable.filterByColumn(COLUMN_TYPE, expected.getType());
      assertEquals(
          f("Number of records for tracking id = %s and type = %s", expected.getTrackingId(),
              expected.getType()), 1, createRouteGroupsPage.txnRsvnTable.getRowsCount());
      TxnRsvn actual = createRouteGroupsPage.txnRsvnTable.readEntity(1);
      expected.compareWithActual(actual);
    });
  }

  @Then("^Operator verifies Reservation records on Create Route Group page using data below:$")
  public void operatorVerifyReservationRecordOnCreateRouteGroupPageUsingDataBelow(
      List<Map<String, String>> data) {
    data.forEach(entry -> {
      TxnRsvn expected = new TxnRsvn(resolveKeyValues(entry));

      if (expected.getId() == null) {
        throw new IllegalArgumentException("id value was not defined");
      }

      createRouteGroupsPage.txnRsvnTable.filterByColumn(COLUMN_ID, expected.getId());
      assertEquals(
          f("Number of records for id = %s", expected.getId()), 1,
          createRouteGroupsPage.txnRsvnTable.getRowsCount());
      TxnRsvn actual = createRouteGroupsPage.txnRsvnTable.readEntity(1);
      expected.compareWithActual(actual);
    });
  }

  @When("Operator selects {string} preset action on Create Route Group page")
  public void selectPresetAction(String action) {
    createRouteGroupsPage.presetActions.selectOption(resolveValue(action));
  }

  @When("Operator selects {string} shipments preset action on Create Route Group page")
  public void selectShippersPresetAction(String action) {
    createRouteGroupsPage.includeShipments.click();
    createRouteGroupsPage.shippersPresetActions.selectOption(resolveValue(action));
  }

  @When("Operator verifies Save Preset dialog on Create Route Group page contains filters:")
  public void verifySelectedFiltersForPreset(List<String> expected) {
    createRouteGroupsPage.savePresetDialog.waitUntilVisible();
    List<String> actual = createRouteGroupsPage.savePresetDialog.selectedFilters.stream()
        .map(PageElement::getNormalizedText)
        .collect(Collectors.toList());
    Assertions.assertThat(actual)
        .as("List of selected filters")
        .containsExactlyInAnyOrderElementsOf(expected);
  }

  @When("Operator verifies Preset Name field in Save Preset dialog on Create Route Group page is required")
  public void verifyPresetNameIsRequired() {
    createRouteGroupsPage.savePresetDialog.waitUntilVisible();
    Assertions
        .assertThat(createRouteGroupsPage.savePresetDialog.presetName.getAttribute("ng-required"))
        .as("Preset Name field ng-required attribute")
        .isEqualTo("required");
  }

  @When("Operator verifies help text {string} is displayed in Save Preset dialog on Create Route Group page")
  public void verifyHelpTextInSavePreset(String expected) {
    createRouteGroupsPage.savePresetDialog.waitUntilVisible();
    Assertions.assertThat(createRouteGroupsPage.savePresetDialog.helpText.getNormalizedText())
        .as("Help Text")
        .isEqualTo(resolveValue(expected));
  }

  @When("Operator verifies Cancel button in Save Preset dialog on Create Route Group page is enabled")
  public void verifyCancelIsEnabled() {
    createRouteGroupsPage.savePresetDialog.waitUntilVisible();
    Assertions.assertThat(createRouteGroupsPage.savePresetDialog.cancel.isEnabled())
        .as("Cancel button is enabled")
        .isTrue();
  }

  @When("Operator verifies Save button in Save Preset dialog on Create Route Group page is enabled")
  public void verifySaveIsEnabled() {
    createRouteGroupsPage.savePresetDialog.waitUntilVisible();
    Assertions.assertThat(createRouteGroupsPage.savePresetDialog.save.isEnabled())
        .as("Save button is enabled")
        .isTrue();
  }

  @When("Operator clicks Save button in Save Preset dialog on Create Route Group page")
  public void clickSaveInSavePresetDialog() {
    createRouteGroupsPage.savePresetDialog.save.click();
  }

  @When("Operator clicks Update button in Save Preset dialog on Create Route Group page")
  public void clickUpdateInSavePresetDialog() {
    createRouteGroupsPage.savePresetDialog.update.click();
  }

  @When("Operator verifies Save button in Save Preset dialog on Create Route Group page is disabled")
  public void verifySaveIsDisabled() {
    createRouteGroupsPage.savePresetDialog.waitUntilVisible();
    Assertions.assertThat(createRouteGroupsPage.savePresetDialog.save.isEnabled())
        .as("Save button is enabled")
        .isFalse();
  }

  @When("Operator verifies Cancel button in Delete Preset dialog on Create Route Group page is enabled")
  public void verifyCancelIsEnabledInDeletePreset() {
    createRouteGroupsPage.deletePresetDialog.waitUntilVisible();
    Assertions.assertThat(createRouteGroupsPage.deletePresetDialog.cancel.isEnabled())
        .as("Cancel button is enabled")
        .isTrue();
  }

  @When("Operator verifies Delete button in Delete Preset dialog on Create Route Group page is enabled")
  public void verifyDeleteIsEnabled() {
    createRouteGroupsPage.deletePresetDialog.waitUntilVisible();
    Assertions.assertThat(createRouteGroupsPage.deletePresetDialog.delete.isEnabled())
        .as("Delete button is enabled")
        .isTrue();
  }

  @When("Operator selects {string} preset in Delete Preset dialog on Create Route Group page")
  public void selectPresetInDeletePresets(String value) {
    createRouteGroupsPage.deletePresetDialog.waitUntilVisible();
    createRouteGroupsPage.deletePresetDialog.preset.searchAndSelectValue(resolveValue(value));
  }

  @When("Operator clicks Delete button in Delete Preset dialog on Create Route Group page")
  public void clickDeleteInDeletePresetDialog() {
    createRouteGroupsPage.deletePresetDialog.delete.click();
  }

  @When("Operator verifies Delete button in Delete Preset dialog on Create Route Group page is disabled")
  public void verifyDeleteIsDisabled() {
    createRouteGroupsPage.deletePresetDialog.waitUntilVisible();
    Assertions.assertThat(createRouteGroupsPage.deletePresetDialog.delete.isEnabled())
        .as("Delete button is enabled")
        .isFalse();
  }

  @When("Operator verifies {string} message is displayed in Delete Preset dialog on Create Route Group page")
  public void verifyMessageInDeletePreset(String expected) {
    createRouteGroupsPage.deletePresetDialog.waitUntilVisible();
    Assertions.assertThat(createRouteGroupsPage.deletePresetDialog.message.getNormalizedText())
        .as("Delete Preset message")
        .isEqualTo(resolveValue(expected));
  }

  @When("Operator enters {string} Preset Name in Save Preset dialog on Create Route Group page")
  public void enterPresetNameIsRequired(String presetName) {
    createRouteGroupsPage.savePresetDialog.waitUntilVisible();
    presetName = resolveValue(presetName);
    createRouteGroupsPage.savePresetDialog.presetName.setValue(presetName);
    put(KEY_CREATE_ROUTE_GROUPS_FILTERS_PRESET_NAME, presetName);
  }

  @When("Operator verifies Preset Name field in Save Preset dialog on Create Route Group page has green checkmark on it")
  public void verifyPresetNameIsValidated() {
    Assertions.assertThat(createRouteGroupsPage.savePresetDialog.confirmedIcon.isDisplayed())
        .as("Preset Name checkmark")
        .isTrue();
  }

  @When("Operator verifies selected Filter Preset name is {string} on Create Route Group page")
  public void verifySelectedPresetName(String expected) {
    expected = resolveValue(expected);
    String actual = StringUtils.trim(createRouteGroupsPage.filterPreset.getValue());
    Pattern p = Pattern.compile("(\\d+)\\s-\\s(.+)");
    Matcher m = p.matcher(actual);
    Assertions.assertThat(m.matches())
        .as("Selected Filter Preset value matches to pattern")
        .isTrue();
    Long presetId = Long.valueOf(m.group(1));
    String presetName = m.group(2);
    Assertions.assertThat(presetName)
        .as("Preset Name")
        .isEqualTo(expected);
    put(KEY_CREATE_ROUTE_GROUPS_FILTERS_PRESET_ID, presetId);
  }

  @When("Operator verifies selected shippers Filter Preset name is {string} on Create Route Group page")
  public void verifySelectedShippersPresetName(String expected) {
    expected = resolveValue(expected);
    String actual = StringUtils.trim(createRouteGroupsPage.shippersFilterPreset.getValue());
    Pattern p = Pattern.compile("(\\d+)\\s-\\s(.+)");
    Matcher m = p.matcher(actual);
    Assertions.assertThat(m.matches())
        .as("Selected Shippers Filter Preset value matches to pattern")
        .isTrue();
    Long presetId = Long.valueOf(m.group(1));
    String presetName = m.group(2);
    Assertions.assertThat(presetName)
        .as("Preset Name")
        .isEqualTo(expected);
    put(KEY_SHIPMENTS_FILTERS_PRESET_ID, presetId);
  }

  @When("Operator selects {string} Filter Preset on Create Route Group page")
  public void selectPresetName(String value) {
    createRouteGroupsPage.filterPreset.searchAndSelectValue(resolveValue(value));
    if (createRouteGroupsPage.halfCircleSpinner.waitUntilVisible(3)) {
      createRouteGroupsPage.halfCircleSpinner.waitUntilInvisible();
    }
    pause1s();
  }

  @When("Operator selects {string} shipments Filter Preset on Create Route Group page")
  public void selectShippersPresetName(String value) {
    createRouteGroupsPage.includeShipments.click();
    createRouteGroupsPage.shippersFilterPreset.searchAndSelectValue(resolveValue(value));
    if (createRouteGroupsPage.halfCircleSpinner.waitUntilVisible(3)) {
      createRouteGroupsPage.halfCircleSpinner.waitUntilInvisible();
    }
    pause1s();
  }
}
