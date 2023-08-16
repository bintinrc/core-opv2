package co.nvqa.operator_v2.cucumber.glue.recovery;

import co.nvqa.common.model.DataEntity;
import co.nvqa.common.utils.StandardTestConstants;
import co.nvqa.operator_v2.cucumber.glue.AbstractSteps;
import co.nvqa.operator_v2.model.FailedDelivery;
import co.nvqa.operator_v2.selenium.elements.ant.AntNotification;
import co.nvqa.operator_v2.selenium.page.recovery.fdm.FailedDeliveryManagementPage;
import co.nvqa.operator_v2.selenium.page.recovery.fdm.FailedDeliveryManagementPage.FailedDeliveryTable;
import io.cucumber.java.en.Given;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;

import java.util.Arrays;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.apache.commons.lang3.StringUtils;
import org.assertj.core.api.Assertions;

import static co.nvqa.commons.util.NvAssertions.LOGGER;

public class FailedDeliveryManagementSteps extends AbstractSteps {

  private FailedDeliveryManagementPage failedDeliveryManagementReactPage;

  public FailedDeliveryManagementSteps() {
  }

  @Override
  public void init() {
    failedDeliveryManagementReactPage = new FailedDeliveryManagementPage(getWebDriver());
  }

  @When("Recovery User - Wait until FDM Page loaded completely")
  public void doWaitUntilPageLoaded() {
    failedDeliveryManagementReactPage.inFrame(() -> {
      failedDeliveryManagementReactPage.fdmHeader.waitUntilVisible(60);
    });
  }

  @When("Recovery User - Search failed orders by trackingId = {string}")
  public void doFilterByTrackingId(String trackingId) {
    failedDeliveryManagementReactPage.inFrame((page) -> {
      page.fdmTable.filterTableByTID("trackingId", resolveValue(trackingId));
      page.fdmTable.verifyTableisFiltered();
    });

  }

  @When("Recovery User - Search failed orders by shipperName = {string}")
  public void doFilterByShipperId(String shipperName) {
    failedDeliveryManagementReactPage.inFrame(
        page -> page.fdmTable.filterTableByShipperName("shipperName", resolveValue(shipperName)));
  }

  @When("Recovery User - Clear the TID filter")
  public void doClearTIDFilter() {
    failedDeliveryManagementReactPage.inFrame(page -> {
      page.fdmTable.clearTIDFilter();
    });
  }

  @Then("Recovery User - verify failed delivery table on FDM page:")
  public void doVerifyFdmTable(Map<String, String> dataTable) {
    FailedDelivery expected = new FailedDelivery(resolveKeyValues(dataTable));

    failedDeliveryManagementReactPage.inFrame(page -> {
      page.waitUntilLoaded(3);
      List<String> actual = page.fdmTable.getFilteredValue();

      Assertions.assertThat(actual.get(1)).as("TrackingId is Match")
          .isEqualTo(expected.getTrackingId());
      Assertions.assertThat(actual.get(3)).as("Shipper Name is Match")
          .isEqualTo(expected.getShipperName());
      Assertions.assertThat(actual.get(5)).as("Failure Comments is Match")
          .isEqualTo(expected.getFailureReasonComments());
    });
  }

  @Given("Recovery User - clicks {string} button on Failed Delivery Management page")
  public void operatorClicksButtonOnFdmPage(String buttonName) {
    failedDeliveryManagementReactPage.inFrame(page -> {
      switch (buttonName) {
        case "Select All Shown":
          page.fdmTable.bulkSelectDropdown.click();
          page.fdmTable.selectAll.click();
          break;
        case "Deselect All Shown":
          page.fdmTable.bulkSelectDropdown.click();
          page.fdmTable.deselectAll.click();
          break;
        case "Clear Current Selection":
          page.fdmTable.bulkSelectDropdown.click();
          page.fdmTable.selectAll.click();
          page.fdmTable.bulkSelectDropdown.click();
          page.fdmTable.clearCurrentSelection.click();
          break;
        case "Show Only Selected":
          page.fdmTable.bulkSelectDropdown.click();
          page.fdmTable.showOnlySelected.click();
          break;
        case "CSV Reschedule":
          page.csvReschedule.click();
      }
    });
  }

  @Then("Recovery User - verifies number of selected rows on Failed Delivery Management page")
  public void operatorVerifiesNumberOfSelectedRows() {
    failedDeliveryManagementReactPage.inFrame(() ->
        failedDeliveryManagementReactPage.verifyBulkSelectResult()
    );
  }

