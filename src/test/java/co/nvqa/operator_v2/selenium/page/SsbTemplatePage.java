package co.nvqa.operator_v2.selenium.page;

import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.support.FindBy;

public class SsbTemplatePage extends OperatorV2SimplePage {

  @FindBy(xpath = "//button[@label='Create New Template']")
  public Button createNewTemplateBtn;

  @FindBy(css = ".ant-spin-dot")
  public PageElement spinner;

  @FindBy(tagName = "iframe")
  private PageElement pageFrame;

  @FindBy(xpath = "//h1[text()='SSB Report Template Editor']")
  private PageElement createTemplateHeader;

  public SsbTemplatePage(WebDriver webDriver) {
    super(webDriver);
  }

  public void switchTo() {
    getWebDriver().switchTo().frame(pageFrame.getWebElement());
  }

  public void waitUntilLoaded() {
    if (spinner.waitUntilVisible(10)) {
      spinner.waitUntilInvisible();
    }
  }

}
