package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.common.model.DataEntity;
import co.nvqa.common.utils.StandardTestConstants;
import co.nvqa.commons.model.core.Order;
import co.nvqa.commons.model.core.RouteGroup;
import co.nvqa.commons.model.core.Transaction;
import co.nvqa.operator_v2.model.TxnRsvn;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.page.CreateRouteGroupsPage;
import co.nvqa.operator_v2.selenium.page.SimpleReactPage;
import com.google.common.collect.ImmutableList;
import io.cucumber.guice.ScenarioScoped;
import io.cucumber.java.en.Given;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import java.text.ParseException;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.stream.Collectors;
import org.apache.commons.lang3.StringUtils;
import org.apache.commons.lang3.time.DateFormatUtils;
import org.apache.commons.lang3.time.DateUtils;
import org.assertj.core.api.Assertions;
import org.assertj.core.api.SoftAssertions;

import static co.nvqa.common.model.DataEntity.toDateTime;
import static co.nvqa.operator_v2.selenium.page.CreateRouteGroupsPage.TxnRsvnTable.COLUMN_ID;
import static co.nvqa.operator_v2.selenium.page.CreateRouteGroupsPage.TxnRsvnTable.COLUMN_TRACKING_ID;
import static co.nvqa.operator_v2.selenium.page.CreateRouteGroupsPage.TxnRsvnTable.COLUMN_TYPE;

/**
 * @author Sergey Mishanin
 */
@ScenarioScoped
public class CreateRouteGroupsSteps extends AbstractSteps {

  public static final String LIST_OF_TXN_RSVN = "LIST_OF_TXN_RSVN";
  public static final String CSV_FILE_NAME = "createRouteGroups.csv";

  private CreateRouteGroupsPage createRouteGroupsPage;

  public CreateRouteGroupsSteps() {
  }

  @Override
  public void init() {
    createRouteGroupsPage = new CreateRouteGroupsPage(getWebDriver());
  }

  @When("^Operator wait until 'Create Route Groups' page is loaded$")
  public void waitUntilCreateRouteGroupIsLoaded() {
    createRouteGroupsPage.inFrame(SimpleReactPage::waitUntilLoaded);
  }

