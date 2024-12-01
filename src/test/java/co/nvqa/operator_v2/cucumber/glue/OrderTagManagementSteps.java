package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.common.core.model.order.Order;
import co.nvqa.common.utils.StandardTestUtils;
import co.nvqa.operator_v2.model.TaggedOrderParams;
import co.nvqa.operator_v2.selenium.page.OrderTagManagementPage;
import io.cucumber.guice.ScenarioScoped;
import io.cucumber.java.en.And;
import io.cucumber.java.en.When;
import java.io.File;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.stream.Collectors;
import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang3.StringUtils;
import org.assertj.core.api.Assertions;

/**
 * @author Niko Susanto
 */
@ScenarioScoped
public class OrderTagManagementSteps extends AbstractSteps {

  private OrderTagManagementPage orderTagManagementPage;

  public OrderTagManagementSteps() {
  }

  @Override
  public void init() {
    orderTagManagementPage = new OrderTagManagementPage(getWebDriver());
  }

  @When("Operator selects filter and clicks Load Selection on Add Tags to Order page using data below:")
  public void operatorSelectsFilterAndClicksLoadSelectionOnAddTagsToOrderPageUsingDataBelow(
      Map<String, String> data) {
    data = resolveKeyValues(data);

    orderTagManagementPage.loadSelection.waitUntilVisible();

    if (data.containsKey("orderTags")) {
      List<String> tags = splitAndNormalize(data.get("orderTags"));
      orderTagManagementPage.orderTagsFilter.clearAll();
      orderTagManagementPage.orderTagsFilter.selectFilter(tags);
    }

    if (data.containsKey("shipperName")) {
      if (!orderTagManagementPage.shipperFilter.isDisplayedFast()) {
        orderTagManagementPage.addFilter("Shipper");
      }
      orderTagManagementPage.shipperFilter.clearAll();
      orderTagManagementPage.shipperFilter.selectFilter(data.get("shipperName"));
    } else {
      if (orderTagManagementPage.shipperFilter.isDisplayedFast()) {
        orderTagManagementPage.shipperFilter.clearAll();
      }
    }

    if (data.containsKey("status")) {
      if (!orderTagManagementPage.statusFilter.isDisplayedFast()) {
        orderTagManagementPage.addFilter("Status");
      }
      orderTagManagementPage.statusFilter.clearAll();
      orderTagManagementPage.statusFilter.selectFilter(data.get("status"));
    } else {
      if (orderTagManagementPage.statusFilter.isDisplayedFast()) {
        orderTagManagementPage.statusFilter.clearAll();
      }
    }

    if (data.containsKey("granularStatus")) {
      if (!orderTagManagementPage.granularStatusFilter.isDisplayedFast()) {
        orderTagManagementPage.addFilter("Granular Status");
      }
      orderTagManagementPage.granularStatusFilter.clearAll();
      orderTagManagementPage.granularStatusFilter.selectFilter(data.get("granularStatus"));
    } else {
      if (orderTagManagementPage.granularStatusFilter.isDisplayedFast()) {
        orderTagManagementPage.granularStatusFilter.clearAll();
      }
    }

    if (data.containsKey("orderType")) {
      if (!orderTagManagementPage.orderTypeFilter.isDisplayedFast()) {
        orderTagManagementPage.addFilter("Order Type");
      }
      orderTagManagementPage.orderTypeFilter.clearAll();
      orderTagManagementPage.orderTypeFilter.selectFilter(data.get("orderType"));
    } else {
      if (orderTagManagementPage.orderTypeFilter.isDisplayedFast()) {
        orderTagManagementPage.orderTypeFilter.clearAll();
      }
    }

    if (data.containsKey("rts")) {
      if (!orderTagManagementPage.rtsFilter.isDisplayedFast()) {
        orderTagManagementPage.addFilter("RTS");
      }
      orderTagManagementPage.rtsFilter.setFilter(data.get("rts"));
    } else {
      if (orderTagManagementPage.rtsFilter.isDisplayedFast()) {
        orderTagManagementPage.rtsFilter.removeFilter();
      }
    }

    if (data.containsKey("masterShipperName")) {
      if (!orderTagManagementPage.masterShipperFilter.isDisplayedFast()) {
        orderTagManagementPage.addFilter("Master Shipper");
      }
      orderTagManagementPage.masterShipperFilter.clearAll();
      orderTagManagementPage.masterShipperFilter.waitUntilLoaded();
      orderTagManagementPage.masterShipperFilter.selectFilter(data.get("masterShipperName"));
    } else {
      if (orderTagManagementPage.masterShipperFilter.isDisplayedFast()) {
        orderTagManagementPage.masterShipperFilter.clearAll();
      }
    }

    orderTagManagementPage.loadSelection.click();
    orderTagManagementPage.waitWhilePageIsLoading();
  }

