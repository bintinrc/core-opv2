package co.nvqa.operator_v2.selenium.page;

import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.ForceClearTextBox;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.TextBox;
import co.nvqa.operator_v2.selenium.elements.ant.AntModal;
import co.nvqa.operator_v2.selenium.elements.ant.AntSelect3;
import org.assertj.core.api.Assertions;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;

/**
 * @author Sergey Mishanin
 */
public class AddOrderToRoutePage extends SimpleReactPage<AddOrderToRoutePage> {

  @FindBy(css = "[placeholder='Enter route ID']")
  public ForceClearTextBox routeId;

  @FindBy(css = "[placeholder='Scan a new parcel / Enter a tracking ID']")
  public ForceClearTextBox trackingId;

  @FindBy(xpath = "//div[@data-testid='single-select']")
  public AntSelect3 transactionType;

  @FindBy(css = "[data-pa-label='Add Prefix']")
  public Button addPrefix;

  @FindBy(css = "[data-pa-label='Remove Prefix']")
  public Button removePrefix;

  @FindBy(xpath = "//div[@class='ant-card-body']//span[contains(@class,'nv-text')]")
  public PageElement lastScannedTrackingId;

  @FindBy(className = "ant-modal-content")
  public SetPrefixDialog setPrefixDialog;

  @FindBy(xpath = "//div[@class='ant-notification-notice-message']/text()")
  public PageElement message;

  @FindBy(xpath = "//div[@class='ant-notification-notice-description']//b[.='Error Message:']/following-sibling::span")
  public PageElement description;

  public AddOrderToRoutePage(WebDriver webDriver) {
    super(webDriver);
  }

  public void addPrefix(String prefix) {
    addPrefix.click();
    setPrefixDialog.waitUntilVisible();
    setPrefixDialog.prefix.setValue(prefix);
    setPrefixDialog.save.click();
    setPrefixDialog.waitUntilInvisible();
    Assertions.assertThat(removePrefix.isDisplayed()).as("Remove Prefix button in present")
        .isTrue();
  }

  public static class SetPrefixDialog extends AntModal {

    @FindBy(css = "[placeholder='Prefix']")
    public TextBox prefix;

    @FindBy(css = "[data-pa-label='Save']")
    public Button save;

    public SetPrefixDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }
  }
}