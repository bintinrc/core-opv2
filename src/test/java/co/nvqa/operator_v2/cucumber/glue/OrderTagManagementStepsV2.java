package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.common.core.model.order.Order;
import co.nvqa.common.utils.StandardTestUtils;
import co.nvqa.operator_v2.model.TaggedOrderParams;
import co.nvqa.operator_v2.selenium.page.OrderTagManagementPageV2;
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

@ScenarioScoped
public class OrderTagManagementStepsV2 extends AbstractSteps {

  private OrderTagManagementPageV2 orderTagManagementPageV2;

  public OrderTagManagementStepsV2() {
  }

  @Override
  public void init() {
    orderTagManagementPageV2 = new OrderTagManagementPageV2(getWebDriver());
  }

  @When("Operator selects filter and clicks Load Selection on Add Tags to Order page V2 using data below:")
  public void operatorSelectsFilterAndClicksLoadSelectionOnAddTagsToOrderPageV2UsingDataBelow(
      Map<String, String> data) {
    orderTagManagementPageV2.inFrame((page) -> {
      Map<String, String> finalData = resolveKeyValues(data);

      page.loadSelection.waitUntilVisible();

      if (finalData.containsKey("shipperName")) {
        if (!page.shipperFilter.isDisplayedFast()) {
          page.addFilter("Shipper");
        }
        page.shipperFilter.clearValue();
        page.shipperFilter.selectValue(finalData.get("shipperName"));
      } else {
        if (page.shipperFilter.isDisplayedFast()) {
          page.shipperFilter.clearValue();
        }
      }

      if (finalData.containsKey("status")) {
        if (!page.statusFilter.isDisplayedFast()) {
          page.addFilter("Status");
        }
        page.statusFilter.clearValue();
        page.statusFilter.selectValue(finalData.get("status"));
      } else {
        if (page.statusFilter.isDisplayedFast()) {
          page.statusFilter.clearValue();
        }
      }

      if (finalData.containsKey("granularStatus")) {
        if (!page.granularStatusFilter.isDisplayedFast()) {
          page.addFilter("Granular Status");
        }
        page.granularStatusFilter.clearValue();
        page.granularStatusFilter.selectValue(finalData.get("granularStatus"));
      } else {
        if (page.granularStatusFilter.isDisplayedFast()) {
          page.granularStatusFilter.clearValue();
        }
      }

      if (finalData.containsKey("orderType")) {
        if (!page.orderTypeFilter.isDisplayedFast()) {
          page.addFilter("Order Type");
        }
        page.orderTypeFilter.clearValue();
        page.orderTypeFilter.selectValue(finalData.get("orderType"));
      } else {
        if (page.orderTypeFilter.isDisplayedFast()) {
          page.orderTypeFilter.clearValue();
        }
      }

      if (finalData.containsKey("rts")) {
        if (!page.rtsFilter.isDisplayedFast()) {
          page.addFilter("RTS");
        }
        if(finalData.containsValue("Show")) {
          page.rtsFilter.check();
        }
      } else {
        if (page.rtsFilter.isDisplayedFast()) {
          page.rtsFilter.uncheck();
        }
      }

      if (finalData.containsKey("masterShipperName")) {
        if (!page.masterShipperFilter.isDisplayedFast()) {
          page.addFilter("Master Shipper");
        }
        page.masterShipperFilter.clearValue();
        page.masterShipperFilter.waitUntilVisible();
        page.masterShipperFilter.selectValue(finalData.get("masterShipperName"));
      } else {
        if (page.masterShipperFilter.isDisplayedFast()) {
          page.masterShipperFilter.clearValue();
        }
      }

      page.loadSelection.click();
      page.waitWhilePageIsLoading();
    });
  }

