package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.cucumber.glue.AddressFactory;
import co.nvqa.commons.model.core.Address;
import co.nvqa.commons.model.core.Order;
import co.nvqa.commons.model.driver.FailureReason;
import co.nvqa.operator_v2.model.RtsDetails;
import co.nvqa.operator_v2.selenium.page.CommonParcelManagementPage;
import co.nvqa.operator_v2.selenium.page.FailedDeliveryManagementPage;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import io.cucumber.guice.ScenarioScoped;
import java.io.File;
import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;
import org.apache.commons.lang3.StringUtils;

/**
 * @author Daniel Joi Partogi Hutapea
 */
@ScenarioScoped
public class FailedDeliveryManagementSteps extends AbstractSteps {

  private FailedDeliveryManagementPage failedDeliveryManagementPage;

  public FailedDeliveryManagementSteps() {
  }

  @Override
  public void init() {
    failedDeliveryManagementPage = new FailedDeliveryManagementPage(getWebDriver());
  }

  @Then("^Operator verify the failed delivery order is listed on Failed Delivery orders list$")
  public void operatorVerifyTheFailedDeliveryOrderIsListedOnFailedDeliveryOrderList() {
    Order order = get(KEY_CREATED_ORDER);
    FailureReason selectedFailureReason = get(KEY_SELECTED_FAILURE_REASON);
    failedDeliveryManagementPage.verifyFailedDeliveryOrderIsListed(order, selectedFailureReason);
  }

  @Then("^Operator verifies the failed delivery order is listed and tagged on Failed Delivery orders list$")
  public void operatorVerifyTheFailedDeliveryOrderIsListedAndTaggedOnFailedDeliveryOrderList() {
    Order order = get(KEY_CREATED_ORDER);
    List<String> orderTag = Collections.singletonList(get(KEY_ORDER_TAG));
    FailureReason selectedFailureReason = get(KEY_SELECTED_FAILURE_REASON);
    failedDeliveryManagementPage.verifyFailedDeliveryOrderIsListed(order, selectedFailureReason);
    failedDeliveryManagementPage.verifyFailedDeliveryOrderIsTagged(order, orderTag);
  }

  @When("^Operator download CSV file of failed delivery order on Failed Delivery orders list$")
  public void operatorDownloadCsvFileOfFailedDeliveryOrderOnFailedDeliveryOrdersList() {
    String trackingId = get(KEY_CREATED_ORDER_TRACKING_ID);
    failedDeliveryManagementPage.waitWhilePageIsLoading();
    failedDeliveryManagementPage.downloadCsvFile(trackingId);
  }

  @Then("^Operator verify CSV file of failed delivery order on Failed Delivery orders list downloaded successfully$")
  public void operatorVerifyCsvFileOfFailedDeliveryOrderOnFailedDeliveryOrdersListDownloadedSuccessfully() {
    String trackingId = get(KEY_CREATED_ORDER_TRACKING_ID);
    failedDeliveryManagementPage.verifyCsvFileDownloadedSuccessfully(trackingId);
  }

  @When("^Operator reschedule failed delivery order on next day$")
  public void operatorRescheduleFailedDeliveryOrderOnNextDay() {
    String trackingId = get(KEY_CREATED_ORDER_TRACKING_ID);
    failedDeliveryManagementPage.waitWhilePageIsLoading();
    failedDeliveryManagementPage.rescheduleNextDay(trackingId);
  }

  @When("^Operator reschedule failed delivery orders using data below:$")
  public void operatorRescheduleFailedDeliveryOrders(Map<String, String> data) {
    data = resolveKeyValues(data);

    List<String> trackingIds = get(KEY_LIST_OF_CREATED_ORDER_TRACKING_ID);
    failedDeliveryManagementPage.waitWhilePageIsLoading();
    trackingIds.forEach(trackingId ->
    {
      failedDeliveryManagementPage.failedDeliveriesTable
          .filterByColumn(CommonParcelManagementPage.FailedDeliveriesTable.COLUMN_TRACKING_ID,
              trackingId);
      failedDeliveryManagementPage.failedDeliveriesTable.selectRow(1);
    });

    failedDeliveryManagementPage.actionsMenu.selectOption("Reschedule Selected");
    failedDeliveryManagementPage.rescheduleSelectedOrdersDialog.waitUntilVisible();
    failedDeliveryManagementPage.rescheduleSelectedOrdersDialog.date
        .simpleSetValue(data.get("date"));
    failedDeliveryManagementPage.rescheduleSelectedOrdersDialog.reschedule.click();
  }

