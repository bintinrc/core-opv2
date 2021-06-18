package co.nvqa.operator_v2.selenium.page;

import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.TextBox;
import co.nvqa.operator_v2.selenium.elements.md.MdDialog;
import co.nvqa.operator_v2.selenium.elements.nv.NvApiTextButton;
import co.nvqa.operator_v2.selenium.elements.nv.NvIconTextButton;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;

public class NinjaPackTrackingIdGeneratorPage extends OperatorV2SimplePage {

  @FindBy(name = "quantity")
  public TextBox quantity;

  @FindBy(name = "Generate")
  public NvApiTextButton generate;

  @FindBy(css = "md-dialog")
  public ReviewNinjaPackIdGeneratorSelectionDialog reviewNinjaPackIdGeneratorSelectionDialog;

  public NinjaPackTrackingIdGeneratorPage(WebDriver webDriver) {
    super(webDriver);
  }

  public static class ReviewNinjaPackIdGeneratorSelectionDialog extends MdDialog {

    public ReviewNinjaPackIdGeneratorSelectionDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }

    @FindBy(xpath = ".//div[.='Quantity']/following-sibling::div")
    public PageElement quantity;

    @FindBy(name = "commons.confirm")
    public NvIconTextButton confirm;
  }
}
