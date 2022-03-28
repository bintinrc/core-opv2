package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.operator_v2.selenium.page.FinanceCodPage;
import io.cucumber.java.en.Given;
import java.util.Map;
import java.util.Objects;

public class FinanceCodSteps extends AbstractSteps {

  private FinanceCodPage financeCodPage;

  @Override
  public void init() {
    financeCodPage = new FinanceCodPage(getWebDriver());
  }

  @Given("Operator generates success finance cod report using data below:")
  public void operatorGeneratesSuccessBillingsForData(Map<String, String> mapOfData) {
    mapOfData = resolveKeyValues(mapOfData);
    financeCodPage.switchTo();
    setFinanceCodData(mapOfData);
    financeCodPage.generateCodReportBtn.click();
    financeCodPage.verifyNoErrorsAvailable();
  }

  private void setFinanceCodData(Map<String, String> mapOfData) {
    if (Objects.nonNull(mapOfData.get("basedOn"))) {
      String basedOn = mapOfData.get("basedOn");
      financeCodPage.selectOption(basedOn);
    }
    if (Objects.nonNull(mapOfData.get("startDate"))) {
      String startDate = mapOfData.get("startDate");
      put(KEY_ORDER_BILLING_START_DATE, startDate);
      financeCodPage.betweenDates.setFromDate(startDate);
    }
    if (Objects.nonNull(mapOfData.get("endDate"))) {
      String endDate = mapOfData.get("endDate");
      put(KEY_ORDER_BILLING_END_DATE, endDate);
      financeCodPage.betweenDates.setToDate(endDate);
    }
    String generateFile = mapOfData.get("generateFile");
    if (Objects.nonNull(generateFile)) {
      financeCodPage.selectOption(generateFile);
    }
    String emailAddress = mapOfData.get("emailAddress");
    if (Objects.nonNull(emailAddress)) {
      financeCodPage.setEmailAddress(emailAddress);
    }
  }
}
