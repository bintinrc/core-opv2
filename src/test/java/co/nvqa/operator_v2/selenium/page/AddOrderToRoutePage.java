package co.nvqa.operator_v2.selenium.page;

import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.TextBox;
import co.nvqa.operator_v2.selenium.elements.md.MdDialog;
import co.nvqa.operator_v2.selenium.elements.nv.NvAutocomplete;
import co.nvqa.operator_v2.selenium.elements.nv.NvIconTextButton;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;

/**
 * @author Sergey Mishanin
 */
public class AddOrderToRoutePage extends OperatorV2SimplePage {

  @FindBy(id = "container.routing.add-order-to-route.route-id")
  public TextBox routeId;

  @FindBy(id = "scan")
  public TextBox trackingId;

  @FindBy(css = "nv-autocomplete[item-types='transaction types']")
  public NvAutocomplete transactionType;

  @FindBy(name = "container.routing.add-order-to-route.add-prefix")
  public NvIconTextButton addPrefix;

  @FindBy(name = "container.routing.add-order-to-route.remove-prefix")
  public NvIconTextButton removePrefix;

  @FindBy(css = "h5.last-scanned-tracking-id")
  public PageElement lastScannedTrackingId;

  @FindBy(css = "md-dialog")
  public SetPrefixDialog setPrefixDialog;

  public AddOrderToRoutePage(WebDriver webDriver) {
    super(webDriver);
  }

  public void addPrefix(String prefix) {
    addPrefix.click();
    setPrefixDialog.waitUntilVisible();
    setPrefixDialog.prefix.setValue(prefix);
    setPrefixDialog.save.click();
    setPrefixDialog.waitUntilInvisible();
    assertTrue("Remove Prefix button in present", removePrefix.isDisplayed());
  }

  public static class SetPrefixDialog extends MdDialog {

    @FindBy(id = "container.global-inbound.prefix")
    public TextBox prefix;

    @FindBy(id = "saveButtonPrefix")
    public NvIconTextButton save;

    public SetPrefixDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }
  }
}