  @Then("Recovery User - verify the number of selected Failed Delivery rows is {value}")
  public void operatorVerifiesNumberOfSelectedRow(String expectedRowCount) {
    failedDeliveryManagementReactPage.inFrame(() -> {
      String selectedRows = failedDeliveryManagementReactPage.fdmTable.selectedRowCount.getText();
      Assertions.assertThat(selectedRows).as("Number of selected rows are the same")
          .contains(expectedRowCount);
    });
  }

  @Given("Recovery User - selects {int} rows on Failed Delivery Management page")
  public void operatorSelectRowsOnFdmPage(int numberOfRows) {
    failedDeliveryManagementReactPage.inFrame(() -> {
      for (int i = 1; i <= numberOfRows; i++) {
        failedDeliveryManagementReactPage.fdmTable.clickActionButton(i,
            FailedDeliveryTable.ACTION_SELECT);
      }
    });
  }

  @Then("Recovery User - Download CSV file of failed delivery order on Failed Delivery orders list")
  public void operatorDownloadSelectedRowToCsv() {
    failedDeliveryManagementReactPage.inFrame(() -> {
      failedDeliveryManagementReactPage.applyAction.click();
      failedDeliveryManagementReactPage.downloadCsvFileAction.click();
    });
  }

  @Then("Recovery User - verify CSV file of failed delivery order on Failed Delivery orders list downloaded successfully")
  public void verifyCsvFileDownloadedSuccessfully() {
    failedDeliveryManagementReactPage.inFrame(page -> {
      List<FailedDelivery> expectedFailedOrder = page.fdmTable.readAllEntities();
      final String fileName = page.getLatestDownloadedFilename(
          FailedDeliveryManagementPage.FDM_CSV_FILENAME_PATTERN);
      page.verifyFileDownloadedSuccessfully(fileName);
      final String pathName = StandardTestConstants.TEMP_DIR + fileName;

      List<FailedDelivery> actualFailedOrder = DataEntity
          .fromCsvFile(FailedDelivery.class, pathName, true);

      Assertions.assertThat(actualFailedOrder).as("Number of records is match")
          .hasSameSizeAs(expectedFailedOrder);

      for (int i = 0; i < actualFailedOrder.size(); i++) {
        expectedFailedOrder.get(i).compareWithActual(actualFailedOrder.get(i), "orderTags");
      }
    });
  }

  @Then("Recovery User - verify CSV file downloaded after reschedule")
  public void verifyCsvFileDownloadedAfterReschedule() {
    failedDeliveryManagementReactPage.inFrame(page -> {
      final String fileName = page.getLatestDownloadedFilename(
          FailedDeliveryManagementPage.RESCHEDULE_CSV_FILENAME_PATTERN);
      page.verifyFileDownloadedSuccessfully(fileName);
    });
  }

  @When("Recovery User - reschedule failed delivery order on next day")
  public void doRescheduleFailedDeliveryOrderOnNextDay() {
    failedDeliveryManagementReactPage.inFrame((page) -> {
      page.fdmTable.clickActionButton(1, FailedDeliveryTable.ACTION_RESCHEDULE);
    });
  }

  @Then("Recovery User - verifies that toast displayed with message below:")
  public void doVerifiesToastDisplayed(Map<String, String> data) {
    failedDeliveryManagementReactPage.inFrame(() -> {
      Map<String, String> finalData = resolveKeyValues(data);
      boolean waitUntilInvisible = Boolean.parseBoolean(
          finalData.getOrDefault("waitUntilInvisible", "false"));
      long start = new Date().getTime();
      AntNotification toastInfo;
      do {
        toastInfo = failedDeliveryManagementReactPage.noticeNotifications.stream().filter(toast -> {
          String actualTop = failedDeliveryManagementReactPage.notifMessage.getText();
          LOGGER.info("Found notification: " + actualTop);
          String value = finalData.get("message");
          if (StringUtils.isNotBlank(value)) {
            if (value.startsWith("^")) {
              if (!actualTop.matches(value)) {
                return false;
              }
            } else {
              if (!StringUtils.equalsIgnoreCase(value, actualTop)) {
                return false;
              }
            }
          }
          value = finalData.get("description");
          if (StringUtils.isNotBlank(value)) {
            String actual = failedDeliveryManagementReactPage.notifDescription.getText();
            if (value.startsWith("^")) {
              return actual.matches(value);
            } else {
              return StringUtils.equalsIgnoreCase(value, actual);
            }
          }
          return true;
        }).findFirst().orElse(null);
      } while (toastInfo == null && new Date().getTime() - start < 20000);
      Assertions.assertThat(toastInfo != null).as("Toast " + finalData + " is displayed").isTrue();
      if (toastInfo != null && waitUntilInvisible) {
        toastInfo.waitUntilInvisible();
      }
      pause3s();
      reloadPage();
    });
  }

