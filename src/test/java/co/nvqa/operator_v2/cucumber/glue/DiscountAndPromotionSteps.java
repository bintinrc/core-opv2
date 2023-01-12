package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.common.utils.StandardTestUtils;
import co.nvqa.commons.model.shipper.v2.Shipper;
import co.nvqa.commons.support.DateUtil;
import co.nvqa.commons.util.NvTestRuntimeException;
import co.nvqa.operator_v2.model.Campaign;
import co.nvqa.operator_v2.selenium.page.CampaignCreateEditPage;
import co.nvqa.operator_v2.selenium.page.DiscountAndPromotionPage;
import io.cucumber.datatable.DataTable;
import io.cucumber.java.en.Given;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import java.io.File;
import java.text.ParseException;
import java.util.List;
import java.util.Objects;
import org.apache.commons.lang3.StringUtils;
import org.assertj.core.api.Assertions;
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
        page.selectServiceType(serviceType);
      }
      List<String> serviceLevel = campaign.getServiceLevel();
      if (Objects.nonNull(serviceLevel)) {
        page.selectServiceLevel(serviceLevel);
      }
      List<String> discountValue = campaign.getDiscountValue();
      if (Objects.nonNull(discountValue)) {
        page.enterDiscountValue(discountValue);
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
    put(KEY_OBJECT_OF_GET_CAMPAIGN, campaignDetail);
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

  @When("Operator clicks on Search by Shipper tab")
  public void operatorClickOnSearchByShipperTab() {
    campaignCreateEditPage.inFrame(page -> {
      campaignCreateEditPage.clickSearchByShippersTab();
    });
  }

  @When("Operator uploads csv file with {value}")
  public void operatorUploadsCsvFileWithBelowData(String shipperLegacyId) {
    campaignCreateEditPage.inFrame(page -> {
      File csvFile = getCsvFile(resolveValue(shipperLegacyId));
      campaignCreateEditPage.uploadFile(csvFile);
    });
  }

  @Then("Operator search and select the created shipper")
  public void operatorSearchAndSelectShipper() {
    campaignCreateEditPage.inFrame(page -> {
      Shipper createdShipper = resolveValue(KEY_CREATED_SHIPPER);
      page.searchForTheShipper(createdShipper.getName());
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
}