  @And("Operator searches and selects orders created on Order Tag Management page V2:")
  public void operatorSearchesAndSelectsOrdersCreatedOnAddTagsToOrderPageV2(
      List<String> trackingIds) {
    orderTagManagementPageV2.inFrame((page) -> {
      List<String> listOfTrackingIds = resolveValues(trackingIds);
      pause3s();
      listOfTrackingIds.forEach(trackingId -> {
        page.ordersTable.filterByColumn("trackingId", trackingId);
        if (page.ordersTable.getRowsCount() == 0) {
          page.loadingBar.waitUntilInvisible(60);
        }
        page.ordersTable.selectRow(1);
      });
    });
  }

  @And("Operator searches and selects orders created first row on Add Tags to Order page V2")
  public void operatorSearchesAndSelectsOrdersCreatedFirstRowOnAddTagsToOrderPageV2(
      List<String> trackingIds) {
    List<String> listOfTrackingIds = resolveValues(trackingIds);
    listOfTrackingIds.forEach(trackingId ->
    {
      orderTagManagementPageV2.ordersTable.filterByColumn("trackingId", trackingId);
      orderTagManagementPageV2.ordersTable.selectFirstRowCheckBox();
    });
  }

  @And("Operator tags order V2 with:")
  public void operatorTagsOrderV2With(List<String> orderTag) {
    orderTagManagementPageV2.inFrame((page) -> {
      page.addTag(resolveValues(orderTag));
    });
  }

  @And("Operator removes order tags on Order Tag Management page V2:")
  public void operatorRemoveOrderTagsV2(List<String> orderTags) {
    orderTagManagementPageV2.inFrame((page) -> {
      List<String> listOfOrderTags = resolveValues(orderTags);
      page.actionsMenu.selectOption("Remove Tags");
      page.removeTagsModal.save.waitUntilVisible();
      while (page.removeTagsModal.removeTag.isDisplayedFast()) {
        page.removeTagsModal.removeTag.click();
      }
      for (String tag : listOfOrderTags) {
        page.removeTagsModal.selectTag.selectValue(tag);
      }
      page.removeTagsModal.save.click();
      page.removeTagsModal.waitUntilInvisible();
    });
  }

  @And("Operator clear all order tags on Order Tag Management page V2")
  public void operatorClearAllTagsV2() {
    orderTagManagementPageV2.inFrame((page) -> {
      page.actionsMenu.selectOption("Clear All Tags");
      page.clearAllTagsModal.waitUntilClickable();
      Assertions.assertThat(page.clearAllTagsModal.message.getText())
          .as("Clear All Tags dialog message")
          .isEqualTo("All existing tags for these orders will be removed");
      page.clearAllTagsModal.removeAll.click();
      page.clearAllTagsModal.waitUntilInvisible();
    });
  }

  @And("Operator verifies selected value of RTS filter is {string} on Order Tag Management page V2")
  public void operatorVerifyRtsFilterV2(String value) {
    orderTagManagementPageV2.inFrame((page) -> {
      String expected = resolveValue(value);
      Assertions.assertThat(page.rtsFilter.isDisplayed())
          .as("RTS filter is displayed").isTrue();
      Assertions.assertThat(page.rtsValue.getText()).as("RTS filter value")
          .isEqualTo(expected);
    });
  }

  @And("Operator clicks 'Clear All Selection' button on Order Tag Management page V2")
  public void operatorClicksClearAllSelectionV2() {
    orderTagManagementPageV2.inFrame((page) -> {
      page.clearAllSelection.click();
    });
  }

  @And("Operator verifies orders are not displayed on Order Tag Management page V2:")
  public void operatorVerifyOrdersAreNotDisplayedV2(List<String> trackingIds) {
    orderTagManagementPageV2.inFrame((page) -> {
    List<String> listOfTrackingIds = resolveValues(trackingIds);
    pause3s();
      listOfTrackingIds.forEach(trackingId ->
    {

      page.ordersTable.filterByColumnV2("trackingId", trackingId);
      page.loadingBar.waitUntilInvisible(60);
      Assertions.assertThat(page.ordersTable.isEmpty())
          .as(f("Order %s must not be displayed", trackingId)).isTrue();
    });
    });
  }