  @Then("Recovery User - Reschedule Selected failed delivery order on Failed Delivery orders list")
  public void doRescheduleSelectedFailedDeliveryOrder() {
    failedDeliveryManagementReactPage.inFrame(() -> {
      failedDeliveryManagementReactPage.applyAction.click();
      failedDeliveryManagementReactPage.rescheduleSelected.click();
    });
  }

  @When("Recovery User - set reschedule date to {string}")
  public void doSetRescheduleDate(String date) {
    failedDeliveryManagementReactPage.inFrame(() -> {
      failedDeliveryManagementReactPage.rescheduleDialog.setRescheduleDate(resolveValue(date));
      failedDeliveryManagementReactPage.rescheduleDialog.rescheduleButton.click();
    });
  }

  @When("Recovery User - Reschedule failed orders with CSV")
  public void doRescheduleByCSV(Map<String, String> dataTable) {
    dataTable = resolveKeyValues(dataTable);
    String rescheduleDate = dataTable.get("reschedule_date");
    List<String> trackingIds = Arrays.stream(dataTable.get("tracking_ids").split(","))
        .map(String::trim)
        .collect(Collectors.toList());

    failedDeliveryManagementReactPage.inFrame(() -> {
      failedDeliveryManagementReactPage.uploadCSVDialog.generateRescheduleCSV(trackingIds,
          rescheduleDate);
      failedDeliveryManagementReactPage.uploadCSVDialog.upload.click();
    });
  }

  @When("Recovery User - RTS order on next day")
  public void selectRTS() {
    failedDeliveryManagementReactPage.inFrame((page) -> {
      page.fdmTable.clickActionButton(1, FailedDeliveryTable.ACTION_RTS);
    });
  }

  @Then("Recovery User - verifies Edit RTS Details dialog")
  public void verifyRTSDialog(Map<String, String> dataMap) {
    Map<String, String> dataTable = resolveKeyValues(dataMap);
    failedDeliveryManagementReactPage.inFrame((page) -> {
      Assertions.assertThat(page.rtsDetailsDialog.recipientName.getAttribute("value"))
          .isEqualTo(dataTable.get("recipientName"));
      Assertions.assertThat(page.rtsDetailsDialog.recipientContact.getAttribute("value"))
          .isEqualTo(dataTable.get("recipientContact"));
      Assertions.assertThat(page.rtsDetailsDialog.recipientEmail.getAttribute("value"))
          .isEqualTo(dataTable.get("recipientEmail"));
      Assertions.assertThat(page.rtsDetailsDialog.shipperInstructions.getAttribute("value"))
          .isEqualTo(dataTable.get("shipperInstructions"));
      Assertions.assertThat(page.rtsDetailsDialog.country.getAttribute("value"))
          .isEqualTo(dataTable.get("country"));
      Assertions.assertThat(page.rtsDetailsDialog.city.getAttribute("value")).isEqualTo("-");
      Assertions.assertThat(page.rtsDetailsDialog.address1.getAttribute("value"))
          .isEqualTo(dataTable.get("address1"));
      Assertions.assertThat(page.rtsDetailsDialog.address2.getAttribute("value"))
          .isEqualTo(dataTable.get("address2"));
      Assertions.assertThat(page.rtsDetailsDialog.postalCode.getAttribute("value"))
          .isEqualTo(dataTable.get("postalCode"));

    });
  }

  @When("Recovery User - selects reason from Return To Sender Reason dropdown and timeslot from Timeslot dropdown")
  public void selectRTSReasonAndTimeslot() {
    failedDeliveryManagementReactPage.inFrame((page) -> {
      page.rtsDetailsDialog.selectionInput.get(0).click();
      page.rtsDetailsDialog.unableToFindAddress.click();
      page.rtsDetailsDialog.selectionInput.get(1).click();
      page.rtsDetailsDialog.nightSlot.click();
    });
  }

  @When("Recovery User - set RTS date to {string}")
  public void setRTSDate(String date) {
    failedDeliveryManagementReactPage.inFrame((page) -> {
      page.rtsDetailsDialog.setDate(resolveValue(date));
      page.rtsDetailsDialog.saveChanges.click();
    });
  }