  @And("Operator searches and selects orders created on Order Tag Management page:")
  public void operatorSearchesAndSelectsOrdersCreatedOnAddTagsToOrderPage(
      List<String> trackingIds) {
    List<String> listOfTrackingIds = resolveValues(trackingIds);
    listOfTrackingIds.forEach(trackingId -> {
      orderTagManagementPage.ordersTable.filterByColumn("trackingId", trackingId);
      if (orderTagManagementPage.ordersTable.getRowsCount() == 0) {
        orderTagManagementPage.loadingBar.waitUntilInvisible(60);
      }
      orderTagManagementPage.ordersTable.selectRow(1);
    });
  }

  @And("Operator searches and selects orders created first row on Add Tags to Order page")
  public void operatorSearchesAndSelectsOrdersCreatedFirstRowOnAddTagsToOrderPage(
      List<String> trackingIds) {
    List<String> listOfTrackingIds = resolveValues(trackingIds);
    listOfTrackingIds.forEach(trackingId ->
    {
      orderTagManagementPage.ordersTable.filterByColumn("trackingId", trackingId);
      orderTagManagementPage.ordersTable.selectFirstRowCheckBox();
    });
  }

  @And("Operator tags order with:")
  public void operatorTagsOrderWith(List<String> orderTag) {
    orderTagManagementPage.addTag(resolveValues(orderTag));
  }

  @And("Operator removes order tags on Order Tag Management page:")
  public void operatorRemoveOrderTags(List<String> orderTags) {
    orderTags = resolveValues(orderTags);
    orderTagManagementPage.actionsMenu.selectOption("Remove Tags");
    orderTagManagementPage.removeTagsDialog.remove.waitUntilVisible();
    while (orderTagManagementPage.removeTagsDialog.removeTag.isDisplayedFast()) {
      orderTagManagementPage.removeTagsDialog.removeTag.click();
    }
    for (String tag : orderTags) {
      orderTagManagementPage.removeTagsDialog.selectTag.selectValue(tag);
    }
    orderTagManagementPage.removeTagsDialog.remove.click();
    orderTagManagementPage.removeTagsDialog.waitUntilInvisible();
  }

  @And("Operator clear all order tags on Order Tag Management page")
  public void operatorClearAllTags() {
    orderTagManagementPage.actionsMenu.selectOption("Clear All Tags");
    orderTagManagementPage.clearAllTagsDialog.waitUntilClickable();
    Assertions.assertThat(orderTagManagementPage.clearAllTagsDialog.message.getText())
        .as("Clear All Tags dialog message")
        .isEqualTo("All existing tags for these orders will be removed.");
    orderTagManagementPage.clearAllTagsDialog.removeAll.click();
    orderTagManagementPage.clearAllTagsDialog.waitUntilInvisible();
  }

  @And("Operator verifies selected value of RTS filter is {string} on Order Tag Management page")
  public void operatorVerifyRtsFilter(String expected) {
    expected = resolveValue(expected);
    Assertions.assertThat(orderTagManagementPage.rtsFilter.isDisplayed())
        .as("RTS filter is displayed").isTrue();
    Assertions.assertThat(orderTagManagementPage.rtsFilter.getValue()).as("RTS filter value")
        .isEqualTo(expected);
  }

  @And("Operator clicks 'Clear All Selection' button on Order Tag Management page")
  public void operatorClicksClearAllSelection() {
    orderTagManagementPage.clearAllSelection.click();
  }

