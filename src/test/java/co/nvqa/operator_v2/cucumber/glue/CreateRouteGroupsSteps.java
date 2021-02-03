package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.model.DataEntity;
import co.nvqa.commons.model.core.Order;
import co.nvqa.commons.model.core.Transaction;
import co.nvqa.commons.util.StandardTestConstants;
import co.nvqa.operator_v2.model.TxnRsvn;
import co.nvqa.operator_v2.selenium.page.CreateRouteGroupsPage;
import com.google.common.collect.ImmutableList;
import cucumber.api.java.en.Given;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import cucumber.runtime.java.guice.ScenarioScoped;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import org.apache.commons.lang3.StringUtils;

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
    String routeGroupName = get(KEY_ROUTE_GROUP_NAME);

    createRouteGroupsPage.removeFilter("Start Datetime");
    createRouteGroupsPage.removeFilter("End Datetime");
    createRouteGroupsPage.setCreationTimeFilter();
    createRouteGroupsPage.loadSelection.clickAndWaitUntilDone();
    createRouteGroupsPage.searchByTrackingId(expectedTrackingId);
    createRouteGroupsPage.txnRsvnTable.selectAllShown();
    createRouteGroupsPage.addToRouteGroup.click();
    createRouteGroupsPage.selectRouteGroupOnAddToRouteGroupDialog(routeGroupName);
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
    put(KEY_ROUTE_GROUP_NAME, groupName);
    putInList(KEY_LIST_OF_ROUTE_GROUP_NAMES, groupName);
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
    put(KEY_ROUTE_GROUP_NAME, groupName);
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

  @Given("^Operator add following filters on Transactions Filters section on Create Route Group page:$")
  public void operatorAddFollowingFiltersOnTransactionsFiltersSectionOnCreateRouteGroupPage(
      Map<String, String> data) {
    data = resolveKeyValues(data);
    String value = data.get("rts");
    if (StringUtils.isNotBlank(value)) {
      if (!createRouteGroupsPage.transactionsFiltersForm.rtsFilter.isDisplayedFast()) {
        createRouteGroupsPage.transactionsFiltersForm.addFilter.selectValue("RTS");
      }
      createRouteGroupsPage.transactionsFiltersForm.rtsFilter
          .selectFilter(StringUtils.equalsIgnoreCase("Show", value));
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
  }

  @Given("^Operator add following filters on Reservation Filters section on Create Route Group page:$")
  public void operatorAddFollowingFiltersOnReservationFiltersSectionOnCreateRouteGroupPage(
      Map<String, String> data) {
    data = resolveKeyValues(data);
    String value = data.get("reservationType");
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

  @Given("^Operator add following filters on General Filters section on Create Route Group page:$")
  public void operatorAddFollowingFiltersOnGeneralFiltersSectionOnCreateRouteGroupPage(
      Map<String, String> mapOfData) {
    createRouteGroupsPage.addGeneralFilters(resolveKeyValues(mapOfData));
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
}