  @When("Recovery User - set RTS date to {string} for multiple orders")
  public void setRTSDateMultipleOrders(String date) {
    failedDeliveryManagementReactPage.inFrame(() -> {
      failedDeliveryManagementReactPage.selectedToRTSDialog.setDate(resolveValue(date));
      failedDeliveryManagementReactPage.selectedToRTSDialog.setToRTS.click();
    });
  }

  @When("Recovery User - RTS multiple orders on next day")
  public void RTSMultipleOrders() {
    failedDeliveryManagementReactPage.inFrame((page) -> {
      page.applyAction.click();
      page.rtsSelected.click();
    });
  }

  @When("Recovery User - verifies Set Selected to Return to Sender dialog")
  public void verifySetSelectedRTSDialog(List<Map<String, String>> data) {
    failedDeliveryManagementReactPage.inFrame((page) -> {
      List<Map<String, String>> dataTable = resolveListOfMaps(data);
      Assertions.assertThat(page.selectedToRTSDialog.dialogTitle.getText())
          .isEqualTo("Set Selected to Return to Sender");
      for (int i = 0; i < dataTable.size(); i++) {
        if (dataTable.get(i).containsKey("trackingId")) {
          Assertions.assertThat(page.selectedToRTSDialog.trackingId.get(i).getText())
              .isEqualTo(dataTable.get(i).get(resolveValue("trackingId")));
          if (dataTable.get(i).containsKey("status")) {
            Assertions.assertThat(page.selectedToRTSDialog.status.getText())
                .isEqualTo(dataTable.get(i).get("status"));
          }
        }
      }
    });
  }

  @When("Recovery User - change order address in Edit RTS Details dialog")
  public void changeAddress() {
    failedDeliveryManagementReactPage.inFrame((page) -> {
      page.rtsDetailsDialog.changeAddress.click();
      page.rtsDetailsDialog.newCountry.sendKeys("SG");
      page.rtsDetailsDialog.newCity.sendKeys("SG");
      page.rtsDetailsDialog.newAddress1.sendKeys("new Address1");
      page.rtsDetailsDialog.newAddress2.sendKeys("new Address2");
      page.rtsDetailsDialog.newPostalCode.sendKeys("546080");
    });
  }

  @When("Recovery User - search address by name in Edit RTS Details dialog")
  public void searchAddressByName() {
    failedDeliveryManagementReactPage.inFrame((page) -> {
      page.rtsDetailsDialog.changeAddress.click();
      page.rtsDetailsDialog.addressFinder.click();
      page.rtsDetailsDialog.searchTerm.sendKeys("SG");
      page.rtsDetailsDialog.search.click();
      String searchResult = page.rtsDetailsDialog.locationResult.getText();
      Assertions.assertThat(searchResult).isNotBlank();
      page.rtsDetailsDialog.saveLocation.click();
      Assertions.assertThat(searchResult).contains(page.rtsDetailsDialog.newAddress1.getText());
    });
  }

  @When("Recovery User - cancel address change in Edit RTS Details dialog")
  public void cancelAddressChange() {
    failedDeliveryManagementReactPage.inFrame((page) -> {
      page.rtsDetailsDialog.cancelAddressChange.click();
    });
  }

  @Then("Recovery User - verifies that error dialog displayed with message below:")
  public void doVerifiesErrorDialogDisplayed(Map<String, String> dataTable) {
    dataTable = resolveKeyValues(dataTable);
    String message = dataTable.get("message");
    String description = dataTable.get("description");
    failedDeliveryManagementReactPage.inFrame((page) -> {
      retryIfAssertionErrorOrRuntimeExceptionOccurred(() -> {
        Assertions.assertThat(page.errorDialog.alertMessage.getText())
            .as(f("Error Message contains: %s", message)).isEqualTo(message);
        Assertions.assertThat(page.errorDialog.alertDescription.getText())
            .as(f("Error Description contains %s", description)).isEqualTo(description);
        page.errorDialog.close.click();
      }, 5);
    });
  }

  @When("Recovery User - uploads csv file without header")
  public void uploadInvalidFile() {
    failedDeliveryManagementReactPage.inFrame(() -> {
      failedDeliveryManagementReactPage.uploadCSVDialog.generateNoHeaderCSV();
      failedDeliveryManagementReactPage.uploadCSVDialog.upload.click();
    });
  }
}
