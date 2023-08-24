package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.common.pricing.model.persisted_classes.billing.InvoiceDisputes;
import co.nvqa.operator_v2.model.InvoiceDisputeDetails;
import co.nvqa.operator_v2.selenium.page.InvoiceDisputesDetailPage;
import co.nvqa.operator_v2.selenium.page.InvoiceDisputesPage;
import io.cucumber.java.en.And;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import java.time.format.DateTimeFormatter;
import java.util.Arrays;
import java.util.List;
import java.util.ListIterator;
import java.util.Map;
import java.util.Objects;
import java.util.stream.Collectors;
import org.assertj.core.api.Assertions;
import org.assertj.core.api.SoftAssertions;
import org.openqa.selenium.JavascriptExecutor;

import static co.nvqa.common.pricing.cucumber.glue.FinanceKeyStorage.KEY_INVOICE_DISPUTES_COUNT;
import static co.nvqa.common.pricing.cucumber.glue.FinanceKeyStorage.KEY_INVOICE_DISPUTE_DETAILS_DB;

public class InvoiceDisputesSteps extends AbstractSteps {

  private InvoiceDisputesPage invoiceDisputesPage;
  private InvoiceDisputesDetailPage invoiceDisputesDetailPage;

  public InvoiceDisputesSteps() {
  }

  @Override
  public void init() {
    invoiceDisputesPage = new InvoiceDisputesPage(getWebDriver());
    invoiceDisputesDetailPage = new InvoiceDisputesDetailPage(getWebDriver());
  }

  @When("Invoice Dispute Orders page is loaded")
  public void invoiceDisputePageIsLoaded() {
    invoiceDisputesPage.waitUntilLoaded();
  }

  @Then("Operator add filters according to data below:")
  public void operatorAddFilters(Map<String, String> mapOfData) {
    final Map<String, String> finalMapOfData = resolveKeyValues(mapOfData);
    invoiceDisputesPage.inFrame(page -> {
      String value = finalMapOfData.get("caseStatus");
      if (Objects.nonNull(value)) {
        invoiceDisputesPage.selectCaseStatus(value);
      }
      value = finalMapOfData.get("fromDate");
      if (Objects.nonNull(value)) {
        invoiceDisputesPage.betweenDates.clearAndSetFromDate(value);
      }
      value = finalMapOfData.get("toDate");
      if (Objects.nonNull(value)) {
        invoiceDisputesPage.betweenDates.clearAndSetToDate(value);
      }
      value = finalMapOfData.get("shipperId");
      if (Objects.nonNull(value)) {
        invoiceDisputesPage.searchForTheShipper(value);
      }
      value = finalMapOfData.get("invoiceId");
      if (Objects.nonNull(value)) {
        invoiceDisputesPage.enterInvoiceId(value);
      }
    });

  }

  @And("Operator click load selection")
  public void clickLoadSelection() {
    invoiceDisputesPage.inFrame(page -> {
      invoiceDisputesPage.clickLoadSelection();
      invoiceDisputesPage.waitUntilLoaded();
    });
  }

  @And("Operator verify the invoice dispute details")
  public void verifySearchDetailsForCase() {
    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
    InvoiceDisputes invoiceDispute = get(KEY_INVOICE_DISPUTE_DETAILS_DB);
    invoiceDisputesPage.inFrame(page -> {
      InvoiceDisputeDetails invoiceDisputeDetails = invoiceDisputesPage.getInvoiceDisputeDetails(
          invoiceDispute.getId().toString());
      SoftAssertions softAssertions = new SoftAssertions();
      softAssertions.assertThat(invoiceDisputeDetails.getCaseNumber()).as("Case Number is correct")
          .isEqualTo(invoiceDispute.getId().toString());
      softAssertions.assertThat(invoiceDisputeDetails.getNumberOfTIDs())
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
    });

  }

  @And("Operator verifies the result count")
  public void verifyTheSearchResultCount() {
    Long dbCount = get(KEY_INVOICE_DISPUTES_COUNT);
    SoftAssertions softAssertions = new SoftAssertions();
    invoiceDisputesPage.inFrame(page -> {
      softAssertions.assertThat(invoiceDisputesPage.getInvoiceDisputesCount())
          .as("Result count is correct").isEqualTo(dbCount.toString());
      softAssertions.assertAll();
    });
  }

  @And("Operator clicks action button")
  public void clicksActionButton() {
    invoiceDisputesPage.inFrame(page -> {
      page.clickActionButton();
      page.waitUntilLoaded();
      page.switchToNewWindow();
      page.waitUntilLoaded();
    });
  }

