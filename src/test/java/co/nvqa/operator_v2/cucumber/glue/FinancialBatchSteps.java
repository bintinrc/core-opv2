package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.operator_v2.selenium.page.FinancialBatchPage;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;
import org.assertj.core.api.Assertions;
import org.assertj.core.api.SoftAssertions;

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
        financialBatchPage.selectDate(mapOfData.get("date"));
      }
    }
    financialBatchPage.clickSearchBtn();
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
  }

  @Then("Operator verifies financial batch data as below")
  public void operatorVerifiesFinancialBatchDataAsBelow(Map<String, String> mapOfData) {
    mapOfData = resolveKeyValues(mapOfData);
    SoftAssertions softAssertions = new SoftAssertions();
    if (mapOfData.containsKey("overallBalance")) {
      softAssertions.assertThat(financialBatchPage.getOverallBalance())
          .as("Overall Balance is correct").isEqualTo(mapOfData.get("overallBalance"));
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
      softAssertions.assertThat(financialBatchPage.getDebitCod()).as("Debit Total COD is correct")
          .isEqualTo(mapOfData.get("debitTotalCOD"));
    }
    if (mapOfData.containsKey("debitTotalFee")) {
      softAssertions.assertThat(financialBatchPage.getDebitFee()).as("Debit Total Fee is correct")
          .isEqualTo(mapOfData.get("debitTotalFee"));
    }
    if (mapOfData.containsKey("debitTotalAdjustment")) {
      softAssertions.assertThat(financialBatchPage.getDebitAdjustment())
          .as("Debit Total Adjustment is correct").isEqualTo(mapOfData.get("debitTotalAdjustment"));
    }
    if (mapOfData.containsKey("debitNettBalance")) {
      softAssertions.assertThat(financialBatchPage.getDebitNettBalance())
          .as("Debit Nett Balance is correct").isEqualTo(mapOfData.get("debitNettBalance"));
    }
    if (mapOfData.containsKey("creditTotalCOD")) {
      softAssertions.assertThat(financialBatchPage.getCreditCod()).as("Credit Total COD is correct")
          .isEqualTo(mapOfData.get("creditTotalCOD"));
    }
    if (mapOfData.containsKey("creditTotalFee")) {
      softAssertions.assertThat(financialBatchPage.getCreditFee()).as("Credit Total Fee is correct")
          .isEqualTo(mapOfData.get("creditTotalFee"));
    }
    if (mapOfData.containsKey("creditTotalAdjustment")) {
      softAssertions.assertThat(financialBatchPage.getCreditAdjustment())
          .as("Credit Total Adjustment is correct")
          .isEqualTo(mapOfData.get("creditTotalAdjustment"));
    }
    if (mapOfData.containsKey("creditNettBalance")) {
      softAssertions.assertThat(financialBatchPage.getCreditNettBalance())
          .as("Credit Nett Balance is correct").isEqualTo(mapOfData.get("creditNettBalance"));
    }
    softAssertions.assertAll();
  }

  @Then("Operator verifies error message is displayed in Financial Batch page")
  public void operatorVerifiesErrorMessageIsDisplayedInFinancialBatchPage(
      List<String> errorMessages) {
    financialBatchPage.antNotificationMessage.waitUntilVisible(1);

    List<String> actualErrorMsgs = financialBatchPage.noticeNotifications.stream()
        .map(e -> e.message.getText()).collect(Collectors.toList());

    Assertions.assertThat(errorMessages).as("Error Messages are correct")
        .isEqualTo(actualErrorMsgs);

  }


  @Then("Operator verifies error message {string} is displayed on Financial Batch Page")
  public void operatorVerifiesErrorMessageIsDisplayedOnFinancialBatchPage(String message) {
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

}
