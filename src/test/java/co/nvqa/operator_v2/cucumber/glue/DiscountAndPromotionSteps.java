package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.support.DateUtil;
import co.nvqa.commons.util.NvTestRuntimeException;
import co.nvqa.operator_v2.model.Campaign;
import co.nvqa.operator_v2.selenium.page.CampaignCreateEditPage;
import co.nvqa.operator_v2.selenium.page.DiscountAndPromotionPage;
import io.cucumber.datatable.DataTable;
import io.cucumber.java.en.Given;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import java.text.ParseException;
import java.util.List;
import java.util.Objects;
import org.assertj.core.api.Assertions;

import static co.nvqa.commons.support.DateUtil.DATE_FORMAT;
import static co.nvqa.commons.support.DateUtil.DATE_FORMAT_SNS_1;

public class DiscountAndPromotionSteps extends AbstractSteps {

  private DiscountAndPromotionPage discountAndPromotionsPage;
  private CampaignCreateEditPage campaignCreateEditPage;

  @Override
  public void init() {
    discountAndPromotionsPage = new DiscountAndPromotionPage(getWebDriver());
    campaignCreateEditPage = new CampaignCreateEditPage(getWebDriver());
  }

  @Given("Operator click Create ne campaign button in Discounts & Promotion Page")
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

  @When("operator clicks on publish button")
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
}