  @And("Operator verifies Invoice Dispute Case Information using below data:")
  public void verifyInvoiceDisputeDetailPage(Map<String, String> mapOfData) {
    final Map<String, String> finalMapOfData = resolveKeyValues(mapOfData);
    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
    invoiceDisputesDetailPage.inFrame(page -> {
      SoftAssertions softAssertions = new SoftAssertions();
      InvoiceDisputes invoiceDispute = get(KEY_INVOICE_DISPUTE_DETAILS_DB);
      InvoiceDisputeDetails invoiceDisputeDetails = invoiceDisputesDetailPage.getInvoiceDisputeExtendedDetails();
      softAssertions.assertThat(invoiceDisputeDetails.getCaseNumber()).as("Case Number is correct")
          .isEqualTo(invoiceDispute.getExternalRefId());
      softAssertions.assertThat(invoiceDisputeDetails.getCaseStatus()).as("Case Status is correct")
          .isEqualToIgnoringCase(invoiceDispute.getStatus());
      softAssertions.assertThat(invoiceDisputeDetails.getDisputeFiledDate())
          .as("Date dispute filed is correct")
          .isEqualTo(invoiceDispute.getDisputeFiledDate().format(formatter));
      softAssertions.assertThat(invoiceDisputeDetails.getInvoiceId()).as("Invoice Id is correct")
          .isEqualTo(invoiceDispute.getInvoiceId());
      softAssertions.assertThat(invoiceDisputeDetails.getShipperName())
          .as("Shipper Name is correct").isEqualTo(invoiceDispute.getShipperName());
      softAssertions.assertThat(invoiceDisputeDetails.getShipperId()).as("Shipper Id is correct")
          .isEqualTo(invoiceDispute.getLegacyShipperId().toString());
      softAssertions.assertThat(invoiceDisputeDetails.getDisputePersonName())
          .as("Dispute person name is correct")
          .isEqualTo(invoiceDispute.getDisputePersonName());
      if (!invoiceDisputeDetails.getNumberOfTIDs().equals("-") && !mapOfData.get(
          "errorTIDs").equals("-")) {
        softAssertions.assertThat(invoiceDisputeDetails.getNumberOfTIDs())
            .as("Number of disputed TIDs is correct")
            .isEqualTo(
                String.valueOf(
                    invoiceDispute.getNumberOfTids() - Long.parseLong(mapOfData.get("errorTIDs"))));
      } else if (!invoiceDisputeDetails.getNumberOfTIDs().equals("-")
          && mapOfData.get(
          "errorTIDs").equals("-")) {
        softAssertions.assertThat(invoiceDisputeDetails.getNumberOfTIDs())
            .as("Number of disputed TIDs is correct")
            .isEqualTo(invoiceDispute.getNumberOfTids().toString());
      } else {
        softAssertions.assertThat(invoiceDisputeDetails.getNumberOfTIDs())
            .as("Number of disputed TIDs is correct").isEqualTo("-");
      }
      if (finalMapOfData.containsKey("numberOfInvalidTIDs")) {
        softAssertions.assertThat(invoiceDisputeDetails.getNumberOfInvalidTIDs())
            .as("Number of Invalid TIDs is correct")
            .isEqualTo(mapOfData.get("numberOfInvalidTIDs"));
      }
      if (finalMapOfData.containsKey("numberOfValidTIDs")) {
        softAssertions.assertThat(invoiceDisputeDetails.getNumberOfValidTIDs())
            .as("Number of Valid TIDs is correct").isEqualTo(mapOfData.get("numberOfValidTIDs"));
      }
      if (finalMapOfData.containsKey("pendingTIDs")) {
        softAssertions.assertThat(invoiceDisputeDetails.getNumberOfPendingTIDs())
            .as("Pending TIDs is correct").isEqualTo(mapOfData.get("pendingTIDs"));
      }
      if (finalMapOfData.containsKey("acceptedTIDs")) {
        softAssertions.assertThat(invoiceDisputeDetails.getNumberOfAcceptedTIDs())
            .as("Accepted TIDs is correct").isEqualTo(mapOfData.get("acceptedTIDs"));
      }
      if (finalMapOfData.containsKey("rejectedTIDs")) {
        softAssertions.assertThat(invoiceDisputeDetails.getNumberOfRejectedTIDs())
            .as("Rejected TIDs is correct").isEqualTo(mapOfData.get("rejectedTIDs"));
      }
      if (finalMapOfData.containsKey("errorTIDs")) {
        softAssertions.assertThat(invoiceDisputeDetails.getNumberOfErrorTIDs())
            .as("Error TIDs is correct").isEqualTo(mapOfData.get("errorTIDs"));
      }
      softAssertions.assertAll();

    });
  }

