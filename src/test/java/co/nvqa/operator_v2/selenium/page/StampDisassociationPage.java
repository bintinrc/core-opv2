package co.nvqa.operator_v2.selenium.page;

import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.TextBox;
import co.nvqa.operator_v2.selenium.elements.nv.NvApiTextButton;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.support.FindBy;

/**
 * @author Sergey Mishanin
 */
public class StampDisassociationPage extends OperatorV2SimplePage {

  @FindBy(name = "stampId")
  public TextBox stampIdInput;

  @FindBy(xpath = "//md-card//nv-tag/span")
  public PageElement stampLabel;

  @FindBy(xpath = "//div[contains(@class, 'order-details-container flex-100')]")
  public PageElement alertLabel;

  @FindBy(xpath = "//md-card//h5")
  public PageElement orderId;

  @FindBy(xpath = "//md-card-content/div[5]")
  public PageElement deliveryAddress;

  @FindBy(name = "Disassociate Stamp")
  public NvApiTextButton disassociateStamp;

  public StampDisassociationPage(WebDriver webDriver) {
    super(webDriver);
  }

}