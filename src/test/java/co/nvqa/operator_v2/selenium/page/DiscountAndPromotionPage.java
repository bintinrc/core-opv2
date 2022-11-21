package co.nvqa.operator_v2.selenium.page;

import co.nvqa.operator_v2.selenium.elements.PageElement;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.support.FindBy;

public class DiscountAndPromotionPage extends SimpleReactPage<DiscountAndPromotionPage>{
  @FindBy(xpath = "//span[text()='Create new campaign']/parent::button")
  public PageElement createNewCampaignBtn;

  @FindBy(xpath = "//span[text()='Publish']/parent::button")
  public PageElement campaignPublishButton;

  public DiscountAndPromotionPage(WebDriver webDriver) {
    super(webDriver);
  }

  public void clickCreateNewCampaignButton() {
    waitUntilPageLoaded();
    createNewCampaignBtn.click();
  }

  public void clickPublishButton() {
    waitUntilPageLoaded();
    campaignPublishButton.click();
  }

  public void waitUntilCampaignPageIsLoaded() {
    campaignPublishButton.waitUntilClickable(120);
  }
}