  @And("Operator verifies Manual Resolution Disputed Orders in Invoice Dispute page using below data:")
  public void verifyManualResolutionDisputedOrders(Map<String, String> mapOfData) {
    final Map<String, String> finalMapOfData = resolveKeyValues(mapOfData);
    invoiceDisputesDetailPage.inFrame(page -> {
      SoftAssertions softAssertions = new SoftAssertions();
      page.manualResolutionTab.click();
      if (finalMapOfData.containsKey("manualResolutionCount")) {
        softAssertions.assertThat(page.manualResolutionTab.getText())
            .as("Manual resolution count is correct")
            .contains(finalMapOfData.get("manualResolutionCount"));
      }
      if (finalMapOfData.containsKey("trackingId")) {
        List<String> tids = Arrays.stream(finalMapOfData.get("trackingId").split(","))
            .collect(Collectors.toList());
        ListIterator<String> tidIterator = tids.listIterator();
        while (tidIterator.hasNext()) {
          int index = tidIterator.nextIndex();
          String tid = tidIterator.next();
          if (finalMapOfData.containsKey("disputeType")) {
            List<String> disputeTypes = Arrays.stream(finalMapOfData.get("disputeType").split(","))
                .collect(Collectors.toList());
            softAssertions.assertThat(page.getDisputeType(tid)).as("Dispute Type is correct")
                .isEqualTo(disputeTypes.get(index));
          }
          if (finalMapOfData.containsKey("status")) {
            List<String> disputeStatuses = Arrays.stream(finalMapOfData.get("status").split(","))
                .collect(Collectors.toList());
            softAssertions.assertThat(page.getDisputeStatus(tid))
                .as("Dispute Status is correct")
                .isEqualTo(disputeStatuses.get(index));
          }
          if (finalMapOfData.containsKey("financeRevisedDeliveryFee")) {
            List<String> financeRevisedDeliveryFees = Arrays.stream(
                    finalMapOfData.get("financeRevisedDeliveryFee").split(","))
                .collect(Collectors.toList());
            softAssertions.assertThat(page.getDisputeRevisedDeliveryFee(tid))
                .as("Dispute Revised Delivery Fee is correct")
                .isEqualTo(financeRevisedDeliveryFees.get(index));
          }
          if (finalMapOfData.containsKey("financeRevisedCodFee")) {
            List<String> financeRevisedCodFees = Arrays.stream(
                    finalMapOfData.get("financeRevisedCodFee").split(","))
                .collect(Collectors.toList());
            softAssertions.assertThat(page.getDisputeRevisedCODFee(tid))
                .as("Dispute Revised COD Fee is correct")
                .isEqualTo(financeRevisedCodFees.get(index));
          }
          if (finalMapOfData.containsKey("deltaOfOriginalBillAmtAndRevisedAmt")) {
            List<String> deltaOfOriginalBillAmtAndRevisedAmts = Arrays.stream(
                    finalMapOfData.get("deltaOfOriginalBillAmtAndRevisedAmt").split(","))
                .collect(Collectors.toList());
            softAssertions.assertThat(page.getDisputeDeltaAmount(tid))
                .as("Dispute Delta Amount is correct")
                .isEqualTo(deltaOfOriginalBillAmtAndRevisedAmts.get(index));
          }
        }
      }
      softAssertions.assertAll();
    });
  }

