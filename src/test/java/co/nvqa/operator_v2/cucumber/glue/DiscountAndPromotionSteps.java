package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.common.utils.StandardTestUtils;
import co.nvqa.commons.model.shipper.v2.Shipper;
import co.nvqa.commons.support.DateUtil;
import co.nvqa.commons.util.NvTestRuntimeException;
import co.nvqa.operator_v2.model.Campaign;
import co.nvqa.operator_v2.selenium.page.CampaignCreateEditPage;
import co.nvqa.operator_v2.selenium.page.DiscountAndPromotionPage;
import io.cucumber.datatable.DataTable;
import io.cucumber.java.en.And;
import io.cucumber.java.en.Given;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import java.io.File;
import java.text.ParseException;
import java.util.List;
import java.util.Objects;
import org.apache.commons.lang3.StringUtils;
import org.assertj.core.api.Assertions;
import org.assertj.core.api.SoftAssertions;
import org.jetbrains.annotations.NotNull;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import static co.nvqa.commons.support.DateUtil.DATE_FORMAT;
import static co.nvqa.commons.support.DateUtil.DATE_FORMAT_SNS_1;

public class DiscountAndPromotionSteps extends AbstractSteps {

  private DiscountAndPromotionPage discountAndPromotionsPage;
  private CampaignCreateEditPage campaignCreateEditPage;
  public static final String CSV_FILENAME_PATTERN = "automation_upload_shippers.csv";
  private static final Logger LOGGER = LoggerFactory.getLogger(DiscountAndPromotionSteps.class);

  @Override
  public void init() {
    discountAndPromotionsPage = new DiscountAndPromotionPage(getWebDriver());
    campaignCreateEditPage = new CampaignCreateEditPage(getWebDriver());
  }

  @Given("Operator click Create new campaign button in Discounts & Promotion Page")
  public void operatorClickCreateNewCampaignButton() {
    discountAndPromotionsPage.inFrame(page -> {
      discountAndPromotionsPage.clickCreateNewCampaignButton();
    });
  }

  @Then("Operator enter campaign details using data below:")
  public void operatorEnterCampaignDetails(DataTable dt) {
    List<Campaign> campaignDetails = convertDataTableToListWhereDataTableHasListOfData(dt,
        Campaign.class);
    Campaign campaignDetail = campaignDetails.get(0);
    put(KEY_OBJECT_OF_CREATED_CAMPAIGN, campaignDetail);
    put(KEY_CAMPAIGN_NAME_OF_CREATED_CAMPAIGN, campaignDetail.getCampaignName());
    setCampaignData(campaignDetail);
  }

  @Then("Operator enter {string} campaign rule using data below:")
  public void operatorEnterCampaignRule(String row, DataTable dt) {
    List<Campaign> campaignRules = convertDataTableToListWhereDataTableHasListOfData(dt,
        Campaign.class);
    Campaign campaignRule = campaignRules.get(0);
    put(KEY_OBJECT_OF_CREATED_CAMPAIGN, campaignRules);
    setCampaignRuleData(campaignRule, Integer.valueOf(row) - 1);
  }

  private void setCampaignData(Campaign campaign) {
    campaignCreateEditPage.inFrame(page -> {
      String value;
      value = campaign.getCampaignName();
      if (Objects.nonNull(value)) {
        page.enterCampaignName(value);
      }
      value = campaign.getCampaignDescription();
      if (Objects.nonNull(value)) {
        page.enterCampaignDescription(value);
      }
      value = campaign.getEndDate();
      if (Objects.nonNull(value)) {
        page.endDate.setFromDate(value);
      }
      value = campaign.getStartDate();
      if (Objects.nonNull(value)) {
        page.startDate.setFromDate(value);
      }
      value = campaign.getDiscountOperator();
      if (Objects.nonNull(value)) {
        page.selectDiscountOperator(value);
      }
      // perform the + Add button
      performRulesAddButton(campaign, page);

      List<String> serviceType = campaign.getServiceType();
      if (Objects.nonNull(serviceType)) {
        page.selectServiceType(serviceType, 0);
      }
      List<String> serviceLevel = campaign.getServiceLevel();
      if (Objects.nonNull(serviceLevel)) {
        page.selectServiceLevel(serviceLevel, 0);
      }
      List<String> discountValue = campaign.getDiscountValue();
      if (Objects.nonNull(discountValue)) {
        page.enterDiscountValue(discountValue, 0);
      }
    });
  }

