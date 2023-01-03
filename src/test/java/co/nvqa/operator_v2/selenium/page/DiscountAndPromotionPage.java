package co.nvqa.operator_v2.selenium.page;

import co.nvqa.operator_v2.selenium.elements.PageElement;
import java.util.List;
import java.util.Objects;
import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;

public class DiscountAndPromotionPage extends SimpleReactPage<DiscountAndPromotionPage> {

  @FindBy(xpath = "//span[text()='Create new campaign']/parent::button")
  public PageElement createNewCampaignBtn;

  public static final String CAMPAIGN_ROWS = "//div[@role='rowgroup']//div[@role='row']";
  public static final String CAMPAIGN_NAME = "//span[@class = 'campaign-link-text']";

  public DiscountAndPromotionPage(WebDriver webDriver) {
    super(webDriver);
  }

  public void clickCreateNewCampaignButton() {
    waitUntilPageLoaded();
    createNewCampaignBtn.click();
  }

  public boolean isCampaignIsDisplayed(String campaignName) {
    waitUntilPageLoaded();
    pause5s();
    boolean isDisplayed = false;
    List<WebElement> rows = findElementsBy(By.xpath(CAMPAIGN_ROWS));
    for (WebElement row : rows) {
      if (Objects.equals(row.findElement(By.xpath(CAMPAIGN_NAME)).getText(), campaignName)) {
        isDisplayed = true;
        break;
      }
    }
    return isDisplayed;
  }
}