  @When("^Operator reschedule failed delivery orders using CSV:$")
  public void operatorRescheduleFailedDeliveryOrdersUsingCsv(Map<String, String> data) {
    data = resolveKeyValues(data);
    String date = data.get("date");

    List<String> trackingIds = get(KEY_LIST_OF_CREATED_ORDER_TRACKING_ID);

    String csvContents = trackingIds.stream()
        .map(trackingId -> trackingId + "," + date)
        .collect(Collectors.joining(System.lineSeparator(), "", System.lineSeparator()));
    csvContents = "tracking_id,delivery_date" + System.lineSeparator() + csvContents;
    File csvFile = failedDeliveryManagementPage.createFile(
        String.format("csv_reschedule_%s.csv", generateDateUniqueString()), csvContents);

    failedDeliveryManagementPage.waitWhilePageIsLoading();
    failedDeliveryManagementPage.csvReschedule.click();
    failedDeliveryManagementPage.uploadCsvRescheduleDialog.waitUntilVisible();
    failedDeliveryManagementPage.uploadCsvRescheduleDialog.selectFile.setValue(csvFile);
    failedDeliveryManagementPage.uploadCsvRescheduleDialog.upload.clickAndWaitUntilDone();
  }

  @When("^csv-reschedule-result CSV file is successfully downloaded$")
  public void verifyCsvRescheduleResultCsvDownloaded() {
    String fileName = failedDeliveryManagementPage
        .getLatestDownloadedFilename("csv-reschedule-result.xlsx");
    failedDeliveryManagementPage.verifyFileDownloadedSuccessfully(fileName);
  }

  @Then("^Operator verify failed delivery order rescheduled on next day successfully$")
  public void operatorVerifyFailedDeliveryOrderRescheduleOnNextDaySuccessfully() {
    String trackingId = get(KEY_CREATED_ORDER_TRACKING_ID);
    failedDeliveryManagementPage.verifyOrderIsRemovedFromTableAfterReschedule(trackingId);
  }

  @When("^Operator reschedule failed delivery order on next 2 days$")
  public void operatorRescheduleFailedDeliveryOrderOnNext2Days() {
    String trackingId = get(KEY_CREATED_ORDER_TRACKING_ID);
    failedDeliveryManagementPage.waitWhilePageIsLoading();
    failedDeliveryManagementPage.rescheduleNext2Days(trackingId);
  }

  @Then("^Operator verify failed delivery order rescheduled on next 2 days successfully$")
  public void operatorVerifyFailedDeliveryOrderRescheduleOnNext2DaysSuccessfully() {
    String trackingId = get(KEY_CREATED_ORDER_TRACKING_ID);
    failedDeliveryManagementPage.waitWhilePageIsLoading();
    failedDeliveryManagementPage.verifyOrderIsRemovedFromTableAfterReschedule(trackingId);
  }

  @When("^Operator RTS failed delivery order on next day$")
  public void operatorRtsFailedDeliveryOrderOnNextDay() {
    String trackingId = get(KEY_CREATED_ORDER_TRACKING_ID);
    failedDeliveryManagementPage.waitWhilePageIsLoading();
    failedDeliveryManagementPage.rtsSingleOrderNextDay(trackingId);
  }