  private void setCampaignRuleData(Campaign campaign, int row) {
    campaignCreateEditPage.inFrame(page -> {
      String value;
      value = campaign.getCampaignName();

      List<String> serviceType = campaign.getServiceType();
      if (Objects.nonNull(serviceType)) {
        page.selectServiceType(serviceType, row);
      }
      List<String> serviceLevel = campaign.getServiceLevel();
      if (Objects.nonNull(serviceLevel)) {
        page.selectServiceLevel(serviceLevel, row);
      }
      List<String> discountValue = campaign.getDiscountValue();
      if (Objects.nonNull(discountValue)) {
        page.enterDiscountValue(discountValue, row);
      }
    });
  }

  private void getCampaignData() throws ParseException {
    Campaign campaignDetail = new Campaign();
    campaignDetail.setCampaignName(campaignCreateEditPage.getCampaignName());
    if (!campaignCreateEditPage.getCampaignDescription().isEmpty()) {
      campaignDetail.setCampaignDescription(campaignCreateEditPage.getCampaignDescription());
    }
    String startDate = DateUtil.formatDate(campaignCreateEditPage.getStartDate(), DATE_FORMAT_SNS_1,
        DATE_FORMAT);
    campaignDetail.setStartDate(startDate);
    String endDate = DateUtil.formatDate(campaignCreateEditPage.getEndDate(), DATE_FORMAT_SNS_1,
        DATE_FORMAT);
    campaignDetail.setEndDate(endDate);
    campaignDetail.setServiceType(campaignCreateEditPage.getServiceType());
    campaignDetail.setServiceLevel(campaignCreateEditPage.getServiceLevel());
    campaignDetail.setDiscountValue(campaignCreateEditPage.getDiscountValue());
    campaignDetail.setDiscountOperator(campaignCreateEditPage.getDiscountOperator());
    put(KEY_OBJECT_OF_GET_CAMPAIGN, campaignDetail);
  }

  private void getCampaignRuleData() throws ParseException {
    Campaign campaignRule = new Campaign();
    campaignRule.setServiceType(campaignCreateEditPage.getServiceType());
    campaignRule.setServiceLevel(campaignCreateEditPage.getServiceLevel());
    campaignRule.setDiscountValue(campaignCreateEditPage.getDiscountValue());
    put(KEY_OBJECT_OF_GET_CAMPAIGN, campaignRule);
  }

  private void performRulesAddButton(Campaign campaign, CampaignCreateEditPage page) {
    if (campaign.getServiceType() == null) {
      if (campaign.getServiceLevel() != null) {
        page.clickAddButton(campaign.getServiceLevel());
      } else {
        if (campaign.getDiscountValue() != null) {
          page.clickAddButton(campaign.getDiscountValue());
        }
      }
    } else {
      page.clickAddButton(campaign.getServiceType());
    }
  }

  @When("Operator clicks on publish button")
  public void operatorClicksOnPublishButton() {
    campaignCreateEditPage.inFrame(page -> {
      campaignCreateEditPage.clickPublishButton();
    });
  }

  @When("Operator clicks on cancel button")
  public void operatorClicksOnCancelButton() {
    campaignCreateEditPage.inFrame(page -> {
      campaignCreateEditPage.clickCancelButton();
    });
  }

  @Then("Operator verifies toast message {string} in Campaign Page")
  public void operatorVerifiesToastMessageInCampaignPage(String expectedToastMsg) {
    campaignCreateEditPage.inFrame(page -> {
      String validateNotificationText = page.getNotificationMessageText();
      LOGGER.info(validateNotificationText);
      Assertions.assertThat(validateNotificationText).as("Expected Toast Msg is visible")
          .isEqualTo(expectedToastMsg);
    });
  }

