package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.common.pricing.model.rest.BillingReportsRequest;
import co.nvqa.operator_v2.selenium.page.FinancialBatchReportsPage;
import io.cucumber.java.en.Given;
import io.cucumber.java.en.Then;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import org.assertj.core.api.Assertions;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import static co.nvqa.common.pricing.cucumber.glue.FinanceKeyStorage.KEY_FINANCE_BILLING_REPORT_REQUEST;
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
    financialBatchReportsPage.waitUntilLoaded();
    setFinancialBatchReportsData(mapOfData);
    financialBatchReportsPage.generateReportBtn.click();
    financialBatchReportsPage.waitUntilVisibilityOfNotification(
        "Report Request submitted Successfully.");
    financialBatchReportsPage.verifyNoErrorsAvailable();
  }

  @Given("Operator select financial batch report using data below:")
  public void operatorSelectsFinancialBatchReportForData(Map<String, String> mapOfData) {
    mapOfData = resolveKeyValues(mapOfData);
    financialBatchReportsPage.switchTo();
    setFinancialBatchReportsData(mapOfData);
    financialBatchReportsPage.generateReportBtn.jsClick();
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
    put(KEY_FINANCE_BILLING_REPORT_REQUEST, request);
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