  @When("^Operator RTS failed delivery order with following properties:$")
  public void operatorRtsFailedDeliveryOrderWithFollowingProperties(Map<String, String> data) {
    RtsDetails rtsDetails = buildRtsDetails(data);
    String trackingId = get(KEY_CREATED_ORDER_TRACKING_ID);

    failedDeliveryManagementPage.waitWhilePageIsLoading();
    failedDeliveryManagementPage
        .openEditRtsDetailsDialog(trackingId)
        .fillForm(rtsDetails)
        .submitForm();

    RtsDetails.RtsAddress newAddress = rtsDetails.getAddress();
    if (newAddress != null) {
      Order createdOrder = get(KEY_CREATED_ORDER);
      createdOrder.setFromCountry(newAddress.getCountry());
      createdOrder.setFromCity(newAddress.getCity());
      createdOrder.setFromAddress1(newAddress.getAddress1());
      createdOrder.setFromAddress2(newAddress.getAddress2());
      createdOrder.setFromPostcode(newAddress.getPostcode());
    }
  }

  @When("^Operator RTS failed delivery orders with following properties:$")
  public void operatorRtsFailedDeliveryOrdersWithFollowingProperties(Map<String, String> data) {
    RtsDetails rtsDetails = buildRtsDetails(data);
    rtsDetails.setInternalNotes(null);
    List<String> trackingIds = get(KEY_LIST_OF_CREATED_ORDER_TRACKING_ID);

    failedDeliveryManagementPage.waitWhilePageIsLoading();
    trackingIds.forEach(trackingId -> {
      failedDeliveryManagementPage.failedDeliveriesTable
          .filterByColumn(CommonParcelManagementPage.FailedDeliveriesTable.COLUMN_TRACKING_ID,
              trackingId);
      failedDeliveryManagementPage.failedDeliveriesTable.selectRow(1);
    });
    failedDeliveryManagementPage.actionsMenu.selectOption("Set RTS to Selected");
    failedDeliveryManagementPage.editRtsDetailsDialog.waitUntilVisible();
    failedDeliveryManagementPage.editRtsDetailsDialog.fillForm(rtsDetails);
    failedDeliveryManagementPage.editRtsDetailsDialog.setOrderToRts.clickAndWaitUntilDone();

    RtsDetails.RtsAddress newAddress = rtsDetails.getAddress();
    if (newAddress != null) {
      Order createdOrder = get(KEY_CREATED_ORDER);
      createdOrder.setFromCountry(newAddress.getCountry());
      createdOrder.setFromCity(newAddress.getCity());
      createdOrder.setFromAddress1(newAddress.getAddress1());
      createdOrder.setFromAddress2(newAddress.getAddress2());
      createdOrder.setFromPostcode(newAddress.getPostcode());
    }
  }

  private RtsDetails buildRtsDetails(Map<String, String> data) {
    Map<String, String> mapOfTokens = createDefaultTokens();
    data = replaceDataTableTokens(data, mapOfTokens);

    RtsDetails rtsDetails = new RtsDetails(resolveKeyValues(data));

    if (StringUtils.equalsIgnoreCase("RANDOM", data.get("address"))) {
      Address randomAddress = AddressFactory.getRandomAddress();

      RtsDetails.RtsAddress rtsAddress = new RtsDetails.RtsAddress();
      rtsAddress.setCountry(randomAddress.getCountry());
      rtsAddress.setCity(randomAddress.getCity());
      rtsAddress.setAddress1(randomAddress.getAddress1());
      rtsAddress.setAddress2(randomAddress.getAddress2());
      rtsAddress.setPostcode(randomAddress.getPostcode());
      rtsDetails.setAddress(rtsAddress);
    }
    return rtsDetails;
  }

  @Then("^Operator verify failed delivery order RTS-ed successfully$")
  public void operatorVerifyFailedDeliveryOrderRtsedSuccessfully() {
    String trackingId = get(KEY_CREATED_ORDER_TRACKING_ID);
    failedDeliveryManagementPage.verifyOrderIsRemovedFromTableAfterReschedule(trackingId);
  }

  @When("^Operator RTS selected failed delivery order on next day$")
  public void operatorRtsSelectedFailedDeliveryOrderOnNextDay() {
    String trackingId = get(KEY_CREATED_ORDER_TRACKING_ID);
    failedDeliveryManagementPage.waitWhilePageIsLoading();
    failedDeliveryManagementPage.rtsSelectedOrderNextDay(trackingId);
  }
}