  @Then("Operator verifies toast error for duplicate campaigns")
  public void operatorVerifiesToastErrorForDuplicateCampaigns() {
    campaignCreateEditPage.waitUntilVisibilityAndGetErrorToastData();
    String errorTitle = "Network Request Error";
    boolean isErrorFound;
    isErrorFound = campaignCreateEditPage.toastErrors.stream().anyMatch(toastError ->
        StringUtils.equalsIgnoreCase(toastError.toastTop.getText(), errorTitle));
    Assertions.assertThat(isErrorFound).as("Error message is exist").isTrue();
  }

  @Then("Operator verifies the published campaign page")
  public void operatorVerifiesTheCampaignPage() {
    campaignCreateEditPage.inFrame(page -> {
      try {
        getCampaignData();
      } catch (ParseException e) {
        throw new NvTestRuntimeException(e);
      }
      put(KEY_CAMPAIGN_ID_OF_CREATED_CAMPAIGN, page.getCampaignId());
      Assertions.assertThat(page.isCampaignIdDisplayed()).as("Campaign Id is displayed")
          .isTrue();
      Assertions.assertThat(page.isDownloadButtonDisplayed()).as("Download button is displayed")
          .isTrue();
      Assertions.assertThat(page.isShippersAddButtonDisplayed()).as("Add button is displayed")
          .isTrue();
      Assertions.assertThat(page.isShippersRemoveButtonDisplayed())
          .as("Remover button is displayed")
          .isTrue();
      Assertions.assertThatObject(get(KEY_OBJECT_OF_GET_CAMPAIGN)).usingRecursiveComparison()
          .ignoringCollectionOrder()
          .isEqualTo(get(KEY_OBJECT_OF_CREATED_CAMPAIGN))
          .as("Campaign Details are matched");

    });
  }

  @Then("Operator verifies {string} the published campaign rule")
  public void operatorVerifiesTheCampaignRule(String row) {
    campaignCreateEditPage.inFrame(page -> {
      List<Campaign> updatedCampaign = get(KEY_OBJECT_OF_CREATED_CAMPAIGN);
      Assertions.assertThat(campaignCreateEditPage.getServiceType().get(Integer.valueOf(row) - 1))
          .contains(updatedCampaign.get(0).getServiceType().get(0))
          .as(f("Service Type %s is present", updatedCampaign.get(0).getServiceType().get(0)));
      Assertions.assertThat(
              campaignCreateEditPage.getServiceLevel().get(Integer.valueOf(row) - 1))
          .contains(updatedCampaign.get(0).getServiceLevel().get(0))
          .as(f("Service Level %s is present", updatedCampaign.get(0).getServiceLevel().get(0)));
      Assertions.assertThat(
              campaignCreateEditPage.getDiscountValue().get(Integer.valueOf(row) - 1))
          .contains(updatedCampaign.get(0).getDiscountValue().get(0))
          .as(f("Discount Value %s is present",
              updatedCampaign.get(0).getDiscountValue().get(0)));

    });
  }

  @Then("Operator verifies campaign is not created")
  public void operatorVerifiesCampaignIsNotAdded() {
    discountAndPromotionsPage.inFrame(page -> {
      Campaign campaignDetail = get(KEY_OBJECT_OF_CREATED_CAMPAIGN);
      Assertions.assertThat(
              page.isCampaignIsDisplayed(campaignDetail.getCampaignName()))
          .isFalse().as("Campaign is displayed");
    });
  }

  @Then("Operator verifies campaign name is not exceeded 50")
  public void operatorVerifiesCampaignNameIsNotExceeded50() {
    campaignCreateEditPage.inFrame(page -> {
      Assertions.assertThat(page.getCampaignName().length()).as("Campaign name is exceeded 50")
          .isEqualTo(50);
    });
  }

  @Then("Operator verifies campaign description is not exceeded 255")
  public void operatorVerifiesCampaignDescriptionIsNotExceeded255() {
    campaignCreateEditPage.inFrame(page -> {
      Assertions.assertThat(page.getCampaignDescription().length())
          .as("Campaign description is exceeded 255").isEqualTo(255);
    });
  }

