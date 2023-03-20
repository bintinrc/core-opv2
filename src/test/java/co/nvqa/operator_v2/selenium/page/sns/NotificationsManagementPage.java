package co.nvqa.operator_v2.selenium.page.sns;

import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.page.OperatorV2SimplePage;
import co.nvqa.operator_v2.selenium.page.SimpleReactPage;
import org.assertj.core.api.Assertions;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.support.FindBy;

public class NotificationsManagementPage extends OperatorV2SimplePage {
  @FindBy(xpath = "//input[@placeholder='Search']")
  public PageElement searchTemplate;
  public String tableColumns = "//div[contains(@class,'table-body')]//table//tr[@data-row-key][1]//td[%s]";

  //  @FindBy(xpath = "//iframe[contains(@src,'notifications')]")
//  public PageElement iframe;
  private static final String XPATH_IFRAME = "//iframe[contains(@src,'notifications')]";


  public NotificationsManagementPage(WebDriver webDriver) {
    super(webDriver);
  }

  public void verifyTemplateIdAndName(String templateId, String templateName) {
    pause5s();
    switchToIframe();
    setTemplateNameId(templateId);
    pause2s();
    Assertions.assertThat(getTemplateIdTextFromTable()).as("Template Id is correct: ").isEqualTo(templateId);
    Assertions.assertThat(getTemplateNameTextFromTable().contains(templateName)).as("Template Name is correct: ").isTrue();
    getWebDriver().switchTo().defaultContent();
  }

  public void switchToIframe() {
    waitUntilVisibilityOfElementLocated(XPATH_IFRAME);
    getWebDriver().switchTo().frame(findElementByXpath(XPATH_IFRAME));
  }
  public void setTemplateNameId(String templateNameId) {
    searchTemplate.waitUntilVisible();
    searchTemplate.sendKeys(templateNameId);
  }

  public String getTemplateIdTextFromTable() {
    pause5s();
    String text = getText(f(tableColumns, 2));
    return text;
  }

  public String getTemplateNameTextFromTable() {
    pause5s();
    String text = getText(f(tableColumns, 3));
    return text;
  }

}
