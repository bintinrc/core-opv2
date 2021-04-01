package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.util.NvTestRuntimeException;
import co.nvqa.operator_v2.selenium.page.OrderBillingPage;
import cucumber.api.java.en.Given;
import cucumber.api.java.en.Then;
import cucumber.runtime.java.guice.ScenarioScoped;
import java.text.ParseException;
import java.util.Map;
import java.util.Objects;


/**
 * @author Kateryna Skakunova
 */
@ScenarioScoped
public class OrderBillingSteps extends AbstractSteps {

  private OrderBillingPage orderBillingPage;

  public OrderBillingSteps() {
  }

  @Override
  public void init() {
    orderBillingPage = new OrderBillingPage(getWebDriver());
  }

  @Given("^Operator generates success billings using data below:$")
  public void operatorGeneratesSuccessBillingsForData(Map<String, String> mapOfData) {
    try {
      if (Objects.nonNull(mapOfData.get("startDate"))) {
        String startDate = mapOfData.get("startDate");
        put(KEY_ORDER_BILLING_START_DATE, startDate);
        orderBillingPage.selectStartDate(YYYY_MM_DD_SDF.parse(startDate));
      }
      if (Objects.nonNull(mapOfData.get("endDate"))) {
        String endDate = mapOfData.get("endDate");
        put(KEY_ORDER_BILLING_END_DATE, endDate);
        orderBillingPage.selectEndDate(YYYY_MM_DD_SDF.parse(endDate));
      }
    } catch (ParseException e) {
      throw new NvTestRuntimeException("Failed to parse date.", e);
    }
    if (Objects.nonNull(mapOfData.get("shipper"))) {
      String shipper = mapOfData.get("shipper");
      orderBillingPage.setSpecificShipper(shipper);
      put(KEY_ORDER_BILLING_SHIPPER_NAME, shipper);

    }
    if (Objects.nonNull(mapOfData.get("uploadCsv"))) {
      String shipperIds = mapOfData.get("uploadCsv");
      orderBillingPage.uploadCsvShippers(shipperIds);
    }
    if (Objects.nonNull(mapOfData.get("parentShipper"))) {
      String parentShipper = mapOfData.get("parentShipper");
      orderBillingPage.setParentShipper(parentShipper);
      put(KEY_ORDER_BILLING_SHIPPER_NAME, parentShipper);
    }
    String generateFile = mapOfData.get("generateFile");
    if (Objects.nonNull(generateFile)) {
      if (generateFile.contains("Orders consolidated by shipper")) {
        put(KEY_ORDER_BILLING_REPORT_TYPE, "SHIPPER");
      }
      orderBillingPage.tickGenerateTheseFilesOption(generateFile);
    }
    if (Objects.nonNull(mapOfData.get("emailAddress"))) {
      orderBillingPage.setEmailAddress(mapOfData.get("emailAddress"));
    }

    orderBillingPage.clickGenerateSuccessBillingsButton();
    orderBillingPage.verifyNoErrorsAvailable();
  }

  @Then("Operator tries to upload a PDF and verifies that any other file except csv is not allowed")
  public void operatorTriesToUploadAPDFAndVerifiesThatAnyOtherFileExceptCsvIsNotAllowed() {
    orderBillingPage.uploadPDFShippersAndVerifyErrorMsg();
  }

  @Then("Operator chooses Select by Parent Shippers option and search for normal shipper ID like below:")
  public void operatorChoosesSelectByParentShippersOptionAndSearchForNormalShipperIDLikeBelow(
      String shipperId) {
    orderBillingPage.setInvalidParentShipper(shipperId);
  }

  @Then("Operator verifies that the name of normal shipper suggestion is not displayed")
  public void operatorVerifiesThatTheNameOfNormalShipperSuggestionIsNotDisplayed() {
    assertThat("The displayed error msg does not match with the expected error msg",
        orderBillingPage.getNoParentErrorMsg(), containsString("No Parent Shipper matching"));
  }

}