  @Then("Operator verifies validation error message for {string}")
  public void operatorVerifiesCampaignValidationErrorMessage(String field) {
    campaignCreateEditPage.inFrame(page -> {
      String validation_error = null;
      switch (field) {
        case "campaign-name-empty":
          validation_error = page.getCampaignNameError();
          Assertions.assertThat(validation_error).as(field + "Validation is correct")
              .isEqualTo("Please enter campaign name!");
          break;

        case "campaign-start-date-empty":
          validation_error = page.getStartDateError();
          Assertions.assertThat(validation_error).as(field + "Validation is correct")
              .isEqualTo("Please add a start date!");
          break;

        case "campaign-end-date-empty":
          validation_error = page.getEndDateError();
          Assertions.assertThat(validation_error).as(field + "Validation is correct")
              .isEqualTo("Please add an end date!");
          break;

        case "campaign-end-date-is-before-start-date":
          validation_error = page.getEndDateError();
          Assertions.assertThat(validation_error).as(field + "Validation is correct")
              .isEqualTo("End date can't be before start date!");
          break;

        case "campaign-service-type-empty":
          validation_error = page.getCampaignServiceTypeError();
          Assertions.assertThat(validation_error).as(field + "Validation is correct")
              .isEqualTo("Please choose service type!");
          break;

        case "campaign-service-level-empty":
          validation_error = page.getCampaignServiceLevelError();
          Assertions.assertThat(validation_error).as(field + "Validation is correct")
              .isEqualTo("Please choose service level!");
          break;

        case "campaign-discount-value-empty":
          validation_error = page.getCampaignDiscountValueError();
          Assertions.assertThat(validation_error).as(field + "Validation is correct")
              .isEqualTo("Please enter discount value!");
          break;

        case "campaign-discount-value-more_than-2-decimal-points":
          validation_error = page.getCampaignDiscountValueError();
          Assertions.assertThat(validation_error).as(field + "Validation is correct")
              .isEqualTo("Please enter a number with max 2 decimal places!");
          break;

        case "campaign-discount-value-0":
        case "campaign-discount-value-negative":

          validation_error = page.getCampaignDiscountValueError();
          Assertions.assertThat(validation_error).as(field + "Validation is correct")
              .isEqualTo("Discount value can't be 0 or less!");
          break;

        case "campaign-discount-value-characters":
        case "campaign-discount-value-alphabets":
          validation_error = page.getCampaignDiscountValueAlert();
          Assertions.assertThat(validation_error).as(field + "Validation is correct")
              .isEqualTo("Please enter a number.");
          break;

        case "campaign-discount-value-more-than-100%":
          validation_error = page.getCampaignDiscountValueError();
          Assertions.assertThat(validation_error).as(field + "Validation is correct")
              .isEqualTo("Value can't more than 100%!");
          break;

        case "campaign-same-rule":
          validation_error = page.getCampaignGeneralError();
          Assertions.assertThat(validation_error).as(field + "Validation is correct")
              .isEqualTo("Duplicate service type/level");
          break;
      }
    });
  }

  @When("Operator clicks on Shippers Add button")
  public void operatorClickOnShipperAddButton() {
    campaignCreateEditPage.inFrame(page -> {
      campaignCreateEditPage.clickShippersAddButton();
    });
  }

  @When("Operator clicks on Shippers Remove button")
  public void operatorClickOnShipperRemoveButton() {
    campaignCreateEditPage.inFrame(page -> {
      campaignCreateEditPage.clickShippersRemoveButton();
    });
  }

  @When("Operator clicks on Search by Shipper tab")
  public void operatorClickOnSearchByShipperTab() {
    campaignCreateEditPage.inFrame(page -> {
      campaignCreateEditPage.clickSearchByShippersTab();
    });
  }

  @When("Operator uploads csv file with {value}")
  public void operatorUploadsCsvFileWithBelowData(String shipperLegacyId) {
    campaignCreateEditPage.inFrame(page -> {
      System.out.println(resolveValue(shipperLegacyId).toString());
      File csvFile = getCsvFile(resolveValue(shipperLegacyId));
      campaignCreateEditPage.uploadFile(csvFile);
    });
  }

