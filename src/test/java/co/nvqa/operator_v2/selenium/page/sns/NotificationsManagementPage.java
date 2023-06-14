package co.nvqa.operator_v2.selenium.page.sns;

import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.page.OperatorV2SimplePage;
import org.assertj.core.api.Assertions;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.support.FindBy;

public class NotificationsManagementPage extends OperatorV2SimplePage {
  @FindBy(xpath = "//input[@placeholder='Search']")
  public PageElement searchTemplate;
  public String tableColumns = "//div[contains(@class,'table-body')]//table//tr[@data-row-key][1]//td[%s]";

  public NotificationsManagementPage(WebDriver webDriver) {
    super(webDriver);
  }

  public void verifyTemplateIdAndName(String templateId, String templateName) {
    setTemplateNameId(templateId);
    Assertions.assertThat(getTemplateIdTextFromTable()).as("Template Id is correct: ").isEqualTo(templateId);
    Assertions.assertThat(getTemplateNameTextFromTable().contains(templateName)).as("Template Name is correct: ").isTrue();
  }

  public void setTemplateNameId(String templateNameId) {
    searchTemplate.waitUntilVisible();
    searchTemplate.sendKeys(templateNameId);
  }

  public String getTemplateIdTextFromTable() {
    String text = getText(f(tableColumns, 2));
    return text;
  }

  public String getTemplateNameTextFromTable() {
    String text = getText(f(tableColumns, 3));
    return text;
  }

}