  @And("Operator verifies Automatic Resolution Disputed Orders in Invoice Dispute page using below data:")
  public void verifyAutomaticResolutionDisputedOrders(Map<String, String> mapOfData) {
    final Map<String, String> finalMapOfData = resolveKeyValues(mapOfData);
    invoiceDisputesDetailPage.inFrame(page -> {
      SoftAssertions softAssertions = new SoftAssertions();
      page.automaticResolutionTab.click();
      if (finalMapOfData.containsKey("automaticResolutionCount")) {
        softAssertions.assertThat(page.automaticResolutionTab.getText())
            .as("Automatic resolution count is correct")
            .contains(finalMapOfData.get("automaticResolutionCount"));
      }
      if (finalMapOfData.containsKey("trackingId")) {
        List<String> tids = Arrays.stream(finalMapOfData.get("trackingId").split(","))
            .collect(Collectors.toList());
        ListIterator<String> tidIterator = tids.listIterator();
        while (tidIterator.hasNext()) {
          int index = tidIterator.nextIndex();
          String tid = tidIterator.next();
          if (finalMapOfData.containsKey("disputeType")) {
            List<String> disputeTypes = Arrays.stream(finalMapOfData.get("disputeType").split(","))
                .collect(Collectors.toList());
            softAssertions.assertThat(page.getDisputeType(tid)).as("Dispute Type is correct")
                .isEqualTo(disputeTypes.get(index));
          }
          if (finalMapOfData.containsKey("status")) {
            List<String> disputeStatuses = Arrays.stream(finalMapOfData.get("status").split(","))
                .collect(Collectors.toList());
            softAssertions.assertThat(page.getDisputeStatus(tid))
                .as("Dispute Status is correct")
                .isEqualTo(disputeStatuses.get(index));
          }
          if (finalMapOfData.containsKey("financeRevisedWeightInput")) {
            List<String> financeRevisedWeightInput = Arrays.stream(
                    finalMapOfData.get("financeRevisedWeightInput").split(","))
                .collect(Collectors.toList());
            softAssertions.assertThat(page.getDisputeRevisedWeightInput(tid))
                .as("Dispute Revised Weight Input is correct")
                .isEqualTo(financeRevisedWeightInput.get(index));
          }
          if (finalMapOfData.containsKey("financeRevisedDeliveryFee")) {
            List<String> financeRevisedDeliveryFees = Arrays.stream(
                    finalMapOfData.get("financeRevisedDeliveryFee").split(","))
                .collect(Collectors.toList());
            softAssertions.assertThat(page.getDisputeRevisedDeliveryFee(tid))
                .as("Dispute Revised Delivery Fee is correct")
                .isEqualTo(financeRevisedDeliveryFees.get(index));
          }
          if (finalMapOfData.containsKey("deltaOfOriginalBillAmtAndRevisedAmt")) {
            List<String> deltaOfOriginalBillAmtAndRevisedAmts = Arrays.stream(
                    finalMapOfData.get("deltaOfOriginalBillAmtAndRevisedAmt").split(","))
                .collect(Collectors.toList());
            softAssertions.assertThat(page.getDisputeDeltaAmount(tid))
                .as("Dispute Delta Amount is correct")
                .isEqualTo(deltaOfOriginalBillAmtAndRevisedAmts.get(index));
          }
        }
      }
      softAssertions.assertAll();
    });
  }

  @And("Operator verifies Invalid TID Disputed Orders in Invoice Dispute page using below data:")
  public void verifyInvalidTidDisputedOrders(Map<String, String> mapOfData) {
    final Map<String, String> finalMapOfData = resolveKeyValues(mapOfData);
    invoiceDisputesDetailPage.inFrame(page -> {
      SoftAssertions softAssertions = new SoftAssertions();
      page.invalidTIDTab.click();
      if (finalMapOfData.containsKey("invalidTIDCount")) {
        softAssertions.assertThat(page.invalidTIDTab.getText())
            .as("Invalid TID count is correct")
            .contains(finalMapOfData.get("invalidTIDCount"));
      }
      if (finalMapOfData.containsKey("trackingId")) {
        List<String> tids = Arrays.stream(finalMapOfData.get("trackingId").split(","))
            .collect(Collectors.toList());
        ListIterator<String> tidIterator = tids.listIterator();
        while (tidIterator.hasNext()) {
          int index = tidIterator.nextIndex();
          String tid = tidIterator.next();
          if (finalMapOfData.containsKey("disputeType")) {
            List<String> disputeTypes = Arrays.stream(finalMapOfData.get("disputeType").split(","))
                .collect(Collectors.toList());
            softAssertions.assertThat(page.getDisputeType(tid)).as("Dispute Type is correct")
                .isEqualTo(disputeTypes.get(index));
          }
          if (finalMapOfData.containsKey("status")) {
            List<String> disputeStatuses = Arrays.stream(finalMapOfData.get("status").split(","))
                .collect(Collectors.toList());
            softAssertions.assertThat(page.getDisputeStatus(tid))
                .as("Dispute Status is correct")
                .isEqualTo(disputeStatuses.get(index));
          }
          if (finalMapOfData.containsKey("invalidTIDReason")) {
            List<String> invalidTIDReason = Arrays.stream(
                    finalMapOfData.get("invalidTIDReason").split(","))
                .collect(Collectors.toList());
            softAssertions.assertThat(page.getInvalidTIDReason(tid))
                .as("Invalid TID reason is correct")
                .isEqualTo(invalidTIDReason.get(index));
          }
        }
      }
      softAssertions.assertAll();
    });
  }