  @Then("Operator search using {string} and select the created shipper")
  public void operatorSearchAndSelectShipper(String searchOption) {
    campaignCreateEditPage.inFrame(page -> {
      Shipper createdShipper = resolveValue(KEY_CREATED_SHIPPER);
      String searchValue = null;
      switch (searchOption) {
        case "Legacy ID":
          LOGGER.info("Using Legacy ID to search Shipper");
          searchValue = createdShipper.getLegacyId().toString();
          break;
        case "Invalid Shipper ID":
          LOGGER.info("Using Invalid Shipper ID to search Shipper");
          searchValue = "Invalid Shipper ID";
          break;
        case "Name":
          LOGGER.info("Using Name to search Shipper");
          searchValue = createdShipper.getName();
          break;
        default:
          LOGGER.info("Using user defined value to search Shipper");
          searchValue = searchOption;
      }

      page.searchForTheShipper(searchValue);
    });
  }

  @When("Operator clicks on upload button")
  public void operatorClicksOnUploadButton() {
    campaignCreateEditPage.closeNotificationMessage();
    campaignCreateEditPage.inFrame(page -> {
      campaignCreateEditPage.clickUploadButton();
    });
  }

  @NotNull
  private File getCsvFile(String shipperLegacyId) {
    File csvFile = StandardTestUtils.createFile(CSV_FILENAME_PATTERN, shipperLegacyId);
    LOGGER.info("Path of the created file " + csvFile.getAbsolutePath());
    return csvFile;
  }

  @And("Operator clicks on campaign with name {string}")
  public void operatorClicksOnCampaignWithName(String name) {
    discountAndPromotionsPage.inFrame(page -> {

      pause10s();
      pause10s();
      discountAndPromotionsPage.selectCampaignWithName(name);
    });
  }

  @And("Operator clicks on first {string} campaign")
  public void operatorClicksOnFirstCampaign(String status) {
    discountAndPromotionsPage.inFrame(page -> {
      doWithRetry(() ->
      {
        pause5s();
        discountAndPromotionsPage.selectCampaignWithStatus(status, "1");
      }, getCurrentMethodName(), 500, 5);
    });
  }

  @And("Operator clicks on second {string} campaign")
  public void operatorClicksOnSecondCampaign(String status) {
    discountAndPromotionsPage.inFrame(page -> {
      doWithRetry(() ->
      {
        pause5s();
        discountAndPromotionsPage.selectCampaignWithStatus(status, "2");
      }, getCurrentMethodName(), 500, 5);
    });
  }

  @And("Operator verifies {string} (input)(select)(picker) field is {string}")
  public void operatorVerifiesValueIsDisabled(String fieldName, String fieldType,
      String isClickable) {
    discountAndPromotionsPage.inFrame(page -> {
      String fieldValue = null;
      if (fieldType.equalsIgnoreCase("input") || fieldType.equalsIgnoreCase("picker")) {
        Assertions.assertThat(discountAndPromotionsPage.verifyCampaignField(fieldName, isClickable))
            .as(f("%s is displayed", fieldName)).isTrue();
        fieldValue = discountAndPromotionsPage.getCampaignFieldValue(fieldName, isClickable);
      } else if (fieldType.equalsIgnoreCase("select")) {
        Assertions.assertThat(
                discountAndPromotionsPage.verifySelectCampaignField(fieldName, isClickable))
            .as(f("%s is displayed", fieldName)).isTrue();
        fieldValue = discountAndPromotionsPage.getCampaignSelectFieldValue(fieldName, isClickable);
      }
      Assertions.assertThat(fieldValue.length())
          .as(f("%s contains %s", fieldName, fieldValue)).isGreaterThan(0);
    });
  }

  @And("^Operator verifies Campaign is (.+)$")
  public void operatorVerifiesCampaignIs(String campaignStatus) {
    discountAndPromotionsPage.inFrame(page -> {
      String actualCampaignStatus = discountAndPromotionsPage.getCampaignStatus();
      Assertions.assertThat(actualCampaignStatus)
          .as(f("Campaign status expected is %s and acutal is %s", campaignStatus,
              actualCampaignStatus)).isEqualTo(campaignStatus);
    });
  }

