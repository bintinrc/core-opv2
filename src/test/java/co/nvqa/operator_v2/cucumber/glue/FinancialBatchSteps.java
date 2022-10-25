package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.util.StandardTestUtils;
import co.nvqa.operator_v2.selenium.page.FinancialBatchPage;
import io.cucumber.java.en.And;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;
import org.apache.commons.lang3.StringUtils;
import org.assertj.core.api.Assertions;
import org.assertj.core.api.SoftAssertions;
import org.assertj.core.data.Offset;

public class FinancialBatchSteps extends AbstractSteps {

  private FinancialBatchPage financialBatchPage;

  @Override
  public void init() {
    financialBatchPage = new FinancialBatchPage(getWebDriver());
  }


  @When("Operator generates financial batch data as below")
  public void operatorGeneratesFinancialBatchDataAsBelow(Map<String, String> mapOfData) {
    mapOfData = resolveKeyValues(mapOfData);
    financialBatchPage.switchToIframe();
    if (mapOfData.containsKey("shipper")) {
      financialBatchPage.selectShipper(mapOfData.get("shipper"));
    }
    if (mapOfData.containsKey("date")) {
      String value = mapOfData.get("date");
      if (value.equalsIgnoreCase("clear")) {
        financialBatchPage.clearDate();
      } else {
        financialBatchPage.selectDate(value);
      }
    }
    financialBatchPage.clickSearchBtn();
    takesScreenshot();
  }


  @When("Operator selects financial batch data as below")
  public void operatorSelectsFinancialBatchDataAsBelow(Map<String, String> mapOfData) {
    mapOfData = resolveKeyValues(mapOfData);
    financialBatchPage.switchToIframe();
    if (mapOfData.containsKey("shipper")) {
      String value = mapOfData.get("shipper");
      if (value.equalsIgnoreCase("test")) {
        financialBatchPage.searchShipper.sendKeys(value);
        pause1s();
      } else {
        financialBatchPage.selectShipper(value);
      }
    }
    if (mapOfData.containsKey("date")) {
      String value = mapOfData.get("date");
      if (value.equalsIgnoreCase("clear")) {
        financialBatchPage.searchDate.clear.click();
      } else {
        financialBatchPage.selectDate(value);
      }
    }
    takesScreenshot();
  }