  @And("Operator verifies Error TID Disputed Orders in Invoice Dispute page using below data:")
  public void verifyErrorTIDDisputedOrders(Map<String, String> mapOfData) {
    final Map<String, String> finalMapOfData = resolveKeyValues(mapOfData);
    invoiceDisputesDetailPage.inFrame(page -> {
      SoftAssertions softAssertions = new SoftAssertions();
      page.errorTIDTab.click();
      if (finalMapOfData.containsKey("errorTIDCount")) {
        softAssertions.assertThat(page.errorTIDTab.getText())
            .as("Error TID count is correct")
            .contains(finalMapOfData.get("errorTIDCount"));
      }
      if (finalMapOfData.containsKey("trackingId")) {
        List<String> tids = Arrays.stream(finalMapOfData.get("trackingId").split(","))
            .collect(Collectors.toList());
        ListIterator<String> tidIterator = tids.listIterator();
        while (tidIterator.hasNext()) {
          int index = tidIterator.nextIndex();
          String tid = tidIterator.next();
          if (finalMapOfData.containsKey("disputeType")) {
            List<String> disputeTypes = Arrays.stream(finalMapOfData.get("disputeType").split(","))
                .collect(Collectors.toList());
            softAssertions.assertThat(page.getDisputeType(tid)).as("Dispute Type is correct")
                .isEqualTo(disputeTypes.get(index));
          }
          if (finalMapOfData.containsKey("status")) {
            List<String> disputeStatuses = Arrays.stream(finalMapOfData.get("status").split(","))
                .collect(Collectors.toList());
            softAssertions.assertThat(page.getDisputeStatus(tid))
                .as("Dispute Status is correct")
                .isEqualTo(disputeStatuses.get(index));
          }
          if (finalMapOfData.containsKey("financeRevisedDeliveryFee")) {
            List<String> financeRevisedDeliveryFees = Arrays.stream(
                    finalMapOfData.get("financeRevisedDeliveryFee").split(","))
                .collect(Collectors.toList());
            softAssertions.assertThat(page.getDisputeRevisedDeliveryFee(tid))
                .as("Dispute Revised Delivery Fee is correct")
                .isEqualTo(financeRevisedDeliveryFees.get(index));
          }
          if (finalMapOfData.containsKey("financeRevisedCodFee")) {
            List<String> financeRevisedCodFees = Arrays.stream(
                    finalMapOfData.get("financeRevisedCodFee").split(","))
                .collect(Collectors.toList());
            softAssertions.assertThat(page.getDisputeRevisedCODFee(tid))
                .as("Dispute Revised COD Fee is correct")
                .isEqualTo(financeRevisedCodFees.get(index));
          }
          if (finalMapOfData.containsKey("deltaOfOriginalBillAmtAndRevisedAmt")) {
            List<String> deltaOfOriginalBillAmtAndRevisedAmts = Arrays.stream(
                    finalMapOfData.get("deltaOfOriginalBillAmtAndRevisedAmt").split(","))
                .collect(Collectors.toList());
            softAssertions.assertThat(page.getDisputeDeltaAmount(tid))
                .as("Dispute Delta Amount is correct")
                .isEqualTo(deltaOfOriginalBillAmtAndRevisedAmts.get(index));
          }
        }
      }
      softAssertions.assertAll();
    });
  }

  @And("Operator click action button in Manual Resolution tab for {value} TID")
  public void clickActionButtonForTI(String value) {
    invoiceDisputesDetailPage.inFrame(page -> {
      page.clickActionButtonInManualResolutionTab(value);
      page.verifyManualResolutionDisputedOrderIsDisplayed();
    });
  }

  @And("Operator click action button in Automatic Resolution tab for {value} TID")
  public void clickActionButtonForAutomaticResolution(String value) {
    invoiceDisputesDetailPage.inFrame(page -> {
      page.automaticResolutionTab.click();
      page.clickActionButtonInAutomaticResolutionTab(value);
      page.verifyManualResolutionDisputedOrderIsDisplayed();
    });
  }

  @And("Operator click action button in Error TID tab for {value} TID")
  public void clickActionButtonForErrorTID(String value) {
    invoiceDisputesDetailPage.inFrame(page -> {
      page.clickActionButtonInErrorTIDTab(value);
      page.verifyManualResolutionDisputedOrderIsDisplayed();
    });
  }