  @And("^Operator verifies (.+) button is (.+)$")
  public void operatorVerifiesButtonIs(String buttonName, String buttonStatus) {
    discountAndPromotionsPage.inFrame(page -> {
      Assertions.assertThat(discountAndPromotionsPage.verifyButtonStatus(buttonName, buttonStatus))
          .as(f("%s is %s", buttonName, buttonStatus)).isTrue();
    });
  }

  @And("Operator verifies shippers count is present")
  public void operatorVerifiesShippersCountIsPresent() {
    discountAndPromotionsPage.inFrame(page -> {
      Assertions.assertThat(discountAndPromotionsPage.verifyShippersCount())
          .as(f("Visibility of Shippers count : %s",
              discountAndPromotionsPage.verifyShippersCount())).isTrue();
    });
  }

  @When("Operator clicks on Campaign Rule Add button")
  public void operatorClickOnCampaignRuleAddButton() {
    campaignCreateEditPage.inFrame(page -> {
      campaignCreateEditPage.clickCampaignRuleAddButton();
    });
  }

  @And("Operator verifies new row of Service type, Service level, and Discount value box fields")
  public void operatorVerifiesNewRowOfServiceTypeServiceLevelAndDiscountValueBoxFields() {
    campaignCreateEditPage.inFrame(page -> {
      campaignCreateEditPage.verifyNewRowAdded();
    });
  }

  @And("Operator verify remove button for {string} Campaign rule")
  @And("Operator clicks on remove button for {string} Campaign rule")
  public void operatorClicksOnRemoveButtonforCampaignRule(String row) {
    campaignCreateEditPage.inFrame(page -> {
      campaignCreateEditPage.removeCampaignRule(Integer.valueOf(row));
    });
  }

  @And("Operator verifies total Campaign Rule rows should be {int}")
  public void operatorVerifiesTotalCampaingRulesRowsShouldBe(int row) {
    campaignCreateEditPage.inFrame(page -> {
      Assertions.assertThat(campaignCreateEditPage.getCampaignRuleCount())
          .as(f("Total Campaign Rule rows count Expected %d and Actual %d", row,
              campaignCreateEditPage.getCampaignRuleCount())).isEqualTo(row);
    });
  }

  @And("^Operator verifies (.+) is updated on campaign page$")
  public void operatorVerifiesUpdatedCampaignPage(String fieldName) {
    campaignCreateEditPage.inFrame(page -> {
      String updatedValue = null;
      String actualValue = null;
      switch (fieldName) {
        case "campaign name":
          actualValue = campaignCreateEditPage.getCampaignName();
          updatedValue = get(KEY_OBJECT_OF_CREATED_CAMPAIGN).toString().split(":", 2)[1].substring(
              1).split("\"", 2)[0];
          if (updatedValue.length() > 50) {
            updatedValue = updatedValue.substring(0, 50);
          }
          break;
        case "campaign description":
          actualValue = campaignCreateEditPage.getCampaignDescription();
          updatedValue = get(KEY_OBJECT_OF_CREATED_CAMPAIGN).toString().split(":", 2)[1].substring(
              1).split("\"", 2)[0];
          if (updatedValue.length() > 255) {
            updatedValue = updatedValue.substring(0, 255);
          }
          if (updatedValue.equalsIgnoreCase("blank")) {
            updatedValue = "";
          }
          break;
        case "start date":
          actualValue = campaignCreateEditPage.getStartDate();
          updatedValue = get(KEY_OBJECT_OF_CREATED_CAMPAIGN).toString().split(":", 2)[1].substring(
              1).split("\"", 2)[0];
          String year = updatedValue.substring(0, 4);
          String month = updatedValue.substring(5, 7);
          String date = updatedValue.substring(8);
          updatedValue = date + "/" + month + "/" + year;
          break;
        case "end date":
          actualValue = campaignCreateEditPage.getEndDate();
          updatedValue = get(KEY_OBJECT_OF_CREATED_CAMPAIGN).toString().split(":", 2)[1].substring(
              1).split("\"", 2)[0];
          year = updatedValue.substring(0, 4);
          month = updatedValue.substring(5, 7);
          date = updatedValue.substring(8);
          updatedValue = date + "/" + month + "/" + year;
          break;
      }

      Assertions.assertThat(actualValue).contains(updatedValue)
          .as(f("%s to contain %s", actualValue, updatedValue));
    });
  }

