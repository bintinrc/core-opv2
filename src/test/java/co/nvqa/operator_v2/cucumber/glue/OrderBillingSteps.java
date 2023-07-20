package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.util.NvTestRuntimeException;
import co.nvqa.operator_v2.selenium.elements.ant.AntNotification;
import co.nvqa.operator_v2.selenium.page.OrderBillingPage;
import io.cucumber.guice.ScenarioScoped;
import io.cucumber.java.en.And;
import io.cucumber.java.en.Given;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import java.io.File;
import java.time.format.DateTimeParseException;
import java.util.Map;
import java.util.Objects;
import java.util.stream.Collectors;
import java.util.stream.IntStream;
import org.assertj.core.api.Assertions;
import org.assertj.core.api.SoftAssertions;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import static co.nvqa.common.utils.StandardTestUtils.createFile;


/**
 * @author Kateryna Skakunova
 */
@ScenarioScoped
public class OrderBillingSteps extends AbstractSteps {

  private static final Logger LOGGER = LoggerFactory.getLogger(OrderBillingSteps.class);

  private OrderBillingPage orderBillingPage;

  public OrderBillingSteps() {
  }

  @Override
  public void init() {
    orderBillingPage = new OrderBillingPage(getWebDriver());
    orderBillingPage.switchToIframe();
    orderBillingPage.waitUntilLoaded();
  }

  @Given("Operator generates success billings using data below:")
  public void operatorGeneratesSuccessBillingsForData(Map<String, String> mapOfData) {
    setOrderBillingData(mapOfData);
    orderBillingPage.clickGenerateSuccessBillingsButton();
    orderBillingPage.verifyNoErrorsAvailable();
  }

  @Given("Operator generates success billings with more than 1000 shippers using data below:")
  public void operatorGeneratesSuccessBillingsFor1000ShippersData(Map<String, String> mapOfData) {
    setOrderBillingData(mapOfData);
  }


  private void setOrderBillingData(Map<String, String> mapOfData) {
    try {
      if (Objects.nonNull(mapOfData.get("startDate"))) {
        String startDate = mapOfData.get("startDate");
        put(KEY_ORDER_BILLING_START_DATE, startDate);
        orderBillingPage.selectStartDate(startDate);
      }
      if (Objects.nonNull(mapOfData.get("endDate"))) {
        String endDate = mapOfData.get("endDate");
        put(KEY_ORDER_BILLING_END_DATE, endDate);
        orderBillingPage.selectEndDate(endDate);
      }
      if (Objects.nonNull(mapOfData.get("shipper"))) {
        String shipper = mapOfData.get("shipper");
        orderBillingPage.setSpecificShipper(shipper);
        put(KEY_ORDER_BILLING_SHIPPER, Long.valueOf(shipper));

      }
      if (Objects.nonNull(mapOfData.get("uploadCsv"))) {
        String shipperIds = mapOfData.get("uploadCsv");
        if (shipperIds.equalsIgnoreCase("generatedCsv")) {
          orderBillingPage.uploadCsvShippers(get(KEY_ORDER_BILLING_UPLOAD_CSV_FILE));
        } else {
          File csvFile = createFile("shipper-id-upload.csv", shipperIds);
          LOGGER.info("Path of the created file : " + csvFile.getAbsolutePath());
          int countOfShipperIds = shipperIds.split(",").length;
          orderBillingPage.uploadCsvShippersAndVerifyToastMsg(csvFile, "Upload success.",
              f("Extracted %s Shipper IDs.", countOfShipperIds));
        }
      }
      if (Objects.nonNull(mapOfData.get("parentShipper"))) {
        String parentShipper = mapOfData.get("parentShipper");
        orderBillingPage.setParentShipper(parentShipper);
        put(KEY_ORDER_BILLING_SHIPPER, Long.valueOf(parentShipper));
      }
      if (Objects.nonNull(mapOfData.get("scriptId"))) {
        String scriptId = mapOfData.get("scriptId");
        orderBillingPage.setScriptId(scriptId);
      }
      String generateFile = mapOfData.get("generateFile");
      pause(10);
      if (Objects.nonNull(generateFile)) {
        orderBillingPage.tickGenerateTheseFilesOption(generateFile);
        if (generateFile.contains("Orders consolidated by shipper")) {
          put(KEY_ORDER_BILLING_REPORT_TYPE, "SHIPPER");
        } else if (generateFile.contains("All orders grouped by shipper")) {
          Assertions.assertThat(orderBillingPage.getAggregatedInfoMsg())
              .as("Aggregated Ino msg is available")
              .isEqualTo("* Customized Template is not supported for aggregated report type.");
        }
      }
      String csvFileTemplate = mapOfData.get("csvFileTemplate");
      if (Objects.nonNull(csvFileTemplate)) {
        retryIfRuntimeExceptionOccurred(
            () -> orderBillingPage.setCsvFileTemplateName(csvFileTemplate), 40);
      }
      String emailAddress = mapOfData.get("emailAddress");
      if (Objects.nonNull(emailAddress)) {
        orderBillingPage.setEmailAddress(emailAddress);
      }
    } catch (DateTimeParseException e) {
      throw new NvTestRuntimeException("Failed to parse date.", e);
    }
  }

  @Then("Operator tries to upload a PDF and verifies that any other file except csv is not allowed")
  public void operatorTriesToUploadAPDFAndVerifiesThatAnyOtherFileExceptCsvIsNotAllowed() {
    String pdfFileName = "shipper-id-upload.pdf";
    File pdfFile = createFile(pdfFileName, "TEST");
    orderBillingPage.uploadCsvShippersAndVerifyToastMsg(pdfFile, "Upload failed",
        "Please select only .csv file.");
  }