  @Then("Operator verifies Manual Resolution Order and Dispute Information in manual resolution modal as below:")
  public void verifyManualResolutionDisputedOrderInformation(Map<String, String> mapOfData) {
    final Map<String, String> finalMapOfData = resolveKeyValues(mapOfData);
    invoiceDisputesDetailPage.inFrame(page -> {
      SoftAssertions softAssertions = new SoftAssertions();
      if (finalMapOfData.containsKey("tid")) {
        softAssertions.assertThat(
                page.manualResolutionDisputedOrderModal.orderInfoTrackingId.getText())
            .as("TID is correct")
            .contains(finalMapOfData.get("tid"));
      }
      if (finalMapOfData.containsKey("disputeType")) {
        softAssertions.assertThat(
                page.manualResolutionDisputedOrderModal.orderInfoDisputeType.getText())
            .as("Dispute Type is correct")
            .contains(finalMapOfData.get("disputeType"));
      }
      if (finalMapOfData.containsKey("completionDate")) {
        softAssertions.assertThat(
                page.manualResolutionDisputedOrderModal.orderInfoCompletionDate.getText())
            .as("Completion date is correct")
            .contains(finalMapOfData.get("completionDate"));
      }
      if (finalMapOfData.containsKey("rts")) {
        softAssertions.assertThat(page.manualResolutionDisputedOrderModal.orderInfoRts.getText())
            .as("RTS is correct")
            .contains(finalMapOfData.get("rts"));
      }
      if (finalMapOfData.containsKey("originalBilledAmount")) {
        softAssertions.assertThat(
                page.manualResolutionDisputedOrderModal.disputeInfoOriginalBilledAmount.getText())
            .as("NV original billed amt (tax-exclusive) ($) is correct")
            .contains(finalMapOfData.get("originalBilledAmount"));
      }
      if (finalMapOfData.containsKey("codAmount")) {
        softAssertions.assertThat(
                page.manualResolutionDisputedOrderModal.disputeInfoCODAmount.getText())
            .as("COD Amount ($) is correct")
            .contains(finalMapOfData.get("codAmount"));
      }
      softAssertions.assertAll();
    });
  }

  @And("Operator verifies Manual Resolution data in manual resolution modal using data below:")
  public void verifyManualResolution(Map<String, String> mapData) {
    final Map<String, String> finalMapData = resolveKeyValues(mapData);
    invoiceDisputesDetailPage.inFrame(page -> {
      SoftAssertions softAssertions = new SoftAssertions();
      if (finalMapData.containsKey("revisedWeightInput")) {
        softAssertions.assertThat(
                page.manualResolutionDisputedOrderModal.revisedWeightInput.getValue())
            .as("Revised Weight are correct").isEqualTo(finalMapData.get("revisedWeightInput"));
      }
      if (finalMapData.containsKey("originalDeliveryFee")) {
        softAssertions.assertThat(
                page.manualResolutionDisputedOrderModal.originalDeliveryFee.getValue())
            .as("Original Delivery fee is correct")
            .isEqualTo(finalMapData.get("originalDeliveryFee"));
      }
      if (finalMapData.containsKey("originalRTSFee")) {
        softAssertions.assertThat(page.manualResolutionDisputedOrderModal.originalRTSFee.getValue())
            .as("Original RTS fee is correct").isEqualTo(finalMapData.get("originalRTSFee"));
      }
      if (finalMapData.containsKey("originalCODFee")) {
        softAssertions.assertThat(page.manualResolutionDisputedOrderModal.originalCODFee.getValue())
            .as("Original COD fee is correct").isEqualTo(finalMapData.get("originalCODFee"));
      }
      if (finalMapData.containsKey("originalInsuranceFee")) {
        softAssertions.assertThat(
                page.manualResolutionDisputedOrderModal.originalInsuranceFee.getValue())
            .as("Original Insurance fee is correct")
            .isEqualTo(finalMapData.get("originalInsuranceFee"));
      }
      if (finalMapData.containsKey("originalTax")) {
        softAssertions.assertThat(page.manualResolutionDisputedOrderModal.originalTax.getValue())
            .as("Original Tax is correct").isEqualTo(finalMapData.get("originalTax"));
      }
      if (finalMapData.containsKey("originalBillAmount")) {
        softAssertions.assertThat(
                page.manualResolutionDisputedOrderModal.originalBillingAmount.getValue())
            .as("Original Bill amount is correct")
            .isEqualTo(finalMapData.get("originalBillAmount"));
      }
      if (finalMapData.containsKey("revisedDeliveryFee")) {
        softAssertions.assertThat(
                page.manualResolutionDisputedOrderModal.revisedDeliveryFee.getValue())
            .as("Revised Delivery fee is correct")
            .isEqualTo(finalMapData.get("revisedDeliveryFee"));
      }
      if (finalMapData.containsKey("revisedRTSFee")) {
        softAssertions.assertThat(page.manualResolutionDisputedOrderModal.revisedRTSFee.getValue())
            .as("Revised RTS fee is correct").isEqualTo(finalMapData.get("revisedRTSFee"));
      }
      if (finalMapData.containsKey("revisedCODFee")) {
        softAssertions.assertThat(page.manualResolutionDisputedOrderModal.revisedCODFee.getValue())
            .as("Revised COD fee is correct").isEqualTo(finalMapData.get("revisedCODFee"));
      }
      if (finalMapData.containsKey("revisedInsuranceFee")) {
        softAssertions.assertThat(
                page.manualResolutionDisputedOrderModal.revisedInsuranceFee.getValue())
            .as("Revised Insurance fee is correct")
            .isEqualTo(finalMapData.get("revisedInsuranceFee"));
      }
      if (finalMapData.containsKey("revisedTax")) {
        softAssertions.assertThat(page.manualResolutionDisputedOrderModal.revisedTax.getValue())
            .as("Revised tax is correct").isEqualTo(finalMapData.get("revisedTax"));
      }
      if (finalMapData.containsKey("revisedTotalBillAmount")) {
        softAssertions.assertThat(
                page.manualResolutionDisputedOrderModal.revisedTotalBillAmount.getValue())
            .as("Revised Total Bill amount is correct")
            .isEqualTo(finalMapData.get("revisedTotalBillAmount"));
      }
      if (finalMapData.containsKey("deltaAmount")) {
        softAssertions.assertThat(page.manualResolutionDisputedOrderModal.deltaAmount.getValue())
            .as("Delta between original bill amount and revised amount is correct")
            .isEqualTo(finalMapData.get("deltaAmount"));
      }
      if (finalMapData.containsKey("remarks")) {
        softAssertions.assertThat(page.manualResolutionDisputedOrderModal.remarks.getText())
            .as("Remarks are correct").isEqualTo(finalMapData.get("remarks"));
      }
      if (finalMapData.containsKey("customRemarkInput")) {
        softAssertions.assertThat(
                page.manualResolutionDisputedOrderModal.customRemarksInput.getValue())
            .as("Custom remarks are correct").isEqualTo(finalMapData.get("customRemarkInput"));
      }
      if (finalMapData.containsKey("internalCommentary")) {
        softAssertions.assertThat(
                page.manualResolutionDisputedOrderModal.internalCommentary.getValue())
            .as("internal Commentary is correct").isEqualTo(finalMapData.get("internalCommentary"));
      }
      softAssertions.assertAll();
    });
  }