  @When("Operator clicks on download button on Campaign Page")
  public void operatorClickOnDownloadButtonOnCampaignPage() {
    campaignCreateEditPage.inFrame(page -> {
      campaignCreateEditPage.clickDownloadButton();
    });
  }

  @And("Operator verifies downloaded shippers CSV file on Campaign Page")
  public void operatorVerifiesDownloadedShippersCSVFileOnCapaignPage() {
    campaignCreateEditPage.inFrame(page -> {
      campaignCreateEditPage.verifyFileDownloadedSuccessfully("shippers.csv");
    });
  }

  @Then("Operator verifies {string} modal is displayed")
  public void operatorVerifiesModalIsDisplayed(String modalName) {
    campaignCreateEditPage.inFrame(page -> {
      campaignCreateEditPage.shipperModalDisplayed(modalName);
    });
  }

  @And("Operator verifies {string} is default selected tab")
  public void operatorVerifiesBulkUploadIsDefaultSelectedTab(String tab) {
    campaignCreateEditPage.inFrame(page -> {
      campaignCreateEditPage.addShipperSelectedTab(tab);
    });
  }

  @And("Operator verifies Shipper count is {string}")
  public void operatorVerifiesShipperCountIs(String value) {
    campaignCreateEditPage.inFrame(page -> {
      Assertions.assertThat(campaignCreateEditPage.getShipperCount()).isEqualTo(value)
          .as(f("Shipper Count expected is %s and actual is %s", value,
              campaignCreateEditPage.getShipperCount()));
    });
  }

  @And("Operator removes selected shipper")
  public void operatorRemoveSelectedShipper() {
    campaignCreateEditPage.inFrame(page -> {
      campaignCreateEditPage.removeSelectedShipper();
    });
  }

  @And("Operator verifies error message is {string}")
  public void operatorVerifiesErrorMessageIs(String error) {
    String validateNotificationText = campaignCreateEditPage.toastErrorMessage.getText();
    LOGGER.info(validateNotificationText);
    Assertions.assertThat(validateNotificationText).as("Expected Toast Msg is visible")
        .contains(error);
  }

  @And("Operator verifies columns in Discounts & Promotion Page")
  public void operatorVerifiesColumnsInDiscountsAndPromotionPage() {
    discountAndPromotionsPage.inFrame(page -> {
      SoftAssertions softAssertions = new SoftAssertions();
      softAssertions.assertThat(discountAndPromotionsPage.verifyColumnPresent("Name"))
          .as("Name column present").isTrue();
      softAssertions.assertThat(discountAndPromotionsPage.verifyColumnPresent("Description"))
          .as("Description column present").isTrue();
      softAssertions.assertThat(discountAndPromotionsPage.verifyColumnPresent("Status"))
          .as("Status column present").isTrue();
      softAssertions.assertThat(discountAndPromotionsPage.verifyColumnPresent("Create Date"))
          .as("Create Date column present").isTrue();
      softAssertions.assertThat(discountAndPromotionsPage.verifyColumnPresent("Start Date"))
          .as("Start Date column present").isTrue();
      softAssertions.assertThat(discountAndPromotionsPage.verifyColumnPresent("End Date"))
          .as("End Date column present").isTrue();
      softAssertions.assertAll();
    });
  }

  @And("Operator verifies campaign count present in Discounts & Promotion Page")
  public void operatorVerifiesCampaignCountPresentInDiscountsAndPromotionPage() {
    discountAndPromotionsPage.inFrame(page -> {
      SoftAssertions softAssertions = new SoftAssertions();
      String value = discountAndPromotionsPage.campaignCount.getText();
      softAssertions.assertThat(value.contains("Showing "));
      softAssertions.assertThat(value.contains(" of "));
      softAssertions.assertThat(value.contains(" results"));
      softAssertions.assertThat(value.contains(" Active Filter(s)"));
      softAssertions.assertAll();
    });
  }
}