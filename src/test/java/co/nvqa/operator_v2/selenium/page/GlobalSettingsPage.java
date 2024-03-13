package co.nvqa.operator_v2.selenium.page;

import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.TextBox;
import co.nvqa.operator_v2.selenium.elements.md.MdCheckbox;
import java.util.List;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.support.FindBy;

/**
 * @author Sergey Mishanin
 */
public class GlobalSettingsPage extends SimpleReactPage<GlobalSettingsPage> {

  @FindBy(css = "[data-testid='weight-tolerance-input']")
  public TextBox inputWeightTolerance;

  @FindBy(css = "[data-testid='weight-tolerance-input-update-button']")
  public Button updateWeightTolerance;

  @FindBy(css = "[data-testid='weight-limit-input']")
  public TextBox inputMaxWeightLimit;

  @FindBy(css = "[data-testid='weight-limit-input-update-button']")
  public Button updateMaxWeightLimit;

  @FindBy(css = "[data-testid='sms-notification-update-button']")
  public Button updateSmsSettings;

  @FindBy(xpath = "//input[@type='checkbox' and @name='allowVanInbound']/following-sibling::span")
  public MdCheckbox enableVanInboundSms;

  @FindBy(xpath = "//input[@type='checkbox' and @name='allowReturnPickupSms']/following-sibling::span")
  public MdCheckbox enableReturnPickupSms;

  @FindBy(xpath = "//div[@data-testid='allowVanInboundShipperIds']/input")
  public PageElement exemptedShippersFromVanInboundSms;

  @FindBy(xpath = "//div[@data-testid='allowReturnPickupSmsShipperIds']/input")
  public PageElement exemptedShippersFromReturnPickupSms;

  @FindBy(xpath = "//div[@data-testid='allowVanInboundShipperIds']//li")
  public PageElement vanInboundShipperValue;

  @FindBy(xpath = "//div[@data-testid='allowReturnPickupSmsShipperIds']//li")
  public PageElement returnPickupShipperValue;

  @FindBy(xpath = "//div[@data-testid='chip-container']//div[text()='Exempted shippers from van inbound SMS']/following-sibling::div/div[@data-testid='filterChip']/span")
  public List<PageElement> selectedVanInboundShippers;

  @FindBy(xpath = "//div[@data-testid='chip-container']//div[text()='Exempted shippers from return pickup SMS']/following-sibling::div/div[@data-testid='filterChip']/span")
  public List<PageElement> selectedReturnPickupShipper;


  public GlobalSettingsPage(WebDriver webDriver) {
    super(webDriver);
  }
}