  @Then("Operator clicks accept button")
  public void clickAcceptButton() {
    invoiceDisputesDetailPage.inFrame(page -> {
      page.manualResolutionDisputedOrderModal.acceptRadiobutton.check();
    });
  }

  @Then("Operator clicks reject button")
  public void clickRejectButton() {
    invoiceDisputesDetailPage.inFrame(page -> {
      page.manualResolutionDisputedOrderModal.rejectRadiobutton.check();
    });
  }

  @Then("Operator clicks Manual adjustment button")
  public void clickManualAdjustmentButton() {
    invoiceDisputesDetailPage.inFrame(page -> {
      page.manualResolutionDisputedOrderModal.manualAdjustmentButton.click();
    });
  }

  @And("Operator clicks calculate button")
  public void clickCalculateButton() {
    invoiceDisputesDetailPage.inFrame(page -> {
      page.manualResolutionDisputedOrderModal.calculateButton.click();
    });
  }

  @And("Operator select remark as {string}")
  public void clickRejectButton(String remark) {
    invoiceDisputesDetailPage.inFrame(page -> {
      page.manualResolutionDisputedOrderModal.remark.selectValue(remark);
    });
  }

  @And("Operator enters Manual Resolution data using data below:")
  public void enterRevisedResolutionData(Map<String, String> mapData) {
    final Map<String, String> finalMapData = resolveKeyValues(mapData);
    invoiceDisputesDetailPage.inFrame(page -> {
      if (finalMapData.containsKey("revisedWeightInput")) {
        page.manualResolutionDisputedOrderModal.revisedWeightInput.setValue(
            finalMapData.get("revisedWeightInput"));
      }
      if (finalMapData.containsKey("originalDeliveryFee")) {
        page.manualResolutionDisputedOrderModal.originalDeliveryFee.forceClear();
        page.manualResolutionDisputedOrderModal.originalDeliveryFee.setValue(
            finalMapData.get("originalDeliveryFee"));
      }
      if (finalMapData.containsKey("originalRTSFee")) {
        page.manualResolutionDisputedOrderModal.originalRTSFee.forceClear();
        page.manualResolutionDisputedOrderModal.originalRTSFee.setValue(
            finalMapData.get("originalRTSFee"));
      }
      if (finalMapData.containsKey("originalCODFee")) {
        page.manualResolutionDisputedOrderModal.originalCODFee.forceClear();
        page.manualResolutionDisputedOrderModal.originalCODFee.setValue(
            finalMapData.get("originalCODFee"));
      }
      if (finalMapData.containsKey("originalInsuranceFee")) {
        page.manualResolutionDisputedOrderModal.originalInsuranceFee.forceClear();
        page.manualResolutionDisputedOrderModal.originalInsuranceFee.setValue(
            finalMapData.get("originalInsuranceFee"));
      }
      if (finalMapData.containsKey("originalTax")) {
        page.manualResolutionDisputedOrderModal.originalTax.forceClear();
        page.manualResolutionDisputedOrderModal.originalTax.setValue(
            finalMapData.get("originalTax"));
      }
      if (finalMapData.containsKey("originalBillAmount")) {
        page.manualResolutionDisputedOrderModal.originalBillingAmount.forceClear();
        ((JavascriptExecutor) getWebDriver()).executeScript("arguments[0].value=arguments[1]",
            page.manualResolutionDisputedOrderModal.originalBillingAmount.getWebElement(),
            finalMapData.get("originalBillAmount"));
      }
      if (finalMapData.containsKey("revisedDeliveryFee")) {
        page.manualResolutionDisputedOrderModal.revisedDeliveryFee.forceClear();
        page.manualResolutionDisputedOrderModal.revisedDeliveryFee.setValue(
            finalMapData.get("revisedDeliveryFee"));
      }
      if (finalMapData.containsKey("revisedRTSFee")) {
        page.manualResolutionDisputedOrderModal.revisedRTSFee.setValue(
            finalMapData.get("revisedRTSFee"));
      }
      if (finalMapData.containsKey("revisedCODFee")) {
        page.manualResolutionDisputedOrderModal.revisedCODFee.setValue(
            finalMapData.get("revisedCODFee"));
      }
      if (finalMapData.containsKey("revisedInsuranceFee")) {
        page.manualResolutionDisputedOrderModal.revisedInsuranceFee.setValue(
            finalMapData.get("revisedInsuranceFee"));
      }
      if (finalMapData.containsKey("revisedTax")) {
        page.manualResolutionDisputedOrderModal.revisedTax.forceClear();
        page.manualResolutionDisputedOrderModal.revisedTax.setValue(finalMapData.get("revisedTax"));
      }
      if (finalMapData.containsKey("remarks")) {
        page.manualResolutionDisputedOrderModal.remark.selectValue(finalMapData.get("remarks"));
      }
      if (finalMapData.containsKey("customRemarkInput")) {
        page.manualResolutionDisputedOrderModal.customRemarksInput.setValue(
            finalMapData.get("customRemarkInput"));
      }
      if (finalMapData.containsKey("internalCommentary")) {
        page.manualResolutionDisputedOrderModal.internalCommentary.forceClear();
        page.manualResolutionDisputedOrderModal.internalCommentary.setValue(
            finalMapData.get("internalCommentary"));
      }
    });
  }

