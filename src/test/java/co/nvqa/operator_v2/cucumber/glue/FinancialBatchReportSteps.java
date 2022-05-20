package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.model.pricing.BillingReportsRequest;
import co.nvqa.commons.model.pricing.billing.FinancialBatchReportEntry;
import co.nvqa.commons.model.pricing.billing.FinancialBatchReportExtendedEntry;
import co.nvqa.operator_v2.selenium.page.FinancialBatchReportsPage;
import io.cucumber.java.en.Given;
import io.cucumber.java.en.Then;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import org.assertj.core.api.Assertions;
import org.assertj.core.api.SoftAssertions;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class FinancialBatchReportSteps extends AbstractSteps {

  private FinancialBatchReportsPage financialBatchReportsPage;

  private static final Logger LOGGER = LoggerFactory.getLogger(FinancialBatchReportSteps.class);


  @Override
  public void init() {
    financialBatchReportsPage = new FinancialBatchReportsPage(getWebDriver());
  }

  @Given("Operator generates success financial batch report using data below:")
  public void operatorGeneratesFinancialBatchReportForData(Map<String, String> mapOfData) {
    mapOfData = resolveKeyValues(mapOfData);
    financialBatchReportsPage.switchTo();
    setFinancialBatchReportsData(mapOfData);
    financialBatchReportsPage.generateReportBtn.click();
    financialBatchReportsPage.verifyNoErrorsAvailable();
  }

  @Given("Operator select financial batch report using data below:")
  public void operatorSelectsFinancialBatchReportForData(Map<String, String> mapOfData) {
    mapOfData = resolveKeyValues(mapOfData);
    financialBatchReportsPage.switchTo();
    setFinancialBatchReportsData(mapOfData);
    financialBatchReportsPage.generateReportBtn.click();
  }

  public void setFinancialBatchReportsData(Map<String, String> mapOfData) {
    BillingReportsRequest request = new BillingReportsRequest();
    List<String> consolidatedOptions = new ArrayList<>();
    List<Long> legacyShipperIds = new ArrayList<>();
    List<String> email = new ArrayList<>();

    String value;
    value = mapOfData.get("reportDetails");
    if (Objects.nonNull(value) && value.equalsIgnoreCase("yes")) {
      financialBatchReportsPage.orderLevelDetails.click();
      consolidatedOptions.add("EXTENDED_DETAILS");
      request.setConsolidatedOptions(consolidatedOptions);
    }
    value = mapOfData.get("startDate");
    if (Objects.nonNull(value)) {
      financialBatchReportsPage.betweenDates.clearAndSetFromDate(value);
      request.setStartDate(value);
    }
    value = mapOfData.get("endDate");
    if (Objects.nonNull(value)) {
      financialBatchReportsPage.betweenDates.clearAndSetToDate(value);
      request.setEndDate(value);
    }
    value = mapOfData.get("For");
    if (Objects.nonNull(value)) {
      financialBatchReportsPage.selectOption(value);
    }
    value = mapOfData.get("shipperId");
    if (Objects.nonNull(value)) {
      financialBatchReportsPage.selectShipperTxtBox.sendKeys(value);
      legacyShipperIds.add(Long.valueOf(value));
      request.setLegacyShipperIds(legacyShipperIds);
    }
    value = mapOfData.get("generateFile");
    if (Objects.nonNull(value)) {
      financialBatchReportsPage.selectOption(value);
      switch (value) {
        case "All orders batches in 1 file":
          consolidatedOptions.add("ALL");
          break;
        case "Batches consolidated by shipper (1 shipper 1 file)":
          consolidatedOptions.add("SHIPPER");
          break;
      }
    }
    value = mapOfData.get("emailAddress");
    if (Objects.nonNull(value)) {
      financialBatchReportsPage.setEmailAddress(value);
      email.add(value);
      request.setEmailAddresses(email);
    }
    put(KEY_FINANCE_REPORT_REQUEST, request);
  }

  @Then("Operator verifies the count of csv entries is {int}")
  public void operatorVerifiesTheCountOfCsvEntriesIs(int count) {
    List<FinancialBatchReportEntry> listOfBatchEntries = get(
        KEY_FINANCIAL_BATCH_REPORT_CSV_BODY_ENTRIES);
    Assertions.assertThat(listOfBatchEntries.size()).as("Count of CSV entries is correct")
        .isEqualTo(count);
  }

  @Then("Operator verifies financial batch report data in CSV is as below")
  public void operatorVerifiesFinancialBatchReportDataAsBelow(Map<String, String> mapOfData) {
    mapOfData = resolveKeyValues(mapOfData);
    List<FinancialBatchReportEntry> listOfBatchEntries = get(
        KEY_FINANCIAL_BATCH_REPORT_CSV_BODY_ENTRIES);
    FinancialBatchReportEntry financialBatchReportEntryCsv = listOfBatchEntries.get(0);
    SoftAssertions softAssertions = new SoftAssertions();

    if (mapOfData.containsKey("globalShipperId")) {
      softAssertions.assertThat(financialBatchReportEntryCsv.getGlobalShipperId())
          .as("Global Shipper ID is correct")
          .hasToString(mapOfData.get("globalShipperId"));
    }
    if (mapOfData.containsKey("legacyShipperId")) {
      softAssertions.assertThat(financialBatchReportEntryCsv.getLegacyShipperId())
          .as("Legacy Shipper ID is correct")
          .hasToString(mapOfData.get("legacyShipperId"));
    }
    if (mapOfData.containsKey("shipperName")) {
      softAssertions.assertThat(financialBatchReportEntryCsv.getShipperName())
          .as("Shipper Name is correct")
          .isEqualTo(mapOfData.get("shipperName"));
    }
    if (mapOfData.containsKey("batchId")) {
      softAssertions.assertThat(financialBatchReportEntryCsv.getBatchId()).as("Batch Id is correct")
          .isEqualTo(mapOfData.get("batchId"));
    }
    if (mapOfData.containsKey("date")) {
      softAssertions.assertThat(financialBatchReportEntryCsv.getDate()).as("Date is correct")
          .isEqualTo(mapOfData.get("date"));
    }
    if (mapOfData.containsKey("totalCOD")) {
      softAssertions.assertThat(financialBatchReportEntryCsv.getTotalCod())
          .as("Total COD is correct")
          .isEqualTo(mapOfData.get("totalCOD"));
    }
    if (mapOfData.containsKey("totalFees")) {
      softAssertions.assertThat(financialBatchReportEntryCsv.getTotalFees())
          .as("Total Fees is correct")
          .isEqualTo(mapOfData.get("totalFees"));
    }
    if (mapOfData.containsKey("totalAdjustment")) {
      softAssertions.assertThat(financialBatchReportEntryCsv.getTotalAdjustment())
          .as("Total Adjustment is correct").isEqualTo(mapOfData.get("totalAdjustment"));
    }
    if (mapOfData.containsKey("balance")) {
      softAssertions.assertThat(financialBatchReportEntryCsv.getBalance())
          .as("Balance is correct").isEqualTo(mapOfData.get("balance"));
    }
    softAssertions.assertAll();
  }

  @Then("Operator verifies extended financial batch report data in CSV is as below")
  public void operatorVerifiesExtendedFinancialBatchReportDataAsBelow(
      Map<String, String> mapOfData) {
    mapOfData = resolveKeyValues(mapOfData);
    List<FinancialBatchReportExtendedEntry> listOfBatchEntries = get(
        KEY_FINANCIAL_BATCH_REPORT_EXTENDED_BODY_ENTRIES);
    FinancialBatchReportExtendedEntry financialBatchReportExtendedEntry = listOfBatchEntries.get(0);
    SoftAssertions softAssertions = new SoftAssertions();
    if (mapOfData.containsKey("batchId")) {
      softAssertions.assertThat(financialBatchReportExtendedEntry.getBatchId())
          .as("Batch Id is correct")
          .isNotNull();
    }
    if (mapOfData.containsKey("batchDate")) {
      softAssertions.assertThat(financialBatchReportExtendedEntry.getBatchDate())
          .as("Batch Date is correct")
          .isEqualTo(mapOfData.get("batchDate"));
    }
    if (mapOfData.containsKey("shipperId")) {
      softAssertions.assertThat(financialBatchReportExtendedEntry.getShipperId())
          .as("Shipper ID is correct")
          .hasToString(mapOfData.get("shipperId"));
    }
    if (mapOfData.containsKey("shipperName")) {
      softAssertions.assertThat(financialBatchReportExtendedEntry.getShipperName())
          .as("Shipper Name is correct")
          .isEqualTo(mapOfData.get("shipperName"));
    }
    if (mapOfData.containsKey("trackingID")) {
      softAssertions.assertThat(financialBatchReportExtendedEntry.getTrackingID())
          .as("Tracking ID is correct")
          .isEqualTo(mapOfData.get("trackingID"));
    }
    if (mapOfData.containsKey("orderID")) {
      softAssertions.assertThat(financialBatchReportExtendedEntry.getOrderID())
          .as("Order ID is correct")
          .isEqualTo(mapOfData.get("orderID"));
    }
    if (mapOfData.containsKey("nvMeasuredWeight")) {
      softAssertions.assertThat(financialBatchReportExtendedEntry.getNvMeasuredWeight())
          .as("NV Measured Weight is correct")
          .isEqualTo(mapOfData.get("nvMeasuredWeight"));
    }
    if (mapOfData.containsKey("fromCity")) {
      softAssertions.assertThat(String.valueOf(financialBatchReportExtendedEntry.getFromCity()))
          .as("From City is correct")
          .isEqualTo(mapOfData.get("fromCity"));
    }
    if (mapOfData.containsKey("toAddress")) {
      softAssertions.assertThat(String.valueOf(financialBatchReportExtendedEntry.getToAddress()))
          .as("To Address is correct")
          .isEqualTo(mapOfData.get("toAddress"));
    }
    if (mapOfData.containsKey("toBillingZone")) {
      softAssertions.assertThat(financialBatchReportExtendedEntry.getToBillingZone())
          .as("To Billing Zone is correct")
          .isEqualTo(mapOfData.get("toBillingZone"));
    }
    if (mapOfData.containsKey("codAmount")) {
      softAssertions.assertThat(financialBatchReportExtendedEntry.getCodAmount())
          .as("COD Amount is correct")
          .isEqualTo(mapOfData.get("codAmount"));
    }
    if (mapOfData.containsKey("insuredAmount")) {
      softAssertions.assertThat(financialBatchReportExtendedEntry.getInsuredAmount())
          .as("Insured Amount is correct")
          .isEqualTo(mapOfData.get("insuredAmount"));
    }
    if (mapOfData.containsKey("codFee")) {
      softAssertions.assertThat(financialBatchReportExtendedEntry.getCodFee())
          .as("COD Fee is correct")
          .isEqualTo(mapOfData.get("codFee"));
    }
    if (mapOfData.containsKey("insuredFee")) {
      softAssertions.assertThat(financialBatchReportExtendedEntry.getInsuredFee())
          .as("Insured Fee is correct")
          .isEqualTo(mapOfData.get("insuredFee"));
    }
    if (mapOfData.containsKey("deliveryFee")) {
      softAssertions.assertThat(financialBatchReportExtendedEntry.getDeliveryFee())
          .as("Delivery Fee is correct")
          .isEqualTo(mapOfData.get("deliveryFee"));
    }
    if (mapOfData.containsKey("rtsFee")) {
      softAssertions.assertThat(financialBatchReportExtendedEntry.getRtsFee())
          .as("RTS Fee is correct")
          .isEqualTo(mapOfData.get("rtsFee"));
    }
    if (mapOfData.containsKey("totalTax")) {
      softAssertions.assertThat(financialBatchReportExtendedEntry.getTotalTax())
          .as("Total Tax is correct")
          .isEqualTo(mapOfData.get("totalTax"));
    }
    if (mapOfData.containsKey("totalWithTax")) {
      softAssertions.assertThat(financialBatchReportExtendedEntry.getTotalWithTax())
          .as("Total With Tax is correct")
          .isEqualTo(mapOfData.get("totalWithTax"));
    }
    if (mapOfData.containsKey("type")) {
      softAssertions.assertThat(financialBatchReportExtendedEntry.getType())
          .as("Type is correct")
          .isEqualTo(mapOfData.get("type"));
    }
    softAssertions.assertAll();
  }

  @Then("Operator verifies error message {string} is displayed on Financial Batch Reports Page")
  public void operatorVerifiesErrorMessage(String errorMsg) {
    takesScreenshot();
    Assertions.assertThat(financialBatchReportsPage.verifyErrorMsgIsVisible(errorMsg))
        .as("Error message is visible").isTrue();
  }

  @Then("Operator verifies that error toast is displayed on Financial Batch Reports page:")
  public void operatorVerifiesThatErrorToastDisplayedOnOrderBillingPage(
      Map<String, String> mapOfData) {
    mapOfData = resolveKeyValues(mapOfData);
    financialBatchReportsPage.getWebDriver().switchTo().defaultContent();
    if (mapOfData.containsKey("top")) {
      Assertions.assertThat(financialBatchReportsPage.toastErrorTopText.getText())
          .as("Error top text is correct")
          .isEqualTo(mapOfData.get("top"));
    }
    if (mapOfData.containsKey("bottom")) {
      Assertions.assertThat(financialBatchReportsPage.toastErrorBottomText.getText())
          .as("Error bottom text is correct").contains(mapOfData.get("bottom"));
    }
  }

  @Then("Operator selects Include Order-Level Details and verifies All Shippers option is disabled")
  public void operatorSelectsIncludeOrderLevelDetailsAndVerifiesAllShippersOptionIsDisabled() {
    financialBatchReportsPage.switchTo();
    financialBatchReportsPage.orderLevelDetails.click();
    Assertions.assertThat(financialBatchReportsPage.allShippersBtn.isEnabled())
        .as("All Shippers btn is disabled").isFalse();
  }
}
