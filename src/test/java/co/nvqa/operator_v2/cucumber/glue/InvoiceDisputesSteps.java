package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.common.pricing.model.persisted_classes.billing.InvoiceDisputes;
import co.nvqa.operator_v2.model.InvoiceDisputeDetails;
import co.nvqa.operator_v2.selenium.page.InvoiceDisputesPage;
import io.cucumber.java.en.And;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import java.time.format.DateTimeFormatter;
import java.util.Map;
import java.util.Objects;
import org.assertj.core.api.SoftAssertions;

import static co.nvqa.common.pricing.cucumber.glue.FinanceKeyStorage.KEY_INVOICE_DISPUTES_COUNT;
import static co.nvqa.common.pricing.cucumber.glue.FinanceKeyStorage.KEY_INVOICE_DISPUTE_DETAILS_DB;

public class InvoiceDisputesSteps extends AbstractSteps {

  private InvoiceDisputesPage invoiceDisputesPage;

  public InvoiceDisputesSteps() {
  }

  @Override
  public void init() {
    invoiceDisputesPage = new InvoiceDisputesPage(getWebDriver());
  }

  @When("Invoice Dispute Orders page is loaded")
  public void invoiceDisputePageIsLoaded() {
    invoiceDisputesPage.switchToIframe();
    invoiceDisputesPage.waitUntilLoaded();
  }

  @Then("Operator add filters according to data below:")
  public void operatorAddFilters(Map<String, String> mapOfData) {
    mapOfData = resolveKeyValues(mapOfData);
    String value;
    value = mapOfData.get("caseStatus");
    if (Objects.nonNull(value)) {
      invoiceDisputesPage.selectCaseStatus(value);
    }
    value = mapOfData.get("fromDate");
    if (Objects.nonNull(value)) {
      invoiceDisputesPage.betweenDates.clearAndSetFromDate(value);
    }
    value = mapOfData.get("toDate");
    if (Objects.nonNull(value)) {
      invoiceDisputesPage.betweenDates.clearAndSetToDate(value);
    }
    value = mapOfData.get("shipperId");
    if (Objects.nonNull(value)) {
      invoiceDisputesPage.searchForTheShipper(value);
    }
    value = mapOfData.get("invoiceId");
    if (Objects.nonNull(value)) {
      invoiceDisputesPage.enterInvoiceId(value);
    }

  }

  @And("Operator click load selection")
  public void clickLoadSelection() {
    invoiceDisputesPage.clickLoadSelection();
    invoiceDisputesPage.waitUntilLoaded();
  }

  @And("Operator verify the invoice dispute details")
  public void verifySearchDetailsForCase() {
    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
    InvoiceDisputes invoiceDispute = get(KEY_INVOICE_DISPUTE_DETAILS_DB);
    InvoiceDisputeDetails invoiceDisputeDetails = invoiceDisputesPage.getInvoiceDisputeDetails(
        invoiceDispute.getId().toString());
    SoftAssertions softAssertions = new SoftAssertions();
    softAssertions.assertThat(invoiceDisputeDetails.getCaseNumber()).as("Case Number is correct")
        .isEqualTo(invoiceDispute.getId().toString());
    softAssertions.assertThat(invoiceDisputeDetails.getNumberOfTids())
        .as("Number of TIDs is correct")
        .isEqualTo(invoiceDispute.getNumberOfTids().toString());
    softAssertions.assertThat(invoiceDisputeDetails.getDisputeFiledDate())
        .as("Date dispute filed is correct")
        .isEqualTo(invoiceDispute.getDisputeFiledDate().format(formatter).toString());
    softAssertions.assertThat(invoiceDisputeDetails.getShipperId()).as("Shipper ID is correct")
        .isEqualTo(invoiceDispute.getLegacyShipperId().toString() + " - "
            + invoiceDispute.getShipperName());
    softAssertions.assertThat(invoiceDisputeDetails.getInvoiceId()).as("Invoice ID is correct")
        .isEqualTo(invoiceDispute.getInvoiceId());
    softAssertions.assertThat(invoiceDisputeDetails.getCaseStatus()).as("Case Status is correct")
        .isEqualToIgnoringCase(invoiceDispute.getStatus());
    softAssertions.assertAll();

  }

  @And("Operator verifies the result count")
  public void verifyTheSearchResultCount() {
    Long dbCount = get(KEY_INVOICE_DISPUTES_COUNT);
    SoftAssertions softAssertions = new SoftAssertions();
    softAssertions.assertThat(invoiceDisputesPage.getInvoiceDisputesCount())
        .as("Result count is correct").isEqualTo(dbCount.toString());
    softAssertions.assertAll();
  }

}