  @And("Operator clicks save and exit button")
  public void clckSaveAndExitButton() {
    invoiceDisputesDetailPage.inFrame(page -> {
      page.manualResolutionDisputedOrderModal.saveAndExitButton.click();
      page.manualResolutionDisputedOrderModal.waitUntilInvisible();
    });
  }

  @And("Operator clicks save and confirm button")
  public void clickSaveAndConfirmButton() {
    invoiceDisputesDetailPage.inFrame(page -> {
      page.manualResolutionDisputedOrderModal.saveAndConfirmButton.click();
      page.manualResolutionDisputedOrderModal.waitUntilInvisible();
    });
  }

  @And("Operator clicks save and next button")
  public void clickSaveAndNextButton() {
    invoiceDisputesDetailPage.inFrame(page -> {
      page.manualResolutionDisputedOrderModal.saveAndNextButton.waitUntilClickable();
      page.manualResolutionDisputedOrderModal.saveAndNextButton.click();
      page.manualResolutionDisputedOrderModal.waitUntilLoaded();
    });
  }

  @And("Operator close the invoice dispute manual resolution modal")
  public void closeInvoiceDisputeModal() {
    invoiceDisputesDetailPage.inFrame(page -> {
      page.manualResolutionDisputedOrderModal.closeButton.click();
      page.manualResolutionDisputedOrderModal.closeConfirmButton.click();
      page.manualResolutionDisputedOrderModal.waitUntilInvisible();
    });
  }

  @And("Operator close invoice dispute case")
  public void closeInvoiceDisputeCase() {
    invoiceDisputesDetailPage.inFrame(page -> {
      page.closeCase.click();
      page.confirmCloseCase.click();
    });
  }

  @And("Operator click shipper ID hyperlink {string}")
  public void clickShipperIdHyperlink(String Url) {
    invoiceDisputesDetailPage.inFrame(page -> {
      page.shipperIdHyperlink.click();
      Assertions.assertThat(page.getCurrentUrl()).as("Edit shipper page URL is correct")
          .isEqualTo(Url);
    });
  }

  @And("Operator click TID hyperlink {string}")
  public void clickTidHyperlink(String Url) {
    invoiceDisputesDetailPage.inFrame(page -> {
      page.manualResolutionDisputedOrderModal.orderInfoTrackingId.click();
      Assertions.assertThat(page.getCurrentUrl()).as("Order detail page URL is correct")
          .isEqualTo(Url);
    });
  }
}