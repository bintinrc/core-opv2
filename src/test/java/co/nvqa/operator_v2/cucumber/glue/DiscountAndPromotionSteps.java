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
    List<Campaign> campaignDetails = convertDataTableToListWhereDataTableHasListOfData(dt, Campaign.class);
    Campaign campaignDetail = campaignDetails.get(0);
    put(KEY_OBJECT_OF_CREATED_CAMPAIGN, campaignDetail);
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
      value = campaign.getStartDate();
      if (Objects.nonNull(value)) {
        page.startDate.setFromDate(value);
      }
      value = campaign.getEndDate();
      if (Objects.nonNull(value)) {
        page.endDate.setFromDate(value);
      }
      page.clickAddButton(campaign.getServiceType());
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
      campaignDetail.setCampaignDescription(campaignCreateEditPage.getCampaignDescription());
      String startDate = DateUtil.formatDate(campaignCreateEditPage.getStartDate(), DATE_FORMAT_SNS_1, DATE_FORMAT);
      campaignDetail.setStartDate(startDate);
      String endDate = DateUtil.formatDate(campaignCreateEditPage.getEndDate(), DATE_FORMAT_SNS_1, DATE_FORMAT);
      campaignDetail.setEndDate(endDate);
      campaignDetail.setServiceType(campaignCreateEditPage.getServiceType());
      campaignDetail.setServiceLevel(campaignCreateEditPage.getServiceLevel());
      campaignDetail.setDiscountValue(campaignCreateEditPage.getDiscountValue());
      put(KEY_OBJECT_OF_GET_CAMPAIGN, campaignDetail);
  }

  @When("Operator clicks on publish button")
  public void operatorClicksOnPublishButton() {
    discountAndPromotionsPage.inFrame(page -> {
      discountAndPromotionsPage.clickPublishButton();
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