  @Then("Operator chooses Select by Parent Shippers option and search for normal shipper ID like below:")
  public void operatorChoosesSelectByParentShippersOptionAndSearchForNormalShipperIDLikeBelow(
      String shipperId) {
    orderBillingPage.setInvalidParentShipper(shipperId);
  }

  @Then("Operator verifies {string} is selected in Customized CSV File Template")
  public void operatorVerifiesIsSelectedInCustomizedCSVFileTemplate(String value) {
    orderBillingPage.waitUntilLoaded();
    Assertions.assertThat(orderBillingPage.getCsvFileTemplateName())
        .as("file template name is selected and shown").isEqualTo(value);
  }

  @Then("Operator verifies that error toast is displayed on Order Billing page:")
  public void operatorVerifiesThatErrorToastDisplayedOnOrderBillingPage(
      Map<String, String> mapOfData) {
    String errorTitle = mapOfData.get("top");
    String errorMessage = mapOfData.get("bottom");

    retryIfAssertionErrorOccurred(
        () -> Assertions.assertThat(orderBillingPage.noticeNotifications.get(0).message.getText())
            .as("Notifications are available").isNotEmpty(), "Get Notifications",
        500, 3);
    AntNotification notification = orderBillingPage.noticeNotifications.get(0);
    SoftAssertions softAssertions = new SoftAssertions();
    softAssertions.assertThat(notification.message.getText()).as("Toast top text is correct")
        .isEqualTo(errorTitle);
    softAssertions.assertThat(notification.description.getText()).as("Toast bottom text is correct")
        .contains(errorMessage);
    softAssertions.assertAll();
  }

  @Then("Operator verifies that info pop up is displayed with message {string}")
  public void operatorVerifiesThatInfoPopUpIsDisplayedWithMessage(String expectedInfoMsg) {
    String actualInfoMsg = orderBillingPage.infoMessage.getText();
    Assertions.assertThat(actualInfoMsg).as("info pop up message is correct")
        .isEqualTo(expectedInfoMsg);
  }

  @When("Operator selects Order Billing data as below")
  public void operatorSelectsStartDateAndEndDateAsBelow(Map<String, String> mapOfData) {
    setOrderBillingData(mapOfData);
  }

  @Then("Operator clicks Generate Success Billing Button")
  public void operatorClicksGenerateSuccessBillingButton() {
    orderBillingPage.clickGenerateSuccessBillingsButton();
    takesScreenshot();
  }

  @Then("Operator verifies Generate Success Billings button is disabled")
  public void operatorVerifiesGenerateSuccessBillingsButtonIsDisabled() {
    Assertions.assertThat(orderBillingPage.isGenerateSuccessBillingsButtonEnabled())
        .as("Generate Success Billings button is disabled").isFalse();
  }

  @When("Operator generates CSV file with {int} shippers")
  public void operatorGeneratesCSVFileWithShippers(int shipperCount) {
    final String shipperIds = IntStream.range(1, shipperCount + 1).mapToObj(Integer::toString)
        .collect(Collectors.joining(","));

    final File csvFile = createFile("shipper-id-upload.csv", shipperIds);
    LOGGER.info("Path of the created file : " + csvFile.getAbsolutePath());
    put(KEY_ORDER_BILLING_UPLOAD_CSV_FILE, csvFile);
  }

  @Then("Operator chooses {string} option and does not input a shipper ID")
  public void operatorChoosesSelectByParentShippersOptionAndDoesNotInputAShipperID(String option) {
    if (option.equalsIgnoreCase("Select by Parent Shipper")) {
      orderBillingPage.setEmptyParentShipper();
    } else if (option.equalsIgnoreCase("Selected Shipper")) {
      orderBillingPage.setEmptySelectedShipper();
    } else if (option.equalsIgnoreCase("Select by script ID")) {
      orderBillingPage.setEmptyScriptId();
    } else {
      throw new NvTestRuntimeException("Please input correct option");
    }
  }

  @Then("Operator verifies {string} is not available in template selector drop down menu")
  public void operatorVerifiesIsNotAvailableInTemplateSelectorDropDownMenu(String template) {
    Assertions.assertThat(orderBillingPage.csvFileTemplate.hasItem(template))
        .as(f(" Template with name : %s is not available in the dropdown ", template)).isTrue();
  }

  @Then("Operator verifies error msg {string} in Order Billing Page")
  public void operatorVerifiesErrorMsgInOrderBillingPage(String errorMsg) {
    Assertions.assertThat(orderBillingPage.verifyErrorMsgIsVisible(errorMsg))
        .as("Error message is visible").isTrue();

  }

  @When("Operator searches for script id {string} using Select by Script Id")
  public void operatorSearchesForScriptIdUsingSelectByScriptId(String scriptIdAndName) {
    try {
      orderBillingPage.scriptId.click();
      orderBillingPage.scriptIdInput.selectValue(scriptIdAndName);
    } catch (Exception ex) {
      LOGGER.info("Element not found");
    }
  }

  @And("Operator verifies No Data is displayed in the order billing page")
  public void operatorVerifiesNoResultsFoundIsDisplayed() {
    orderBillingPage.noDataFound.waitUntilVisible(3);
    Assertions.assertThat(orderBillingPage.noDataFound.isDisplayed())
        .as("No Results Found Message is not displayed").isTrue();
  }
}
