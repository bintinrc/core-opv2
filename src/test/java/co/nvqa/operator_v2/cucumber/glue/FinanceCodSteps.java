package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.operator_v2.selenium.page.FinanceCodPage;
import io.cucumber.java.en.Given;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import java.util.Map;
import java.util.Objects;
import org.assertj.core.api.Assertions;

public class FinanceCodSteps extends AbstractSteps {

  private FinanceCodPage financeCodPage;

  @Override
  public void init() {
    financeCodPage = new FinanceCodPage(getWebDriver());
  }

  @Given("Operator generates success finance cod report using data below:")
  public void operatorGeneratesFinanceCodReportForData(Map<String, String> mapOfData) {
    mapOfData = resolveKeyValues(mapOfData);
    financeCodPage.switchTo();
    setFinanceCodData(mapOfData);
    financeCodPage.generateCodReportBtn.click();
    financeCodPage.verifyNoErrorsAvailable();
  }

  private void setFinanceCodData(Map<String, String> mapOfData) {
    String value;
    value = mapOfData.get("basedOn");
    if (Objects.nonNull(value)) {
      financeCodPage.selectOption(value);
    }
    value = mapOfData.get("startDate");
    if (Objects.nonNull(value)) {
      put(KEY_FINANCE_COD_REPORT_START_DATE, value);
      financeCodPage.betweenDates.clearAndSetFromDate(value);
    }
    value = mapOfData.get("endDate");
    if (Objects.nonNull(value)) {
      put(KEY_FINANCE_COD_REPORT_END_DATE, value);
      financeCodPage.betweenDates.clearAndSetToDate(value);
    }
    value = mapOfData.get("generateFile");
    if (Objects.nonNull(value)) {
      financeCodPage.selectOption(value);
      put(KEY_FINANCE_COD_REPORT_TYPE, value);
    }
    value = mapOfData.get("emailAddress");
    if (Objects.nonNull(value)) {
      financeCodPage.setEmailAddress(value);
    }
  }

  @When("Operator selects Finance COD Report data as below")
  public void operatorSelectsFinanceCODReportDataAsBelow(Map<String, String> mapOfData) {
    mapOfData = resolveKeyValues(mapOfData);
    financeCodPage.switchTo();
    setFinanceCodData(mapOfData);
    financeCodPage.generateCodReportBtn.click();
  }

  @Then("Operator verifies error message {string}")
  public void operatorVerifiesErrorMessage(String errorMsg) {
    Assertions.assertThat(financeCodPage.verifyErrorMsgIsVisible(errorMsg))
        .as("Error message is visible").isTrue();
  }

  @Then("Operator verifies Generate COD based on option is not clickable")
  public void operatorVerifiesGenerateCODBasedOnOptionIsNotClickable() {
    Assertions.assertThat(financeCodPage.orderCompletedBtn.isEnabled())
        .as("Order Completed date is disabled").isFalse();
    Assertions.assertThat(financeCodPage.routeBtn.isEnabled()).as("Route date is disabled")
        .isFalse();
  }

  @Then("Operator verifies Between Dates option is not clickable")
  public void operatorVerifiesBetweenDatesOptionIsNotClickable() {
    Assertions.assertThat(financeCodPage.startDate.isEnabled()).as("Start Date is disabled")
        .isFalse();
    Assertions.assertThat(financeCodPage.endDate.isEnabled()).as("End Date is disabled")
        .isFalse();
  }
}
