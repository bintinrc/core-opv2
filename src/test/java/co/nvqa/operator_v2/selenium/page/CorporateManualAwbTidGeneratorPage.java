package co.nvqa.operator_v2.selenium.page;

import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.TextBox;
import co.nvqa.operator_v2.selenium.elements.ant.AntButton;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.support.FindBy;

public class CorporateManualAwbTidGeneratorPage extends OperatorV2SimplePage {

  @FindBy(id = "register_quantity")
  public TextBox quantity;

  @FindBy(css = "label[for='register_quantity']")
  public PageElement quantityLabel;

  @FindBy(css = "div.ant-form-explain")
  public PageElement errorLabel;

  @FindBy(xpath = ".//button[.='Generate tracking ids']")
  public AntButton generate;

  @FindBy(tagName = "iframe")
  private PageElement pageFrame;

  @FindBy(css = ".ant-spin-dot")
  public PageElement spinner;

  public CorporateManualAwbTidGeneratorPage(WebDriver webDriver) {
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