  @And("Operator opens 'View Tagged Orders' tab on Order Tag Management page V2:")
  public void operatorOpenViewTaggedOrdersTabV2() {
    orderTagManagementPageV2.viewTaggedOrders.click();
  }

  @And("Operator verifies that 'Load Selection' button is (enabled|disabled) on Order Tag Management page V2")
  public void operatorVerifyLoadSelectionV2(String state) {
    Assertions.assertThat(orderTagManagementPageV2.loadSelection.isEnabled())
        .as("Load selection button enable state")
        .isEqualTo(StringUtils.equalsIgnoreCase(state, "enabled"));
  }

  @And("Operator verifies order params on Order Tag Management page V2:")
  public void operatorVerifyOrderParamsV2(Map<String, String> data) {
    data = resolveKeyValues(data);
    Order expected = new Order();
    expected.fromMap(data);
    orderTagManagementPageV2.ordersTable.filterByColumn("trackingId", expected.getTrackingId());
    Order actual = orderTagManagementPageV2.ordersTable.readEntity(1);
    expected.compareWithActual(actual);
  }

  @And("Operator verifies tagged order params on Order Tag Management page V2:")
  public void operatorVerifytaggedOrderParamsV2(Map<String, String> data) {
    data = resolveKeyValues(data);
    TaggedOrderParams expected = new TaggedOrderParams(data);
    orderTagManagementPageV2.taggedOrdersTable.filterByColumn("trackingId", expected.getTrackingId());
    TaggedOrderParams actual = orderTagManagementPageV2.taggedOrdersTable.readEntity(1);
    expected.compareWithActual(actual);
  }

  @When("Operator find orders by uploading CSV on Order Tag Management page V2:")
  public void operatorFindOrdersByUploadingCsvOnAllOrderPageV2(List<String> listOfTrackingId) {
    if (CollectionUtils.isEmpty(listOfTrackingId)) {
      throw new IllegalArgumentException(
          "List of created Tracking ID should not be null or empty.");
    }
    String csvContents = resolveValues(listOfTrackingId).stream()
        .collect(Collectors.joining(System.lineSeparator(), "", System.lineSeparator()));
    File csvFile = orderTagManagementPageV2.createFile(
        String.format("find-orders-with-csv_%s.csv", StandardTestUtils.generateDateUniqueString()),
        csvContents);

    orderTagManagementPageV2.inFrame((page) -> {

      page.findOrdersWithCsv.click();
      page.findOrdersWithCsvModal.waitUntilVisible();
      page.findOrdersWithCsvModal.selectFile.setValue(csvFile);
      page.findOrdersWithCsvModal.upload.click();
    });
  }

  @And("Operator selects orders created V2")
  public void operatorSelectsOrdersInTableV2() {
    orderTagManagementPageV2.selectOrdersInTable();
  }

  @When("Operator selects filter and clicks Load Selection on Order Level Tag Management page V2 using data below:")
  public void operatorSelectsFilterAndClicksLoadSelectionOnorderTagManagementPageV2UsingDataBelow(
      Map<String, String> mapOfData) {
    if (Objects.nonNull(mapOfData.get("shipperName"))) {
      orderTagManagementPageV2.selectShipperValue(mapOfData.get("shipperName"));
    }

    if (Objects.nonNull(mapOfData.get("status"))) {
      orderTagManagementPageV2.selectUniqueStatusValue(mapOfData.get("status"));
    }

    if (Objects.nonNull(mapOfData.get("granularStatus"))) {
      orderTagManagementPageV2.selectUniqueGranularStatusValue(mapOfData.get("granularStatus"));
    }

    if (Objects.nonNull(mapOfData.get("masterShipper"))) {
      orderTagManagementPageV2.selectMasterShipperValue(mapOfData.get("masterShipper"));
    }

    orderTagManagementPageV2.clickLoadSelectionButton();
  }
}
