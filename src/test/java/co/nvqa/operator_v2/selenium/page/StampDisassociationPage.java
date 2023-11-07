package co.nvqa.operator_v2.selenium.page;

import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.TextBox;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.support.FindBy;

/**
 * @author Sergey Mishanin
 */
public class StampDisassociationPage extends SimpleReactPage<StampDisassociationPage> {

  @FindBy(css = "[data-testid='stamp-id-input']")
  public TextBox stampIdInput;

  @FindBy(css = ".ant-tag")
  public PageElement stampLabel;

  @FindBy(css = ".not-found")
  public PageElement alertLabel;

  @FindBy(css = ".ant-card-body h5")
  public PageElement orderId;

  @FindBy(css = ".ant-card-body div:nth-of-type(6)")
  public PageElement deliveryAddress;

  @FindBy(css = "[data-testid='stamp-disassociation-button']")
  public Button disassociateStamp;

  public StampDisassociationPage(WebDriver webDriver) {
    super(webDriver);
  }

}