  @And("Operator verifies orders are not displayed on Order Tag Management page:")
  public void operatorVerifyOrdersAreNotDisplayed(List<String> trackingIds) {
    trackingIds = resolveValues(trackingIds);
    trackingIds.forEach(trackingId ->
    {
      orderTagManagementPage.ordersTable.filterByColumn("trackingId", trackingId);
      orderTagManagementPage.loadingBar.waitUntilInvisible(60);
      Assertions.assertThat(orderTagManagementPage.ordersTable.isEmpty())
          .as(f("Order %s must not be displayed", trackingId)).isTrue();
    });
  }

  @And("Operator opens 'View Tagged Orders' tab on Order Tag Management page:")
  public void operatorOpenViewTaggedOrdersTab() {
    orderTagManagementPage.viewTaggedOrders.click();
  }

  @And("Operator verifies that 'Load Selection' button is (enabled|disabled) on Order Tag Management page")
  public void operatorVerifyLoadSelection(String state) {
    Assertions.assertThat(orderTagManagementPage.loadSelection.isEnabled())
        .as("Load selection button enable state")
        .isEqualTo(StringUtils.equalsIgnoreCase(state, "enabled"));
  }

  @And("Operator verifies order params on Order Tag Management page:")
  public void operatorVerifyOrderParams(Map<String, String> data) {
    data = resolveKeyValues(data);
    Order expected = new Order();
    expected.fromMap(data);
    orderTagManagementPage.ordersTable.filterByColumn("trackingId", expected.getTrackingId());
    Order actual = orderTagManagementPage.ordersTable.readEntity(1);
    expected.compareWithActual(actual);
  }

  @And("Operator verifies tagged order params on Order Tag Management page:")
  public void operatorVerifytaggedOrderParams(Map<String, String> data) {
    data = resolveKeyValues(data);
    TaggedOrderParams expected = new TaggedOrderParams(data);
    orderTagManagementPage.taggedOrdersTable.filterByColumn("trackingId", expected.getTrackingId());
    TaggedOrderParams actual = orderTagManagementPage.taggedOrdersTable.readEntity(1);
    expected.compareWithActual(actual);
  }

  @When("Operator find orders by uploading CSV on Order Tag Management page:")
  public void operatorFindOrdersByUploadingCsvOnAllOrderPage(List<String> listOfTrackingId) {
    if (CollectionUtils.isEmpty(listOfTrackingId)) {
      throw new IllegalArgumentException(
          "List of created Tracking ID should not be null or empty.");
    }
    String csvContents = resolveValues(listOfTrackingId).stream()
        .collect(Collectors.joining(System.lineSeparator(), "", System.lineSeparator()));
    File csvFile = orderTagManagementPage.createFile(
        String.format("find-orders-with-csv_%s.csv", StandardTestUtils.generateDateUniqueString()),
        csvContents);

    orderTagManagementPage.findOrdersWithCsv.click();
    orderTagManagementPage.findOrdersWithCsvDialog.waitUntilVisible();
    orderTagManagementPage.findOrdersWithCsvDialog.selectFile.setValue(csvFile);
    orderTagManagementPage.findOrdersWithCsvDialog.upload.clickAndWaitUntilDone();
  }

  @And("Operator selects orders created")
  public void operatorSelectsOrdersInTable() {
    orderTagManagementPage.selectOrdersInTable();
  }

  @When("Operator selects filter and clicks Load Selection on Order Level Tag Management page using data below:")
  public void operatorSelectsFilterAndClicksLoadSelectionOnorderTagManagementPageUsingDataBelow(
      Map<String, String> mapOfData) {
    if (Objects.nonNull(mapOfData.get("shipperName"))) {
      orderTagManagementPage.selectShipperValue(mapOfData.get("shipperName"));
    }

    if (Objects.nonNull(mapOfData.get("status"))) {
      orderTagManagementPage.selectUniqueStatusValue(mapOfData.get("status"));
    }

    if (Objects.nonNull(mapOfData.get("granularStatus"))) {
      orderTagManagementPage.selectUniqueGranularStatusValue(mapOfData.get("granularStatus"));
    }

    if (Objects.nonNull(mapOfData.get("masterShipper"))) {
      orderTagManagementPage.selectMasterShipperValue(mapOfData.get("masterShipper"));
    }

    orderTagManagementPage.clickLoadSelectionButton();
  }
}