  @Then("Operator verifies financial batch data as below")
  public void operatorVerifiesFinancialBatchDataAsBelow(Map<String, String> mapOfData) {
    mapOfData = resolveKeyValues(mapOfData);
    SoftAssertions softAssertions = new SoftAssertions();
    if (mapOfData.containsKey("overallBalance")) {
      String expectedOverallBalance = mapOfData.get("overallBalance");
      String expectedBalanceValue = StringUtils.substringBetween(expectedOverallBalance, "$", "(")
          .trim().replace(",", "");
      String expectedBalanceType = StringUtils.substringBetween(expectedOverallBalance, "(", ")");

      String actualOverallBalance = financialBatchPage.getOverallBalance();
      String actualBalanceValue = StringUtils.substringBetween(actualOverallBalance, "$", "(");
      String actualBalanceType = StringUtils.substringBetween(actualOverallBalance, "(", ")");

      softAssertions.assertThat(getDoubleValueForPricing(actualBalanceValue))
          .as("Overall Balance Value is correct")
          .isEqualTo(getDoubleValueForPricing(expectedBalanceValue), Offset.offset(0.9));
      softAssertions.assertThat(actualBalanceType)
          .as("Overall Balance Type is correct").isEqualTo(expectedBalanceType);
    }
    if (mapOfData.containsKey("date")) {
      softAssertions.assertThat(financialBatchPage.getDate()).as("Date is correct")
          .isEqualTo(mapOfData.get("date"));
    }
    if (mapOfData.containsKey("shipperName")) {
      softAssertions.assertThat(financialBatchPage.getShipperName()).as("Shipper Name is correct")
          .isEqualTo(mapOfData.get("shipperName"));
    }
    if (mapOfData.containsKey("debitTotalCOD")) {
      softAssertions.assertThat(getDoubleValueForPricing(financialBatchPage.getDebitCod()))
          .as("Debit Total COD is correct")
          .isEqualTo(getDoubleValueForPricing(mapOfData.get("debitTotalCOD")), Offset.offset(0.9));
    }
    if (mapOfData.containsKey("debitTotalFee")) {
      softAssertions.assertThat(getDoubleValueForPricing(financialBatchPage.getDebitFee()))
          .as("Debit Total Fee is correct")
          .isEqualTo(getDoubleValueForPricing(mapOfData.get("debitTotalFee")), Offset.offset(0.9));
    }
    if (mapOfData.containsKey("debitTotalAdjustment")) {
      softAssertions.assertThat(getDoubleValueForPricing(financialBatchPage.getDebitAdjustment()))
          .as("Debit Total Adjustment is correct")
          .isEqualTo(getDoubleValueForPricing(mapOfData.get("debitTotalAdjustment")),
              Offset.offset(0.9));
    }
    if (mapOfData.containsKey("debitNettBalance")) {
      softAssertions.assertThat(getDoubleValueForPricing(financialBatchPage.getDebitNettBalance()))
          .as("Debit Nett Balance is correct")
          .isEqualTo(getDoubleValueForPricing(mapOfData.get("debitNettBalance")),
              Offset.offset(0.9));
    }
    if (mapOfData.containsKey("creditTotalCOD")) {
      softAssertions.assertThat(getDoubleValueForPricing(financialBatchPage.getCreditCod()))
          .as("Credit Total COD is correct")
          .isEqualTo(getDoubleValueForPricing(mapOfData.get("creditTotalCOD")), Offset.offset(0.9));
    }
    if (mapOfData.containsKey("creditTotalFee")) {
      softAssertions.assertThat(getDoubleValueForPricing(financialBatchPage.getCreditFee()))
          .as("Credit Total Fee is correct")
          .isEqualTo(getDoubleValueForPricing(mapOfData.get("creditTotalFee")), Offset.offset(0.9));
    }
    if (mapOfData.containsKey("creditTotalAdjustment")) {
      softAssertions.assertThat(getDoubleValueForPricing(financialBatchPage.getCreditAdjustment()))
          .as("Credit Total Adjustment is correct")
          .isEqualTo(getDoubleValueForPricing(mapOfData.get("creditTotalAdjustment")),
              Offset.offset(0.9));
    }
    if (mapOfData.containsKey("creditNettBalance")) {
      softAssertions.assertThat(getDoubleValueForPricing(financialBatchPage.getCreditNettBalance()))
          .as("Credit Nett Balance is correct")
          .isEqualTo(getDoubleValueForPricing(mapOfData.get("creditNettBalance")),
              Offset.offset(0.9));
    }
    softAssertions.assertAll();
  }

  private Double getDoubleValueForPricing(String value) {
    return StandardTestUtils.getDoubleValue(value.trim().replace(",", ""));
  }

  @Then("Operator verifies error message is displayed in Financial Batch page")
  public void operatorVerifiesErrorMessageIsDisplayedInFinancialBatchPage(
      List<String> errorMessages) {
    takesScreenshot();
    financialBatchPage.antNotificationMessage.waitUntilVisible(1);

    List<String> actualErrorMsgs = financialBatchPage.noticeNotifications.stream()
        .map(e -> e.message.getText()).collect(Collectors.toList());

    Assertions.assertThat(errorMessages).as("Error Messages are correct")
        .isEqualTo(actualErrorMsgs);
  }


  @Then("Operator verifies error message {string} is displayed on Financial Batch Page")
  public void operatorVerifiesErrorMessageIsDisplayedOnFinancialBatchPage(String message) {
    takesScreenshot();
    String actualErrorMsgText = financialBatchPage.errorMessageText.getText();
    Assertions.assertThat(message).as("Error message is correct").isEqualTo(actualErrorMsgText);
  }


  @Then("Operator verifies that error toast is displayed on Financial Batch page:")
  public void operatorVerifiesThatErrorToastIsDisplayedOnFinancialBatchPage(
      Map<String, String> mapOfData) {
    financialBatchPage.getWebDriver().switchTo().defaultContent();
    if (mapOfData.containsKey("top")) {
      Assertions.assertThat(financialBatchPage.toastErrorTopText.getText())
          .as("Error top text is correct")
          .isEqualTo(mapOfData.get("top"));
    }
    if (mapOfData.containsKey("bottom")) {
      Assertions.assertThat(financialBatchPage.toastErrorBottomText.getText())
          .as("Error bottom text is correct").contains(mapOfData.get("bottom"));
    }
  }

  @And("Operator generated financial batch report using data below:")
  public void operatorGeneratedFinancialBatchReportUsingDataBelow(Map<String, String> mapOfData) {
    if (mapOfData.containsKey("emailAddress")) {
      financialBatchPage.setEmailAddress(mapOfData.get("emailAddress"));
    }
    financialBatchPage.requestReportBtn.click();
  }
}