  @When("^Operator V2 add created Transaction to Route Group on Create Route Groups page$")
  public void addCreatedTransactionToRouteGroup() {
    String expectedTrackingId = get(KEY_CREATED_ORDER_TRACKING_ID);
    RouteGroup routeGroup = get(KEY_CREATED_ROUTE_GROUP);

    createRouteGroupsPage.removeFilter("Start Datetime");
    createRouteGroupsPage.removeFilter("End Datetime");
    createRouteGroupsPage.setCreationTimeFilter();
    createRouteGroupsPage.loadSelection.click();
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

  @When("Operator adds following transactions to new Route Group {value} on Create Route Groups page:")
  public void addTransactionsToNewRouteGroup(String groupName, List<Map<String, String>> data) {
    createRouteGroupsPage.inFrame(page -> {
      data.forEach(entry -> {
        entry = resolveKeyValues(entry);
        String trackingId = entry.get("trackingId");
        String type = entry.get("type");
        page.txnRsvnTable.filterByColumn(COLUMN_TRACKING_ID, trackingId);
        if (StringUtils.isNotBlank(type)) {
          page.txnRsvnTable.filterByColumn(COLUMN_TYPE, type);
        }
        page.txnRsvnTable.selectAllShown();
      });
      page.addToRouteGroup.click();
      page.addToRouteGroupDialog.waitUntilVisible();
      page.addToRouteGroupDialog.createNewRouteGroup.click();
      page.addToRouteGroupDialog.newRouteGroup.setValue(groupName);
      page.addToRouteGroupDialog.addTransactionsReservations.click();
      RouteGroup routeGroup = new RouteGroup();
      routeGroup.setName(groupName);
      put(KEY_CREATED_ROUTE_GROUP, routeGroup);
      putInList(KEY_LIST_OF_CREATED_ROUTE_GROUPS, routeGroup);
    });
  }

  @When("Operator adds following reservations to new Route Group {value} on Create Route Groups page:")
  public void addReservationsToNewRouteGroup(String groupName, List<Map<String, String>> data) {
    createRouteGroupsPage.inFrame(page -> {
      data.forEach(entry -> {
        entry = resolveKeyValues(entry);
        String id = entry.get("id");
        page.txnRsvnTable.filterByColumn(COLUMN_ID, id);
        page.txnRsvnTable.selectAllShown();
      });
      page.addToRouteGroup.click();
      page.addToRouteGroupDialog.waitUntilVisible();
      page.addToRouteGroupDialog.createNewRouteGroup.click();
      page.addToRouteGroupDialog.newRouteGroup.setValue(groupName);
      page.addToRouteGroupDialog.addTransactionsReservations.click();
      RouteGroup routeGroup = new RouteGroup();
      routeGroup.setName(groupName);
      put(KEY_CREATED_ROUTE_GROUP, routeGroup);
      putInList(KEY_LIST_OF_CREATED_ROUTE_GROUPS, routeGroup);
    });
  }

  @When("Operator adds following transactions to Route Group {value} on Create Route Groups:")
  public void addTransactionsToRouteGroup(String groupName, List<Map<String, String>> data) {
    createRouteGroupsPage.inFrame(page -> {
      data.forEach(entry -> {
        entry = resolveKeyValues(entry);
        String trackingId = entry.get("trackingId");
        String type = entry.get("type");
        page.txnRsvnTable.filterByColumn(COLUMN_TRACKING_ID, trackingId);
        if (StringUtils.isNotBlank(type)) {
          page.txnRsvnTable.filterByColumn(COLUMN_TYPE, type);
        }
        page.txnRsvnTable.selectAllShown();
      });
      page.addToRouteGroup.click();
      page.addToRouteGroupDialog.waitUntilVisible();
      page.addToRouteGroupDialog.existingRouteGroup.click();
      page.addToRouteGroupDialog.routeGroup.selectValue(groupName);
      page.addToRouteGroupDialog.addTransactionsReservations.click();
    });
  }

  @Given("^Operator removes all General Filters except following on Create Route Groups page: \"([^\"]*)\"$")
  public void operatorRemovesAllGeneralFiltersExceptFollowingCreationTime(String filtersAsString) {
    createRouteGroupsPage.inFrame(
        page -> page.removeAllFilterExceptGiven(splitAndNormalize(filtersAsString)));
  }

  @Given("Operator choose {value} on Transaction Filters section on Create Route Groups page")
  public void operatorChooseOnTransactionFiltersSectionOnCreateRouteGroupPage(String value) {
    createRouteGroupsPage.inFrame(page -> page.selectTransactionFiltersMode(value));
  }

  @Given("Operator choose {value} on Reservation Filters section on Create Route Groups page")
  public void operatorChooseOnReservationFiltersSectionOnCreateRouteGroupPage(String value) {
    createRouteGroupsPage.inFrame(page -> page.selectReservationFiltersMode(value));
  }

  @Given("Operator choose {value} on Shipments Filters section on Create Route Groups page")
  public void operatorChooseOnShipmentsFiltersSectionOnCreateRouteGroupPage(String value) {
    createRouteGroupsPage.inFrame(page -> page.selectShipmentsFiltersMode(value));
  }

  @When("^Operator verifies selected Transactions Filters on Create Route Groups page:$")
  public void operatorVerifiesSelectedTransactionFilters(Map<String, String> data) {
    Map<String, String> finalData = resolveKeyValues(data);

    SoftAssertions assertions = new SoftAssertions();

    createRouteGroupsPage.inFrame(page -> {
      if (finalData.containsKey("granularOrderStatus")) {
        if (!createRouteGroupsPage.transactionsFiltersForm.granularOrderStatusFilter.isDisplayedFast()) {
          assertions.fail("Granular Order Status is not displayed");
        } else {
          assertions.assertThat(
                  createRouteGroupsPage.transactionsFiltersForm.granularOrderStatusFilter.getSelectedValues())
              .as("Granular Order Status").containsExactlyInAnyOrderElementsOf(
                  splitAndNormalize(finalData.get("granularOrderStatus")));
        }
      }

      if (finalData.containsKey("orderServiceType")) {
        if (!createRouteGroupsPage.transactionsFiltersForm.orderServiceTypeFilter.isDisplayedFast()) {
          assertions.fail("Order Service Type is not displayed");
        } else {
          assertions.assertThat(
                  createRouteGroupsPage.transactionsFiltersForm.orderServiceTypeFilter.getSelectedValues())
              .as("Order Service Type").containsExactlyInAnyOrderElementsOf(
                  splitAndNormalize(finalData.get("orderServiceType")));
        }
      }

      if (finalData.containsKey("zone")) {
        if (!createRouteGroupsPage.transactionsFiltersForm.zoneFilter.isDisplayedFast()) {
          assertions.fail("Zone is not displayed");
        } else {
          assertions.assertThat(
                  createRouteGroupsPage.transactionsFiltersForm.zoneFilter.getSelectedValues())
              .as("Zone")
              .containsExactlyInAnyOrderElementsOf(splitAndNormalize(finalData.get("zone")));
        }
      }

      if (finalData.containsKey("orderType")) {
        if (!createRouteGroupsPage.transactionsFiltersForm.orderTypeFilter.isDisplayedFast()) {
          assertions.fail("Order Type is not displayed");
        } else {
          assertions.assertThat(
                  createRouteGroupsPage.transactionsFiltersForm.orderTypeFilter.getSelectedValues())
              .as("Order Type")
              .containsExactlyInAnyOrderElementsOf(splitAndNormalize(finalData.get("orderType")));
        }
      }

      if (finalData.containsKey("ppDdLeg")) {
        if (!createRouteGroupsPage.transactionsFiltersForm.ppDdLegFilter.isDisplayedFast()) {
          assertions.fail("PP/DD Leg is not displayed");
        } else {
          assertions.assertThat(
                  createRouteGroupsPage.transactionsFiltersForm.ppDdLegFilter.getSelectedValues())
              .as("PP/DD Leg")
              .containsExactlyInAnyOrderElementsOf(splitAndNormalize(finalData.get("ppDdLeg")));
        }
      }

      if (finalData.containsKey("transactionStatus")) {
        if (!createRouteGroupsPage.transactionsFiltersForm.transactionStatusFilter.isDisplayedFast()) {
          assertions.fail("Transaction Status is not displayed");
        } else {
          assertions.assertThat(
                  createRouteGroupsPage.transactionsFiltersForm.transactionStatusFilter.getSelectedValues())
              .as("Transaction Status").containsExactlyInAnyOrderElementsOf(
                  splitAndNormalize(finalData.get("transactionStatus")));
        }
      }

      if (finalData.containsKey("rts")) {
        if (!createRouteGroupsPage.transactionsFiltersForm.rtsFilter.isDisplayedFast()) {
          assertions.fail("Transaction Status is not displayed");
        } else {
          assertions.assertThat(createRouteGroupsPage.transactionsFiltersForm.rtsFilter.getValue())
              .as("Transaction Status").isEqualTo(finalData.get("rts"));
        }
      }

      if (finalData.containsKey("parcelSize")) {
        if (!createRouteGroupsPage.transactionsFiltersForm.parcelSizeFilter.isDisplayedFast()) {
          assertions.fail("Parcel Size is not displayed");
        } else {
          assertions.assertThat(
                  createRouteGroupsPage.transactionsFiltersForm.parcelSizeFilter.getSelectedValues())
              .as("Parcel Size")
              .containsExactlyInAnyOrderElementsOf(splitAndNormalize(finalData.get("parcelSize")));
        }
      }

      if (finalData.containsKey("timeslots")) {
        if (!createRouteGroupsPage.transactionsFiltersForm.timeslotsFilter.isDisplayedFast()) {
          assertions.fail("Timeslots is not displayed");
        } else {
          assertions.assertThat(
                  createRouteGroupsPage.transactionsFiltersForm.timeslotsFilter.getSelectedValues())
              .as("Timeslots")
              .containsExactlyInAnyOrderElementsOf(splitAndNormalize(finalData.get("timeslots")));
        }
      }

      if (finalData.containsKey("deliveryType")) {
        if (!createRouteGroupsPage.transactionsFiltersForm.deliveryTypeFilter.isDisplayedFast()) {
          assertions.fail("Delivery Type is not displayed");
        } else {
          assertions.assertThat(removeIdsFromValues(
                  createRouteGroupsPage.transactionsFiltersForm.deliveryTypeFilter.getSelectedValues()))
              .as("Delivery Type").containsExactlyInAnyOrderElementsOf(
                  splitAndNormalize(finalData.get("deliveryType")));
        }
      }

      if (finalData.containsKey("dnrGroup")) {
        if (!createRouteGroupsPage.transactionsFiltersForm.dnrGroupFilter.isDisplayedFast()) {
          assertions.fail("DNR Group is not displayed");
        } else {
          assertions.assertThat(
                  createRouteGroupsPage.transactionsFiltersForm.dnrGroupFilter.getSelectedValues())
              .as("DNR Group")
              .containsExactlyInAnyOrderElementsOf(splitAndNormalize(finalData.get("dnrGroup")));
        }
      }
    });
    assertions.assertAll();
  }

  public static List<String> removeIdsFromValues(List<String> values) {
    Pattern p = Pattern.compile("(\\(\\d+\\))\\s*(.*)");
    return values.stream().map(v -> {
      Matcher m = p.matcher(v);
      if (m.matches()) {
        return m.group(2);
      } else {
        return v;
      }
    }).collect(Collectors.toList());
  }

  @Given("^Operator add following filters on Transactions Filters section on Create Route Groups page:$")
  public void operatorAddFollowingFiltersOnTransactionsFiltersSectionOnCreateRouteGroupPage(
      Map<String, String> data) {
    Map<String, String> finalData = resolveKeyValues(data);

    createRouteGroupsPage.inFrame(page -> {
      createRouteGroupsPage.transactionsFiltersForm.includeTransactions.check();
      String value = finalData.get("granularOrderStatus");
      if (StringUtils.isNotBlank(value)) {
        if (!createRouteGroupsPage.transactionsFiltersForm.granularOrderStatusFilter.isDisplayedFast()) {
          createRouteGroupsPage.transactionsFiltersForm.addFilter("Granular Order Status");
        }
        createRouteGroupsPage.transactionsFiltersForm.granularOrderStatusFilter.clearAll();
        createRouteGroupsPage.transactionsFiltersForm.granularOrderStatusFilter.selectFilter(
            splitAndNormalize(value));
      }

      value = finalData.get("orderServiceType");
      if (StringUtils.isNotBlank(value)) {
        if (!createRouteGroupsPage.transactionsFiltersForm.orderServiceTypeFilter.isDisplayedFast()) {
          createRouteGroupsPage.transactionsFiltersForm.addFilter("Order Service Type");
        }
        createRouteGroupsPage.transactionsFiltersForm.orderServiceTypeFilter.clearAll();
        createRouteGroupsPage.transactionsFiltersForm.orderServiceTypeFilter.selectFilter(
            splitAndNormalize(value));
      }

      value = finalData.get("zone");
      if (StringUtils.isNotBlank(value)) {
        if (!createRouteGroupsPage.transactionsFiltersForm.zoneFilter.isDisplayedFast()) {
          createRouteGroupsPage.transactionsFiltersForm.addFilter("Zone");
        }
        createRouteGroupsPage.transactionsFiltersForm.zoneFilter.clearAll();
        createRouteGroupsPage.transactionsFiltersForm.zoneFilter.selectFilter(
            splitAndNormalize(value));
      }

      value = finalData.get("orderType");
      if (StringUtils.isNotBlank(value)) {
        if (!createRouteGroupsPage.transactionsFiltersForm.orderTypeFilter.isDisplayedFast()) {
          createRouteGroupsPage.transactionsFiltersForm.addFilter("Order Type");
        }
        createRouteGroupsPage.transactionsFiltersForm.orderTypeFilter.clearAll();
        createRouteGroupsPage.transactionsFiltersForm.orderTypeFilter.selectFilter(
            splitAndNormalize(value));
      }

      value = finalData.get("ppDdLeg");
      if (StringUtils.isNotBlank(value)) {
        if (!createRouteGroupsPage.transactionsFiltersForm.ppDdLegFilter.isDisplayedFast()) {
          createRouteGroupsPage.transactionsFiltersForm.addFilter("PP/DD Leg");
        }
        createRouteGroupsPage.transactionsFiltersForm.ppDdLegFilter.clearAll();
        createRouteGroupsPage.transactionsFiltersForm.ppDdLegFilter.selectFilter(
            splitAndNormalize(value));
      }

      value = finalData.get("transactionStatus");
      if (StringUtils.isNotBlank(value)) {
        if (!createRouteGroupsPage.transactionsFiltersForm.transactionStatusFilter.isDisplayedFast()) {
          createRouteGroupsPage.transactionsFiltersForm.addFilter("Transaction Status");
        }
        createRouteGroupsPage.transactionsFiltersForm.transactionStatusFilter.clearAll();
        createRouteGroupsPage.transactionsFiltersForm.transactionStatusFilter.selectFilter(
            splitAndNormalize(value));
      }

      value = finalData.get("rts");
      if (StringUtils.isNotBlank(value)) {
        if (!createRouteGroupsPage.transactionsFiltersForm.rtsFilter.isDisplayedFast()) {
          createRouteGroupsPage.transactionsFiltersForm.addFilter("RTS");
        }
        createRouteGroupsPage.transactionsFiltersForm.rtsFilter.selectFilter(
            StringUtils.equalsIgnoreCase("Show", value));
      }

      value = finalData.get("parcelSize");
      if (StringUtils.isNotBlank(value)) {
        if (!createRouteGroupsPage.transactionsFiltersForm.parcelSizeFilter.isDisplayedFast()) {
          createRouteGroupsPage.transactionsFiltersForm.addFilter("Parcel Size");
        }
        createRouteGroupsPage.transactionsFiltersForm.parcelSizeFilter.clearAll();
        createRouteGroupsPage.transactionsFiltersForm.parcelSizeFilter.selectFilter(
            splitAndNormalize(value));
      }

      value = finalData.get("timeslots");
      if (StringUtils.isNotBlank(value)) {
        if (!createRouteGroupsPage.transactionsFiltersForm.timeslotsFilter.isDisplayedFast()) {
          createRouteGroupsPage.transactionsFiltersForm.addFilter("Timeslots");
        }
        createRouteGroupsPage.transactionsFiltersForm.timeslotsFilter.clearAll();
        createRouteGroupsPage.transactionsFiltersForm.timeslotsFilter.selectFilter(
            splitAndNormalize(value));
      }

      value = finalData.get("deliveryType");
      if (StringUtils.isNotBlank(value)) {
        if (!createRouteGroupsPage.transactionsFiltersForm.deliveryTypeFilter.isDisplayedFast()) {
          createRouteGroupsPage.transactionsFiltersForm.addFilter("Delivery Type");
        }
        createRouteGroupsPage.transactionsFiltersForm.deliveryTypeFilter.clearAll();
        createRouteGroupsPage.transactionsFiltersForm.deliveryTypeFilter.selectFilter(
            splitAndNormalize(value));
      }

      value = finalData.get("dnrGroup");
      if (StringUtils.isNotBlank(value)) {
        if (!createRouteGroupsPage.transactionsFiltersForm.dnrGroupFilter.isDisplayedFast()) {
          createRouteGroupsPage.transactionsFiltersForm.addFilter("DNR Group");
        }
        createRouteGroupsPage.transactionsFiltersForm.dnrGroupFilter.clearAll();
        createRouteGroupsPage.transactionsFiltersForm.dnrGroupFilter.selectFilter(
            splitAndNormalize(value));
      }

      value = finalData.get("weight");
      if (StringUtils.isNotBlank(value)) {
        if (!createRouteGroupsPage.transactionsFiltersForm.weightFilter.isDisplayedFast()) {
          createRouteGroupsPage.transactionsFiltersForm.addFilter("Weight");
        }
        createRouteGroupsPage.transactionsFiltersForm.weightFilter.selectFilter(value);
      }

      value = finalData.get("priorityLevel");
      if (StringUtils.isNotBlank(value)) {
        if (!createRouteGroupsPage.transactionsFiltersForm.priorityLevelFilter.isDisplayedFast()) {
          createRouteGroupsPage.transactionsFiltersForm.addFilter("Priority Level");
        }
        createRouteGroupsPage.transactionsFiltersForm.priorityLevelFilter.selectFilter(value);
      }
    });
  }

  @Given("^Operator add following filters on Reservation Filters section on Create Route Groups page:$")
  public void operatorAddFollowingFiltersOnReservationFiltersSectionOnCreateRouteGroupPage(
      Map<String, String> data) {

    Map<String, String> finalData = resolveKeyValues(data);

    createRouteGroupsPage.inFrame(page -> {
      createRouteGroupsPage.reservationFiltersForm.includeReservations.check();

      String value = finalData.get("pickUpSize");
      if (StringUtils.isNotBlank(value)) {
        if (!createRouteGroupsPage.reservationFiltersForm.pickUpSizeFilter.isDisplayedFast()) {
          createRouteGroupsPage.reservationFiltersForm.addFilter.selectValue("Pick Up Size");
        }
        String finalValue = value;
        retryIfRuntimeExceptionOccurred(() -> {
          createRouteGroupsPage.reservationFiltersForm.pickUpSizeFilter.clearAll();
          createRouteGroupsPage.reservationFiltersForm.pickUpSizeFilter.selectFilter(
              splitAndNormalize(finalValue));
        }, 5);
      }

      value = finalData.get("reservationType");
      if (StringUtils.isNotBlank(value)) {
        if (!createRouteGroupsPage.reservationFiltersForm.reservationTypeFilter.isDisplayedFast()) {
          createRouteGroupsPage.reservationFiltersForm.addFilter.selectValue("Reservation Type");
        }
        createRouteGroupsPage.reservationFiltersForm.reservationTypeFilter.clearAll();
        createRouteGroupsPage.reservationFiltersForm.reservationTypeFilter.selectFilter(
            splitAndNormalize(value));
      }

      value = finalData.get("reservationStatus");
      if (StringUtils.isNotBlank(value)) {
        if (!createRouteGroupsPage.reservationFiltersForm.reservationStatusFilter.isDisplayedFast()) {
          createRouteGroupsPage.reservationFiltersForm.addFilter.selectValue("Reservation Status");
        }
        createRouteGroupsPage.reservationFiltersForm.reservationStatusFilter.clearAll();
        createRouteGroupsPage.reservationFiltersForm.reservationStatusFilter.selectFilter(
            splitAndNormalize(value));
      }
    });
  }

  @When("^Operator verifies selected Reservation Filters on Create Route Groups page:$")
  public void operatorVerifiesSelectedReservationFilters(Map<String, String> data) {
    Map<String, String> finalData = resolveKeyValues(data);

    SoftAssertions assertions = new SoftAssertions();

    createRouteGroupsPage.inFrame(page -> {
      if (finalData.containsKey("pickUpSize")) {
        if (!createRouteGroupsPage.reservationFiltersForm.pickUpSizeFilter.isDisplayedFast()) {
          assertions.fail("Pick Up Size is not displayed");
        } else {
          assertions.assertThat(
                  createRouteGroupsPage.reservationFiltersForm.pickUpSizeFilter.getSelectedValues())
              .as("Pick Up Size")
              .containsExactlyInAnyOrderElementsOf(splitAndNormalize(finalData.get("pickUpSize")));
        }
      }

      if (finalData.containsKey("reservationType")) {
        if (!createRouteGroupsPage.reservationFiltersForm.reservationTypeFilter.isDisplayedFast()) {
          assertions.fail("Reservation Type is not displayed");
        } else {
          assertions.assertThat(
                  createRouteGroupsPage.reservationFiltersForm.reservationTypeFilter.getSelectedValues())
              .as("Reservation Type").containsExactlyInAnyOrderElementsOf(
                  splitAndNormalize(finalData.get("reservationType")));
        }
      }

      if (finalData.containsKey("reservationStatus")) {
        if (!createRouteGroupsPage.reservationFiltersForm.reservationStatusFilter.isDisplayedFast()) {
          assertions.fail("Reservation Status is not displayed");
        } else {
          assertions.assertThat(
                  createRouteGroupsPage.reservationFiltersForm.reservationStatusFilter.getSelectedValues())
              .as("Reservation Status").containsExactlyInAnyOrderElementsOf(
                  splitAndNormalize(finalData.get("reservationStatus")));
        }
      }
    });

    assertions.assertAll();
  }

  @Given("^Operator add following filters on General Filters section on Create Route Groups page:$")
  public void operatorAddFollowingFiltersOnGeneralFiltersSectionOnCreateRouteGroupPage(
      Map<String, String> data) {
    Map<String, String> finalData = resolveKeyValues(data);

    createRouteGroupsPage.inFrame(page -> {
      page.waitUntilLoaded(2);

      String value;
      if (finalData.containsKey("startDateTimeFrom") || finalData.containsKey("startDateTimeTo")) {
        if (!page.generalFiltersForm.startDateTimeFilter.isDisplayedFast()) {
          page.generalFiltersForm.addFilter("Start Datetime");
        }
        value = finalData.get("startDateTimeFrom");
        if (StringUtils.isNotBlank(value)) {
          page.generalFiltersForm.startDateTimeFilter.setFromDate(value);
        }
        value = finalData.get("startDateTimeTo");
        if (StringUtils.isNotBlank(value)) {
          page.generalFiltersForm.startDateTimeFilter.setToDate(value);
        }
      }

      if (finalData.containsKey("endDateTimeFrom") || finalData.containsKey("endDateTimeTo")) {
        if (!page.generalFiltersForm.endDateTimeFilter.isDisplayedFast()) {
          page.generalFiltersForm.addFilter("End Datetime");
        }
        value = finalData.get("endDateTimeFrom");
        if (StringUtils.isNotBlank(value)) {
          page.generalFiltersForm.endDateTimeFilter.setFromDate(value);
        }
        value = finalData.get("endDateTimeTo");
        if (StringUtils.isNotBlank(value)) {
          page.generalFiltersForm.endDateTimeFilter.setToDate(value);
        }
      }

      if (finalData.containsKey("creationTimeFrom") || finalData.containsKey("creationTimeTo")) {
        if (!page.generalFiltersForm.creationTimeFilter.isDisplayedFast()) {
          page.generalFiltersForm.addFilter("Creation Time");
        }

        value = finalData.get("creationTimeFrom");
        if (StringUtils.isNotBlank(value)) {
          page.generalFiltersForm.creationTimeFilter.setFromDate(value);
          page.generalFiltersForm.creationTimeFilter.selectFromHours("00");
          page.generalFiltersForm.creationTimeFilter.selectFromMinutes("00");
        }

        value = finalData.get("creationTimeTo");
        if (StringUtils.isNotBlank(value)) {
          page.generalFiltersForm.creationTimeFilter.setToDate(value);
          page.generalFiltersForm.creationTimeFilter.selectToHours("00");
          page.generalFiltersForm.creationTimeFilter.selectToMinutes("00");
        }
      }

      value = finalData.get("shipper");
      if (StringUtils.isNotBlank(value)) {
        if (!page.generalFiltersForm.shipperFilter.isDisplayedFast()) {
          page.generalFiltersForm.addFilter.selectValue("Shipper");
        }
        page.generalFiltersForm.shipperFilter.clearAll();
        page.generalFiltersForm.shipperFilter.selectFilter(value);
      }

      value = finalData.get("dpOrder");
      if (StringUtils.isNotBlank(value)) {
        if (!page.generalFiltersForm.dpOrderFilter.isDisplayedFast()) {
          page.generalFiltersForm.addFilter.selectValue("DP Order");
        }
        page.generalFiltersForm.dpOrderFilter.clearAll();
        page.generalFiltersForm.dpOrderFilter.selectFilter(value);
      }

      value = finalData.get("routeGrouping");
      if (StringUtils.isNotBlank(value)) {
        if (!page.generalFiltersForm.routeGroupingFilter.isDisplayedFast()) {
          page.generalFiltersForm.addFilter.selectValue("Route Grouping");
        }
        page.generalFiltersForm.routeGroupingFilter.clearAll();
        page.generalFiltersForm.routeGroupingFilter.selectFilter(value);
      }

      value = finalData.get("routed");
      if (StringUtils.isNotBlank(value)) {
        if (!page.generalFiltersForm.routedFilter.isDisplayedFast()) {
          page.generalFiltersForm.addFilter.selectValue("Routed");
        }
        page.generalFiltersForm.routedFilter.selectFilter(
            StringUtils.equalsIgnoreCase(value, "Show"));
      }

      value = finalData.get("serviceLevel");
      if (StringUtils.isNotBlank(value)) {
        if (!page.generalFiltersForm.serviceLevelFilter.isDisplayedFast()) {
          page.generalFiltersForm.addFilter.selectValue("Service Level");
          page.waitUntilLoaded(2);
        }
        page.generalFiltersForm.serviceLevelFilter.clearAll();
        page.generalFiltersForm.serviceLevelFilter.selectFilter(value);
      }

      value = finalData.get("excludedShipper");
      if (StringUtils.isNotBlank(value)) {
        if (!page.generalFiltersForm.excludedShipperFilter.isDisplayedFast()) {
          page.generalFiltersForm.addFilter.selectValue("Excluded Shipper");
          page.waitUntilLoaded(2);
        }
        page.generalFiltersForm.excludedShipperFilter.clearAll();
        page.generalFiltersForm.excludedShipperFilter.selectFilter(value);
      }

      value = finalData.get("hubInboundUser");
      if (StringUtils.isNotBlank(value)) {
        if (!page.generalFiltersForm.hubInboundUserFilter.isDisplayedFast()) {
          page.generalFiltersForm.addFilter.selectValue("Hub Inbound User");
          page.waitUntilLoaded(2);
        }
        page.generalFiltersForm.hubInboundUserFilter.clearAll();
        page.generalFiltersForm.hubInboundUserFilter.selectFilter(value);
      }

      if (finalData.containsKey("hubInboundDatetimeFrom") || finalData.containsKey(
          "hubInboundDatetimeTo")) {
        if (!page.generalFiltersForm.hubInboundDatetimeFilter.isDisplayedFast()) {
          page.generalFiltersForm.addFilter.selectValue("Hub Inbound Datetime");
        }

        value = finalData.get("hubInboundDatetimeFrom");
        if (StringUtils.isNotBlank(value)) {
          page.generalFiltersForm.hubInboundDatetimeFilter.setFromDate(value);
          page.generalFiltersForm.hubInboundDatetimeFilter.selectFromHours("00");
          page.generalFiltersForm.hubInboundDatetimeFilter.selectFromMinutes("00");
        }

        value = finalData.get("hubInboundDatetimeTo");
        if (StringUtils.isNotBlank(value)) {
          page.generalFiltersForm.hubInboundDatetimeFilter.setToDate(value);
          page.generalFiltersForm.hubInboundDatetimeFilter.selectToHours("00");
          page.generalFiltersForm.hubInboundDatetimeFilter.selectToMinutes("00");
        }
      }

      if (finalData.containsKey("originalTransactionEndTimeFrom") || finalData.containsKey(
          "originalTransactionEndTimeTo")) {
        if (!page.generalFiltersForm.originalTransactionEndTimeFilter.isDisplayedFast()) {
          page.generalFiltersForm.addFilter.selectValue("Original Transaction End Time");
          page.waitUntilLoaded(2);
        }

        value = finalData.get("originalTransactionEndTimeFrom");
        if (StringUtils.isNotBlank(value)) {
          page.generalFiltersForm.originalTransactionEndTimeFilter.setFromDate(value);
          page.generalFiltersForm.originalTransactionEndTimeFilter.selectFromHours("00");
          page.generalFiltersForm.originalTransactionEndTimeFilter.selectFromMinutes("00");
        }

        value = finalData.get("originalTransactionEndTimeTo");
        if (StringUtils.isNotBlank(value)) {
          page.generalFiltersForm.originalTransactionEndTimeFilter.setToDate(value);
          page.generalFiltersForm.originalTransactionEndTimeFilter.selectToHours("00");
          page.generalFiltersForm.originalTransactionEndTimeFilter.selectToMinutes("00");
        }
      }

      value = finalData.get("masterShipper");
      if (StringUtils.isNotBlank(value)) {
        if (!page.generalFiltersForm.masterShipperFilter.isDisplayedFast()) {
          page.generalFiltersForm.addFilter("Master Shipper");
          page.waitUntilLoaded(2);
        }
        page.generalFiltersForm.masterShipperFilter.clearAll();
        page.generalFiltersForm.masterShipperFilter.selectFilter(value);
      }
    });
  }

  @Given("^Create Route Groups page is loaded$")
  public void pageIsLoaded() {
    createRouteGroupsPage.inFrame(SimpleReactPage::waitUntilLoaded);
  }

  @Given("^Operator set General Filters on Create Route Groups page:$")
  public void operatorSetGeneralFilters(Map<String, String> data) {
    Map<String, String> finalData = resolveKeyValues(data);

    createRouteGroupsPage.inFrame(page -> {
      String value;
      page.waitUntilLoaded(5, 30);
      page.generalFiltersForm.waitUntilVisible();

      if (finalData.containsKey("startDateTimeFrom") || finalData.containsKey("startDateTimeTo")) {
        if (!page.generalFiltersForm.startDateTimeFilter.isDisplayedFast()) {
          page.generalFiltersForm.addFilter("Start Datetime");
        }
        value = finalData.get("startDateTimeFrom");
        if (StringUtils.isNotBlank(value)) {
          page.generalFiltersForm.startDateTimeFilter.setFromDate(value);
        }
        value = finalData.get("startDateTimeTo");
        if (StringUtils.isNotBlank(value)) {
          page.generalFiltersForm.startDateTimeFilter.setToDate(value);
        }
      } else if (page.generalFiltersForm.startDateTimeFilter.isDisplayedFast()) {
        page.generalFiltersForm.startDateTimeFilter.removeFilter();
      }

      if (finalData.containsKey("endDateTimeFrom") || finalData.containsKey("endDateTimeTo")) {
        if (!page.generalFiltersForm.endDateTimeFilter.isDisplayedFast()) {
          page.generalFiltersForm.addFilter("End Datetime");
        }
        value = finalData.get("endDateTimeFrom");
        if (StringUtils.isNotBlank(value)) {
          page.generalFiltersForm.endDateTimeFilter.setFromDate(value);
        }
        value = finalData.get("endDateTimeTo");
        if (StringUtils.isNotBlank(value)) {
          page.generalFiltersForm.endDateTimeFilter.setToDate(value);
        }
      } else if (page.generalFiltersForm.endDateTimeFilter.isDisplayedFast()) {
        page.generalFiltersForm.endDateTimeFilter.removeFilter();
      }

      if (finalData.containsKey("creationTimeFrom") || finalData.containsKey("creationTimeTo")
          || finalData.containsKey("creationTime")) {
        if (!page.generalFiltersForm.creationTimeFilter.isDisplayedFast()) {
          page.generalFiltersForm.addFilter("Creation Time");
        }

        value = finalData.get("creationTimeFrom");
        if (StringUtils.isNotBlank(value)) {
          page.generalFiltersForm.creationTimeFilter.setFromDate(value);
          page.generalFiltersForm.creationTimeFilter.selectFromHours("00");
          page.generalFiltersForm.creationTimeFilter.selectFromMinutes("00");
        }

        value = finalData.get("creationTimeTo");
        if (StringUtils.isNotBlank(value)) {
          page.generalFiltersForm.creationTimeFilter.setToDate(value);
          page.generalFiltersForm.creationTimeFilter.selectToHours("00");
          page.generalFiltersForm.creationTimeFilter.selectToMinutes("00");
        }

        value = finalData.get("creationTime");
        if (StringUtils.equalsIgnoreCase(value, "current hour")) {
          Date date = new Date();
          date = DateUtils.addHours(date, 1);
          page.generalFiltersForm.creationTimeFilter.setToDate(date);
          page.generalFiltersForm.creationTimeFilter.selectToHours(
              DateUtils.getFragmentInHours(date, Calendar.DAY_OF_YEAR));
          page.generalFiltersForm.creationTimeFilter.selectToMinutes("00");

          date = DateUtils.addHours(date, -1);
          page.generalFiltersForm.creationTimeFilter.setFromDate(date);
          page.generalFiltersForm.creationTimeFilter.selectFromHours(
              DateUtils.getFragmentInHours(date, Calendar.DAY_OF_YEAR));
          page.generalFiltersForm.creationTimeFilter.selectFromMinutes("00");
        } else if (StringUtils.equalsIgnoreCase(value, "today")) {
          var fromDate = new Date();
          var toDate = DateUtils.addDays(fromDate, 1);
          page.generalFiltersForm.creationTimeFilter.setToDate(toDate);
          page.generalFiltersForm.creationTimeFilter.selectToTime("00", "00");

          page.generalFiltersForm.creationTimeFilter.setFromDate(fromDate);
          page.generalFiltersForm.creationTimeFilter.selectFromTime("00", "00");
        }
      } else if (page.generalFiltersForm.creationTimeFilter.isDisplayedFast()) {
        page.generalFiltersForm.creationTimeFilter.removeFilter();
      }

      value = finalData.get("shipper");
      if (StringUtils.isNotBlank(value)) {
        if (!page.generalFiltersForm.shipperFilter.isDisplayedFast()) {
          page.generalFiltersForm.addFilter.selectValue("Shipper");
        }
        page.generalFiltersForm.shipperFilter.clearAll();
        page.generalFiltersForm.shipperFilter.selectFilter(value);
      } else if (page.generalFiltersForm.shipperFilter.isDisplayedFast()) {
        page.generalFiltersForm.shipperFilter.removeFilter();
      }

      value = finalData.get("dpOrder");
      if (StringUtils.isNotBlank(value)) {
        if (!page.generalFiltersForm.dpOrderFilter.isDisplayedFast()) {
          page.generalFiltersForm.addFilter.selectValue("DP Order");
        }
        page.generalFiltersForm.dpOrderFilter.clearAll();
        page.generalFiltersForm.dpOrderFilter.selectFilter(value);
      } else if (page.generalFiltersForm.dpOrderFilter.isDisplayedFast()) {
        page.generalFiltersForm.dpOrderFilter.removeFilter();
      }

      value = finalData.get("routeGrouping");
      if (StringUtils.isNotBlank(value)) {
        if (!page.generalFiltersForm.routeGroupingFilter.isDisplayedFast()) {
          page.generalFiltersForm.addFilter.selectValue("Route Grouping");
        }
        page.generalFiltersForm.routeGroupingFilter.clearAll();
        String finalValue = value;
        retryIfRuntimeExceptionOccurred(() ->
            page.generalFiltersForm.routeGroupingFilter.selectFilter(finalValue), 5);
      } else if (page.generalFiltersForm.routeGroupingFilter.isDisplayedFast()) {
        page.generalFiltersForm.routeGroupingFilter.removeFilter();
      }

      value = finalData.get("routed");
      if (StringUtils.isNotBlank(value)) {
        if (!page.generalFiltersForm.routedFilter.isDisplayedFast()) {
          page.generalFiltersForm.addFilter.selectValue("Routed");
        }
        page.generalFiltersForm.routedFilter.selectFilter(
            StringUtils.equalsIgnoreCase(value, "Show"));
      } else if (page.generalFiltersForm.routedFilter.isDisplayedFast()) {
        page.generalFiltersForm.routedFilter.removeFilter();
      }

      value = finalData.get("serviceLevel");
      if (StringUtils.isNotBlank(value)) {
        if (!page.generalFiltersForm.serviceLevelFilter.isDisplayedFast()) {
          page.generalFiltersForm.addFilter.selectValue("Service Level");
          page.waitUntilLoaded(2);
        }
        page.generalFiltersForm.serviceLevelFilter.clearAll();
        page.generalFiltersForm.serviceLevelFilter.selectFilter(value);
      } else if (page.generalFiltersForm.serviceLevelFilter.isDisplayedFast()) {
        page.generalFiltersForm.serviceLevelFilter.removeFilter();
      }

      value = finalData.get("excludedShipper");
      if (StringUtils.isNotBlank(value)) {
        if (!page.generalFiltersForm.excludedShipperFilter.isDisplayedFast()) {
          page.generalFiltersForm.addFilter("Excluded Shipper");
        }
        page.generalFiltersForm.excludedShipperFilter.clearAll();
        page.generalFiltersForm.excludedShipperFilter.selectFilter(splitAndNormalize(value));
      } else if (page.generalFiltersForm.excludedShipperFilter.isDisplayedFast()) {
        page.generalFiltersForm.excludedShipperFilter.removeFilter();
      }

      value = finalData.get("hubInboundUser");
      if (StringUtils.isNotBlank(value)) {
        if (!page.generalFiltersForm.hubInboundUserFilter.isDisplayedFast()) {
          page.generalFiltersForm.addFilter("Hub Inbound User");
        }
        page.generalFiltersForm.hubInboundUserFilter.clearAll();
        page.generalFiltersForm.hubInboundUserFilter.selectFilter(splitAndNormalize(value));
      } else if (page.generalFiltersForm.hubInboundUserFilter.isDisplayedFast()) {
        page.generalFiltersForm.hubInboundUserFilter.removeFilter();
      }

      if (finalData.containsKey("hubInboundDatetimeFrom") || finalData.containsKey(
          "hubInboundDatetimeTo")) {
        if (!page.generalFiltersForm.hubInboundDatetimeFilter.isDisplayedFast()) {
          page.generalFiltersForm.addFilter.selectValue("Hub Inbound Datetime");
        }

        value = finalData.get("hubInboundDatetimeFrom");
        if (StringUtils.isNotBlank(value)) {
          page.generalFiltersForm.hubInboundDatetimeFilter.setFromDate(value);
          page.generalFiltersForm.hubInboundDatetimeFilter.selectFromHours("00");
          page.generalFiltersForm.hubInboundDatetimeFilter.selectFromMinutes("00");
        }

        value = finalData.get("hubInboundDatetimeTo");
        if (StringUtils.isNotBlank(value)) {
          page.generalFiltersForm.hubInboundDatetimeFilter.setToDate(value);
          page.generalFiltersForm.hubInboundDatetimeFilter.selectToHours("00");
          page.generalFiltersForm.hubInboundDatetimeFilter.selectToMinutes("00");
        }
      } else if (page.generalFiltersForm.hubInboundDatetimeFilter.isDisplayedFast()) {
        page.generalFiltersForm.hubInboundDatetimeFilter.removeFilter();
      }

      if (finalData.containsKey("originalTransactionEndTimeFrom") || finalData.containsKey(
          "originalTransactionEndTimeTo")) {
        if (!page.generalFiltersForm.originalTransactionEndTimeFilter.isDisplayedFast()) {
          page.generalFiltersForm.addFilter.selectValue("Original Transaction End Time");
          page.waitUntilLoaded(2);
        }

        value = finalData.get("originalTransactionEndTimeFrom");
        if (StringUtils.isNotBlank(value)) {
          page.generalFiltersForm.originalTransactionEndTimeFilter.setFromDate(value);
          page.generalFiltersForm.originalTransactionEndTimeFilter.selectFromHours("00");
          page.generalFiltersForm.originalTransactionEndTimeFilter.selectFromMinutes("00");
        }

        value = finalData.get("originalTransactionEndTimeTo");
        if (StringUtils.isNotBlank(value)) {
          if ("+1 day".equals(value)) {
            String from = finalData.get("originalTransactionEndTimeFrom");
            try {
              var fromDate = DateUtils.parseDate(from, "yyyy-MM-dd");
              value = DateFormatUtils.format(DateUtils.addDays(fromDate, 1), "yyyy-MM-dd");
            } catch (ParseException e) {
              throw new RuntimeException(e);
            }
          }
          page.generalFiltersForm.originalTransactionEndTimeFilter.setToDate(value);
          page.generalFiltersForm.originalTransactionEndTimeFilter.selectToHours("00");
          page.generalFiltersForm.originalTransactionEndTimeFilter.selectToMinutes("00");
        }
      } else if (page.generalFiltersForm.originalTransactionEndTimeFilter.isDisplayedFast()) {
        page.generalFiltersForm.originalTransactionEndTimeFilter.removeFilter();
      }

      value = finalData.get("masterShipper");
      if (StringUtils.isNotBlank(value)) {
        if (!page.generalFiltersForm.masterShipperFilter.isDisplayedFast()) {
          page.generalFiltersForm.addFilter("Master Shipper");
          page.waitUntilLoaded(2, 60);
        }
        page.generalFiltersForm.masterShipperFilter.clearAll();
        page.generalFiltersForm.masterShipperFilter.selectFilter(value);
      } else if (page.generalFiltersForm.masterShipperFilter.isDisplayedFast()) {
        page.generalFiltersForm.masterShipperFilter.removeFilter();
      }
    });
  }

  @Given("^Operator updates General Filters on Create Route Groups page:$")
  public void operatorUpdatesGeneralFilters(Map<String, String> data) {
    Map<String, String> finalData = resolveKeyValues(data);

    createRouteGroupsPage.inFrame(page -> {
      createRouteGroupsPage.waitUntilPageLoaded();

      String value;
      if (finalData.containsKey("startDateTimeFrom") || finalData.containsKey("startDateTimeTo")) {
        if (!createRouteGroupsPage.generalFiltersForm.startDateTimeFilter.isDisplayedFast()) {
          createRouteGroupsPage.generalFiltersForm.addFilter.selectValue("Start Datetime");
        }
        value = finalData.get("startDateTimeFrom");
        if (StringUtils.isNotBlank(value)) {
          createRouteGroupsPage.generalFiltersForm.startDateTimeFilter.setFromDate(value);
        }
        value = finalData.get("startDateTimeTo");
        if (StringUtils.isNotBlank(value)) {
          createRouteGroupsPage.generalFiltersForm.startDateTimeFilter.setToDate(value);
        }
      }

      if (finalData.containsKey("endDateTimeFrom") || finalData.containsKey("endDateTimeTo")) {
        if (!createRouteGroupsPage.generalFiltersForm.endDateTimeFilter.isDisplayedFast()) {
          createRouteGroupsPage.generalFiltersForm.addFilter.selectValue("End Datetime");
        }
        value = finalData.get("endDateTimeFrom");
        if (StringUtils.isNotBlank(value)) {
          createRouteGroupsPage.generalFiltersForm.endDateTimeFilter.setFromDate(value);
        }
        value = finalData.get("endDateTimeTo");
        if (StringUtils.isNotBlank(value)) {
          createRouteGroupsPage.generalFiltersForm.endDateTimeFilter.setToDate(value);
        }
      }

      if (finalData.containsKey("creationTimeFrom") || finalData.containsKey("creationTimeTo")) {
        if (!createRouteGroupsPage.generalFiltersForm.creationTimeFilter.isDisplayedFast()) {
          createRouteGroupsPage.generalFiltersForm.addFilter.selectValue("Creation Time");
        }

        value = finalData.get("creationTimeFrom");
        if (StringUtils.isNotBlank(value)) {
          createRouteGroupsPage.generalFiltersForm.creationTimeFilter.setFromDate(value);
          createRouteGroupsPage.generalFiltersForm.creationTimeFilter.selectFromHours("00");
          createRouteGroupsPage.generalFiltersForm.creationTimeFilter.selectFromMinutes("00");
        }

        value = finalData.get("creationTimeTo");
        if (StringUtils.isNotBlank(value)) {
          createRouteGroupsPage.generalFiltersForm.creationTimeFilter.setToDate(value);
          createRouteGroupsPage.generalFiltersForm.creationTimeFilter.selectToHours("00");
          createRouteGroupsPage.generalFiltersForm.creationTimeFilter.selectToMinutes("00");
        }
      }

      value = finalData.get("shipper");
      if (StringUtils.isNotBlank(value)) {
        if (!createRouteGroupsPage.generalFiltersForm.shipperFilter.isDisplayedFast()) {
          createRouteGroupsPage.generalFiltersForm.addFilter.selectValue("Shipper");
        }
        createRouteGroupsPage.generalFiltersForm.shipperFilter.clearAll();
        createRouteGroupsPage.generalFiltersForm.shipperFilter.selectFilter(value);
      } else if (createRouteGroupsPage.generalFiltersForm.shipperFilter.isDisplayedFast()) {
        createRouteGroupsPage.generalFiltersForm.shipperFilter.removeFilter();
      }

      value = finalData.get("dpOrder");
      if (StringUtils.isNotBlank(value)) {
        if (!createRouteGroupsPage.generalFiltersForm.dpOrderFilter.isDisplayedFast()) {
          createRouteGroupsPage.generalFiltersForm.addFilter.selectValue("DP Order");
        }
        createRouteGroupsPage.generalFiltersForm.dpOrderFilter.clearAll();
        createRouteGroupsPage.generalFiltersForm.dpOrderFilter.selectFilter(value);
      }

      value = finalData.get("routeGrouping");
      if (StringUtils.isNotBlank(value)) {
        if (!createRouteGroupsPage.generalFiltersForm.routeGroupingFilter.isDisplayedFast()) {
          createRouteGroupsPage.generalFiltersForm.addFilter.selectValue("Route Grouping");
        }
        createRouteGroupsPage.generalFiltersForm.routeGroupingFilter.clearAll();
        createRouteGroupsPage.generalFiltersForm.routeGroupingFilter.selectFilter(value);
      }

      value = finalData.get("routed");
      if (StringUtils.isNotBlank(value)) {
        if (!createRouteGroupsPage.generalFiltersForm.routedFilter.isDisplayedFast()) {
          createRouteGroupsPage.generalFiltersForm.addFilter.selectValue("Routed");
        }
        createRouteGroupsPage.generalFiltersForm.routedFilter.selectFilter(
            StringUtils.equalsIgnoreCase(value, "Show"));
      }

      value = finalData.get("masterShipper");
      if (StringUtils.isNotBlank(value)) {
        if (!createRouteGroupsPage.generalFiltersForm.masterShipperFilter.isDisplayedFast()) {
          createRouteGroupsPage.generalFiltersForm.addFilter.selectValue("Master Shipper");
        }
        createRouteGroupsPage.generalFiltersForm.masterShipperFilter.clearAll();
        createRouteGroupsPage.generalFiltersForm.masterShipperFilter.selectFilter(value);
      }
    });
  }

  @When("^Operator verifies selected General Filters on Create Route Groups page:$")
  public void operatorVerifiesSelectedFilters(Map<String, String> data) {
    Map<String, String> finalData = resolveKeyValues(data);

    SoftAssertions assertions = new SoftAssertions();

    createRouteGroupsPage.inFrame(page -> {
      if (finalData.containsKey("startDateTimeFrom") || finalData.containsKey("startDateTimeTo")) {
        if (!createRouteGroupsPage.generalFiltersForm.startDateTimeFilter.isDisplayedFast()) {
          assertions.fail("Start Datetime is not displayed");
        } else {
          if (finalData.containsKey("startDateTimeFrom")) {
            assertions.assertThat(toDateTime(
                    createRouteGroupsPage.generalFiltersForm.startDateTimeFilter.fromInput.getValue()))
                .as("Start Datetime from")
                .isEqualTo(toDateTime(finalData.get("startDateTimeFrom")));
          }
          if (finalData.containsKey("startDateTimeTo")) {
            assertions.assertThat(toDateTime(
                    createRouteGroupsPage.generalFiltersForm.startDateTimeFilter.toInput.getValue()))
                .as("Start Datetime to").isEqualTo(toDateTime(finalData.get("startDateTimeTo")));
          }
        }
      }

      if (finalData.containsKey("endDateTimeFrom") || finalData.containsKey("endDateTimeTo")) {
        if (!createRouteGroupsPage.generalFiltersForm.endDateTimeFilter.isDisplayedFast()) {
          assertions.fail("End Datetime is not displayed");
        } else {
          if (finalData.containsKey("endDateTimeFrom")) {
            assertions.assertThat(toDateTime(
                    createRouteGroupsPage.generalFiltersForm.endDateTimeFilter.fromInput.getValue()))
                .as("End Datetime from").isEqualTo(toDateTime(finalData.get("endDateTimeFrom")));
          }
          if (finalData.containsKey("endDateTimeTo")) {
            assertions.assertThat(toDateTime(
                    createRouteGroupsPage.generalFiltersForm.endDateTimeFilter.toInput.getValue()))
                .as("End Datetime to").isEqualTo(toDateTime(finalData.get("endDateTimeTo")));
          }
        }
      }

      if (finalData.containsKey("creationTimeFrom")) {
        boolean isDisplayed = createRouteGroupsPage.generalFiltersForm.creationTimeFilter.isDisplayedFast();
        if (!isDisplayed) {
          assertions.fail("Creation Time is not displayed");
        } else {
          assertions.assertThat(toDateTime(
                  createRouteGroupsPage.generalFiltersForm.creationTimeFilter.fromInput.getValue()))
              .as("Creation Time from").isEqualTo(toDateTime(finalData.get("creationTimeFrom")));
        }
      }

      if (finalData.containsKey("creationTimeTo")) {
        boolean isDisplayed = createRouteGroupsPage.generalFiltersForm.creationTimeFilter.isDisplayedFast();
        if (!isDisplayed) {
          assertions.fail("Creation Time is not displayed");
        } else {
          assertions.assertThat(toDateTime(
                  createRouteGroupsPage.generalFiltersForm.creationTimeFilter.toInput.getValue()))
              .as("Creation Time to").isEqualTo(toDateTime(finalData.get("creationTimeTo")));
        }
      }

      if (finalData.containsKey("shipper")) {
        boolean isDisplayed = createRouteGroupsPage.generalFiltersForm.shipperFilter.isDisplayedFast();
        if (!isDisplayed) {
          assertions.fail("Shipper is not displayed");
        } else {
          assertions.assertThat(
                  createRouteGroupsPage.generalFiltersForm.shipperFilter.getSelectedValues())
              .as("Shipper")
              .containsExactlyInAnyOrderElementsOf(splitAndNormalize(finalData.get("shipper")));
        }
      }

      if (finalData.containsKey("dpOrder")) {
        boolean isDisplayed = createRouteGroupsPage.generalFiltersForm.dpOrderFilter.isDisplayedFast();
        if (!isDisplayed) {
          assertions.fail("DP Order is not displayed");
        } else {
          assertions.assertThat(
                  createRouteGroupsPage.generalFiltersForm.dpOrderFilter.getSelectedValues())
              .as("DP Order")
              .containsExactlyInAnyOrderElementsOf(splitAndNormalize(finalData.get("dpOrder")));
        }
      }

      if (finalData.containsKey("routeGrouping")) {
        boolean isDisplayed = createRouteGroupsPage.generalFiltersForm.routeGroupingFilter.isDisplayedFast();
        if (!isDisplayed) {
          assertions.fail("Route Grouping is not displayed");
        } else {
          assertions.assertThat(
                  createRouteGroupsPage.generalFiltersForm.routeGroupingFilter.getSelectedValues())
              .as("Route Grouping").containsExactlyInAnyOrderElementsOf(
                  splitAndNormalize(finalData.get("routeGrouping")));
        }
      }

      if (finalData.containsKey("routed")) {
        boolean isDisplayed = createRouteGroupsPage.generalFiltersForm.routedFilter.isDisplayedFast();
        if (!isDisplayed) {
          assertions.fail("Routed is not displayed");
        } else {
          assertions.assertThat(createRouteGroupsPage.generalFiltersForm.routedFilter.getValue())
              .as("Routed").isEqualToIgnoringCase(finalData.get("routed"));
        }
      }

      if (finalData.containsKey("masterShipper")) {
        boolean isDisplayed = createRouteGroupsPage.generalFiltersForm.masterShipperFilter.isDisplayedFast();
        if (!isDisplayed) {
          assertions.fail("Master Shipper is not displayed");
        } else {
          assertions.assertThat(
                  createRouteGroupsPage.generalFiltersForm.masterShipperFilter.getSelectedValues())
              .as("Master Shipper").containsExactlyInAnyOrderElementsOf(
                  splitAndNormalize(finalData.get("masterShipper")));
        }
      }
    });

    assertions.assertAll();
  }

  @Given("^Operator set Shipment Filters on Create Route Groups page:$")
  public void operatorSetShipmentFilters(Map<String, String> data) {
    Map<String, String> finalData = resolveKeyValues(data);
    createRouteGroupsPage.inFrame(page -> {
      createRouteGroupsPage.shipmentFiltersForm.includeShipments.check();

      String value;
      if (finalData.containsKey("shipmentDateFrom") || finalData.containsKey("shipmentDateTo")) {
        value = finalData.get("shipmentDateTo");
        if (StringUtils.isNotBlank(value)) {
          createRouteGroupsPage.shipmentFiltersForm.shipmentDateFilter.setToDate(value);
          createRouteGroupsPage.shipmentFiltersForm.shipmentDateFilter.selectToHours("00");
          createRouteGroupsPage.shipmentFiltersForm.shipmentDateFilter.selectToMinutes("00");
        }
        value = finalData.get("shipmentDateFrom");
        if (StringUtils.isNotBlank(value)) {
          createRouteGroupsPage.shipmentFiltersForm.shipmentDateFilter.setFromDate(value);
          createRouteGroupsPage.shipmentFiltersForm.shipmentDateFilter.selectFromHours("00");
          createRouteGroupsPage.shipmentFiltersForm.shipmentDateFilter.selectFromMinutes("00");
        }
      }

      if (finalData.containsKey("etaDateTimeFrom") || finalData.containsKey("etaDateTimeTo")) {
        if (!createRouteGroupsPage.shipmentFiltersForm.etaDateTimeFilter.isDisplayedFast()) {
          createRouteGroupsPage.shipmentFiltersForm.addFilter.selectValue("ETA (Date Time)");
        }
        value = finalData.get("etaDateTimeFrom");
        if (StringUtils.isNotBlank(value)) {
          createRouteGroupsPage.shipmentFiltersForm.etaDateTimeFilter.setFromDate(value);
        }
        value = finalData.get("etaDateTimeTo");
        if (StringUtils.isNotBlank(value)) {
          createRouteGroupsPage.shipmentFiltersForm.etaDateTimeFilter.setToDate(value);
        }
      } else if (createRouteGroupsPage.shipmentFiltersForm.etaDateTimeFilter.isDisplayedFast()) {
        createRouteGroupsPage.shipmentFiltersForm.etaDateTimeFilter.removeFilter();
      }

      value = finalData.get("startHub");
      if (StringUtils.isNotBlank(value)) {
        if (!createRouteGroupsPage.shipmentFiltersForm.startHubFilter.isDisplayedFast()) {
          createRouteGroupsPage.shipmentFiltersForm.addFilter.selectValue("Start Hub");
        }
        createRouteGroupsPage.shipmentFiltersForm.startHubFilter.clearAll();
        createRouteGroupsPage.shipmentFiltersForm.startHubFilter.selectFilter(value);
      } else if (createRouteGroupsPage.shipmentFiltersForm.startHubFilter.isDisplayedFast()) {
        createRouteGroupsPage.shipmentFiltersForm.startHubFilter.removeFilter();
      }

      value = finalData.get("endHub");
      if (StringUtils.isNotBlank(value)) {
        if (!createRouteGroupsPage.shipmentFiltersForm.endHubFilter.isDisplayedFast()) {
          createRouteGroupsPage.shipmentFiltersForm.addFilter.selectValue("End Hub");
        }
        createRouteGroupsPage.shipmentFiltersForm.endHubFilter.clearAll();
        createRouteGroupsPage.shipmentFiltersForm.endHubFilter.selectFilter(value);
      } else if (createRouteGroupsPage.shipmentFiltersForm.endHubFilter.isDisplayedFast()) {
        createRouteGroupsPage.shipmentFiltersForm.endHubFilter.removeFilter();
      }

      value = finalData.get("lastInboundHub");
      if (StringUtils.isNotBlank(value)) {
        if (!createRouteGroupsPage.shipmentFiltersForm.lastInboundHubFilter.isDisplayedFast()) {
          createRouteGroupsPage.shipmentFiltersForm.addFilter.selectValue("Last Inbound Hub");
        }
        createRouteGroupsPage.shipmentFiltersForm.lastInboundHubFilter.clearAll();
        createRouteGroupsPage.shipmentFiltersForm.lastInboundHubFilter.selectFilter(value);
      } else if (createRouteGroupsPage.shipmentFiltersForm.lastInboundHubFilter.isDisplayedFast()) {
        createRouteGroupsPage.shipmentFiltersForm.lastInboundHubFilter.removeFilter();
      }

      value = finalData.get("mawb");
      if (StringUtils.isNotBlank(value)) {
        if (!createRouteGroupsPage.shipmentFiltersForm.mawbFilter.isDisplayedFast()) {
          createRouteGroupsPage.shipmentFiltersForm.addFilter.selectValue("MAWB");
        }
        createRouteGroupsPage.shipmentFiltersForm.mawbFilter.setValue(value);
      } else if (createRouteGroupsPage.shipmentFiltersForm.mawbFilter.isDisplayedFast()) {
        createRouteGroupsPage.shipmentFiltersForm.mawbFilter.removeFilter();
      }

      if (finalData.containsKey("shipmentCompletionDateTimeFrom") || finalData.containsKey(
          "shipmentCompletionDateTimeTo")) {
        if (!createRouteGroupsPage.shipmentFiltersForm.shipmentCompletionDateTimeFilter.isDisplayedFast()) {
          createRouteGroupsPage.shipmentFiltersForm.addFilter.selectValue(
              "Shipment Completion Date Time");
        }
        value = finalData.get("shipmentCompletionDateTimeFrom");
        if (StringUtils.isNotBlank(value)) {
          createRouteGroupsPage.shipmentFiltersForm.shipmentCompletionDateTimeFilter.setFromDate(
              value);
        }
        value = finalData.get("shipmentCompletionDateTimeTo");
        if (StringUtils.isNotBlank(value)) {
          createRouteGroupsPage.shipmentFiltersForm.shipmentCompletionDateTimeFilter.setToDate(
              value);
        }
      } else if (createRouteGroupsPage.shipmentFiltersForm.shipmentCompletionDateTimeFilter.isDisplayedFast()) {
        createRouteGroupsPage.shipmentFiltersForm.shipmentCompletionDateTimeFilter.removeFilter();
      }

      value = finalData.get("shipmentStatus");
      createRouteGroupsPage.shipmentFiltersForm.shipmentStatusFilter.clearAll();
      if (StringUtils.isNotBlank(value)) {
        createRouteGroupsPage.shipmentFiltersForm.shipmentStatusFilter.selectFilter(value);
      }

      value = finalData.get("shipmentType");
      createRouteGroupsPage.shipmentFiltersForm.shipmentTypeFilter.clearAll();
      if (StringUtils.isNotBlank(value)) {
        createRouteGroupsPage.shipmentFiltersForm.shipmentTypeFilter.selectFilter(value);
      }

      if (finalData.containsKey("transitDateTimeFrom") || finalData.containsKey(
          "transitDateTimeTo")) {
        if (!createRouteGroupsPage.shipmentFiltersForm.transitDateTimeFilter.isDisplayedFast()) {
          createRouteGroupsPage.shipmentFiltersForm.addFilter.selectValue("Transit Date Time");
        }
        value = finalData.get("transitDateTimeFrom");
        if (StringUtils.isNotBlank(value)) {
          createRouteGroupsPage.shipmentFiltersForm.transitDateTimeFilter.setFromDate(value);
          createRouteGroupsPage.shipmentFiltersForm.transitDateTimeFilter.selectFromHours("00");
          createRouteGroupsPage.shipmentFiltersForm.transitDateTimeFilter.selectFromMinutes("00");
        }
        value = finalData.get("transitDateTimeTo");
        if (StringUtils.isNotBlank(value)) {
          createRouteGroupsPage.shipmentFiltersForm.transitDateTimeFilter.setToDate(value);
          createRouteGroupsPage.shipmentFiltersForm.transitDateTimeFilter.selectToHours("00");
          createRouteGroupsPage.shipmentFiltersForm.transitDateTimeFilter.selectToMinutes("00");
        }
      } else if (createRouteGroupsPage.shipmentFiltersForm.transitDateTimeFilter.isDisplayedFast()) {
        createRouteGroupsPage.shipmentFiltersForm.transitDateTimeFilter.removeFilter();
      }

    });

  }

  @When("^Operator verifies selected Shipment Filters on Create Route Groups page:$")
  public void operatorVerifiesSelectedShipmentFilters(Map<String, String> data) {
    Map<String, String> finalData = resolveKeyValues(data);

    SoftAssertions assertions = new SoftAssertions();

    createRouteGroupsPage.inFrame(page -> {
      if (finalData.containsKey("shipmentDateFrom") || finalData.containsKey("shipmentDateTo")) {
        if (!createRouteGroupsPage.shipmentFiltersForm.shipmentDateFilter.isDisplayedFast()) {
          assertions.fail("Start Datetime is not displayed");
        } else {
          if (finalData.containsKey("shipmentDateFrom")) {
            assertions.assertThat(toDateTime(
                    createRouteGroupsPage.shipmentFiltersForm.shipmentDateFilter.fromInput.getValue()))
                .as("Shipment Date from").isEqualTo(toDateTime(finalData.get("shipmentDateFrom")));
          }
          if (finalData.containsKey("shipmentDateTo")) {
            assertions.assertThat(toDateTime(
                    createRouteGroupsPage.shipmentFiltersForm.shipmentDateFilter.toInput.getValue()))
                .as("Shipment Date to").isEqualTo(toDateTime(finalData.get("shipmentDateTo")));
          }
        }
      }

      if (finalData.containsKey("etaDateTimeFrom") || finalData.containsKey("etaDateTimeTo")) {
        if (!createRouteGroupsPage.shipmentFiltersForm.etaDateTimeFilter.isDisplayedFast()) {
          assertions.fail("ETA (Date Time) is not displayed");
        } else {
          if (finalData.containsKey("etaDateTimeFrom")) {
            assertions.assertThat(toDateTime(
                    createRouteGroupsPage.shipmentFiltersForm.etaDateTimeFilter.fromInput.getValue()))
                .as("ETA (Date Time) from").isEqualTo(toDateTime(finalData.get("etaDateTimeFrom")));
          }
          if (finalData.containsKey("etaDateTimeTo")) {
            assertions.assertThat(toDateTime(
                    createRouteGroupsPage.shipmentFiltersForm.etaDateTimeFilter.toInput.getValue()))
                .as("ETA (Date Time) to").isEqualTo(toDateTime(finalData.get("etaDateTimeTo")));
          }
        }
      }

      if (finalData.containsKey("shipmentCompletionDateTimeFrom") || finalData.containsKey(
          "shipmentCompletionDateTimeTo")) {
        if (!createRouteGroupsPage.shipmentFiltersForm.shipmentCompletionDateTimeFilter.isDisplayedFast()) {
          assertions.fail("Shipment Completion Date Time is not displayed");
        } else {
          if (finalData.containsKey("shipmentCompletionDateTimeFrom")) {
            assertions.assertThat(toDateTime(
                    createRouteGroupsPage.shipmentFiltersForm.shipmentCompletionDateTimeFilter.fromInput.getValue()))
                .as("Shipment Completion Date Time from")
                .isEqualTo(toDateTime(finalData.get("shipmentCompletionDateTimeFrom")));
          }
          if (finalData.containsKey("shipmentCompletionDateTimeTo")) {
            assertions.assertThat(toDateTime(
                    createRouteGroupsPage.shipmentFiltersForm.shipmentCompletionDateTimeFilter.toInput.getValue()))
                .as("Shipment Completion Date Time to")
                .isEqualTo(toDateTime(finalData.get("shipmentCompletionDateTimeTo")));
          }
        }
      }

      if (finalData.containsKey("transitDateTimeFrom") || finalData.containsKey(
          "transitDateTimeTo")) {
        if (!createRouteGroupsPage.shipmentFiltersForm.transitDateTimeFilter.isDisplayedFast()) {
          assertions.fail("Transit Date Time is not displayed");
        } else {
          if (finalData.containsKey("transitDateTimeFrom")) {
            assertions.assertThat(toDateTime(
                    createRouteGroupsPage.shipmentFiltersForm.transitDateTimeFilter.fromInput.getValue()))
                .as("Transit Date Time from")
                .isEqualTo(toDateTime(finalData.get("transitDateTimeFrom")));
          }
          if (finalData.containsKey("transitDateTimeTo")) {
            assertions.assertThat(toDateTime(
                    createRouteGroupsPage.shipmentFiltersForm.transitDateTimeFilter.toInput.getValue()))
                .as("Transit Date Time to")
                .isEqualTo(toDateTime(finalData.get("transitDateTimeTo")));
          }
        }
      }

      if (finalData.containsKey("startHub")) {
        if (!createRouteGroupsPage.shipmentFiltersForm.startHubFilter.isDisplayedFast()) {
          assertions.fail("Start Hub is not displayed");
        } else {
          assertions.assertThat(
                  createRouteGroupsPage.shipmentFiltersForm.startHubFilter.getSelectedValues())
              .as("Start Hub")
              .containsExactlyInAnyOrderElementsOf(splitAndNormalize(finalData.get("startHub")));
        }
      }

      if (finalData.containsKey("endHub")) {
        if (!createRouteGroupsPage.shipmentFiltersForm.endHubFilter.isDisplayedFast()) {
          assertions.fail("End Hub is not displayed");
        } else {
          assertions.assertThat(
                  createRouteGroupsPage.shipmentFiltersForm.endHubFilter.getSelectedValues())
              .as("End Hub")
              .containsExactlyInAnyOrderElementsOf(splitAndNormalize(finalData.get("endHub")));
        }
      }

      if (finalData.containsKey("lastInboundHub")) {
        if (!createRouteGroupsPage.shipmentFiltersForm.lastInboundHubFilter.isDisplayedFast()) {
          assertions.fail("Last Inbound Hub is not displayed");
        } else {
          assertions.assertThat(
                  createRouteGroupsPage.shipmentFiltersForm.lastInboundHubFilter.getSelectedValues())
              .as("Last Inbound Hub").containsExactlyInAnyOrderElementsOf(
                  splitAndNormalize(finalData.get("lastInboundHub")));
        }
      }

      if (finalData.containsKey("mawb")) {
        if (!createRouteGroupsPage.shipmentFiltersForm.mawbFilter.isDisplayedFast()) {
          assertions.fail("MAWB is not displayed");
        } else {
          assertions.assertThat(createRouteGroupsPage.shipmentFiltersForm.mawbFilter.getValue())
              .as("MAWB").isEqualToIgnoringCase(finalData.get("mawb"));
        }
      }

      if (finalData.containsKey("shipmentStatus")) {
        if (!createRouteGroupsPage.shipmentFiltersForm.shipmentStatusFilter.isDisplayedFast()) {
          assertions.fail("Shipment Status is not displayed");
        } else {
          assertions.assertThat(
                  createRouteGroupsPage.shipmentFiltersForm.shipmentStatusFilter.getSelectedValues())
              .as("Shipment Status").containsExactlyInAnyOrderElementsOf(
                  splitAndNormalize(finalData.get("shipmentStatus")));
        }
      }

      if (finalData.containsKey("shipmentType")) {
        if (!createRouteGroupsPage.shipmentFiltersForm.shipmentTypeFilter.isDisplayedFast()) {
          assertions.fail("Shipment Type is not displayed");
        } else {
          assertions.assertThat(
                  createRouteGroupsPage.shipmentFiltersForm.shipmentTypeFilter.getSelectedValues())
              .as("Shipment Type").containsExactlyInAnyOrderElementsOf(
                  splitAndNormalize(finalData.get("shipmentType")));
        }
      }
    });

    assertions.assertAll();
  }

  @Given("^Operator click Edit Filters & Sort on Create Route Groups page$")
  public void operatorClickEditFilter() {
    createRouteGroupsPage.inFrame(page -> page.editFilter.click());
  }

  @Given("^Operator click Load Selection on Create Route Groups page$")
  public void operatorClickLoadSelectionOnCreateRouteGroupPage() {
    createRouteGroupsPage.inFrame(page -> {
      page.loadSelection.click();
      page.waitUntilLoaded(5, 120);
      pause2s();
    });
  }

  @Given("^Operator sort Transactions/Reservations table by Tracking ID on Create Route Groups page$")
  public void operatorSortTableOnCreateRouteGroupPage() {
    createRouteGroupsPage.inFrame(page -> page.txnRsvnTable.sortColumn(COLUMN_TRACKING_ID, true));
  }

  @Given("^Operator save records from Transactions/Reservations table on Create Route Groups page$")
  public void operatorSaveTableOnCreateRouteGroupPage() {
    createRouteGroupsPage.inFrame(page -> {
      List<TxnRsvn> records = page.txnRsvnTable.readFirstEntities(3);
      put(LIST_OF_TXN_RSVN, records);
    });
  }

  @Given("^Operator download CSV file on Create Route Groups page$")
  public void operatorDownloadCsvFileOnCreateRouteGroupPage() {
    createRouteGroupsPage.inFrame(page -> {
      page.downloadCsvFile.click();
      page.verifyFileDownloadedSuccessfully(CSV_FILE_NAME);
    });
  }

  @Given("^Operator verify Transactions/Reservations CSV file on Create Route Groups page$")
  public void operatorVerifyCsvFile() {
    List<TxnRsvn> expected = get(LIST_OF_TXN_RSVN);
    String fileName = createRouteGroupsPage.getLatestDownloadedFilename(CSV_FILE_NAME);
    String pathName = StandardTestConstants.TEMP_DIR + fileName;
    List<TxnRsvn> actual = DataEntity.fromCsvFile(TxnRsvn.class, pathName, true);
    Assertions.assertThat(actual).as("Records in " + CSV_FILE_NAME)
        .hasSizeGreaterThanOrEqualTo(expected.size());

    for (TxnRsvn txnRsvn : expected) {
      DataEntity.assertListContains(actual, txnRsvn, "Transactions/Reservations records");
    }
  }

  @Then("^Operator verifies Transaction record on Create Route Groups page using data below:$")
  public void operatorVerifyTransactionReservationRecordOnCreateRouteGroupPageUsingDataBelow(
      Map<String, String> data) {
    operatorVerifyTransactionRecordOnCreateRouteGroupPageUsingDataBelow(ImmutableList.of(data));
  }

  @Then("^Operator verifies Transaction records on Create Route Groups page using data below:$")
  public void operatorVerifyTransactionRecordOnCreateRouteGroupPageUsingDataBelow(
      List<Map<String, String>> data) {
    createRouteGroupsPage.inFrame(page -> data.forEach(entry -> {
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
              .filter(txn -> StringUtils.equalsIgnoreCase(type, txn.getType())).findFirst()
              .orElseThrow(() -> new RuntimeException(
                  f("Order [%s] doesn't have %s transactions", order.getTrackingId(), type)));
          expected.setId(transaction.getId());
        } else if (StringUtils.isNumeric(id)) {
          expected.setId(id);
        }
      }

      page.txnRsvnTable.filterByColumn(COLUMN_TRACKING_ID, expected.getTrackingId());
      page.txnRsvnTable.filterByColumn(COLUMN_TYPE, expected.getType());
      pause1s();
      List<TxnRsvn> actual = page.txnRsvnTable.readAllEntities();
      Assertions.assertThat(actual).as("List of found transactions").isNotEmpty();
      DataEntity.assertListContains(actual, expected, "List of found transactions");
    }));
  }

  @Then("^Operator verifies Transaction records not shown on Create Route Groups page using data below:$")
  public void operatorVerifyTransactionRecordNotShownOnCreateRouteGroupPageUsingDataBelow(
      List<Map<String, String>> data) {
    createRouteGroupsPage.inFrame(page -> {
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
                .filter(txn -> StringUtils.equalsIgnoreCase(type, txn.getType())).findFirst()
                .orElseThrow(() -> new RuntimeException(
                    f("Order [%s] doesn't have %s transactions", order.getTrackingId(), type)));
            expected.setId(transaction.getId());
          } else if (StringUtils.isNumeric(id)) {
            expected.setId(id);
          }
        }

        page.txnRsvnTable.clearColumnFilter(COLUMN_ID);
        page.txnRsvnTable.filterByColumn(COLUMN_TRACKING_ID,
            expected.getTrackingId());
        page.txnRsvnTable.filterByColumn(COLUMN_TYPE, expected.getType());
        Assertions.assertThat(page.txnRsvnTable.isEmpty())
            .as("List of found transactions is empty").isTrue();
      });
    });
  }

  @Then("^Operator verifies results table is empty on Create Route Groups$")
  public void operatorVerifyTransactionsTableIsEmpty() {
    createRouteGroupsPage.inFrame(page -> {
      Assertions.assertThat(page.txnRsvnTable.isEmpty())
          .as("Results table is empty").isTrue();
    });
  }

  @Then("^Operator verifies Reservation records on Create Route Groups page using data below:$")
  public void operatorVerifyReservationRecordOnCreateRouteGroupPageUsingDataBelow(
      List<Map<String, String>> data) {
    final List<Map<String, String>> resolvedData = resolveListOfMaps(data);
    createRouteGroupsPage.inFrame(page -> resolvedData.forEach(entry -> {
      TxnRsvn expected = new TxnRsvn(entry);

      if (expected.getId() == null) {
        throw new IllegalArgumentException("id value was not defined");
      }

      page.txnRsvnTable.filterByColumn(COLUMN_ID, expected.getId());
      pause1s();
      Assertions.assertThat(page.txnRsvnTable.getRowsCount())
          .as(f("Number of records for id = %s", expected.getId())).isEqualTo(1);
      TxnRsvn actual = page.txnRsvnTable.readEntity(1);
      expected.compareWithActual(actual);
    }));
  }

  @Then("^Operator verifies Reservation records not shown on Create Route Groups page using data below:$")
  public void operatorVerifyReservationRecordsNotShownOnCreateRouteGroupPageUsingDataBelow(
      List<Map<String, String>> data) {
    createRouteGroupsPage.inFrame(page -> data.forEach(entry -> {
      TxnRsvn expected = new TxnRsvn(resolveKeyValues(entry));

      if (expected.getId() == null) {
        throw new IllegalArgumentException("id value was not defined");
      }

      page.txnRsvnTable.clearColumnFilter(COLUMN_TRACKING_ID);
      page.txnRsvnTable.clearColumnFilter(COLUMN_TYPE);
      page.txnRsvnTable.filterByColumn(COLUMN_ID, expected.getId());
      Assertions.assertThat(page.txnRsvnTable.getRowsCount())
          .as(f("Number of records for id = %s", expected.getId())).isEqualTo(0);
    }));
  }

  @When("Operator selects {string} preset action on Create Route Groups page")
  public void selectPresetAction(String action) {
    createRouteGroupsPage.inFrame(page -> page.presetActions.selectOption(resolveValue(action)));
  }

  @When("Operator selects {string} shipments preset action on Create Route Groups page")
  public void selectShippersPresetAction(String action) {
    createRouteGroupsPage.shipmentFiltersForm.includeShipments.check();
    createRouteGroupsPage.shippersPresetActions.selectOption(resolveValue(action));
  }

  @When("Operator verifies Save Preset dialog on Create Route Groups page contains filters:")
  public void verifySelectedFiltersForPreset(List<String> expected) {
    createRouteGroupsPage.inFrame(page -> {
      page.savePresetDialog.waitUntilVisible();
      List<String> actual = page.savePresetDialog.selectedFilters.stream()
          .map(PageElement::getNormalizedText).collect(Collectors.toList());
      Assertions.assertThat(actual).as("List of selected filters")
          .containsExactlyInAnyOrderElementsOf(expected);
    });
  }

  @When("Operator verifies Preset Name field in Save Preset dialog on Create Route Groups page is required")
  public void verifyPresetNameIsRequired() {
    createRouteGroupsPage.savePresetDialog.waitUntilVisible();
    Assertions.assertThat(
            createRouteGroupsPage.savePresetDialog.presetName.getAttribute("ng-required"))
        .as("Preset Name field ng-required attribute").isEqualTo("required");
  }

  @When("Operator verifies help text {string} is displayed in Save Preset dialog on Create Route Groups page")
  public void verifyHelpTextInSavePreset(String expected) {
    createRouteGroupsPage.inFrame(page -> {
      page.savePresetDialog.waitUntilVisible();
      Assertions.assertThat(page.savePresetDialog.helpText.getNormalizedText()).as("Help Text")
          .isEqualTo(resolveValue(expected));
    });
  }

  @When("Operator verifies Cancel button in Save Preset dialog on Create Route Groups page is enabled")
  public void verifyCancelIsEnabled() {
    createRouteGroupsPage.inFrame(page -> {
      page.savePresetDialog.waitUntilVisible();
      Assertions.assertThat(page.savePresetDialog.cancel.isEnabled()).as("Cancel button is enabled")
          .isTrue();
    });
  }

  @When("Operator verifies Save button in Save Preset dialog on Create Route Groups page is enabled")
  public void verifySaveIsEnabled() {
    createRouteGroupsPage.inFrame(page -> {
      page.savePresetDialog.waitUntilVisible();
      Assertions.assertThat(page.savePresetDialog.save.isEnabled()).as("Save button is enabled")
          .isTrue();
    });
  }

  @When("Operator clicks Save button in Save Preset dialog on Create Route Groups page")
  public void clickSaveInSavePresetDialog() {
    createRouteGroupsPage.inFrame(page -> page.savePresetDialog.save.click());
  }

  @When("Operator clicks Update button in Save Preset dialog on Create Route Groups page")
  public void clickUpdateInSavePresetDialog() {
    createRouteGroupsPage.inFrame(page -> page.savePresetDialog.update.click());
  }

  @When("Operator verifies Save button in Save Preset dialog on Create Route Groups page is disabled")
  public void verifySaveIsDisabled() {
    createRouteGroupsPage.inFrame(page -> {
      page.savePresetDialog.waitUntilVisible();
      Assertions.assertThat(page.savePresetDialog.save.isEnabled()).as("Save button is enabled")
          .isFalse();
    });
  }

  @When("Operator verifies Cancel button in Delete Preset dialog on Create Route Groups page is enabled")
  public void verifyCancelIsEnabledInDeletePreset() {
    createRouteGroupsPage.inFrame(page -> {
      page.deletePresetDialog.waitUntilVisible();
      Assertions.assertThat(page.deletePresetDialog.cancel.isEnabled())
          .as("Cancel button is enabled").isTrue();
    });
  }

  @When("Operator verifies Delete button in Delete Preset dialog on Create Route Groups page is enabled")
  public void verifyDeleteIsEnabled() {
    createRouteGroupsPage.inFrame(page -> {
      page.deletePresetDialog.waitUntilVisible();
      Assertions.assertThat(page.deletePresetDialog.delete.isEnabled())
          .as("Delete button is enabled").isTrue();
    });
  }

  @When("Operator selects {string} preset in Delete Preset dialog on Create Route Groups page")
  public void selectPresetInDeletePresets(String value) {
    createRouteGroupsPage.inFrame(page -> {
      page.deletePresetDialog.waitUntilVisible();
      page.deletePresetDialog.preset.selectValue(resolveValue(value));
    });
  }

  @When("Operator verifies {value} preset is selected in Delete Preset dialog on Create Route Groups page")
  public void verifySelectedPreset(String value) {
    createRouteGroupsPage.inFrame(page -> {
      page.deletePresetDialog.waitUntilVisible();
      Assertions.assertThat(page.deletePresetDialog.preset.getValue()).as("Selected preset")
          .isEqualTo(value);
    });
  }

  @When("Operator clicks Delete button in Delete Preset dialog on Create Route Groups page")
  public void clickDeleteInDeletePresetDialog() {
    createRouteGroupsPage.inFrame(page -> page.deletePresetDialog.delete.click());
  }

  @When("Operator verifies Delete button in Delete Preset dialog on Create Route Groups page is disabled")
  public void verifyDeleteIsDisabled() {
    createRouteGroupsPage.inFrame(page -> {
      page.deletePresetDialog.waitUntilVisible();
      Assertions.assertThat(page.deletePresetDialog.delete.isEnabled())
          .as("Delete button is enabled").isFalse();
    });
  }

  @When("Operator verifies {string} message is displayed in Delete Preset dialog on Create Route Groups page")
  public void verifyMessageInDeletePreset(String expected) {
    createRouteGroupsPage.inFrame(page -> {
      page.deletePresetDialog.waitUntilVisible();
      Assertions.assertThat(page.deletePresetDialog.message.getNormalizedText())
          .as("Delete Preset message").isEqualTo(resolveValue(expected));
    });
  }

  @When("Operator enters {string} Preset Name in Save Preset dialog on Create Route Groups page")
  public void enterPresetNameIsRequired(String presetName) {
    createRouteGroupsPage.inFrame(page -> {
      page.savePresetDialog.waitUntilVisible();
      String value = resolveValue(presetName);
      page.savePresetDialog.presetName.setValue(value);
      put(KEY_CREATE_ROUTE_GROUPS_FILTERS_PRESET_NAME, value);
    });
  }

  @When("Operator verifies Preset Name field in Save Preset dialog on Create Route Groups page has green checkmark on it")
  public void verifyPresetNameIsValidated() {
    Assertions.assertThat(createRouteGroupsPage.savePresetDialog.confirmedIcon.isDisplayed())
        .as("Preset Name checkmark").isTrue();
  }

  @When("Operator verifies selected Filter Preset name is {string} on Create Route Groups page")
  public void verifySelectedPresetName(String expected) {
    createRouteGroupsPage.inFrame(page -> {
      String exp = resolveValue(expected);
      String actual = StringUtils.trim(page.filterPreset.getValue());
      Pattern p = Pattern.compile("(\\d+)\\s-\\s(.+)");
      Matcher m = p.matcher(actual);
      Assertions.assertThat(m.matches()).as("Selected Filter Preset value matches to pattern")
          .isTrue();
      Long presetId = Long.valueOf(m.group(1));
      String presetName = m.group(2);
      Assertions.assertThat(presetName).as("Preset Name").isEqualTo(exp);
      put(KEY_CREATE_ROUTE_GROUPS_FILTERS_PRESET_ID, presetId);
    });
  }

  @When("Operator verifies selected shippers Filter Preset name is {string} on Create Route Groups page")
  public void verifySelectedShippersPresetName(String expected) {
    expected = resolveValue(expected);
    String actual = StringUtils.trim(createRouteGroupsPage.shippersFilterPreset.getValue());
    Pattern p = Pattern.compile("(\\d+)\\s-\\s(.+)");
    Matcher m = p.matcher(actual);
    Assertions.assertThat(m.matches())
        .as("Selected Shippers Filter Preset value matches to pattern").isTrue();
    Long presetId = Long.valueOf(m.group(1));
    String presetName = m.group(2);
    Assertions.assertThat(presetName).as("Preset Name").isEqualTo(expected);
    put(KEY_SHIPMENTS_FILTERS_PRESET_ID, presetId);
  }

  @When("Operator selects {value} Filter Preset on Create Route Groups page")
  public void selectPresetName(String value) {
    createRouteGroupsPage.inFrame(page -> {
      page.waitUntilLoaded(3);
      page.filterPreset.selectValue(value);
      page.waitUntilLoaded(3, 40);
      pause1s();
    });
  }

  @When("Operator selects {string} shipments Filter Preset on Create Route Groups page")
  public void selectShippersPresetName(String value) {
    createRouteGroupsPage.shipmentFiltersForm.includeShipments.check();
    createRouteGroupsPage.shippersFilterPreset.searchAndSelectValue(resolveValue(value));
    if (createRouteGroupsPage.halfCircleSpinner.waitUntilVisible(3)) {
      createRouteGroupsPage.halfCircleSpinner.waitUntilInvisible();
    }
    pause1s();
  }

}
