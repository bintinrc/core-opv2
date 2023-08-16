package co.nvqa.operator_v2.selenium.page;

import co.nvqa.operator_v2.selenium.elements.PageElement;
import java.util.List;
import java.util.Objects;
import org.openqa.selenium.By;
import org.openqa.selenium.StaleElementReferenceException;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;

public class DiscountAndPromotionPage extends SimpleReactPage<DiscountAndPromotionPage> {

  @FindBy(xpath = "//span[text()='Create new campaign']/parent::button")
  public PageElement createNewCampaignBtn;

  public static final String CAMPAIGN_ROWS = "//div[@role='rowgroup']//div[@role='row']";
  public static final String CAMPAIGN_NAME = "//span[@class = 'campaign-link-text']";

  public static final String CAMPAIGN_STATUS = "//div[@content = '%s']";

  public static final String CAMPAIGN_FIELD_NAME = "(//label[text()='%s']/ancestor::div[contains(@class,'item-row')]//*[(name()='input' or name()='textarea') and %s])[last()]";

  public static final String CAMPAIGN_SELECT_FIELD_NAME = "(//label[text()='%s']/ancestor::div[contains(@class,'item-row')]//div[%s])[last()]";

  public static final String CAMPAIGN_HEADER_STATUS = "//h4[text()='Campaign']/ancestor::div[contains(@class,'space-item')]/following-sibling::div";

  public static final String CAMPAIGN_BUTTON = "(//*[span[text()='%s'] and (name()='button' or name()='div') and %s])[last()] | //a[text()='%s' and %s]";

  public static final String CAMPAIGN_COLUMN = "//div[@role='columnheader']//span[text()='%s']";

  @FindBy (xpath = "//div[@class='container']/preceding-sibling::div[contains(@class,'ant-col')]")
  public PageElement campaignCount;

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
    List<WebElement> campaigns = findElementsBy(By.xpath(CAMPAIGN_NAME));
    for (WebElement campaign : campaigns) {
      try {
        if (Objects.equals(campaign.getText(), campaignName)) {
          isDisplayed = true;
          break;
        }
      } catch (StaleElementReferenceException e) {
        campaigns = findElementsBy(By.xpath(CAMPAIGN_NAME));
      }
    }
    return isDisplayed;
  }

  public void selectCampaignWithStatus(String status) {
    String xpathExpression = f("%s/ancestor::div[@class='tr']/div/button",
        f(CAMPAIGN_STATUS, status));
    doubleClick(xpathExpression);
  }

  public void selectCampaignWithName(String name) {
    String xpathExpression = f("//span[text() = '%s']", name);
    doubleClick(xpathExpression);
  }

  public boolean verifyCampaignField(String fieldName, String isClickable) {
    String xpathExpression;
    if (isClickable.equalsIgnoreCase("not clickable")) {
      xpathExpression = f(CAMPAIGN_FIELD_NAME, fieldName, "@disabled");
      return waitUntilVisibilityOfElementLocated(xpathExpression).isDisplayed();
    } else if (isClickable.equalsIgnoreCase("clickable")) {
      xpathExpression = f(CAMPAIGN_FIELD_NAME, fieldName, "not(@disabled)");
      return waitUntilVisibilityOfElementLocated(xpathExpression).isDisplayed();
    }
    return false;
  }

  public boolean verifySelectCampaignField(String fieldName, String isClickable) {
    String xpathExpression;
    if (isClickable.equalsIgnoreCase("not clickable")) {
      xpathExpression = f(CAMPAIGN_SELECT_FIELD_NAME, fieldName, "contains(@class,'disabled')");
      return waitUntilVisibilityOfElementLocated(xpathExpression).isDisplayed();
    } else if (isClickable.equalsIgnoreCase("clickable")) {
      xpathExpression = f(CAMPAIGN_SELECT_FIELD_NAME, fieldName,
          "not(contains(@class,'disabled'))");
      return waitUntilVisibilityOfElementLocated(xpathExpression).isDisplayed();
    }
    return false;
  }

  public String getCampaignFieldValue(String fieldName, String isClickable) {
    String xpathExpression;
    if (isClickable.equalsIgnoreCase("not clickable")) {
      xpathExpression = f(CAMPAIGN_FIELD_NAME, fieldName, "@disabled");
      return getAttribute(xpathExpression, "value");
    } else if (isClickable.equalsIgnoreCase("clickable")) {
      xpathExpression = f(CAMPAIGN_FIELD_NAME, fieldName, "not(@disabled)");
      return getAttribute(xpathExpression, "value");
    }
    return null;
  }

  public String getCampaignSelectFieldValue(String fieldName, String isClickable) {
    String xpathExpression;
    if (isClickable.equalsIgnoreCase("not clickable")) {
      xpathExpression = f(CAMPAIGN_SELECT_FIELD_NAME, fieldName, "contains(@class,'disabled')");
      return getText(xpathExpression);
    } else if (isClickable.equalsIgnoreCase("clickable")) {
      xpathExpression = f(CAMPAIGN_SELECT_FIELD_NAME, fieldName,
          "not(contains(@class,'disabled'))");
      return getText(xpathExpression);
    }
    return null;
  }

  public String getCampaignStatus() {
    return getText(CAMPAIGN_HEADER_STATUS);
  }

  public boolean verifyButtonStatus(String buttonName, String status) {
    if (status.equalsIgnoreCase("not disabled")) {
      return waitUntilVisibilityOfElementLocated(
          f(CAMPAIGN_BUTTON, buttonName, "not(@disabled)", buttonName,
              "not(@disabled)")).isDisplayed();
    } else if (status.equalsIgnoreCase("disabled")) {
      return waitUntilVisibilityOfElementLocated(
          f(CAMPAIGN_BUTTON, buttonName, "@disabled", buttonName, "@disabled")).isDisplayed();
    }
    return false;
  }

  public boolean verifyShippersCount() {
    return waitUntilVisibilityOfElementLocated(
        "(//div[contains(@class,'row-middle')]/span)[2]").isDisplayed();
  }

  public boolean verifyColumnPresent(String columnName) {
    return waitUntilVisibilityOfElementLocated(CAMPAIGN_COLUMN, columnName).isDisplayed();
  }
}